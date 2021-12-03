Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C10B467038
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378224AbhLCCvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350096AbhLCCvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:00 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD5DC061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:37 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id p18so1080182plf.13
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iCVrtbrupO2p3CSbIlgpBTs9TIXh0ks/7pAWJkZoW3E=;
        b=gttNy+sOkoCfam70kewyLMG9bedu4+vLNpYuyoWzwCc+MQc3nrzT6khC6wjrZ7ZHDW
         bIOAKIXBDDzHn38F6JQ5mXaig+PJMyuKbzc2m/jMd0keO5v1IWg+12YGqGhtmld0amxU
         EwFrUtqe0vXK3JJ+F1xVRcEMr/GnUNFePiUtFOXJWWAPQhF9IjK497TdcMDJSKzNeE+o
         XKq2+nbKYT2Y+NuXrdVUxM0wtIWRfFj3QVE8ShCD9EJE26HakzLZxYZ5/Z7wS1FKPS7Y
         eT1uqsv+cxJcKlXpTYkLrwfQSv5rzW9ghKHX/s7ASYdVglcuVd45YIxJdDk2rSkmCZBr
         IeCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iCVrtbrupO2p3CSbIlgpBTs9TIXh0ks/7pAWJkZoW3E=;
        b=4WX8XBrlwBRuRE6G6o17fJIaP5IYSmLvkyt9vYjzLYEPBABp8zTZJJzyuXwHkZjq/K
         t49uqaDphKYk18cNSIDpxbGM6rnNukPgHk1T4a6/V3cew3dTg87xCQmwBumaSWg38lY1
         8vb2JbOCFiX8EOTdaBMLaIkVwSKP2A8ymCncwfYUhmu60HIaEClT3SiDqYydYjdEY8G7
         hcZgHqE9p6VGXdwPAZObsXCbFDOXSzuqkP0oz6U1LYATMLpHIGd49veCUfUvX0pPoBzv
         FO2VqTbWNrlFVS2digDA0VAVCIkCYe3Uz5fKhHqO5KB4RO0yxfuDNwCeZVj7ln1YxOIM
         6L6Q==
X-Gm-Message-State: AOAM533BzDSdAruZEyubMWCK4bSga4No7L1H4r/GjUjRMpVRewzvgnQl
        HNdlwSVxjLuWT/4CNeOfUt0=
X-Google-Smtp-Source: ABdhPJxzcuVhd69wEtGUrva/6izm+zhnMvTDbANPO51WhroYcNNlqv2SEqUKFOGSO18ZXQk7z3dSgQ==
X-Received: by 2002:a17:903:2093:b0:142:7dff:f7de with SMTP id d19-20020a170903209300b001427dfff7demr19963093plc.75.1638499657195;
        Thu, 02 Dec 2021 18:47:37 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:36 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 07/23] net: add net device refcount tracker to dev_ifsioc()
Date:   Thu,  2 Dec 2021 18:46:24 -0800
Message-Id: <20211203024640.1180745-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev_ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index cbab5fec64b12df9355b154bdcaa0f48701966e8..1d309a6669325ad26c59892c4e78ca14dec017d9 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -313,6 +313,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 	int err;
 	struct net_device *dev = __dev_get_by_name(net, ifr->ifr_name);
 	const struct net_device_ops *ops;
+	netdevice_tracker dev_tracker;
 
 	if (!dev)
 		return -ENODEV;
@@ -381,10 +382,10 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 			return -ENODEV;
 		if (!netif_is_bridge_master(dev))
 			return -EOPNOTSUPP;
-		dev_hold(dev);
+		dev_hold_track(dev, &dev_tracker, GFP_KERNEL);
 		rtnl_unlock();
 		err = br_ioctl_call(net, netdev_priv(dev), cmd, ifr, NULL);
-		dev_put(dev);
+		dev_put_track(dev, &dev_tracker);
 		rtnl_lock();
 		return err;
 
-- 
2.34.1.400.ga245620fadb-goog

