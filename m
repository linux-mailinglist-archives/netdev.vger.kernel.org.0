Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BCC5727DB
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbiGLUxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiGLUxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:43 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C937D0380;
        Tue, 12 Jul 2022 13:53:20 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id c131-20020a1c3589000000b003a2cc290135so93713wma.2;
        Tue, 12 Jul 2022 13:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=93tCkgQSnWP7j8MKkQNUUkCctSIIcngjSEkqdPJ6fOw=;
        b=fc571E8SVwODapQL0U19Opr1UFzf0q5QnKd1RASOgTqD1+rq7tyYrd2eHiC2uwlrv2
         EovC5vq+D1z7pKbUvECinQEEkM7S/iWcjjF0EAQ6UZWiqBQSJuqKr7w8pEIJuOU0Rt4I
         3bgNyzwq9YAWUNvU8FZWQwILB/QCx1RZHjLCla1ibLyUZT3hICnZlq2txEtzfoFnN1Dd
         N5XdC4dMGlMR5kYfJzbrDkrflgM2w5kj/4pFoD38YxbfgYaDqUx5tnFDJu+fcPL2jyXg
         6tvdPx9kKv9fVmV2b2rMsR0IpV7spxDBuGCGiPtNVEEJsp654oiUwaRw8j6GggKgZQAE
         MdOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=93tCkgQSnWP7j8MKkQNUUkCctSIIcngjSEkqdPJ6fOw=;
        b=W1NU2Ub4bEBIstTVKb88F5BKtILt8dssulu7GK3mv7pchDaYwsEU4mIm0Bbgv+NupA
         BjBHyYJ1P7NEV4ro9opnU6N237YNhLTycg+TRUPBosZSM72iCPZi/Eh+DbbRbbEnzRW+
         253cz1db6gX3of1XHK4RFSqgTD2nWNvJEGjg9MzqTeIU+RxnguoTO6+Q7MKlz53WLEu8
         OUVPCj6h2YqlvB0vfluyNpIYCl8xX14SxTdHoVpHzYbZumyAv1EcsAbjs6BSzBRyWiFk
         ncTgu+rtJnN032njG321ZS98qI5W0fu9x33fKxcTOqmLy+InFZzY7Y+VsoEUo8wKK837
         7oGQ==
X-Gm-Message-State: AJIora9+vmGVYvXkaoFjUmgEIv1A5JWhpHN4m+x5K7yMfA8dT5KLpVwh
        nUrxs8jfNU7zPm6g5ebhoI/hwfOcILg=
X-Google-Smtp-Source: AGRyM1sbJ9UkYmXzur77FvKfiydeJpmt08QWMLfgXVHgYyEiKJ0cddUvd8qHIVStFA1S8oB8U9exZA==
X-Received: by 2002:a7b:cd82:0:b0:3a1:7528:2d79 with SMTP id y2-20020a7bcd82000000b003a175282d79mr6043091wmj.79.1657659198241;
        Tue, 12 Jul 2022 13:53:18 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 09/27] ipv4/udp: support externally provided ubufs
Date:   Tue, 12 Jul 2022 21:52:33 +0100
Message-Id: <c7660dfeaf1950a209c8af8959713377eab5ca94.1657643355.git.asml.silence@gmail.com>
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

Teach ipv4/udp how to use external ubuf_info provided in msghdr and
also prepare it for managed frags by sprinkling
skb_zcopy_downgrade_managed() when it could mix managed and not managed
frags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/ip_output.c | 44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 581d1e233260..df7f9dfbe8be 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1017,18 +1017,35 @@ static int __ip_append_data(struct sock *sk,
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
 
@@ -1192,13 +1209,14 @@ static int __ip_append_data(struct sock *sk,
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

