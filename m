Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CE738995C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 00:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhESWd1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 May 2021 18:33:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44755 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhESWd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 18:33:26 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1ljUjR-0007Hn-E3; Wed, 19 May 2021 22:32:01 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 9CA415FDD5; Wed, 19 May 2021 15:31:59 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 97494A040C;
        Wed, 19 May 2021 15:31:59 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] bond_alb: don't rewrite bridged non-local MACs
In-reply-to: <20210518210849.1673577-3-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com> <20210518210849.1673577-3-jarod@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Tue, 18 May 2021 17:08:47 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7728.1621463519.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 19 May 2021 15:31:59 -0700
Message-ID: <7729.1621463519@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>With a virtual machine behind a bridge on top of a bond, outgoing traffic
>should retain the VM's source MAC. That works fine most of the time, until
>doing a failover, and then the MAC gets rewritten to the bond slave's MAC,
>and the return traffic gets dropped. If we don't rewrite the MAC there, we
>don't lose any traffic.

	Please have the log message here specify that this applies only
to balance-alb mode, and, the usual nomenclature for bonding patches is
"[PATCH] bonding:"; for this case, I'd suggest "balance-alb:" right
afterwards to be clear that it's only for alb mode.  I didn't really
spot the "bond_alb" tag for what it was on first read, and it is the
only indication that this change is specific to alb mode other than the
patch itself.

>Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>Cc: Veaceslav Falico <vfalico@gmail.com>
>Cc: Andy Gospodarek <andy@greyhouse.net>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Thomas Davis <tadavis@lbl.gov>
>Cc: netdev@vger.kernel.org
>Signed-off-by: Jarod Wilson <jarod@redhat.com>
>---
> drivers/net/bonding/bond_alb.c | 23 ++++++++++++++++++++++-
> 1 file changed, 22 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>index 3455f2cc13f2..ce8257c7cbea 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -1302,6 +1302,26 @@ void bond_alb_deinitialize(struct bonding *bond)
> 		rlb_deinitialize(bond);
> }
> 
>+static bool bond_alb_bridged_mac(struct bonding *bond, struct ethhdr *eth_data)
>+{
>+	struct list_head *iter;
>+	struct slave *slave;
>+
>+	if (BOND_MODE(bond) != BOND_MODE_ALB)
>+		return false;
>+
>+	/* Don't modify source MACs that do not originate locally
>+	 * (e.g.,arrive via a bridge).
>+	 */
>+	if (!netif_is_bridge_port(bond->dev))
>+		return false;

	I believe this logic will fail if the plumbing is, e.g., bond ->
vlan -> bridge, as netif_is_bridge_port() would not return true for the
bond in that case.

	Making this reliable is tricky at best, and may be impossible to
be correct for all possible cases.  As such, I think the comment above
should reflect the limited scope of what is actually being checked here
(i.e., the bond itself is directly a bridge port).

	-J

>+
>+	if (bond_slave_has_mac_rx(bond, eth_data->h_source))
>+		return false;
>+
>+	return true;
>+}
>+
> static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
> 				    struct slave *tx_slave)
> {
>@@ -1316,7 +1336,8 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
> 	}
> 
> 	if (tx_slave && bond_slave_can_tx(tx_slave)) {
>-		if (tx_slave != rcu_access_pointer(bond->curr_active_slave)) {
>+		if (tx_slave != rcu_access_pointer(bond->curr_active_slave) &&
>+		    !bond_alb_bridged_mac(bond, eth_data)) {
> 			ether_addr_copy(eth_data->h_source,
> 					tx_slave->dev->dev_addr);
> 		}
>-- 
>2.30.2
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
