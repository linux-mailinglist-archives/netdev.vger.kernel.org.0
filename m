Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D6E3AF8CE
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhFUWxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbhFUWx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:53:28 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED153C061756
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:11 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id d2so27465764ljj.11
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6C49aXdYKp9UsIqXJpx6CmJB4xW3x2fJp+8+xbSdrvI=;
        b=mxCHobv11Az0cI7oTnLMaEmdm3y3Idpf3xJXLFzZI2rjg2yfbk9BRp63u4zia5A3QM
         GN+PLXYnXYnlwzUL+1p+I/yYZ0mS/08mJv0O6mRAcogit9fBPtlmL6mvakAfxTejecuM
         1488dO7erAD3l3eQuvcn7/V31mIWNL92e7Huk/FFZ3Wy9sdb102Zpb2kg2rQb+jR7SlI
         c5lvi1qTxCh9+KerGbmcLAYCRnrVm/CmjLR+XeRchPxnPWCbnl+pRrg8uyUF3Pls8bzD
         LlRueNPRNe4D0fXj/toe58oBBAt950nNuzJCPUN+0ISUolxKCguZu7ze/C2bKTW+jAd0
         s78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6C49aXdYKp9UsIqXJpx6CmJB4xW3x2fJp+8+xbSdrvI=;
        b=sHcNRFOBQToVVKOyl+rHCNCuw5Xe3sgx4GS5slXwZnwNcbJVjs0uXD5bK868zRC3F+
         1Np4yrPk+EYVm8u74gsXzN0wdWhjsPbFOY+v0YH2zI8kwrngIxvu36D5ZFiuoIRQHYPm
         6DP/+l2uczx6XEjKVyFWzbV+7djT01pJkPqbPBbrAOxVGYz45mgFhzXgWXelCqxS0NeE
         9X5Birbdff2s4M0goto3zb1VAOYqLH/oYCOohZquHJVlvF7fBjYEzIBKNYkpl+gM9Azc
         xLiMw0vxDGr6A+y3VjEOgyjTxK1Qh4Qmd8Iv2HWLA9Al6KAFaHNqpOJLZUlKwwHO13sC
         wuqA==
X-Gm-Message-State: AOAM533ac4GhFv3pfd2iBT/24fI9D8b3AMkBIpGBpLuVhgcrmhTloIM9
        5W3RX7moxH+/5KTmM11qgLw=
X-Google-Smtp-Source: ABdhPJzZN8seJqU9fiGABIlKmfH06+bW4KCJ0cd7ycr5Ozv8vX5+7t1qCdaYGMj1JzNYk0a5k6yBdg==
X-Received: by 2002:a2e:93c8:: with SMTP id p8mr418313ljh.95.1624315870391;
        Mon, 21 Jun 2021 15:51:10 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id x207sm124826lff.53.2021.06.21.15.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:51:09 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Subject: [PATCH net-next v2 06/10] net: iosm: drop custom netdev(s) removing
Date:   Tue, 22 Jun 2021 01:50:56 +0300
Message-Id: <20210621225100.21005-7-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the last commit, the WWAN core will remove all our network
interfaces for us at the time of the WWAN netdev ops unregistering.
Therefore, we can safely drop the custom code that cleans the list of
created netdevs. Anyway it no longer removes any netdev, since all
netdevs were removed earlier in the wwan_unregister_ops() call.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
CC: M Chetan Kumar <m.chetan.kumar@intel.com>
CC: Intel Corporation <linuxwwan@intel.com>
---

v1 -> v2:
 * no changes

 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 1711b79fc616..bee9b278223d 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -329,22 +329,9 @@ struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
 
 void ipc_wwan_deinit(struct iosm_wwan *ipc_wwan)
 {
-	int if_id;
-
+	/* This call will remove all child netdev(s) */
 	wwan_unregister_ops(ipc_wwan->dev);
 
-	for (if_id = 0; if_id < ARRAY_SIZE(ipc_wwan->sub_netlist); if_id++) {
-		struct iosm_netdev_priv *priv;
-
-		priv = rcu_access_pointer(ipc_wwan->sub_netlist[if_id]);
-		if (!priv)
-			continue;
-
-		rtnl_lock();
-		ipc_wwan_dellink(ipc_wwan, priv->netdev, NULL);
-		rtnl_unlock();
-	}
-
 	mutex_destroy(&ipc_wwan->if_mutex);
 
 	kfree(ipc_wwan);
-- 
2.26.3

