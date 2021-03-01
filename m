Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14E4328293
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 16:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbhCAPek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 10:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237255AbhCAPeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 10:34:19 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28ACC06178A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 07:33:37 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id e10so16368369wro.12
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 07:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=U1RTwDzd3aA+fYeGs3YFLLcfX65jJgtsjxh6rOuVatE=;
        b=fslH9W+84Ps12vTZEB08hETlP13eJNYaNkzc44Q5UFqOrJVHKLrOR7wQ8LXfMUaV5f
         mNoJjj6rFOSmLLRYeKu35V1bXTaEVd5AKrBvfW72XveKO5T+OfbTwBF5g0TkgCkEq5MJ
         wRKTbNS53zxaJRgSKYZdAkeXfHU1I4nIDpKs4/5RVFRpwGfFVS6oQJsgYab+u5KR1+nF
         qQdtCsQUhLRiF6cSswoq/2cUkT4RWE8+FTsoiqItj5IhILATrbcN/MlD5W7qmbJZK585
         eE6Tx6QybtFhHby4YYaQwO5eAIlOJ94R5S6gk2tR6II+xZ5C8t7jZfvKM4BKqsGilcYY
         goeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=U1RTwDzd3aA+fYeGs3YFLLcfX65jJgtsjxh6rOuVatE=;
        b=YNJm1ekHpjxw4x/1eb/ePSI4/Ky3uX1l4kCJgKvjovmUVUr8pDSD1hWD57UtEVJNs8
         lNx72O0Ly1syfdpGyKdwQXuy7OW6zJRX/9Zy2pX0jxLx2SxXqTWgwBCv4zTjCnPXiqeL
         horbRQG+P4wnR2clAgXibNsuh4dan8gJY6ZWm5QUTBDZk4TV4BxIfKrAzOTcuU9sYUC5
         GjV0iBjWJZEztkyqXzv1/6v73SFo87GkSuHI6FPj56LMC32dKThIcbjQssHMu5fqGImU
         NzpPH1Ru71BdsGBsdzESFrMcnHtQ7DttY+GCY0l53hDYEng4UkApv3hv8A/EqJVNeXBs
         x2/w==
X-Gm-Message-State: AOAM5322RDTofhTWY1hF9GeQkqmw0eu36pIr0Cu4gNMBJuk5EDSglb6o
        k0SRayZ3Q05LK6VN82mR1EG1TmKsDABJhyAW
X-Google-Smtp-Source: ABdhPJwUGTT8ogXnD+vXzWU9hwQq3lLM2Z9OnYG1q06PEq1RiznMyXGBgg4UNc+CKyKJPx34rUty9w==
X-Received: by 2002:adf:dbc2:: with SMTP id e2mr16616491wrj.227.1614612816587;
        Mon, 01 Mar 2021 07:33:36 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:5a20:c00c:6ec3:cc84])
        by smtp.gmail.com with ESMTPSA id x8sm3667855wru.46.2021.03.01.07.33.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Mar 2021 07:33:36 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next 1/2] net: mhi: Allow decoupled MTU/MRU
Date:   Mon,  1 Mar 2021 16:41:51 +0100
Message-Id: <1614613312-24642-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a maximum receive unit (MRU) size is specified, use it for RX
buffers allocation instead of the MTU.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi/mhi.h | 1 +
 drivers/net/mhi/net.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mhi/mhi.h b/drivers/net/mhi/mhi.h
index 12e7407..1d0c499 100644
--- a/drivers/net/mhi/mhi.h
+++ b/drivers/net/mhi/mhi.h
@@ -29,6 +29,7 @@ struct mhi_net_dev {
 	struct mhi_net_stats stats;
 	u32 rx_queue_sz;
 	int msg_enable;
+	unsigned int mru;
 };
 
 struct mhi_net_proto {
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index b1769fb..4bef7fe 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -270,10 +270,12 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
 						      rx_refill.work);
 	struct net_device *ndev = mhi_netdev->ndev;
 	struct mhi_device *mdev = mhi_netdev->mdev;
-	int size = READ_ONCE(ndev->mtu);
 	struct sk_buff *skb;
+	unsigned int size;
 	int err;
 
+	size = mhi_netdev->mru ? mhi_netdev->mru : READ_ONCE(ndev->mtu);
+
 	while (!mhi_queue_is_full(mdev, DMA_FROM_DEVICE)) {
 		skb = netdev_alloc_skb(ndev, size);
 		if (unlikely(!skb))
-- 
2.7.4

