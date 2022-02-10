Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6760C4B14BA
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245425AbiBJR5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:57:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245419AbiBJR5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:57:17 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B6F1A8
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:57:18 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id t36so759821pfg.0
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QpmmfLkt7bE7Igneras6kyssB20cZe/Vh0DXUgSq4sQ=;
        b=q0zM/n53n7Gd85knsfa/0fhD5dLLw/nOU2L+gFYFQ6aci52d9wMbQD6X7pHXDRwaAe
         WvSu8H82oTKH8ncVgmthJB8TwD/1b7WPqv3CobV3xHRyKq9Jk43HAEuMRhewOhgyhomW
         LXdlsH1Up1Rcii488T55kH+sBlyXJiNTGnfHa3fZwUc/a+K2I5B1QxzfhzPd04W7xdQL
         r0J8FHVOuHjDDySxZlIMtZgoAsH6VokudyAgJrxjG2L6mNPT8LHApXy8+YKKg3pS6Iny
         Jh5IDMlIaLIMZkrzEulZysfK7FD4VB+fyrliYieW2STx3uxmeFrwKhKJrdrGgRTKUZCF
         6flg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QpmmfLkt7bE7Igneras6kyssB20cZe/Vh0DXUgSq4sQ=;
        b=MVAX6o0yeMjS3f3xJrLZcQxI/VK18kyaISMAe8paEYri/s6JaTpK7Wx+YKwNSEfQLY
         vJfpAkUSnXc4aOWmOkCmvUgRuhnzMVjkYEXlB3rseixDU0r71thNaV7ndaGL28xLc88e
         Z8JO7btZDfOrWudJb8H7Z5G+ktZLW4ZoDhI/0l9U2c3o3VhKHE/HnZ6VFu8I1oqFytOR
         wFJLcp1qlgoL5r6KwVaFHU4o8w4h7XRTff9kSLlnHONgV1KXpzmE7bhYfVPf6oAXZbeX
         wMt/zOwEYE6gUlEX8vjGuaXUUOgeUrTraHE3M2nN06hFE06g5S/bTRsm938Fy4/M7etD
         xu5w==
X-Gm-Message-State: AOAM531udqCbvF3TT0Ag2DaOg6CqF3QOr3KsSeTQ62oRCS5U4vR8zeu0
        rmX01qBhS0L6tcaXlziysuKldAdDzyY=
X-Google-Smtp-Source: ABdhPJyvXNRGDwcyQ2KOKdNdmgjkycwxm3YUZ7LVNCwID4r0zVUzU0PRvjjQ8h7lvDR+XgaChVjPxQ==
X-Received: by 2002:a63:6909:: with SMTP id e9mr7141747pgc.450.1644515838166;
        Thu, 10 Feb 2022 09:57:18 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c3d8:67ff:656a:cfd9])
        by smtp.gmail.com with ESMTPSA id t3sm26230634pfg.28.2022.02.10.09.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 09:57:17 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/4] net: mvpp2: get rid of hard coded assumptions
Date:   Thu, 10 Feb 2022 09:55:56 -0800
Message-Id: <20220210175557.1843151-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
In-Reply-To: <20220210175557.1843151-1-eric.dumazet@gmail.com>
References: <20220210175557.1843151-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

A driver should not assume anything about sizeof(struct skb_shared_info),
or L1_CACHE_BYTES value.

Commit 704e624f7b3e ("net: mvvp2: fix short frame size on s390")
tried to fix this issue for s390, but it seems
MVPP2_BM_SHORT_FRAME_SIZE, MVPP2_BM_LONG_FRAME_SIZE and
MVPP2_BM_JUMBO_FRAME_SIZE should be precise.

We want to be able to tweak MAX_SKB_FRAGS in the future,
without breaking the build.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index ad73a488fc5fb6de4ddbf980355e31944b980e08..3dc0132a1fd569f7e75bfbef586c65163f0466c7 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -938,9 +938,9 @@ enum mvpp22_ptp_packet_format {
 #define MVPP2_BM_COOKIE_POOL_OFFS	8
 #define MVPP2_BM_COOKIE_CPU_OFFS	24
 
-#define MVPP2_BM_SHORT_FRAME_SIZE	736	/* frame size 128 */
-#define MVPP2_BM_LONG_FRAME_SIZE	2240	/* frame size 1664 */
-#define MVPP2_BM_JUMBO_FRAME_SIZE	10432	/* frame size 9856 */
+#define MVPP2_BM_SHORT_FRAME_SIZE	(128 + MVPP2_SKB_HEADROOM + MVPP2_SKB_SHINFO_SIZE)	/* frame size 128 */
+#define MVPP2_BM_LONG_FRAME_SIZE	(1664 + MVPP2_SKB_HEADROOM + MVPP2_SKB_SHINFO_SIZE)	/* frame size 1664 */
+#define MVPP2_BM_JUMBO_FRAME_SIZE	(9856 + MVPP2_SKB_HEADROOM + MVPP2_SKB_SHINFO_SIZE) /* frame size 9856 */
 /* BM short pool packet size
  * These value assure that for SWF the total number
  * of bytes allocated for each buffer will be 512
-- 
2.35.1.265.g69c8d7142f-goog

