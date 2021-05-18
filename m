Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53A63881DF
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 23:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352426AbhERVKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 17:10:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352388AbhERVKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 17:10:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621372157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0EdZKGLvpg9XNYKF32LxZQi1X77ds8QQ+CclE0BiKbw=;
        b=FDIInr1d8rn9+d+Hcvmj/jVnVb00V2glczNbyR/3Fzg8CnYIdaMcSpmWX/Yo3QMeyYK2w4
        z4pKszdo1Jy5l/GYF5QtlbdR/RRghrZHBziHYSW/OJpKEa/RtRWIPCy6yUY/blv1c/Powp
        dLUXEM0Ckda2w1EhQHvQahWUJd4cHeA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-Xs4YkqEcMvaI2ZvTCuosww-1; Tue, 18 May 2021 17:09:16 -0400
X-MC-Unique: Xs4YkqEcMvaI2ZvTCuosww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23F74106BAA7;
        Tue, 18 May 2021 21:09:15 +0000 (UTC)
Received: from f33vm.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E32475C1A1;
        Tue, 18 May 2021 21:09:13 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH 3/4] bond_alb: don't tx balance multicast traffic either
Date:   Tue, 18 May 2021 17:08:48 -0400
Message-Id: <20210518210849.1673577-4-jarod@redhat.com>
In-Reply-To: <20210518210849.1673577-1-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multicast traffic going out the non-primary interface can come back in
through the primary interface in alb mode. When there's a bridge sitting
on top of the bond, with virtual machines behind it, attached to vnetX
interfaces also acting as bridge ports, this can cause problems. The
multicast traffic ends up rewriting the bridge forwarding database
entries, replacing a vnetX entry in the fdb with the bond instead, at
which point, we lose traffic. If we don't tx balance multicast traffic, we
don't break connectivity.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_alb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index ce8257c7cbea..4df661b77252 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1422,6 +1422,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 		const struct iphdr *iph;
 
 		if (is_broadcast_ether_addr(eth_data->h_dest) ||
+		    is_multicast_ether_addr(eth_data->h_dest) ||
 		    !pskb_network_may_pull(skb, sizeof(*iph))) {
 			do_tx_balance = false;
 			break;
@@ -1441,7 +1442,8 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 		/* IPv6 doesn't really use broadcast mac address, but leave
 		 * that here just in case.
 		 */
-		if (is_broadcast_ether_addr(eth_data->h_dest)) {
+		if (is_broadcast_ether_addr(eth_data->h_dest) ||
+		    is_multicast_ether_addr(eth_data->h_dest)) {
 			do_tx_balance = false;
 			break;
 		}
-- 
2.30.2

