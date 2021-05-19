Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8853895B6
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 20:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhESSqr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 May 2021 14:46:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39654 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhESSqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 14:46:47 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1ljRC1-0008NX-Fb; Wed, 19 May 2021 18:45:17 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 98C3C5FDD5; Wed, 19 May 2021 11:45:15 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 90CF0A040C;
        Wed, 19 May 2021 11:45:15 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] bond_alb: don't tx balance multicast traffic either
In-reply-to: <20210518210849.1673577-4-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com> <20210518210849.1673577-4-jarod@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Tue, 18 May 2021 17:08:48 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32658.1621449915.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 19 May 2021 11:45:15 -0700
Message-ID: <32659.1621449915@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>Multicast traffic going out the non-primary interface can come back in
>through the primary interface in alb mode. When there's a bridge sitting
>on top of the bond, with virtual machines behind it, attached to vnetX
>interfaces also acting as bridge ports, this can cause problems. The
>multicast traffic ends up rewriting the bridge forwarding database
>entries, replacing a vnetX entry in the fdb with the bond instead, at
>which point, we lose traffic. If we don't tx balance multicast traffic, we
>don't break connectivity.

	Just so I'm clear, the rewrite happens because the "looped"
frame bears the source MAC of the VM behind the bridge, but is arriving
at the bridge via the bond, correct?

	If so this change seems reasonable, with one minor nit, below.

>Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>Cc: Veaceslav Falico <vfalico@gmail.com>
>Cc: Andy Gospodarek <andy@greyhouse.net>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Thomas Davis <tadavis@lbl.gov>
>Cc: netdev@vger.kernel.org
>Signed-off-by: Jarod Wilson <jarod@redhat.com>
>---
> drivers/net/bonding/bond_alb.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>index ce8257c7cbea..4df661b77252 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -1422,6 +1422,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
> 		const struct iphdr *iph;
> 
> 		if (is_broadcast_ether_addr(eth_data->h_dest) ||
>+		    is_multicast_ether_addr(eth_data->h_dest) ||

	Note that is_multicast_ is a superset of is_broadcast_, so in
this case (and the one below) is_broadcast_ can simply be replaced by
is_multicast_.  Granted, is_broadcast_ is cheap, but this is in the TX
path for every packet.

	-J

> 		    !pskb_network_may_pull(skb, sizeof(*iph))) {
> 			do_tx_balance = false;
> 			break;
>@@ -1441,7 +1442,8 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
> 		/* IPv6 doesn't really use broadcast mac address, but leave
> 		 * that here just in case.
> 		 */
>-		if (is_broadcast_ether_addr(eth_data->h_dest)) {
>+		if (is_broadcast_ether_addr(eth_data->h_dest) ||
>+		    is_multicast_ether_addr(eth_data->h_dest)) {
> 			do_tx_balance = false;
> 			break;
> 		}
>-- 
>2.30.2
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
