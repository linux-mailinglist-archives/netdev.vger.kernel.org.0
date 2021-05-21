Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B729038CCCE
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 19:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237461AbhEUSA1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 May 2021 14:00:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52016 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhEUSA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 14:00:27 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lk9QJ-0001wv-IG; Fri, 21 May 2021 17:58:59 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id BE7BF5FDD5; Fri, 21 May 2021 10:58:57 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id B6766A040C;
        Fri, 21 May 2021 10:58:57 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/4] bonding/balance-lb: don't rewrite bridged non-local MACs
In-reply-to: <20210521132756.1811620-3-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com> <20210521132756.1811620-1-jarod@redhat.com> <20210521132756.1811620-3-jarod@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Fri, 21 May 2021 09:27:54 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21328.1621619937.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Fri, 21 May 2021 10:58:57 -0700
Message-ID: <21329.1621619937@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>With a virtual machine behind a bridge that directly incorporates a
>balance-alb bond as one of its ports, outgoing traffic should retain the
>VM's source MAC. That works fine most of the time, until doing a failover,
>and then the MAC gets rewritten to the bond slave's MAC, and the return
>traffic gets dropped. If we don't rewrite the MAC there, we don't lose the
>traffic.

	Comparing the description above to the patch, is the erroneous
behavior really related to failover (i.e., bond slave goes down, bond
reshuffles various things as it is wont to do), or is it related to
either a TX side rebalance or even simply that specific traffic is being
sent on a slave that isn't the curr_active_slave?

	One more comment, below.

>Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>Cc: Veaceslav Falico <vfalico@gmail.com>
>Cc: Andy Gospodarek <andy@greyhouse.net>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Thomas Davis <tadavis@lbl.gov>
>Cc: netdev@vger.kernel.org
>Signed-off-by: Jarod Wilson <jarod@redhat.com>
>---
> drivers/net/bonding/bond_alb.c | 20 +++++++++++++++++++-
> 1 file changed, 19 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>index 3455f2cc13f2..c57f62e43328 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -1302,6 +1302,23 @@ void bond_alb_deinitialize(struct bonding *bond)
> 		rlb_deinitialize(bond);
> }
> 
>+static bool bond_alb_bridged_mac(struct bonding *bond, struct ethhdr *eth_data)
>+{
>+	if (BOND_MODE(bond) != BOND_MODE_ALB)
>+		return false;
>+
>+	/* Don't modify source MACs that do not originate locally
>+	 * (e.g.,arrive via a bridge).
>+	 */
>+	if (!netif_is_bridge_port(bond->dev))
>+		return false;

	Repeating my comment (from my response to the v1 patch) that
hasn't been addressed:

	I believe this logic will fail if the plumbing is, e.g., bond ->
vlan -> bridge, as netif_is_bridge_port() would not return true for the
bond in that case.

	Making this reliable is tricky at best, and may be impossible to
be correct for all possible cases.  As such, I think the comment above
should reflect the limited scope of what is actually being checked here
(i.e., the bond itself is directly a bridge port).

	Ideally, the bonding.rst documentation should describe the
special behaviors of alb mode when configured as a bridge port.

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
>@@ -1316,7 +1333,8 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
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

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
