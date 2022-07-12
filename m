Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8462D5727D5
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbiGLUyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiGLUxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:46 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC2DD0398;
        Tue, 12 Jul 2022 13:53:21 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id y22-20020a7bcd96000000b003a2e2725e89so108869wmj.0;
        Tue, 12 Jul 2022 13:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s8Z4UCQCwXUXw8ymrA0AVRoggqHC6f/FDd/tj/tGO10=;
        b=YI+zuSHqDwgBSxMQDbNdfCXJYnhCEzG4jPJonm/OmJPXWYtolgG2mlqxIhZ+njdofI
         knhC01VD3yq1AxzXVlRRvfZDTpIXxbDi/ljvOl7fu+97hDXxyo71aDpQ/4sSrPq0TF9E
         XATyfL9AWsmPeUok7LUGrB07G9QDvlfELB/rFcvym7OGBrM8CkFiIBcfhuc065c5k8wR
         q6Ew2qcY8s8CYrsonVSA3c5pqRnuSqM81RKk37QqsOX7kIb5jiE0vZyd+WG0IjIQtpSK
         /rEQ/xNxv3xz34QhrecjpSmSBFeY93Z3IBGhsiWLjDOe3t0+weJ6+OknbAuXMCNh3Ijx
         /aTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s8Z4UCQCwXUXw8ymrA0AVRoggqHC6f/FDd/tj/tGO10=;
        b=klN8gSfmOwhEh0IZ9z5dSOLCHDhvq0MuigvPFbws094qw4Cr2zYM1TDqIqJ+8300Bv
         f+JUDsh3QJQr7e9dxvb551Ubd/vrELKrJP/h23IxYd0dRFLknGEsxDVNnSUne8P1BpU3
         9UfIlJt1iDFhe+tubuo6uBbpuTMiC8ovsiX+CcObIWpRNWYS0kCn2IO3Wo+PUNIGQqrD
         ZPPSB3sYHNhv0QWakp6O6eXdL7S0iZX/P2JoA6L20pVC8srQSXlH3ivJlB4elnm63sFE
         ugNhxNx4w8iScVVbOcuKU8DcWGR49l8Cg/IAnZa+zE5kUJ4lKwoQjjwWqVeK2UIAT/KD
         tfsg==
X-Gm-Message-State: AJIora9nZCWUKAakRIS/myNXSuhASu0RRLzYSapPmtnnpP7CCxPPRcrg
        B7jWMAszkn3MB3gttsGZSOjLTH/IjqA=
X-Google-Smtp-Source: AGRyM1tHCITSPTZ0F1HAPZl2f3/b1zgi2kTBLFOzml+urwPzYJHZiZ4OEm8WKUydwn4dPFhWDsbuWw==
X-Received: by 2002:a05:600c:3512:b0:3a0:5005:86b5 with SMTP id h18-20020a05600c351200b003a0500586b5mr6132266wmq.191.1657659199486;
        Tue, 12 Jul 2022 13:53:19 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 10/27] ipv6/udp: support externally provided ubufs
Date:   Tue, 12 Jul 2022 21:52:34 +0100
Message-Id: <d35ed18eb47cf8c2778f48703ee75bced37878ad.1657643355.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Teach ipv6/udp how to use external ubuf_info provided in msghdr and
also prepare it for managed frags by sprinkling
skb_zcopy_downgrade_managed() when it could mix managed and not managed
frags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 44 ++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index fc74ce3ed8cc..897ca4f9b791 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1542,18 +1542,35 @@ static int __ip6_append_data(struct sock *sk,
 	    rt->dst.dev->features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
 		csummode = CHECKSUM_PARTIAL;
 
-	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
-		uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
-		if (!uarg)
-			return -ENOBUFS;
-		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
-		if (rt->dst.dev->features & NETIF_F_SG &&
-		    csummode == CHECKSUM_PARTIAL) {
-			paged = true;
-			zc = true;
-		} else {
-			uarg->zerocopy = 0;
-			skb_zcopy_set(skb, uarg, &extra_uref);
+	if ((flags & MSG_ZEROCOPY) && length) {
+		struct msghdr *msg = from;
+
+		if (getfrag == ip_generic_getfrag && msg->msg_ubuf) {
+			if (skb_zcopy(skb) && msg->msg_ubuf != skb_zcopy(skb))
+				return -EINVAL;
+
+			/* Leave uarg NULL if can't zerocopy, callers should
+			 * be able to handle it.
+			 */
+			if ((rt->dst.dev->features & NETIF_F_SG) &&
+			    csummode == CHECKSUM_PARTIAL) {
+				paged = true;
+				zc = true;
+				uarg = msg->msg_ubuf;
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
 
@@ -1747,13 +1764,14 @@ static int __ip6_append_data(struct sock *sk,
 				err = -EFAULT;
 				goto error;
 			}
-		} else if (!uarg || !uarg->zerocopy) {
+		} else if (!zc) {
 			int i = skb_shinfo(skb)->nr_frags;
 
 			err = -ENOMEM;
 			if (!sk_page_frag_refill(sk, pfrag))
 				goto error;
 
+			skb_zcopy_downgrade_managed(skb);
 			if (!skb_can_coalesce(skb, i, pfrag->page,
 					      pfrag->offset)) {
 				err = -EMSGSIZE;
-- 
2.37.0

