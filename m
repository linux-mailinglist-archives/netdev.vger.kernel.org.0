Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1CE7533580
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 04:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243711AbiEYCww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 22:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242767AbiEYCwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 22:52:51 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C51D13FBC
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:52:50 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id 135so13937097qkm.4
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iQcr8uJ3zas3vFGD/G3yrt66vkozC5l14AvlElgIioY=;
        b=pu+opcm2t2eRb3NRH18waXAHqTG7Pj3KA4U9+VZPxJe8NciodW85k6U9QkMZGL0Y6l
         SSJZq2qrsINBTbUYHxxuMU0r+dWhStANUA8Q07ETVHJMaBWUHbMbmNLGgl0fsmr7pg/M
         y4I/vMCM4+QM3k2fXyx4w7ux4xzT/3INvxgXvNAiKPg4qRo/qBeM2ifKfvs16ey68RYA
         UiNs4m3JlpC884HlEuIcEFPGJLnfw+pF4uXSX0MqlJXH2YIdQXFttlX0JrT5y3vhcKN2
         VT/jAhDd4SHOxtmjzIR07OPMHU6mtL3IT331GxV8c89s+7/pJONYqVqmENzipJ+mj9pV
         6PIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iQcr8uJ3zas3vFGD/G3yrt66vkozC5l14AvlElgIioY=;
        b=HRmnBMsNZtWv0RWTI69dJFV+zABqfrb3zGHlJqKz5+qntZgf8YnVulK3x8kWcGLaRv
         WSgOvtsOxsql1GNw140C/uV5BeOxoQr/9C179njaeReamrD0E1ZZ6M9qhTrwnhsrKACV
         dTde1Snk6Wy0sNwYAXy43DExTfP1DdvSqH0F/lyxt55oJmCmrHOTAzW01DKcQ5z9yNaE
         u/55OM16sj8i225rBBLv+ZlDMMgGPn5w64CkTkG1kSs0TSq1LH3U6NAnIvRS4ML8ZcHa
         5gTXfcx4AsrFbaGU/Ow9l+2bt4Snh8Xdyr7FssZFP7ns4M2HLK3oL42f77y9W+VNTw7E
         0YwA==
X-Gm-Message-State: AOAM532iwEGrsV0Xly3uGNdOeGUeYdo8u7XNbyGNb7aT5oW/Ox5FmFz5
        ZPUpQr5ZCAxamMGMZufySA==
X-Google-Smtp-Source: ABdhPJxyzXAPzWnyFT/HcWdA2jedF2YmLNWRAAsqaN1x+8TeRi5MwDZhPYqYGq5r54zu5+Wm89QF8g==
X-Received: by 2002:a05:620a:e01:b0:69f:6042:7fa3 with SMTP id y1-20020a05620a0e0100b0069f60427fa3mr18318470qkm.524.1653447169677;
        Tue, 24 May 2022 19:52:49 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id l9-20020a05622a174900b002f39b99f687sm804727qtk.33.2022.05.24.19.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 19:52:49 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2-next 4/7] ss: Delete unnecessary call to snprintf() in user_ent_hash_build()
Date:   Tue, 24 May 2022 19:52:36 -0700
Message-Id: <dc933ad6a1a6d07dc3b8bf09686fd1a5f4806493.1653446538.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1653446538.git.peilin.ye@bytedance.com>
References: <cover.1653446538.git.peilin.ye@bytedance.com>
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

From: Peilin Ye <peilin.ye@bytedance.com>

'name' is already $PROC_ROOT/$PID/fd/$FD there, no need to rebuild the
string.

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 misc/ss.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index dd7b67a76255..ec14d746c669 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -652,10 +652,7 @@ static void user_ent_hash_build(void)
 
 			sscanf(lnk, "socket:[%u]", &ino);
 
-			snprintf(tmp, sizeof(tmp), "%s/%d/fd/%s",
-					root, pid, d1->d_name);
-
-			if (getfilecon(tmp, &sock_context) <= 0)
+			if (getfilecon(name, &sock_context) <= 0)
 				sock_context = strdup(no_ctx);
 
 			if (process[0] == '\0') {
-- 
2.20.1

