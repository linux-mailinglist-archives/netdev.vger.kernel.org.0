Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9923618E6
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 06:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbhDPE3E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Apr 2021 00:29:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49211 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236800AbhDPE3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 00:29:00 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lXG5l-0002WV-3G; Fri, 16 Apr 2021 04:28:29 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 2C5D261DE4; Thu, 15 Apr 2021 21:28:27 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 2543EA040D;
        Thu, 15 Apr 2021 21:28:27 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     jinyiting <jinyiting@huawei.com>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, security@kernel.org,
        linux-kernel@vger.kernel.org, xuhanbing@huawei.com,
        wangxiaogang3@huawei.com
Subject: Re: [PATCH] bonding: 3ad: update slave arr after initialize
In-reply-to: <1618537982-454-1-git-send-email-jinyiting@huawei.com>
References: <1618537982-454-1-git-send-email-jinyiting@huawei.com>
Comments: In-reply-to jinyiting <jinyiting@huawei.com>
   message dated "Fri, 16 Apr 2021 09:53:02 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date:   Thu, 15 Apr 2021 21:28:27 -0700
Message-ID: <17733.1618547307@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

jinyiting <jinyiting@huawei.com> wrote:

>From: jin yiting <jinyiting@huawei.com>
>
>The bond works in mode 4, and performs down/up operations on the bond
>that is normally negotiated. The probability of bond-> slave_arr is NULL
>
>Test commands:
>    ifconfig bond1 down
>    ifconfig bond1 up
>
>The conflict occurs in the following process：
>
>__dev_open (CPU A)
> --bond_open
>   --queue_delayed_work(bond->wq,&bond->ad_work,0);
>   --bond_update_slave_arr
>     --bond_3ad_get_active_agg_info
>
>ad_work(CPU B)
> --bond_3ad_state_machine_handler
>   --ad_agg_selection_logic
>
>ad_work runs on cpu B. In the function ad_agg_selection_logic, all
>agg->is_active will be cleared. Before the new active aggregator is
>selected on CPU B, bond_3ad_get_active_agg_info failed on CPU A,
>bond->slave_arr will be set to NULL. The best aggregator in
>ad_agg_selection_logic has not changed, no need to update slave arr.
>
>Signed-off-by: jin yiting <jinyiting@huawei.com>
>---
> drivers/net/bonding/bond_3ad.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
>index 6908822..d100079 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -2327,6 +2327,12 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
> 
> 			aggregator = __get_first_agg(port);
> 			ad_agg_selection_logic(aggregator, &update_slave_arr);
>+			if (!update_slave_arr) {
>+				struct aggregator *active = __get_active_agg(aggregator);
>+
>+				if (active && active->is_active)
>+					update_slave_arr = true;
>+			}
> 		}
> 		bond_3ad_set_carrier(bond);
> 	}

	The described issue is a race condition (in that
ad_agg_selection_logic clears agg->is_active under mode_lock, but
bond_open -> bond_update_slave_arr is inspecting agg->is_active outside
the lock).  I don't see how the above change will reliably manage this;
the real issue looks to be that bond_update_slave_arr is committing
changes to the array (via bond_reset_slave_arr) based on a racy
inspection of the active aggregator state while it is in flux.

	Also, the description of the issue says "The best aggregator in
ad_agg_selection_logic has not changed, no need to update slave arr,"
but the change above does the opposite, and will set update_slave_arr
when the aggregator has not changed (update_slave_arr remains false at
return of ad_agg_selection_logic).

	I believe I understand the described problem, but I don't see
how the patch fixes it.  I suspect (but haven't tested) that the proper
fix is to acquire mode_lock in bond_update_slave_arr while calling
bond_3ad_get_active_agg_info to avoid conflict with the state machine.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
