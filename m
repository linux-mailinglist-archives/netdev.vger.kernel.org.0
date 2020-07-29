Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138F62322CE
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgG2Qj6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Jul 2020 12:39:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20581 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726496AbgG2Qj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 12:39:57 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-aSYvTtcXOouJ-YLZ5-ixSA-1; Wed, 29 Jul 2020 12:39:52 -0400
X-MC-Unique: aSYvTtcXOouJ-YLZ5-ixSA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6705659;
        Wed, 29 Jul 2020 16:39:51 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9EDF5DA76;
        Wed, 29 Jul 2020 16:39:49 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, cagney@libreswan.org,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec 1/2] espintcp: handle short messages instead of breaking the encap socket
Date:   Wed, 29 Jul 2020 18:38:42 +0200
Message-Id: <7be76ce1ce1e38643484d72d3329ed9d7aa62b94.1596038944.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, short messages (less than 4 bytes after the length header)
will break the stream of messages. This is unnecessary, since we can
still parse messages even if they're too short to contain any usable
data. This is also bogus, as keepalive messages (a single 0xff byte),
though not needed with TCP encapsulation, should be allowed.

This patch changes the stream parser so that short messages are
accepted and dropped in the kernel. Messages that contain a valid SPI
or non-ESP header are processed as before.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Reported-by: Andrew Cagney <cagney@libreswan.org>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/espintcp.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index cb83e3664680..0a91b07f2b43 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -49,9 +49,32 @@ static void espintcp_rcv(struct strparser *strp, struct sk_buff *skb)
 	struct espintcp_ctx *ctx = container_of(strp, struct espintcp_ctx,
 						strp);
 	struct strp_msg *rxm = strp_msg(skb);
+	int len = rxm->full_len - 2;
 	u32 nonesp_marker;
 	int err;
 
+	/* keepalive packet? */
+	if (unlikely(len == 1)) {
+		u8 data;
+
+		err = skb_copy_bits(skb, rxm->offset + 2, &data, 1);
+		if (err < 0) {
+			kfree_skb(skb);
+			return;
+		}
+
+		if (data == 0xff) {
+			kfree_skb(skb);
+			return;
+		}
+	}
+
+	/* drop other short messages */
+	if (unlikely(len <= sizeof(nonesp_marker))) {
+		kfree_skb(skb);
+		return;
+	}
+
 	err = skb_copy_bits(skb, rxm->offset + 2, &nonesp_marker,
 			    sizeof(nonesp_marker));
 	if (err < 0) {
@@ -91,7 +114,7 @@ static int espintcp_parse(struct strparser *strp, struct sk_buff *skb)
 		return err;
 
 	len = be16_to_cpu(blen);
-	if (len < 6)
+	if (len < 2)
 		return -EINVAL;
 
 	return len;
-- 
2.27.0

