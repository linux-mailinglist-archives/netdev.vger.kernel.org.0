Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4645B115EE2
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 23:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfLGWJ6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 7 Dec 2019 17:09:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55375 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfLGWJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 17:09:58 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1idiGw-0003FK-1o; Sat, 07 Dec 2019 22:09:54 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 674576C567; Sat,  7 Dec 2019 14:09:52 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 5F07CAC1CC;
        Sat,  7 Dec 2019 14:09:52 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Mahesh Bandewar <maheshb@google.com>
cc:     Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>
Subject: Re: [PATCH net] bonding: fix active-backup transition after link failure
In-reply-to: <20191206234455.213159-1-maheshb@google.com>
References: <20191206234455.213159-1-maheshb@google.com>
Comments: In-reply-to Mahesh Bandewar <maheshb@google.com>
   message dated "Fri, 06 Dec 2019 15:44:55 -0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10901.1575756592.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Sat, 07 Dec 2019 14:09:52 -0800
Message-ID: <10902.1575756592@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mahesh Bandewar <maheshb@google.com> wrote:

>After the recent fix 1899bb325149 ("bonding: fix state transition
>issue in link monitoring"), the active-backup mode with miimon
>initially come-up fine but after a link-failure, both members
>transition into backup state.
>
>Following steps to reproduce the scenario (eth1 and eth2 are the
>slaves of the bond):
>
>    ip link set eth1 up
>    ip link set eth2 down
>    sleep 1
>    ip link set eth2 up
>    ip link set eth1 down
>    cat /sys/class/net/eth1/bonding_slave/state
>    cat /sys/class/net/eth2/bonding_slave/state
>
>Fixes: 1899bb325149 ("bonding: fix state transition issue in link monitoring")
>CC: Jay Vosburgh <jay.vosburgh@canonical.com>
>Signed-off-by: Mahesh Bandewar <maheshb@google.com>
>---
> drivers/net/bonding/bond_main.c | 3 ---
> 1 file changed, 3 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index fcb7c2f7f001..ad9906c102b4 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -2272,9 +2272,6 @@ static void bond_miimon_commit(struct bonding *bond)
> 			} else if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
> 				/* make it immediately active */
> 				bond_set_active_slave(slave);
>-			} else if (slave != primary) {
>-				/* prevent it from being the active one */
>-				bond_set_backup_slave(slave);

	How does this fix things?  Doesn't bond_select_active_slave() ->
bond_change_active_slave() set the backup flag correctly via a call to
bond_set_slave_active_flags() when it sets a slave to be the active
slave?  If this change resolves the problem, I'm not sure how this ever
worked correctly, even prior to 1899bb325149.

	-J

> 			}
> 
> 			slave_info(bond->dev, slave->dev, "link status definitely up, %u Mbps %s duplex\n",
>-- 
>2.24.0.393.g34dc348eaf-goog
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
