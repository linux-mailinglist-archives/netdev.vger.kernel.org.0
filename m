Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15303A7301
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 02:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhFOAcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 20:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhFOAcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 20:32:46 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2897C0613A3
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:27 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id k8so5601916lja.4
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f7fi9P/9fTNbfzW7zyKkEkMsJd4lNuWm+zuR4Wt1cIw=;
        b=qP1ZE2B7D2eyVqQEo4K8sNI6KO1VnUPtUG7m1zhWxF4wXn2jDUcmAjHWKJOfmS1u/g
         8gX511kCYUpRCbcGdqI+lsfvsEB8p15ZUKW9G8qXL+HbMMj86Py6VbpXYJJjRQ49qgup
         H8oUjuDBCoEUho67l2y8hclK+cWKP4USMVWw4LePnIiasV8+DoFVRyMTW0baHTfmmlMK
         PlkAtYjK9E/Ris1vUFGQ0BunuH88gu09T7S+/bNmOLBZR8Wb2cvD2e6Ugvkirzqu1Z6R
         GT3yLK77Yuo1+4Qy/XLsqr4G1Ji3BhFDbFBsngDUPVaBhgpx+irYBMbmzV5x0dJ777G9
         d8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f7fi9P/9fTNbfzW7zyKkEkMsJd4lNuWm+zuR4Wt1cIw=;
        b=iCbGLXI16Snv6B7+CcEeYtaPDFh42DLFdzyf/smgFUlm06U8/iFapb5ppH30KatGql
         VKJ+vfoOSm7Q3Z4EweoH74sUZnNBsxtawoJvAwcV8c/1WNaNEsWGnZF1fCWtUbL+0xYm
         s+inIK4SId2/K3aCbKn1fZya97IywRoOOO8AU4uOrnvYK0749Q9j1xrVwQKD2ysCkJU9
         9GZ4kFpF5FMiBELMOJUYsScX2fu0JfBhd5lFnsvHZrC8/Lie1XOiqnX5DUoGAP+WJGUO
         dYgNw9GYjaYVw/DJ8qOhHjGKtWxS01Xh1i0Uiz9zV30iHsDHntJVP4b6t2XdghZFf5+B
         7IKw==
X-Gm-Message-State: AOAM530s/1q3b3kbq2p7ZqhwEoPYn3loBdJ646OJc+Uc47FsiB2c1c0I
        +FaLfJTbuX89++dYGXDSyx0=
X-Google-Smtp-Source: ABdhPJxYq1Lf+f0J5vH4im6Sl/nar4NdfubN6av5FanTG9iWfY2vm0WRWEyuMJ6iGt11Sv3BHhlveA==
X-Received: by 2002:a2e:a230:: with SMTP id i16mr15828109ljm.169.1623717026286;
        Mon, 14 Jun 2021 17:30:26 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id 9sm1635522lfy.41.2021.06.14.17.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:30:25 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Subject: [PATCH net-next 06/10] net: iosm: drop custom netdev(s) removing
Date:   Tue, 15 Jun 2021 03:30:12 +0300
Message-Id: <20210615003016.477-7-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210615003016.477-1-ryazanov.s.a@gmail.com>
References: <20210615003016.477-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the last commit, the WWAN core will remove all our network
interfaces for us at the time of the WWAN netdev ops unregistering.
Therefore, we can safely drop the custom code that cleaning the list of
created netdevs. Anyway it no longer removes any netdev, since all
netdevs were removed earlier in the wwan_unregister_ops() call.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
CC: M Chetan Kumar <m.chetan.kumar@intel.com>
CC: Intel Corporation <linuxwwan@intel.com>
---
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

