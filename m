Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5F355ED30
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbiF1TAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiF1TAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:24 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E281413FBE;
        Tue, 28 Jun 2022 12:00:03 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z41so349286ede.1;
        Tue, 28 Jun 2022 12:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p9WO85kcK3aAv/etCUIOEoECnFGVfOx8cNxht2BIvVM=;
        b=JGyeYXVfiLecdLB8zE2WNfeC2X2w/NH6K6N0RQePVZJ3WuaGGktFqNbBp2pYWCHgbi
         Ad4Nt0obLDehOoY7uQC0L8icGt3PHUwmc2oF30EDGlVdKEj2XHcckD2FI3lMCgK4h2k6
         +zfftNBwUU91pCwMCiQReDJ7RetlL8SACeGP/xSdBXYQ5pcwa06JjuKKpLMSJiZPs7Vt
         PoO8sbrzW4oAkThtVY8R9pDV+LIk/PXnNs0MBkiMDVH62zTdbmCM1FqNROt1p99ijpUe
         UJKgN11JiVWi7Z+UuhgaEb72aLmoK9oU7tKYlEJWKxyR3AKzzb1OLBrFQyeZbc4NFsV5
         DEOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p9WO85kcK3aAv/etCUIOEoECnFGVfOx8cNxht2BIvVM=;
        b=nwyPd34a4rL3nDOxjUY8kNfuq92RRJM7RZnxb0bt+BWi7yiIwn56WE0JMPMX84ZU1z
         gA33f8tz7Hj8nPzqdYEoozHBMKo2qbBjCS6adlvIPLQ0JW/IYgF+vwivzeB5WgscwUcu
         /1/67GRYG8Fj3uD4jcjpBJuZdmm5rxse4OemgfkrQle5QMxn35uGJNgNQ7mdBY3vhV81
         QnODxWotkqKLN+3GYTLlF8GKnRrwmBrYHKY9l/L26TUjpI4R6e376dVcNwZHCIvPjuKe
         gxCQdzpHz+fnrsTwjA4RnRDGg2kCKJ0hZT7rkIauVNLGIPb4eqLQYgTa9K7FM6k9/a0r
         mblQ==
X-Gm-Message-State: AJIora+0QZjYI7TyFL+mSIjT7OKXsd2+fBuTZySlL/mE4HfpbMsfwiyz
        XvT0uHCyPFLBlWDXTJp5vTdLbik1d2K00w==
X-Google-Smtp-Source: AGRyM1sUVU6MacxwIl9Qn3l7tOsQqWMQWbGamM2B8AEnEWs1e6t8y1ZTIHOrT1WjkwOr8U04Qgf4TA==
X-Received: by 2002:a05:6402:44a:b0:437:8234:f4c6 with SMTP id p10-20020a056402044a00b004378234f4c6mr8383733edw.346.1656442802159;
        Tue, 28 Jun 2022 12:00:02 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 08/29] skbuff: don't mix ubuf_info of different types
Date:   Tue, 28 Jun 2022 19:56:30 +0100
Message-Id: <1e6515412ce815241c1d950f5d13f5b300e9edfb.1653992701.git.asml.silence@gmail.com>
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

We should not append MSG_ZEROCOPY requests to skbuff with non
MSG_ZEROCOPY ubuf_info, they are not compatible.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/skbuff.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 71870def129c..7e6fcb3cd817 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1222,6 +1222,10 @@ struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 		const u32 byte_limit = 1 << 19;		/* limit to a few TSO */
 		u32 bytelen, next;
 
+		/* there might be non MSG_ZEROCOPY users */
+		if (uarg->callback != msg_zerocopy_callback)
+			return NULL;
+
 		/* realloc only when socket is locked (TCP, UDP cork),
 		 * so uarg->len and sk_zckey access is serialized
 		 */
-- 
2.36.1

