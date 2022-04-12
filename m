Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A8E4FDB9C
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348001AbiDLKF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388457AbiDLJWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 05:22:13 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BF847070;
        Tue, 12 Apr 2022 01:28:52 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id k29so3790pgm.12;
        Tue, 12 Apr 2022 01:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8dj27SHCv5b3Wvo3cWAib4es//0Hr77RKSwBft96qwE=;
        b=MvkGj8kC7BvSx/tQjd+DEgKZ3id7BVEEJPlg5EhjgkhKoKyPuN7dwigevkaC7aO3ti
         TB+WEIQd1SWESEKgzNQ88pB9DSZfVlcmghDv+FlCjq8kLDzEZ/HN3ZO1BxyF847G/hiJ
         Ebw8J7p+BmGJ3jSMuhUG9bp24ZE9ruXFhTJ2cN5xMDRRwPWLNtqO9EP0XqgmkDAPeGFG
         wzVaBGkIOZ5EfEs3nIWtvZgycRZ0KlXeCPgADt8QUmhYiI1nRc4lXDIjXUoUTDN/W87y
         ChiyWJiBtqzQLEHIvTYWb1hT9jRpsij8HmYHI55Uf2RDs8XF5nQ7bKVjYf9IRbJyavCh
         6Ksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8dj27SHCv5b3Wvo3cWAib4es//0Hr77RKSwBft96qwE=;
        b=kOsZ1Au2VBHrnCaM9v5XM2BPMUdV1YJJYxHlSYWWrGPjCcTgLNGfNemJffBKP4FHOw
         o2RfP4tcHcOlvPckO0Eyoz1VCupc+Hun564WjZUQk+meyhQFADeHkmSGZFIhKEq4PQGz
         pfF25xFi4IUG491MBVaIszl1N/RY+cKIDxd0C0vO0MurEqijoZps4uzrtQI3xmMil7IL
         LzM9IX9rXA2jgpa5O3Guy1Dmu/q8kKGeUc06r9EYYTZ/l4GGpqxvulfSTpYAtKsBqhDs
         PCApAFQSHnxixWVpPueiDJgSb09GXvzmEfJ5WIBPo8BTeRnUpWALgT8pcCsYqgtfrAAh
         xlSQ==
X-Gm-Message-State: AOAM530ZQcYdJpx5169VL3XKPkFr2oHrmpxP/8X+xuWL9e8a0vxK2swb
        zEgYmrU1q5cWll6+f1sPKzU=
X-Google-Smtp-Source: ABdhPJwmL6nvNIgc2qB6277prLSlKDBoJ9rDxe+gbZfcxGjX2/wQgi65ZQMUL2G6CWQlHoa4lFSqiw==
X-Received: by 2002:a05:6a00:e14:b0:4fe:3cdb:23f with SMTP id bq20-20020a056a000e1400b004fe3cdb023fmr3450814pfb.86.1649752132287;
        Tue, 12 Apr 2022 01:28:52 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id o1-20020a637e41000000b003804d0e2c9esm1981783pgn.35.2022.04.12.01.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 01:28:51 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     grygorii.strashko@ti.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: ethernet: ti: cpsw: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Tue, 12 Apr 2022 08:28:47 +0000
Message-Id: <20220412082847.2532584-1-chi.minghao@zte.com.cn>
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

Using pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
pm_runtime_put_noidle. This change is just to simplify the code, no
actual functional changes.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/ethernet/ti/cpsw.c | 36 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 03575c017500..9f37b5b196a5 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -756,11 +756,9 @@ static int cpsw_ndo_open(struct net_device *ndev)
 	int ret;
 	u32 reg;
 
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
+	ret = pm_runtime_resume_and_get(cpsw->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	netif_carrier_off(ndev);
 
@@ -968,11 +966,9 @@ static int cpsw_ndo_set_mac_address(struct net_device *ndev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
+	ret = pm_runtime_resume_and_get(cpsw->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	if (cpsw->data.dual_emac) {
 		vid = cpsw->slaves[priv->emac_port].port_vlan;
@@ -1052,11 +1048,9 @@ static int cpsw_ndo_vlan_rx_add_vid(struct net_device *ndev,
 	if (vid == cpsw->data.default_vlan)
 		return 0;
 
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
+	ret = pm_runtime_resume_and_get(cpsw->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	if (cpsw->data.dual_emac) {
 		/* In dual EMAC, reserved VLAN id should not be used for
@@ -1090,11 +1084,9 @@ static int cpsw_ndo_vlan_rx_kill_vid(struct net_device *ndev,
 	if (vid == cpsw->data.default_vlan)
 		return 0;
 
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
+	ret = pm_runtime_resume_and_get(cpsw->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	if (cpsw->data.dual_emac) {
 		int i;
@@ -1567,11 +1559,9 @@ static int cpsw_probe(struct platform_device *pdev)
 	/* Need to enable clocks with runtime PM api to access module
 	 * registers
 	 */
-	ret = pm_runtime_get_sync(dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
 		goto clean_runtime_disable_ret;
-	}
 
 	ret = cpsw_probe_dt(&cpsw->data, pdev);
 	if (ret)
@@ -1734,11 +1724,9 @@ static int cpsw_remove(struct platform_device *pdev)
 	struct cpsw_common *cpsw = platform_get_drvdata(pdev);
 	int i, ret;
 
-	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	for (i = 0; i < cpsw->data.slaves; i++)
 		if (cpsw->slaves[i].ndev)
-- 
2.25.1

