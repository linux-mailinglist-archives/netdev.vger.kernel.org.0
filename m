Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F34538C807
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbhEUN3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:29:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235516AbhEUN3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 09:29:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621603696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VhNQFxkaQPnrQi8kjdlaaUSwWp56dWqJAcIJv0VkFH0=;
        b=aCLhWul2UssVl6PI+9zk59XUAqzkkAXhZLH05TGwLWWFHjGYhTpm1SktwrGuiAYen9kgai
        02q+ov8dzb+6UAV8dIIjecQ044avlVkyafiDhmX7JFdNri833bcPFeG9n0uj0VQgJb/Xrz
        AXSU83jKftZWkYktS4f1Ct2qWyBZfUc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-Jlt78sEENw6Yilvct5FSlw-1; Fri, 21 May 2021 09:28:12 -0400
X-MC-Unique: Jlt78sEENw6Yilvct5FSlw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8989C107AFA8;
        Fri, 21 May 2021 13:28:11 +0000 (UTC)
Received: from f33vm.wilsonet.com.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 539B0100AE43;
        Fri, 21 May 2021 13:28:10 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 3/4] bonding/balance-alb: don't tx balance multicast traffic either
Date:   Fri, 21 May 2021 09:27:55 -0400
Message-Id: <20210521132756.1811620-4-jarod@redhat.com>
In-Reply-To: <20210521132756.1811620-1-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com>
 <20210521132756.1811620-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multicast traffic going out the non-primary interface can come back in
through the primary interface in alb mode. When there's a bridge sitting
on top of the bond, with virtual machines behind it, attached to vnetX
interfaces also acting as bridge ports, this can cause problems. The
looped frame has the source MAC of the VM behind the bridge, and ends up
rewriting the bridge forwarding database entries, replacing a vnetX entry
in the fdb with the bond instead, at which point, we lose traffic. If we
don't tx balance multicast traffic, we don't break connectivity.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_alb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index c57f62e43328..cddc4d8b2519 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1418,7 +1418,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 	case ETH_P_IP: {
 		const struct iphdr *iph;
 
-		if (is_broadcast_ether_addr(eth_data->h_dest) ||
+		if (is_multicast_ether_addr(eth_data->h_dest) ||
 		    !pskb_network_may_pull(skb, sizeof(*iph))) {
 			do_tx_balance = false;
 			break;
@@ -1438,7 +1438,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 		/* IPv6 doesn't really use broadcast mac address, but leave
 		 * that here just in case.
 		 */
-		if (is_broadcast_ether_addr(eth_data->h_dest)) {
+		if (is_multicast_ether_addr(eth_data->h_dest)) {
 			do_tx_balance = false;
 			break;
 		}
-- 
2.30.2

