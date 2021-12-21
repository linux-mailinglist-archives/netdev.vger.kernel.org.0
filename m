Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8802E47C2F5
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239528AbhLUPgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239432AbhLUPgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:00 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ECFC061746;
        Tue, 21 Dec 2021 07:35:59 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o19-20020a1c7513000000b0033a93202467so2344933wmc.2;
        Tue, 21 Dec 2021 07:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RTN4JC/Cs0aKfPl2h/v0kiFtkMj5n0j4ZWeMe20qCjU=;
        b=gYWRgOBHLYoMRt+5a3W6g1jnt2VexcpDkrtmU24DVf2hXA1ufGcFJ3fKO28Gn3/SgA
         2p3QevyFs7R7B42DBg7DCqrKYq5tN+nU6qUVvTTcZ/8+QUwsl29KjcGS2z203zfGcdd+
         e13kbFPgwCDhvrSBqOCJ8/uQHWHOUbwDJ/YgfnuMta4XtFkveQuGrwTOTLWts5omgy/W
         bbJLfehBXSris8OyXEyvnahVIBxS4Ugtk+suq5dJ7lcwsK55NT325fhmGSwVexjV5VaK
         ox/lTFN59bAuRJDSWVdUpWrHMsrTW+6is6lWiVWjUrEGRkIcvfDbpqJTWnLMjTeI2iqD
         H4ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RTN4JC/Cs0aKfPl2h/v0kiFtkMj5n0j4ZWeMe20qCjU=;
        b=G4pGmIKqoepZmdBMPR6SCOhrEyQ7Y+nWnfCm/+vfud0NfnCXpRyltRLeh6/Qw/Dq9q
         AWzshc4e2rlcPaV5MwG914SNHMHDgBSrR42FNgr1Cu4sAA7/wAAkL9xVetp4NdQcGynh
         cQ+o4QJCDhnuzMRr51Ng/cgZH70oSm4OsW5cogqYPpsJ5ssJ/o/qb9pOw6ZSFfeB/rat
         hWv62JC493e9209WYhQPJDueBD+2bKjvHIHhBbo/XmrbhU3NeyIoIRp778Y41qVrKZvE
         l+yia/W3Vx1WSY9NTpSOw0+CIueKNvx0rsxrK9KZYuEltpQjvcyXNeVkXiZS7Marsg6u
         CeTw==
X-Gm-Message-State: AOAM5306f59B7kbeYrW+B2/52AiKY42paWSZssv3CDwh8WpQ4iQEp616
        9mfOjdleOGk2Vr9vhvYXj3Lkg5QcYtg=
X-Google-Smtp-Source: ABdhPJx9m1Tg29F0RP07f65BaSMmKUiKR2caL/U52afTFbfNykdHRZfmrzAI/udyInj2/wl05Rq41A==
X-Received: by 2002:a05:600c:3b19:: with SMTP id m25mr3250527wms.100.1640100958248;
        Tue, 21 Dec 2021 07:35:58 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:35:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC v2 06/19] ipv4/udp: add support msgdr::msg_ubuf
Date:   Tue, 21 Dec 2021 15:35:28 +0000
Message-Id: <92234ed7fe28f63c475b22c25cdc271adadd640d.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make ipv4/udp to use ubuf_info passed in struct msghdr if it was
specified.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/ip_output.c | 50 ++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 9bca57ef8b83..f820288092ab 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -953,7 +953,6 @@ static int __ip_append_data(struct sock *sk,
 	struct inet_sock *inet = inet_sk(sk);
 	struct ubuf_info *uarg = NULL;
 	struct sk_buff *skb;
-
 	struct ip_options *opt = cork->opt;
 	int hh_len;
 	int exthdrlen;
@@ -967,6 +966,7 @@ static int __ip_append_data(struct sock *sk,
 	unsigned int wmem_alloc_delta = 0;
 	bool paged, extra_uref = false;
 	u32 tskey = 0;
+	bool zc = false;
 
 	skb = skb_peek_tail(queue);
 
@@ -1001,17 +1001,37 @@ static int __ip_append_data(struct sock *sk,
 	    (!exthdrlen || (rt->dst.dev->features & NETIF_F_HW_ESP_TX_CSUM)))
 		csummode = CHECKSUM_PARTIAL;
 
-	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
-		uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
-		if (!uarg)
-			return -ENOBUFS;
-		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
-		if (rt->dst.dev->features & NETIF_F_SG &&
-		    csummode == CHECKSUM_PARTIAL) {
-			paged = true;
-		} else {
-			uarg->zerocopy = 0;
-			skb_zcopy_set(skb, uarg, &extra_uref);
+	if ((flags & MSG_ZEROCOPY) && length) {
+		struct msghdr *msg = from;
+
+		if (getfrag == ip_generic_getfrag && msg->msg_ubuf) {
+			uarg = msg->msg_ubuf;
+			if (skb_zcopy(skb) && uarg != skb_zcopy(skb))
+				return -EINVAL;
+
+			if (rt->dst.dev->features & NETIF_F_SG &&
+			    csummode == CHECKSUM_PARTIAL) {
+				paged = true;
+				zc = true;
+			} else {
+				/* Drop uarg if can't zerocopy, callers should
+				 * be able to handle it.
+				 */
+				uarg = NULL;
+			}
+		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
+			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
+			if (!uarg)
+				return -ENOBUFS;
+			extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
+			if (rt->dst.dev->features & NETIF_F_SG &&
+			    csummode == CHECKSUM_PARTIAL) {
+				paged = true;
+				zc = true;
+			} else {
+				uarg->zerocopy = 0;
+				skb_zcopy_set(skb, uarg, &extra_uref);
+			}
 		}
 	}
 
@@ -1172,9 +1192,13 @@ static int __ip_append_data(struct sock *sk,
 				err = -EFAULT;
 				goto error;
 			}
-		} else if (!uarg || !uarg->zerocopy) {
+		} else if (!zc) {
 			int i = skb_shinfo(skb)->nr_frags;
 
+			if (skb_shinfo(skb)->flags & SKBFL_MANAGED_FRAGS) {
+				err = -EFAULT;
+				goto error;
+			}
 			err = -ENOMEM;
 			if (!sk_page_frag_refill(sk, pfrag))
 				goto error;
-- 
2.34.1

