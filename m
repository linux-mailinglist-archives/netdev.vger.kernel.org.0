Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEEF4C864F
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 09:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbiCAITp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 03:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbiCAITo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 03:19:44 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590B919286;
        Tue,  1 Mar 2022 00:19:02 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id bc10so9305536qtb.5;
        Tue, 01 Mar 2022 00:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GSBys8jJTsNLUREVaBf3CNtCbj8ytu+XMpMTrO1dcz8=;
        b=G0/ZvlIS5jFjZMWwYeC0mWSRbluXdvWW+Q9xmstMlpytkW2ZELHxo93sAVJuI6KCVn
         qEqd9qgJMzxAK8m/ip5l93Y65SaMaI1LgcqP1V+S1PqxXLWC33A79k7duf3aexmEJOY/
         08lp/C5d8qPa/vT6qUbS+hekuiFgiEu9UCDcoRJQQlSPSCX0u632tVBg3J/Gfz4vp4d/
         NTGL5a9CXdh6az3qSG6FJyAHfyETj4TIcFneBOArLSVjxEZ9bOMofkFtjUh1ar46xbeG
         Cuw+8zn4AjJUPxB0SwYkojPB+yMJhHUZMnIxMgygiqcWucO7Le1oDPhdzERJ11Ldt7Zy
         G7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GSBys8jJTsNLUREVaBf3CNtCbj8ytu+XMpMTrO1dcz8=;
        b=N7N3YutiKwwGNRSAm/5lDcuyn0pTQfOhPGhHYD4gut41b5T7WC1L6tI6ifIsd+0/Xh
         eYk6lEqPolQjdAshISIPF4fds+7nyGsd5eM7MEbeBZoggwHJrTpW/hJF1nNvCqFt9d5I
         9gYl7aS6XyCiKxdr51crUutd/2hxARh/GwC0JtMmwP1aJEIpfgV4dRXtPY6BLar7Jd35
         fZXQ2BrC2Si0NtWY3PE3Jl1Q2HNPauvX+8t7K47I6uWz8rlrbXGxHomYTSPxW0B2y2XT
         C9ZCF8OJCDOtgacatJzUlS4UQQM+2a7tkKQvF3m1sONo1GpYI6tHxvfp17GdiL6qSYnX
         H8yA==
X-Gm-Message-State: AOAM532dgL3P+MG23nFEml/feP20bOfrKZL5wa5KiJmNFljpW7gVlAd+
        LOaRm6FeoybFX8d96f6sJh4=
X-Google-Smtp-Source: ABdhPJwK6RAJbpvtYBacQljaFQrC5NX36OyF5HyM6JuGzgkZq8H4JUOp39X731sGflud8KjZh3oY6w==
X-Received: by 2002:a05:622a:308:b0:2dc:8b37:5dda with SMTP id q8-20020a05622a030800b002dc8b375ddamr19027809qtw.492.1646122741501;
        Tue, 01 Mar 2022 00:19:01 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p190-20020a37a6c7000000b00648ea630a45sm6180537qke.121.2022.03.01.00.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 00:19:01 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     vyasevich@gmail.com
Cc:     nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net/sctp: use memset avoid infoleaks
Date:   Tue,  1 Mar 2022 08:18:55 +0000
Message-Id: <20220301081855.2053372-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>

Use memset to initialize structs to preventing infoleaks
in sctp_auth_chunk_verify

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 net/sctp/sm_statefuns.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index cc544a97c4af..7ff16d12e0c5 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -652,6 +652,7 @@ static bool sctp_auth_chunk_verify(struct net *net, struct sctp_chunk *chunk,
 		return false;
 
 	/* set-up our fake chunk so that we can process it */
+	memset(&auth, 0x0, sizeof(auth));
 	auth.skb = chunk->auth_chunk;
 	auth.asoc = chunk->asoc;
 	auth.sctp_hdr = chunk->sctp_hdr;
-- 
2.25.1

