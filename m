Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572AB55ED2A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbiF1TAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbiF1TAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:25 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1E0140B8;
        Tue, 28 Jun 2022 12:00:06 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id q6so27605025eji.13;
        Tue, 28 Jun 2022 12:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DH0j6e+roINRxOwiEwvBMCy+ld2yqYbsEeKnLOkWo28=;
        b=AJ1mx5B8G/qRZ1wHonjQ+NfAd8jMG0CfK+1Q0qHsmiFtCSLEo8PbfOQEthCaMP4jeG
         qvtwe6WecBXJuMuBo9rX55vN1eFPDlE/im8kvKOftx7Rasu767aHJ8QRqX4AMvfnYeAG
         iJFR1krhwt4PvOC1pkqhGc7k7ntxeoAIOQMUkJyyhQoUlKJB1GwjikIG92dib3dC6hEd
         x4MlJYeXmgi9gO2QNWr4lRPjjG0h77Pt80KJ+ED0ggxtw9yV0CEhdclmXpDmAH3V6y2C
         0aIJTzuyOLCe+7ue1OI4k27vmm16PyeVVYZf7DzZYNyzAGSN3uHYRsNQnOSIPmO0wHaj
         vmWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DH0j6e+roINRxOwiEwvBMCy+ld2yqYbsEeKnLOkWo28=;
        b=lKcVmT74Gta8/cStKW6m7Zch1tZthK0fxql9CN8mYY7316hlOfhgyE4l3cL1H/nTRv
         vcmsaD6sT20KgtW9G7lBSCzNBJNfGDTg/dyeHBqOFlpAQX1bSeFDCnTxBSZcHiQzregM
         yz27vjJpIhFQWEnHpIoLUg9tQ+6vnt07rmmWA1XW1DWGIuYpjHD9Yncckr95S3zSVgCY
         /bM7vw+QBXmcQNNvq8BYXGNMAXF/fxBnE3Ud1pJTU/2As5cVTU2CfyFgpPrZIsOPf26J
         i231MixS3Lfz9aETnBNepFAW6CM0UvyVO+UYwAcYAAtYsWDq5beiM2upY6iYCPJeweHX
         m3XA==
X-Gm-Message-State: AJIora9uK1u+8RaDffAT5HgIkGIvPEH6ErIjTCUI5ZZbYOK3VGMeWwvG
        7ByMM59zGueknZWwxPdIHUo+0E6WOm8h5g==
X-Google-Smtp-Source: AGRyM1uCPdIqLl0a2kpzcP4JJICwksY+7+UmuTZ3GpTgLnvtW+Y4ZDXfPntodmoDBlkEySElTMN1Ow==
X-Received: by 2002:a17:907:1b25:b0:6da:8206:fc56 with SMTP id mp37-20020a1709071b2500b006da8206fc56mr889842ejc.81.1656442804512;
        Tue, 28 Jun 2022 12:00:04 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 10/29] ipv6/udp: support zc with managed data
Date:   Tue, 28 Jun 2022 19:56:32 +0100
Message-Id: <4ac277fa467025f164b67a76dfb8e12ff6e8ee7d.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
References: <cover.1653992701.git.asml.silence@gmail.com>
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

Just as with ipv4/udp make ipv6/udp to take advantage of managed data
and propagate SKBFL_MANAGED_FRAG_REFS to skb_zerocopy_iter_dgram().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 57 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 6103cd9066ff..f4138ce6eda3 100644
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
@@ -1778,7 +1796,18 @@ static int __ip6_append_data(struct sock *sk,
 			skb->truesize += copy;
 			wmem_alloc_delta += copy;
 		} else {
-			err = skb_zerocopy_iter_dgram(skb, from, copy);
+			struct msghdr *msg = from;
+
+			if (!skb_shinfo(skb)->nr_frags) {
+				if (msg->msg_managed_data)
+					skb_shinfo(skb)->flags |= SKBFL_MANAGED_FRAG_REFS;
+			} else {
+				/* appending, don't mix managed and unmanaged */
+				if (!msg->msg_managed_data)
+					skb_zcopy_downgrade_managed(skb);
+			}
+
+			err = skb_zerocopy_iter_dgram(skb, msg, copy);
 			if (err < 0)
 				goto error;
 		}
-- 
2.36.1

