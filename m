Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A238B4F9240
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 11:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiDHJvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 05:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiDHJvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 05:51:51 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8957812C9E1;
        Fri,  8 Apr 2022 02:49:48 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id c199so2656336qkg.4;
        Fri, 08 Apr 2022 02:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N0ggH3iBrLHxp5T4eJqd/KR8yOLoc8W60Nh2MGRymrI=;
        b=Ox+yY4pxeOi/zVaRG0PR4iTwUHS/JG8KdnrIU53cnNOi1LGpYAWOCG7Vh1uG06YMeU
         8fqUS+1iVyPYwuAUqqpxKKViQ9+amC1rjAv9e2pa5CTsTbp7aQ17bwgSJosgP3UbGwyk
         jNII2u32B7LtmnxDgfhClto7iTVLk9Qe/N7bOPHe0Ue6bDilCgO18sq4izE9Wx7BFq5E
         rFnoyIIRQBpakvNtWiIRfIFwumljZMdR2hGDDhOU0NjntzHzV7FZm1lAcH+DmrMhJ/us
         Z2GIeQqKg4F+VYGYha85BqjaIA3SJZh4z6cnznaKeEi/e3Lh2chMGwXgAbwJcZM7hSuC
         t3Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N0ggH3iBrLHxp5T4eJqd/KR8yOLoc8W60Nh2MGRymrI=;
        b=HUjsK91VaNl9Cr+7sg+0ZtozMwpAoEEeBvc/BP0Xrek9XMvyHweakUFEcNaNyziypH
         n5Zr+2MTArOFuZ3uKXhVKfj4FEJFm4tWBS60q0mL6FUxn16l6K32qAzxiFgP2XPzkH5/
         chbIAeB1syIMDJVgMsufMIoP9EWg2momYKZQEV8sWthI2OCDl9w1lj+U89ifWhMRLiP+
         B/tE9Zx4V7s7J9l457kfukO1TZoG0o/EM5Znasj67d5mbh4fpHH+UiRfAY0hb8elL1G2
         NLofPSicVDcIMhDOMCrNsvJAvm2wsMOHCYvKKwth3JkFbsLgzH/Ct2rYynZZ0/Gbo5oM
         6cEQ==
X-Gm-Message-State: AOAM531dN6BjGLjdxT8xW4LjK844qOiNf5r/bSzC9ruERVDbcY2DivZj
        Tgu3yGWLVdfOG08iRosSryw=
X-Google-Smtp-Source: ABdhPJwKuT4ZBh/qkKmoei6cutZi7QzSR+vAlRvAe90qvJRM6/zZ8eyaN3tMPugX2l/8nP0t8TiEmg==
X-Received: by 2002:a37:64c5:0:b0:69a:73b:f24c with SMTP id y188-20020a3764c5000000b0069a073bf24cmr4335763qkb.57.1649411387777;
        Fri, 08 Apr 2022 02:49:47 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id br13-20020a05620a460d00b00680d020b4cbsm12790855qkb.10.2022.04.08.02.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 02:49:47 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] dpaa_eth: Fix missing of_node_put in dpaa_get_ts_info()
Date:   Fri,  8 Apr 2022 09:49:41 +0000
Message-Id: <20220408094941.2494893-1-lv.ruyi@zte.com.cn>
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

From: Lv Ruyi <lv.ruyi@zte.com.cn>

Both of of_get_parent() and of_parse_phandle() return node pointer with
refcount incremented, use of_node_put() on it to decrease refcount
when done.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 763d2c7b5fb1..5750f9a56393 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -489,11 +489,15 @@ static int dpaa_get_ts_info(struct net_device *net_dev,
 	info->phc_index = -1;
 
 	fman_node = of_get_parent(mac_node);
-	if (fman_node)
+	if (fman_node) {
 		ptp_node = of_parse_phandle(fman_node, "ptimer-handle", 0);
+		of_node_put(fman_node);
+	}
 
-	if (ptp_node)
+	if (ptp_node) {
 		ptp_dev = of_find_device_by_node(ptp_node);
+		of_node_put(ptp_node);
+	}
 
 	if (ptp_dev)
 		ptp = platform_get_drvdata(ptp_dev);
-- 
2.25.1

