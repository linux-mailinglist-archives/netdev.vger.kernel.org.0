Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F9146AFD3
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351750AbhLGBfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242801AbhLGBel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:41 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5650C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:31:11 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id y8so8309103plg.1
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KEBzCxUZxGrDGVJ+OdYncdD+kJPJ8PS+fS3F1qSzyJk=;
        b=eD1wOfeAp5vkKpeD//I1d1bwdtZhvn7wPrqj4cR+jCwLGNSgF7EcshaBxCt/EC0ANw
         5oWRy02ulueRZJDcMuW9K/MSYuA4/Rm9n4S8dL0sbdZOCGnJIlHoYwNr+oK3OCNsax4Y
         tNBFydNGn+XpRtM3i4sP7pT3FfVfMLwSOgE2gYXhLa9Fe4Z86T3ZMJNBTFf1vjuScRos
         +YSubI1mETx12sec7rhPfq0AYNJ2OWgl9EmZiEvEViZ6LH+T84RQrkOlwf0jOtDxq3Ns
         MCzmS3sbMnO2DHjFNfndy/06DW4TwNXOUclfbLaxjpYAaQ8mdLa8eyaF+n6ovTdrX6g7
         oDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KEBzCxUZxGrDGVJ+OdYncdD+kJPJ8PS+fS3F1qSzyJk=;
        b=XpWHPUbIoVR14n7Dzap5guFf/yThH10vtIvqEe8M1BTnx2lHkc7rIGnEYM9vIFf+RK
         YUD0pXjnvnfVNUEs1rvnf3BSUFUCO9fAymKpGFjYJOaVhqKbwkCn38jVdgDha0FEjpXs
         A1wnC+SW3Zymr+dMqAct4b/lpueejPJaiy21mM7SBqN3buIpbsvSifTjxOuKU4VICqor
         I9VEdmdctb025JxthtRrhx0BQGBgMwlb5eL9jZnY9407ql8J9faL6muxl9d5o2sIPO9D
         nfC+0za0t5yI1Ig6IWX3n+qD7WynFWP4j03R9Ov7YONDky9PrsMfAId2AU9LLs7RvHUF
         o2YA==
X-Gm-Message-State: AOAM531QsnN2zyuWQMvC6eDwu6xC0ZjDc0uB4F1nZlH0F7mkeHe++uwR
        lpqLsRvzqRcS0urZOJe+vJw=
X-Google-Smtp-Source: ABdhPJw3BVbpamXAzsE/F59Wno145dup+eCWdgm85Qyk1LrANjQmUP/z/tGl9BLX6YSZlz10du+i+g==
X-Received: by 2002:a17:90b:2290:: with SMTP id kx16mr2743228pjb.193.1638840671306;
        Mon, 06 Dec 2021 17:31:11 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:31:10 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 07/13] ax25: add net device refcount tracker
Date:   Mon,  6 Dec 2021 17:30:33 -0800
Message-Id: <20211207013039.1868645-8-eric.dumazet@gmail.com>
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
 include/net/ax25.h  | 3 +++
 net/ax25/ax25_dev.c | 8 ++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 03d409de61ad0e7d37ba0e805a07475e40bab478..526e49589197909b459de068222c4a9cf76050ba 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -229,7 +229,10 @@ struct ctl_table;
 
 typedef struct ax25_dev {
 	struct ax25_dev		*next;
+
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
+
 	struct net_device	*forward;
 	struct ctl_table_header *sysheader;
 	int			values[AX25_MAX_VALUES];
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index d0a043a51848b3141a6e1f2a7b1ed53a51931ae3..256fadb94df3125ddc2f5ed5f8b1c91d6e243546 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -58,7 +58,7 @@ void ax25_dev_device_up(struct net_device *dev)
 
 	dev->ax25_ptr     = ax25_dev;
 	ax25_dev->dev     = dev;
-	dev_hold(dev);
+	dev_hold_track(dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
 	ax25_dev->forward = NULL;
 
 	ax25_dev->values[AX25_VALUES_IPDEFMODE] = AX25_DEF_IPDEFMODE;
@@ -114,7 +114,7 @@ void ax25_dev_device_down(struct net_device *dev)
 		ax25_dev_list = s->next;
 		spin_unlock_bh(&ax25_dev_lock);
 		dev->ax25_ptr = NULL;
-		dev_put(dev);
+		dev_put_track(dev, &ax25_dev->dev_tracker);
 		kfree(ax25_dev);
 		return;
 	}
@@ -124,7 +124,7 @@ void ax25_dev_device_down(struct net_device *dev)
 			s->next = ax25_dev->next;
 			spin_unlock_bh(&ax25_dev_lock);
 			dev->ax25_ptr = NULL;
-			dev_put(dev);
+			dev_put_track(dev, &ax25_dev->dev_tracker);
 			kfree(ax25_dev);
 			return;
 		}
@@ -188,7 +188,7 @@ void __exit ax25_dev_free(void)
 	ax25_dev = ax25_dev_list;
 	while (ax25_dev != NULL) {
 		s        = ax25_dev;
-		dev_put(ax25_dev->dev);
+		dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
 		ax25_dev = ax25_dev->next;
 		kfree(s);
 	}
-- 
2.34.1.400.ga245620fadb-goog

