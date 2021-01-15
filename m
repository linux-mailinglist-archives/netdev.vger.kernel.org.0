Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFBF2F75D1
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbhAOJsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbhAOJsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:48:53 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCDEC0613C1;
        Fri, 15 Jan 2021 01:48:22 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id be12so4431294plb.4;
        Fri, 15 Jan 2021 01:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=GICVRuFBghK6qmJknMZuPuQSC/9OuxyKLnC7+sZz14o=;
        b=MuIzvxouYS9yUMuqdrFlNlsrQlxv4YFveyqbp1/MvnnxikA09Vcyk6phkunkOr1KOT
         WcrvLUtgFBtiLBdKvkqHKvJNEcLvGkU3eE3E/mmfb8gfPQOUxm6CCKI0+ife4WD6HVoM
         5QfRjWZJQyeSgtwcceXNOKn9U5imOxpN+/U15ofpu8pH/TYngbYgC6FMr3eNjTFukqfZ
         DW9GNdPWMft6FGCnZTs4dUE9j8TFcgF/Hoe5NKFaLcglolCfclb8YD7Tq9OkPW5ObUQ8
         2ym7DFH680pFjqPbGJkk/9Qlvj/9wlv+vrGUNslUmRCukKMkr8drGxbroy25U2yuA8rF
         A1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=GICVRuFBghK6qmJknMZuPuQSC/9OuxyKLnC7+sZz14o=;
        b=oZkZlZYp/EYcuVLVXzu9AIbs/+7OMV5gy79lzAlPu4ddzdPfVwWusbSxqhAp8W2r0X
         j84IzhmocaCvjV4rO66sruAXN7RvizP2jSD+aG8PjoD7AmPX3PDcGj1csp2vxKeOD/Zn
         pdVoiVwtzV5HVFe5uTQLmfxeLcKSsjmCImFluPmNVhtm4LhttRT0o3mn9AOk4lO4Peh9
         xtSp/O0HJ17LN5bTky8N1Ho0qeTBsjavImb08PGpN8/8IDwhViMICDSReOpK+VOhxpHi
         bQFlELQ4U5qiqHY1rcPRq7jrBvpniE+WANU6iXmLBa+idrV103NCx8QAev74A/TXH5EU
         iTkg==
X-Gm-Message-State: AOAM531dToaTIfdvVMy7JSBXg+75smVKD7t7WpG5zUzYh79KpQUqKlUh
        XvN/NlrKo7GqX1i1Pdl48Vic2dDISygmmA==
X-Google-Smtp-Source: ABdhPJwJy/qKN53Csatyj/wBTM/EVcze9J7BbtMHVYh5zKqr3m2x6fT5kZJI5tpuJuJXKlLInY7E4w==
X-Received: by 2002:a17:90a:8b8a:: with SMTP id z10mr9771771pjn.67.1610704101782;
        Fri, 15 Jan 2021 01:48:21 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t22sm8459987pgm.18.2021.01.15.01.48.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 01:48:21 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 3/3] bareudp: add NETIF_F_FRAGLIST flag for dev features
Date:   Fri, 15 Jan 2021 17:47:47 +0800
Message-Id: <35feddbddb835f24a4b518294e5f0b4c3478591f.1610704037.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <ecdc99699bf9e367ee445238c836b025e16376e5.1610704037.git.lucien.xin@gmail.com>
References: <cover.1610704037.git.lucien.xin@gmail.com>
 <25be5f99a282231f29ba984596dbb462e8196171.1610704037.git.lucien.xin@gmail.com>
 <ecdc99699bf9e367ee445238c836b025e16376e5.1610704037.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610704037.git.lucien.xin@gmail.com>
References: <cover.1610704037.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like vxlan and geneve, bareudp also needs this dev feature
to support some protocol's HW GSO.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/bareudp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 57dfaf4..7511bca 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -526,11 +526,12 @@ static void bareudp_setup(struct net_device *dev)
 	dev->netdev_ops = &bareudp_netdev_ops;
 	dev->needs_free_netdev = true;
 	SET_NETDEV_DEVTYPE(dev, &bareudp_type);
-	dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM;
+	dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
 	dev->features    |= NETIF_F_RXCSUM;
 	dev->features    |= NETIF_F_LLTX;
 	dev->features    |= NETIF_F_GSO_SOFTWARE;
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
+	dev->hw_features |= NETIF_F_RXCSUM;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
-- 
2.1.0

