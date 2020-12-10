Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480DF2D591D
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 12:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbgLJLSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 06:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbgLJLSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 06:18:46 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BA3C0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 03:18:06 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id 3so4894777wmg.4
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 03:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=l8OEyC+nvkowN7eN+kky7l/3Os6ECX947w3oC1HJ9pM=;
        b=A+gpGPetwy/btolrME7v0mF94uG7Q2FTzgoL62rm1BNnD7K5RKiIfA5IGZMcP3oWsE
         2MSjzDiu/t0LReCPyg1wx4iEOLem62GGQW70ki8xkyoNJIzGiMQoWofzQ5n/I0qmNz4Y
         bPJ5gF9TK2eLmVwGZnWV2iL20KeYec1ObnR1bnp7fmIkmCrGr+6l8RcTy/x9pgIXOw55
         gyGR2EpC25FgwskxWx5CH6RNRkvLVclNQnXlOR5ijN9J278/y8kTrdPMh4IXrMWx6F0U
         MUtNpRZM8KQbLiF/Kyjf9ljylIubHG77ruoFeiswBEHBvsdX0IYmcxT/QvOaG2PxntT4
         heVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l8OEyC+nvkowN7eN+kky7l/3Os6ECX947w3oC1HJ9pM=;
        b=X84fw0Ttkb2NbqWeqpRSgRKjUvrnbo8EItxX+PP4H8oy7k5q6XaEH69YGPMuPuyqza
         iVsGihIAQtNqHRIE0n2LOhq0qX9NgrKa3OYDL3bfpSJ4fGvJ2kbE/yA6fIxgVE/cJh8L
         HHUcR9fbHm62wzG367BrprfoWV76pp15WqD1XZCTq+JP7LKw+f+MyX9y3fVpaNTSxrJ3
         +byIrbN/Gxr5VFtZ5PCCC2gSMAJYmlg12alUXdXVGjAndmKzhOC6pjXRfqE4js4dTQa2
         ft0ZcXLwN8jWCRuq3lNLzetB5vqti6wpYtjWYMvdHHd/Np5qfQ5ozEf1xvYLPMnCpVNI
         E4uw==
X-Gm-Message-State: AOAM533tNy51bZzK1WXt23dV/zxCksW3c2okptsMo9CihGRu/tzT/y8N
        K+9u3I8ApHG4tNtYNfBwSQEdsRt3UOrmmpFu
X-Google-Smtp-Source: ABdhPJwM9fEkiVPgkhzgKMNaEm4nJ10E9+Xc6B/CjQcJVMq5FYtH/p4y7rQNDcTC1mkpGInBIZzdMA==
X-Received: by 2002:a1c:9c53:: with SMTP id f80mr7446360wme.19.1607599085218;
        Thu, 10 Dec 2020 03:18:05 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:490:8730:4468:1cc2:be0c:233f])
        by smtp.gmail.com with ESMTPSA id c81sm9683148wmd.6.2020.12.10.03.18.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Dec 2020 03:18:04 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] net: mhi: Fix unexpected queue wake
Date:   Thu, 10 Dec 2020 12:25:07 +0100
Message-Id: <1607599507-5879-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch checks that MHI queue is not full before waking up the net
queue. This fix sporadic MHI queueing issues in xmit. Indeed xmit and
its symmetric complete callback (ul_callback) can run concurently, it
is then not safe to unconditionnaly waking the queue in the callback
without checking queue fullness.

Fixes: 3ffec6a14f24 ("net: Add mhi-net driver")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 8e72d94..b7f7f2e 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -173,6 +173,7 @@ static void mhi_net_ul_callback(struct mhi_device *mhi_dev,
 {
 	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
 	struct net_device *ndev = mhi_netdev->ndev;
+	struct mhi_device *mdev = mhi_netdev->mdev;
 	struct sk_buff *skb = mhi_res->buf_addr;
 
 	/* Hardware has consumed the buffer, so free the skb (which is not
@@ -196,7 +197,7 @@ static void mhi_net_ul_callback(struct mhi_device *mhi_dev,
 	}
 	u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
 
-	if (netif_queue_stopped(ndev))
+	if (netif_queue_stopped(ndev) && !mhi_queue_is_full(mdev, DMA_TO_DEVICE))
 		netif_wake_queue(ndev);
 }
 
-- 
2.7.4

