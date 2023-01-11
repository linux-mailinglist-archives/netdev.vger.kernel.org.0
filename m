Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EEF66624B
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbjAKRvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjAKRvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:51:40 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226EA55AB;
        Wed, 11 Jan 2023 09:51:39 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id m6so24698388lfj.11;
        Wed, 11 Jan 2023 09:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rCPqy95C6Ull1wAoxhY/6/ppbJBtfCJsPETF3WTR/qM=;
        b=JXouJcKGqRGXex2GF1mRZOeE2BvpKEr56XxDdtewRXWzaWfoUbjaMpCx6HReF3qCXZ
         UJTj9PEkMIWvH0T8IWGnJ7iBOGSnhDavXUgGotmUL2A1CbN5m3dYj/7qEUjr/4diCvec
         ZF9pFIRX4ZwAJhQAfwLwyZVlQdcYGnadRYvHCPKFt97gRzyHde48HGvP3vKbK8bnmOV/
         zOL8B490gdPzWsjEVbfSeogsg1cEsD0aPkaAwloKOSqOZM3xWyOrwPca9OXFKd8ReUP8
         iJ9fjMKgbNbt9NIQ6jXUAs87TvuCFn7LSQMnAr2NBk2t0vLLxvcuUY7uT6kicmd8fzml
         u+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rCPqy95C6Ull1wAoxhY/6/ppbJBtfCJsPETF3WTR/qM=;
        b=TA81zgqMzvZTDEgJknB4GKmxiHRotkneKdpQPHIouEA9XwjfKLmxELUMAOPlV+EKnR
         tIF/3A/oHILza/fNgTeMLr/jGkuV39E5duD1tKehdq9Exy8o3Npx2SbmLDfoQ0oQEY/J
         WbQGtWcAGUEDdWPewzHjJDTt+45ORT6AORepDRIZFrNvyvqiJQpyceGY8kKVrUIcEejY
         FQ4eXQKlWVwBowraqfBapQsP06skj9FAVszxWEQnJPaLj0mjehgA0ekECqcCip66zA75
         IAy0Z3gD8i7JIF2GYNnzCKD0phDXgB3bc1tuC6BNCLOCWyimKKKHX5/baFJ0fhUSy733
         2yxw==
X-Gm-Message-State: AFqh2kpmWxrDuesQcJND6JKANxALGmar9PLzXd9WPppmVV3JEaNhHCk0
        aETAVidsITlDbmxBPz9jrvQ=
X-Google-Smtp-Source: AMrXdXsMLWhBweFdqHouGzNOfy2FLpER7WmQEJnvZO69e/RhuTihl8FAgTinoHWUAeuExYNdhUwTQA==
X-Received: by 2002:a05:6512:6d4:b0:4cb:1e1:f380 with SMTP id u20-20020a05651206d400b004cb01e1f380mr19853095lff.40.1673459497379;
        Wed, 11 Jan 2023 09:51:37 -0800 (PST)
Received: from localhost.localdomain (077222238029.warszawa.vectranet.pl. [77.222.238.29])
        by smtp.googlemail.com with ESMTPSA id x2-20020a056512130200b004a8f824466bsm2817098lfu.188.2023.01.11.09.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 09:51:36 -0800 (PST)
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
To:     alexander.duyck@gmail.com
Cc:     kvalo@kernel.org, jussi.kivilinna@iki.fi, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        greg@kroah.com, szymon.heidrich@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] rndis_wlan: Prevent buffer overflow in rndis_query_oid
Date:   Wed, 11 Jan 2023 18:50:31 +0100
Message-Id: <20230111175031.7049-1-szymon.heidrich@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <CAKgT0UePq+Gg5mpvD7ag=ern9JN5JyAFv5RPc05Zn9jSh4W+0g@mail.gmail.com>
References: <CAKgT0UePq+Gg5mpvD7ag=ern9JN5JyAFv5RPc05Zn9jSh4W+0g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since resplen and respoffs are signed integers sufficiently
large values of unsigned int len and offset members of RNDIS
response will result in negative values of prior variables.
This may be utilized to bypass implemented security checks
to either extract memory contents by manipulating offset or
overflow the data buffer via memcpy by manipulating both
offset and len.

Additionally assure that sum of resplen and respoffs does not
overflow so buffer boundaries are kept.

Fixes: 80f8c5b434f9 ("rndis_wlan: copy only useful data from rndis_command respond")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
---
V1 -> V2: Use size_t and min macro, fix netdev_dbg format

 drivers/net/wireless/rndis_wlan.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 82a7458e0..bf72e5fd3 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -696,8 +696,8 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 		struct rndis_query	*get;
 		struct rndis_query_c	*get_c;
 	} u;
-	int ret, buflen;
-	int resplen, respoffs, copylen;
+	int ret;
+	size_t buflen, resplen, respoffs, copylen;
 
 	buflen = *len + sizeof(*u.get);
 	if (buflen < CONTROL_BUFFER_SIZE)
@@ -732,22 +732,15 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 
 		if (respoffs > buflen) {
 			/* Device returned data offset outside buffer, error. */
-			netdev_dbg(dev->net, "%s(%s): received invalid "
-				"data offset: %d > %d\n", __func__,
-				oid_to_string(oid), respoffs, buflen);
+			netdev_dbg(dev->net,
+				   "%s(%s): received invalid data offset: %zu > %zu\n",
+				   __func__, oid_to_string(oid), respoffs, buflen);
 
 			ret = -EINVAL;
 			goto exit_unlock;
 		}
 
-		if ((resplen + respoffs) > buflen) {
-			/* Device would have returned more data if buffer would
-			 * have been big enough. Copy just the bits that we got.
-			 */
-			copylen = buflen - respoffs;
-		} else {
-			copylen = resplen;
-		}
+		copylen = min(resplen, buflen - respoffs);
 
 		if (copylen > *len)
 			copylen = *len;
-- 
2.39.0

