Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E082CC647
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389704AbgLBTK1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 14:10:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52727 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387967AbgLBTK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 14:10:26 -0500
Received: from 1.general.jvosburgh.uk.vpn ([10.172.196.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kkXVU-00028c-Gv; Wed, 02 Dec 2020 19:09:40 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 15B995FEE8; Wed,  2 Dec 2020 11:09:39 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 0FF229FAB0;
        Wed,  2 Dec 2020 11:09:39 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 1/4] net: bonding: Notify ports about their initial state
In-reply-to: <20201202091356.24075-2-tobias@waldekranz.com>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-2-tobias@waldekranz.com>
Comments: In-reply-to Tobias Waldekranz <tobias@waldekranz.com>
   message dated "Wed, 02 Dec 2020 10:13:53 +0100."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17901.1606936179.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 02 Dec 2020 11:09:39 -0800
Message-ID: <17902.1606936179@famine>
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
>
>This change simply sends an extra notification once the port has been
>linked to the upper to synchronize the initial state.

	I'm not objecting to this per se, but looking at team and
net_failover (failover_slave_register), those drivers do not send the
same first notification that bonding does (the "can not associate" one),
but only send a notification after netdev_master_upper_dev_link is
complete.

	Does it therefore make more sense to move the existing
notification within bonding to take place after the upper_dev_link
(where you're adding this new call to bond_lower_state_changed)?  If the
existing notification is effectively useless, this would make the
sequence of notifications consistent across drivers.

	-J

>Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>---
> drivers/net/bonding/bond_main.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index e0880a3840d7..d6e1f9cf28d5 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1922,6 +1922,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> 		goto err_unregister;
> 	}
> 
>+	bond_lower_state_changed(new_slave);
>+
> 	res = bond_sysfs_slave_add(new_slave);
> 	if (res) {
> 		slave_dbg(bond_dev, slave_dev, "Error %d calling bond_sysfs_slave_add\n", res);
>-- 
>2.17.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
