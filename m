Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE0438CB7F
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 19:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237917AbhEURDe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 May 2021 13:03:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50663 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237830AbhEURDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 13:03:33 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lk8XG-00067P-L1; Fri, 21 May 2021 17:02:06 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 22E795FDD5; Fri, 21 May 2021 10:02:05 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 1CA9CA040C;
        Fri, 21 May 2021 10:02:05 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/4] bonding/balance-alb: don't tx balance multicast traffic either
In-reply-to: <20210521132756.1811620-4-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com> <20210521132756.1811620-1-jarod@redhat.com> <20210521132756.1811620-4-jarod@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Fri, 21 May 2021 09:27:55 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18964.1621616525.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Fri, 21 May 2021 10:02:05 -0700
Message-ID: <18965.1621616525@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>Multicast traffic going out the non-primary interface can come back in
>through the primary interface in alb mode. When there's a bridge sitting
>on top of the bond, with virtual machines behind it, attached to vnetX
>interfaces also acting as bridge ports, this can cause problems. The
>looped frame has the source MAC of the VM behind the bridge, and ends up
>rewriting the bridge forwarding database entries, replacing a vnetX entry
>in the fdb with the bond instead, at which point, we lose traffic. If we
>don't tx balance multicast traffic, we don't break connectivity.
>
>Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>Cc: Veaceslav Falico <vfalico@gmail.com>
>Cc: Andy Gospodarek <andy@greyhouse.net>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Thomas Davis <tadavis@lbl.gov>
>Cc: netdev@vger.kernel.org
>Signed-off-by: Jarod Wilson <jarod@redhat.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>---
> drivers/net/bonding/bond_alb.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>index c57f62e43328..cddc4d8b2519 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -1418,7 +1418,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
> 	case ETH_P_IP: {
> 		const struct iphdr *iph;
> 
>-		if (is_broadcast_ether_addr(eth_data->h_dest) ||
>+		if (is_multicast_ether_addr(eth_data->h_dest) ||
> 		    !pskb_network_may_pull(skb, sizeof(*iph))) {
> 			do_tx_balance = false;
> 			break;
>@@ -1438,7 +1438,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
> 		/* IPv6 doesn't really use broadcast mac address, but leave
> 		 * that here just in case.
> 		 */
>-		if (is_broadcast_ether_addr(eth_data->h_dest)) {
>+		if (is_multicast_ether_addr(eth_data->h_dest)) {
> 			do_tx_balance = false;
> 			break;
> 		}
>-- 
>2.30.2
>
