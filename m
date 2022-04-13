Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC544FF3B8
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbiDMJkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbiDMJk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:40:26 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B056754BFA;
        Wed, 13 Apr 2022 02:38:05 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c23so1522955plo.0;
        Wed, 13 Apr 2022 02:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RVQstQX3o9VgMBuzdgxmyLLQEnEBUvnceuVNthO6dlM=;
        b=dXLSABKuycKbEvu8Cbf8cU+Tt4k28/o42ccrQugag1yAg+CIi0mlfhumYK1WAkQsdW
         Lm/nUh8dryN2K12146+KOQfe/w+ILGY60DSWzOtwAmvjP+9gCOi2GUUU07ZD6oVggNkc
         +2o/DHLEqup1nW2vxOpDpHxyXtnt+0kYPFOCeXOGXfdfiV6yc3nqnufTSalsOUBR7LuB
         w0Nq3SDCLim5YUTrM4I/3dUbrouLSrmDJ5iPJi5QCgmCdC2jWuxnoBB4QXg2WOPg+qSA
         iyOYsOpmn3Kud8cWDGEwn2F+63w7GWxcfWqejklf4OTWk93XXs2xCSphUZN7PMS1YC9i
         yDqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RVQstQX3o9VgMBuzdgxmyLLQEnEBUvnceuVNthO6dlM=;
        b=oa16GSyqtGirBvr/um/8FxeUmdVJK2Xsm0bEeqwuM1X7XIJs/HesRRCQ3N/7eyMV5F
         lZCW3lbV1x61783NUsvzjEWWKGNUnvuE0qwHfkljDR+j6U0lYcBsxIGpjYAxM/cQ8ViW
         LoQG7vvKVfvIlU8SiKtZQlv6RyrwvxVR0GzoMxE7Kv9Jn32NfjY+pnGTzvomK+TCgDGX
         5pXGp1f2XqtD56zUq+OnKpNHrFwjdTRkl4uElZi37KMbjhPX291AKd9JG19USgbIycyA
         /NaMzh2eXgN7Mkt1a4Xwz3SsNjoI8SvCM5/86cKQOBGbZdg2BK5C+ALSTFEP5Gvw6DAJ
         wAvQ==
X-Gm-Message-State: AOAM5324hMVTH4UWmUamX2DoZiEzRY0gt/vA/Dbicb+NxB11pW2X672w
        LwWu0GySzko+5lrm4Niuj2Y=
X-Google-Smtp-Source: ABdhPJxo7+Ux92bmPql/HXgXEaJR1hwpnpy9HTM8FY+EmsOKoo0D/O11yKvaxb0+Ymw4wQjWoObwKw==
X-Received: by 2002:a17:902:b48d:b0:156:7f54:8ffc with SMTP id y13-20020a170902b48d00b001567f548ffcmr42194833plr.95.1649842685304;
        Wed, 13 Apr 2022 02:38:05 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id f187-20020a6251c4000000b005058e59604csm17229058pfb.217.2022.04.13.02.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:38:04 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     peppe.cavallaro@st.com
Cc:     alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: stmmac: stmmac_main: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Wed, 13 Apr 2022 09:38:01 +0000
Message-Id: <20220413093801.2538628-1-chi.minghao@zte.com.cn>
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

From: Minghao Chi <chi.minghao@zte.com.cn>

Using pm_runtime_resume_and_get is more appropriate
for simplifing code

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c  | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4a4b3651ab3e..580cc5d3c4fa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3643,11 +3643,9 @@ static int stmmac_open(struct net_device *dev)
 	u32 chan;
 	int ret;
 
-	ret = pm_runtime_get_sync(priv->device);
-	if (ret < 0) {
-		pm_runtime_put_noidle(priv->device);
+	ret = pm_runtime_resume_and_get(priv->device);
+	if (ret < 0)
 		return ret;
-	}
 
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI &&
@@ -5886,11 +5884,9 @@ static int stmmac_set_mac_address(struct net_device *ndev, void *addr)
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	int ret = 0;
 
-	ret = pm_runtime_get_sync(priv->device);
-	if (ret < 0) {
-		pm_runtime_put_noidle(priv->device);
+	ret = pm_runtime_resume_and_get(priv->device);
+	if (ret < 0)
 		return ret;
-	}
 
 	ret = eth_mac_addr(ndev, addr);
 	if (ret)
@@ -6220,11 +6216,9 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 	bool is_double = false;
 	int ret;
 
-	ret = pm_runtime_get_sync(priv->device);
-	if (ret < 0) {
-		pm_runtime_put_noidle(priv->device);
+	ret = pm_runtime_resume_and_get(priv->device);
+	if (ret < 0)
 		return ret;
-	}
 
 	if (be16_to_cpu(proto) == ETH_P_8021AD)
 		is_double = true;
-- 
2.25.1


