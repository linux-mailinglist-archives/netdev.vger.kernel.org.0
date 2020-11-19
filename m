Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C872B9A7F
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 19:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgKSSSL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Nov 2020 13:18:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50230 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbgKSSSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 13:18:10 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kfoVP-00050W-VM; Thu, 19 Nov 2020 18:18:04 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 42AB35FEE7; Thu, 19 Nov 2020 10:18:02 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 3D558A0409;
        Thu, 19 Nov 2020 10:18:02 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: bonding: Notify ports about their initial state
In-reply-to: <20201119144508.29468-2-tobias@waldekranz.com>
References: <20201119144508.29468-1-tobias@waldekranz.com> <20201119144508.29468-2-tobias@waldekranz.com>
Comments: In-reply-to Tobias Waldekranz <tobias@waldekranz.com>
   message dated "Thu, 19 Nov 2020 15:45:05 +0100."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <364.1605809882.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Thu, 19 Nov 2020 10:18:02 -0800
Message-ID: <365.1605809882@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tobias Waldekranz <tobias@waldekranz.com> wrote:

>When creating a static bond (e.g. balance-xor), all ports will always
>be enabled. This is set, and the corresponding notification is sent
>out, before the port is linked to the bond upper.
>
>In the offloaded case, this ordering is hard to deal with.
>
>The lower will first see a notification that it can not associate with
>any bond. Then the bond is joined. After that point no more
>notifications are sent, so all ports remain disabled.

	Why are the notifications generated in __netdev_upper_dev_link
(via bond_master_upper_dev_link) not sufficient?

>This change simply sends an extra notification once the port has been
>linked to the upper to synchronize the initial state.
>
>Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>---
> drivers/net/bonding/bond_main.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 71c9677d135f..80c164198dcf 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1897,6 +1897,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> 		goto err_unregister;
> 	}
> 
>+	bond_lower_state_changed(new_slave);
>+
> 	res = bond_sysfs_slave_add(new_slave);
> 	if (res) {
> 		slave_dbg(bond_dev, slave_dev, "Error %d calling bond_sysfs_slave_add\n", res);

	Would it be better to add this call further down, after all
possible failures have been checked?  I.e., if this new call to
bond_lower_state_changed() completes, and then very soon afterwards the
upper is unlinked, could that cause any issues?

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
