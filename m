Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7383D465CB1
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355209AbhLBD0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355198AbhLBD03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:26:29 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81237C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:23:07 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y8so19253205plg.1
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YRhBZzAeV2LuAfYUW//Y3tEzWeNiR52G9iWZL8XYr7E=;
        b=XSodOiNoDSUFSzSgyoCussCKF0VsNc4ahkbOgOVLAYqiJxSUcEtgSf54Q/pJy2BeMH
         RN8xCOu0B5ZdPUX/bm1DCdtaEIezR4AWELoD3CV7oRp9VEIcIsnbhc6R/VkBGFvp8HQP
         k6yHLSvZTNmoOu2nuCyYzJQDhpsPLqFcSVMgR7zSlAhHwyUAVA2FXM8U9J2zPPvk00u9
         CylZmY0nYaUbfr9GIkNYXTgWEYyGicpGMqwOgkktnPXtgvmjBHxNtSUejjHKL5O99UXs
         oe9R3i/zyqumMU8kpmT1o8fPecY+Flh1+sSqmIHWXcMCbxDMS7aXFch3gECRL7qwqofo
         DQFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YRhBZzAeV2LuAfYUW//Y3tEzWeNiR52G9iWZL8XYr7E=;
        b=a8QFnSx8IHtoo5Q/nF+qzRpnFF0gQrHp4F8swxhgCu8hWXUPfD+hHQLSJZS4ie1D3f
         gNz/Yf0HRWz42qnZz1euUE4nH9iKQscd+CRiZ8q/nbOpwMLCELaUYenahmy8HhC7parh
         icE+BD7uy9fucJjRa/QKS5Mg+ue8iM4N2qQDzZnPS1RXQipiY/PFM+wociEvVUqWBKBG
         PS9HQ8Y57ZfpZ+FFTnLWN0pB9Xvf9K5mVcIW4EiECR4ves5EBmOIvmPgKVSwL3Vw2CI+
         ABwa1YFmFY1IvHO1aCIFfXj0mVqv1jJZgnpsnUpMuYp5QrsI5/4nhQaO9D0d/uaFipfS
         C3wA==
X-Gm-Message-State: AOAM531u7pABahM+YHFESVpBSijBBBs+V1FSj35Om8dbdPJLX1K1ct5d
        IGZomEQyRRdnIhrLuBpoAAk=
X-Google-Smtp-Source: ABdhPJx6DuI/hayy1g6DDPX/Xsclgqw7jyVXtpF4CpMGjdBkMie+1kcsJhbain3ejAFYvAIIA9Rqqw==
X-Received: by 2002:a17:90a:590d:: with SMTP id k13mr2879347pji.184.1638415387110;
        Wed, 01 Dec 2021 19:23:07 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:23:06 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 14/19] net: add net device refcount tracker to struct pneigh_entry
Date:   Wed,  1 Dec 2021 19:21:34 -0800
Message-Id: <20211202032139.3156411-15-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/neighbour.h | 1 +
 net/core/neighbour.c    | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 190b07fe089ef5c900a0d97df0bc4d667d8bdcd6..5fffb783670a6d2432896a06d3044f6ac83feaf4 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -174,6 +174,7 @@ struct pneigh_entry {
 	struct pneigh_entry	*next;
 	possible_net_t		net;
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
 	u32			flags;
 	u8			protocol;
 	u8			key[];
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index fb340347e4d88f0058383697071cfb5bfbd9f925..56de74f8d2b1c896c478ded2c659b0207d7b5c75 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -771,10 +771,10 @@ struct pneigh_entry * pneigh_lookup(struct neigh_table *tbl,
 	write_pnet(&n->net, net);
 	memcpy(n->key, pkey, key_len);
 	n->dev = dev;
-	dev_hold(dev);
+	dev_hold_track(dev, &n->dev_tracker, GFP_KERNEL);
 
 	if (tbl->pconstructor && tbl->pconstructor(n)) {
-		dev_put(dev);
+		dev_put_track(dev, &n->dev_tracker);
 		kfree(n);
 		n = NULL;
 		goto out;
@@ -806,7 +806,7 @@ int pneigh_delete(struct neigh_table *tbl, struct net *net, const void *pkey,
 			write_unlock_bh(&tbl->lock);
 			if (tbl->pdestructor)
 				tbl->pdestructor(n);
-			dev_put(n->dev);
+			dev_put_track(n->dev, &n->dev_tracker);
 			kfree(n);
 			return 0;
 		}
@@ -839,7 +839,7 @@ static int pneigh_ifdown_and_unlock(struct neigh_table *tbl,
 		n->next = NULL;
 		if (tbl->pdestructor)
 			tbl->pdestructor(n);
-		dev_put(n->dev);
+		dev_put_track(n->dev, &n->dev_tracker);
 		kfree(n);
 	}
 	return -ENOENT;
-- 
2.34.0.rc2.393.gf8c9666880-goog

