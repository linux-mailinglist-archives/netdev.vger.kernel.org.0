Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3012322CF
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgG2QkA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Jul 2020 12:40:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58051 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726496AbgG2Qj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 12:39:58 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-dYoYi53nMd-ARsjNQFAf4w-1; Wed, 29 Jul 2020 12:39:54 -0400
X-MC-Unique: dYoYi53nMd-ARsjNQFAf4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC41718AAD42;
        Wed, 29 Jul 2020 16:39:52 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC7BA5DA75;
        Wed, 29 Jul 2020 16:39:51 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, cagney@libreswan.org,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec 2/2] espintcp: count packets dropped in espintcp_rcv
Date:   Wed, 29 Jul 2020 18:38:43 +0200
Message-Id: <fc6daad7e7cc0ec9cc75dd3489dada90f8d19275.1596038944.git.sd@queasysnail.net>
In-Reply-To: <7be76ce1ce1e38643484d72d3329ed9d7aa62b94.1596038944.git.sd@queasysnail.net>
References: <7be76ce1ce1e38643484d72d3329ed9d7aa62b94.1596038944.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, espintcp_rcv drops packets silently, which makes debugging
issues difficult. Count packets as either XfrmInHdrError (when the
packet was too short or contained invalid data) or XfrmInError (for
other issues).

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/espintcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 0a91b07f2b43..827ccdf2db57 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -15,6 +15,7 @@ static void handle_nonesp(struct espintcp_ctx *ctx, struct sk_buff *skb,
 {
 	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf ||
 	    !sk_rmem_schedule(sk, skb, skb->truesize)) {
+		XFRM_INC_STATS(sock_net(sk), LINUX_MIB_XFRMINERROR);
 		kfree_skb(skb);
 		return;
 	}
@@ -59,6 +60,7 @@ static void espintcp_rcv(struct strparser *strp, struct sk_buff *skb)
 
 		err = skb_copy_bits(skb, rxm->offset + 2, &data, 1);
 		if (err < 0) {
+			XFRM_INC_STATS(sock_net(strp->sk), LINUX_MIB_XFRMINHDRERROR);
 			kfree_skb(skb);
 			return;
 		}
@@ -71,6 +73,7 @@ static void espintcp_rcv(struct strparser *strp, struct sk_buff *skb)
 
 	/* drop other short messages */
 	if (unlikely(len <= sizeof(nonesp_marker))) {
+		XFRM_INC_STATS(sock_net(strp->sk), LINUX_MIB_XFRMINHDRERROR);
 		kfree_skb(skb);
 		return;
 	}
@@ -78,17 +81,20 @@ static void espintcp_rcv(struct strparser *strp, struct sk_buff *skb)
 	err = skb_copy_bits(skb, rxm->offset + 2, &nonesp_marker,
 			    sizeof(nonesp_marker));
 	if (err < 0) {
+		XFRM_INC_STATS(sock_net(strp->sk), LINUX_MIB_XFRMINHDRERROR);
 		kfree_skb(skb);
 		return;
 	}
 
 	/* remove header, leave non-ESP marker/SPI */
 	if (!__pskb_pull(skb, rxm->offset + 2)) {
+		XFRM_INC_STATS(sock_net(strp->sk), LINUX_MIB_XFRMINERROR);
 		kfree_skb(skb);
 		return;
 	}
 
 	if (pskb_trim(skb, rxm->full_len - 2) != 0) {
+		XFRM_INC_STATS(sock_net(strp->sk), LINUX_MIB_XFRMINERROR);
 		kfree_skb(skb);
 		return;
 	}
-- 
2.27.0

