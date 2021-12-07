Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04F346AFD6
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351765AbhLGBfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351711AbhLGBeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:46 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3ABC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:31:16 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id k26so7450633pfp.10
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tL5ZM2YXicjzNxI/doFLTFvFFTbP1t2rgiQqxkp+MnA=;
        b=DCtDii3Ny1cQrkS6Pxk3cIIAYamAVJROJauEcyXb1/oloX1kZF46//4YoMa3GFOBtA
         4Z1Y9JRLTc1tR7nYsGBX0SnrJvFCutugeUDz3KGtXj9IGysRgdS4JONPpfgqnUxUlHwp
         NJrhi+MnL2b1O01qZt8Iydurv6yCNMRTkckPEcBSb7l8wUVWpYcLvnf+ofx5LbdjLpac
         exJ/3x17v4gQPHcKrrPPJ9K0mmofyQoOo/1+qpsE3US/Q7Y13NUcgSHAF5X1i11fbO93
         HFQqmzflXjVDwZXBIsOD9NEE3hQ9p0rywCjU55uiFLeKog2gjmBE/tM1Cvw9ZwZ4whob
         ycUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tL5ZM2YXicjzNxI/doFLTFvFFTbP1t2rgiQqxkp+MnA=;
        b=KI6rkHB2sn51K04qmeper473PRd4J8AS3SEWIZiSp6LvMF5318ryV6Llx+gntfw9SC
         MTmaIVrdt6zof4AYYeLApAGKLH5+1YELgOzrDxNcAiLxsBCfJoj1TKbLkVhC6z35ttiR
         CTFsCyJAi/kqwVQcH00j4UVkCD9x5WM1zi9CmYxW+nxmkHJqZwwEXAM1/trk0qs+EEBE
         vDx2NKLfKGbs7lkXpViQSJUXH6gHWfBy95PHlMwKAhaAqfWylkVzcVNCaPk79AlzwtRX
         nY6grcfrIfNW5OPCmXPLaD6g5AwVS54UA4WxCR/JehOSRIyf21FP8iOBYzeyBzHs4oaS
         BJrw==
X-Gm-Message-State: AOAM531mUQG9wk33GiSUpFa52P2seUWjCdOnGwDWFeY4ZyUhF7qur1LR
        O+uU/HcyN8wnbevYQPb65fU=
X-Google-Smtp-Source: ABdhPJwrWimEtkzNOq/HFSb8tbUmJFfb4n8ChE1yoBDhLNxPDKsd/WU4T8eTAzHz5Yng79op/5s2YQ==
X-Received: by 2002:a63:8ac1:: with SMTP id y184mr21560692pgd.523.1638840676311;
        Mon, 06 Dec 2021 17:31:16 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:31:15 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 10/13] net/smc: add net device tracker to struct smc_pnetentry
Date:   Mon,  6 Dec 2021 17:30:36 -0800
Message-Id: <20211207013039.1868645-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207013039.1868645-1-eric.dumazet@gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/smc/smc_pnet.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 67e9d9fde08540fe1e152b85c450a0165eb37747..e171cc6483f84aac0e3cf496079a7ca57807b991 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -64,6 +64,7 @@ struct smc_pnetentry {
 		struct {
 			char eth_name[IFNAMSIZ + 1];
 			struct net_device *ndev;
+			netdevice_tracker dev_tracker;
 		};
 		struct {
 			char ib_name[IB_DEVICE_NAME_MAX + 1];
@@ -119,7 +120,7 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 		    smc_pnet_match(pnetelem->pnet_name, pnet_name)) {
 			list_del(&pnetelem->list);
 			if (pnetelem->type == SMC_PNET_ETH && pnetelem->ndev) {
-				dev_put(pnetelem->ndev);
+				dev_put_track(pnetelem->ndev, &pnetelem->dev_tracker);
 				pr_warn_ratelimited("smc: net device %s "
 						    "erased user defined "
 						    "pnetid %.16s\n",
@@ -195,7 +196,7 @@ static int smc_pnet_add_by_ndev(struct net_device *ndev)
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && !pnetelem->ndev &&
 		    !strncmp(pnetelem->eth_name, ndev->name, IFNAMSIZ)) {
-			dev_hold(ndev);
+			dev_hold_track(ndev, &pnetelem->dev_tracker, GFP_ATOMIC);
 			pnetelem->ndev = ndev;
 			rc = 0;
 			pr_warn_ratelimited("smc: adding net device %s with "
@@ -226,7 +227,7 @@ static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 	write_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && pnetelem->ndev == ndev) {
-			dev_put(pnetelem->ndev);
+			dev_put_track(pnetelem->ndev, &pnetelem->dev_tracker);
 			pnetelem->ndev = NULL;
 			rc = 0;
 			pr_warn_ratelimited("smc: removing net device %s with "
@@ -368,7 +369,7 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 	memcpy(new_pe->pnet_name, pnet_name, SMC_MAX_PNETID_LEN);
 	strncpy(new_pe->eth_name, eth_name, IFNAMSIZ);
 	new_pe->ndev = ndev;
-
+	netdev_tracker_alloc(ndev, &new_pe->dev_tracker, GFP_KERNEL);
 	rc = -EEXIST;
 	new_netdev = true;
 	write_lock(&pnettable->lock);
-- 
2.34.1.400.ga245620fadb-goog

