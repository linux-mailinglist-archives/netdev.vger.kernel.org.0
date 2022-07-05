Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F44A5671D2
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiGEPCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiGEPCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:04 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010AF15A2A;
        Tue,  5 Jul 2022 08:01:58 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q9so17960415wrd.8;
        Tue, 05 Jul 2022 08:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p9WO85kcK3aAv/etCUIOEoECnFGVfOx8cNxht2BIvVM=;
        b=CI7e5TdX+dYyE/mbEe4ytqljwSIM3/33pze+KIqSLLhgaZvPFeVzg5UH/mwNeqxgJI
         sRzBNcUGKQIyjOs6ru70yOBjRwemZHuXVlAvBHEjGGzQ9xXT9LHRJBgWGXUf0mBNAmPM
         xCNZtTZpFaM+TgPbaIBteAnum7EBcGhJKdD0ALmV5ZKaF2Rww7eBf/tf5+NyFJ2fUwi1
         7E5KTjKXvEVTWIfNNMywdK0kPXqHnLryp3g0y/jy9dkvGjb/LPJgEHzbjTEIXyyAkyWJ
         0NUOX9M1w/R94/wGsu3wPCyRiquBPwhE+kmuAJfFMT99IG5881yxy9fhU0NthOG3DScw
         EfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p9WO85kcK3aAv/etCUIOEoECnFGVfOx8cNxht2BIvVM=;
        b=Siu4RXrDzFQazELvN7tdQ1j2s2Y8nctMORxUpU/CUdcVSHjUF/3UABD68HIc95WAnF
         //bq8y2od0Icaa0yygfFVkwHumkzn+J+I8o1ozO9CHj8gmkkJKt/5NZXWvg4VUzQLbR7
         dAakVJg+ywVIr3nkOolrO8YIVsGHwwfqEFHTCEF7yfNhiLoIsp1gb8DDNTAS0pGa/Zai
         sKMvtEKM43BI4zQvBucxwuHFZaGmFpmpezQbEshO6m5BZBV+C51zv0E8964TRNi8BNoj
         pPW3/BjeUtCGbC+bSX4y4qGhCs82fpSEWjH5Dc1bP7nGOKJovvyOAhV4LivvqOMq69K6
         tTlw==
X-Gm-Message-State: AJIora+bIBZGepcxL0EzMOQy8n4+7qzwdJs9OD6kPME9XwkGq0r9fcDM
        WKRR1B8+COSnPkGsBHXAWZ/bXoll+vq3Xg==
X-Google-Smtp-Source: AGRyM1tRZ7p7U5wZ/XqQmsWYqPvARkMaVbzOGMkv0lpdmFP+8f89/DJaH4m3Um2Ip3lP0MxP5GvAaw==
X-Received: by 2002:a05:6000:1f0b:b0:21d:6dae:7d04 with SMTP id bv11-20020a0560001f0b00b0021d6dae7d04mr8271951wrb.414.1657033316935;
        Tue, 05 Jul 2022 08:01:56 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:01:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 08/25] skbuff: don't mix ubuf_info of different types
Date:   Tue,  5 Jul 2022 16:01:08 +0100
Message-Id: <8499c042b59474f9969a5a3d3417a0abc07350ae.1656318994.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656318994.git.asml.silence@gmail.com>
References: <cover.1656318994.git.asml.silence@gmail.com>
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

