Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A94423550
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 03:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbhJFBDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 21:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhJFBDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 21:03:35 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7CDC061753
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 18:01:43 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r201so958020pgr.4
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 18:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qkBbO3tJ/P9D3c0rJ10YPqyB3yPEBAOVe4lrvryz3b0=;
        b=CXtk/BZXDFmh5H/WqQT4Xt9hN7I7nQdlKp9rG1Nzn3dACgJ0A5pccLu+ZI0Jw05EbR
         aJW9YDLQDnrla0dZ2vfiSd9lPHTR2Lk4eRhINK/pKoXm0hDpg/gpjbv3CpsP5I8u+1E1
         S2OuIap3gg68UUCD6VgOpkxjCn/uzKo/gqx4CXt0NxQUewrBlxGuFa7/BJYoyDCx+Ij2
         Fxaj03wjORJYK8hHi5Uyu7FTW1Exm4DFWp1tf0Ipwbs3vUPKbvc/JAhGoBcMzttAwjTr
         tor4rluKEG+u4iE99kxcmhkps+LSsMLVaEUpJl3cXZxeheoCEY8YHAHOimCs7P5/l2E6
         a3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qkBbO3tJ/P9D3c0rJ10YPqyB3yPEBAOVe4lrvryz3b0=;
        b=XPjLTjOW7sBuZzp80Q3P0IPgJ2LjwvCXUMOT1EZr/sdAyxp2SOW41AvsdW0u0LTmLx
         jW2X2N6p2sTjeDNCCoX9MdGdopnyulJog/3mx3yPyKBg2mYTfJ9xByzaAAsdrg+1LA/k
         6MaojQDVKOS9KQ8HRHqpE/YgpgqDzDC/VUKRIMzIELD5GzeSoQ7C4+DkQ8JpX7Yx7TmU
         10Xlo9Fene/YyFPjhXltMQo7j8rPvhKcQ+3Lk7al8q5inHEdWqi/69NQzE99zK8NbmfU
         HrGu6VaRtq5JSujqntfAXuVbqfyzJKcHCFF2H8JVtTJeaFuo3OZOylA6jOThkjWO7Zlk
         NO2w==
X-Gm-Message-State: AOAM532S7UooRerJjxprWzTLftc+c1TDs+tjJ6KVeaOjQL2k7NS50pNe
        Go7+9phglCrJqrFYRoa1hk3X5DET5O4=
X-Google-Smtp-Source: ABdhPJwHSrEk5Z3ZB3urmJZNgTTHKO+TEoH/lPSbVMl01+6SgTXTpzfqDB6cMZs3eXp3uOv3rZjAvQ==
X-Received: by 2002:a62:1ac3:0:b0:44b:85d0:5a98 with SMTP id a186-20020a621ac3000000b0044b85d05a98mr34794552pfa.18.1633482103063;
        Tue, 05 Oct 2021 18:01:43 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4c77:3139:c57:fc29])
        by smtp.gmail.com with ESMTPSA id z33sm17902502pga.20.2021.10.05.18.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 18:01:42 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yangchun Fu <yangchun@google.com>,
        Kuo Zhao <kuozhao@google.com>,
        David Awogbemila <awogbemila@google.com>
Subject: [PATCH net] gve: report 64bit tx_bytes counter from gve_handle_report_stats()
Date:   Tue,  5 Oct 2021 18:01:38 -0700
Message-Id: <20211006010138.3215494-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Each tx queue maintains a 64bit counter for bytes, there is
no reason to truncate this to 32bit (or this has not been
documented)

Fixes: 24aeb56f2d38 ("gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yangchun Fu <yangchun@google.com>
Cc: Kuo Zhao <kuozhao@google.com>
Cc: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 99837c9d2cba698ada900229330cb10bc1606a6b..fc7cdf934ddc6cb336a86ef05b1a4fcdf73cb69a 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1190,9 +1190,10 @@ static void gve_handle_reset(struct gve_priv *priv)
 
 void gve_handle_report_stats(struct gve_priv *priv)
 {
-	int idx, stats_idx = 0, tx_bytes;
-	unsigned int start = 0;
 	struct stats *stats = priv->stats_report->stats;
+	int idx, stats_idx = 0;
+	unsigned int start = 0;
+	u64 tx_bytes;
 
 	if (!gve_get_report_stats(priv))
 		return;
-- 
2.33.0.800.g4c38ced690-goog

