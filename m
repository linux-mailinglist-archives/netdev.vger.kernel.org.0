Return-Path: <netdev+bounces-5797-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6F91712C52
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 20:17:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 829AD281994
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B01AB290FC;
	Fri, 26 May 2023 18:17:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28D115BD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 18:17:28 +0000 (UTC)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA80C1B3;
	Fri, 26 May 2023 11:17:26 -0700 (PDT)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-561b50c1856so16258927b3.0;
        Fri, 26 May 2023 11:17:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685125046; x=1687717046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HHy+mHaZfWd/b8HPsmKokkSTajHOg8KJX+wNzl/xSqE=;
        b=FRhFp4uk2tv4CvdlUSHx5+wwS+qGGamshFQ/1n5Wvltl1wFDxZAxECzsNnrR/WunPD
         93UBm+oO59xVYNutTlgEOW7/iU2FfZARoZKosiYeKRTYj0P+S297pmur9ZTl38yw95CR
         3chc86c4976i0e/+GGl6IBqoBa6vj2q4GFwLNGZuvYIF24ZimN/bqE7zhpiTiMbnzzar
         mIJTOvgtg7ynONo6G1mvMbOJAv2jBRhQ99lzeg5T34uHhg+3Y2Bicrde1CQxp01gL+6c
         GBGlpl7uZSHaEENLRfU5SFoEr/mDLoqu5muL0pbHgLA/o8+3xvcKQ13BRaf+ItETg5lX
         4QUg==
X-Gm-Message-State: AC+VfDyaJvuvOB4sCF5eFoQeD9PH3Yo4D2/StjB4Z9ZK3+5H5lnstnyB
	3oPk05bDW160GmTc4GvI9tY=
X-Google-Smtp-Source: ACHHUZ61F3PuTg1MKogFgXO2FSGFp+kxuuybw7ISD/Gk+vw/LKRjhTCU9ir0od+jnG28BX/g9kcTiA==
X-Received: by 2002:a81:5407:0:b0:55a:9b89:4eff with SMTP id i7-20020a815407000000b0055a9b894effmr2925252ywb.13.1685125045742;
        Fri, 26 May 2023 11:17:25 -0700 (PDT)
Received: from tofu.cs.purdue.edu ([128.210.0.165])
        by smtp.gmail.com with ESMTPSA id a130-20020a0dd888000000b0054fbadd96c4sm332628ywe.126.2023.05.26.11.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 11:17:25 -0700 (PDT)
From: Sungwoo Kim <iam@sung-woo.kim>
To: iam@sung-woo.kim
Cc: benquike@gmail.com,
	davem@davemloft.net,
	daveti@purdue.edu,
	edumazet@google.com,
	happiness.sung.woo@gmail.com,
	johan.hedberg@gmail.com,
	kuba@kernel.org,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	luiz.dentz@gmail.com,
	marcel@holtmann.org,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	wuruoyu@me.com
Subject: [PATCH] Bluetooth: L2CAP: Fix use-after-free in l2cap_sock_ready_cb
Date: Fri, 26 May 2023 14:16:48 -0400
Message-Id: <20230526181647.3074391-1-iam@sung-woo.kim>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202120902.2827191-1-iam@sung-woo.kim>
References: <20230202120902.2827191-1-iam@sung-woo.kim>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>    net/bluetooth/l2cap_sock.c: In function 'l2cap_sock_release':
> >> net/bluetooth/l2cap_sock.c:1418:9: error: implicit declaration of function 'l2cap_sock_cleanup_listen'; did you mean 'l2cap_sock_listen'? [-Werror=implicit-function-declaration]

Fix this error

>     1418 |         l2cap_sock_cleanup_listen(sk);
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>          |         l2cap_sock_listen
>    net/bluetooth/l2cap_sock.c: At top level:
> >> net/bluetooth/l2cap_sock.c:1436:13: warning: conflicting types for 'l2cap_sock_cleanup_listen'; have 'void(struct sock *)'
>     1436 | static void l2cap_sock_cleanup_listen(struct sock *parent)
>          |             ^~~~~~~~~~~~~~~~~~~~~~~~~
> >> net/bluetooth/l2cap_sock.c:1436:13: error: static declaration of 'l2cap_sock_cleanup_listen' follows non-static declaration
>    net/bluetooth/l2cap_sock.c:1418:9: note: previous implicit declaration of 'l2cap_sock_cleanup_listen' with type 'void(struct sock *)'
>     1418 |         l2cap_sock_cleanup_listen(sk);
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors

Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
---
 net/bluetooth/l2cap_sock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index eebe25610..3818e11a8 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -46,6 +46,7 @@ static const struct proto_ops l2cap_sock_ops;
 static void l2cap_sock_init(struct sock *sk, struct sock *parent);
 static struct sock *l2cap_sock_alloc(struct net *net, struct socket *sock,
 				     int proto, gfp_t prio, int kern);
+static void l2cap_sock_cleanup_listen(struct sock *parent);
 
 bool l2cap_is_socket(struct socket *sock)
 {
@@ -1414,7 +1415,8 @@ static int l2cap_sock_release(struct socket *sock)
 
 	if (!sk)
 		return 0;
-
+		
+	l2cap_sock_cleanup_listen(sk);
 	bt_sock_unlink(&l2cap_sk_list, sk);
 
 	err = l2cap_sock_shutdown(sock, SHUT_RDWR);
-- 
2.34.1


