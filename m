Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B20772EF3
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 14:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbfGXMgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 08:36:31 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42699 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfGXMgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 08:36:31 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so21993078plb.9;
        Wed, 24 Jul 2019 05:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4kFGVQZY9I0OMqjA+TXCJoqeRUuUARnDiyE+ekteJw8=;
        b=GBmh8afT6DCU6YFrZicRslPpNSfzFbIalG6g47iHbI6MZKpj6hddTpPHpSnVXiOAi0
         xNwTNNqy0rtsgF5r4CMIm5bAWYig2gq/0N+twP2Dbf5nZ8Z3EZSCO3fJ5TOHRDmmYPnF
         +KK4i9btnFwmmaHtiTlP/o6u7Cwbo2AY6zEd6f6Br9JAS4oslD6GchDETIEU0zuFEEMb
         ZyKN1Y6F4hJLlKHzWOWVHKNij4oKmZOSDgWyQJbTGDOKU5BZKquto+KwDCQ38TjUbj+M
         Xfsm6C6bwFiMRJ0vHtSrT7cNLwoXZzS7PYuFOk4UtqgzYunHQFZnPuf4wnWm7k2Mwuvc
         79yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4kFGVQZY9I0OMqjA+TXCJoqeRUuUARnDiyE+ekteJw8=;
        b=W83x79UobYbmuStTD2oZhhi252izhmd15AGrnObFDuMtcpudYxxM1aJW3diCThXgM0
         U97mSN+58RIUlSIESaVbbR+Pe9ngSyIYYrg/Va15HDzeZ7rB2dfIa0z2eXsYQ+CHJh8O
         qbmwUWxoDFQMLiZ2NGY23gw9yY/YcRHbZ/3Awma2OGe28PVJgfcXkCGDV91xcQa+aYtV
         fl4PdETh4I4UmSwWKjorHBoogXSDPpTCxQzkdEdACIq4O4Pe6HsMxLz8/9BVxa0l1uiI
         JgWCrmBcC8YBNH5ZSXbAeFirHSe3NvDtMlKrB1QxPr7jjaKk3AypcLEzdsqUibd0yCaE
         Zjmg==
X-Gm-Message-State: APjAAAUNtXWKWkr8wLpQVH8AOwdo83715Pzz5dqhNDtAi37X2z5qFodH
        +Ff3rzQBzcOhgJWZ9OlzUXeaggkbl78=
X-Google-Smtp-Source: APXvYqzqvclR6pNhtPq4cidLWcB2P/tDnhN5lpGXAHGlFB6jrqMIQPCz4PfQO+sx5+p4RaFC1Kr9Qw==
X-Received: by 2002:a17:902:9a07:: with SMTP id v7mr76301912plp.245.1563971790673;
        Wed, 24 Jul 2019 05:36:30 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id p65sm45935526pfp.58.2019.07.24.05.36.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 05:36:30 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 1/2] net: mac80211: Fix possible null-pointer dereferences in ieee80211_setup_sdata()
Date:   Wed, 24 Jul 2019 20:36:23 +0800
Message-Id: <20190724123623.10093-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ieee80211_setup_sdata(), there is an if statement on line 1410 to
check whether sdata->dev is NULL:
    if (sdata->dev)

When sdata->dev is NULL, it is used on lines 1458 and 1459:
    sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
    sdata->dev->netdev_ops = &ieee80211_monitorif_ops;

Thus, possible null-pointer dereferences may occur.

To fix these bugs, sdata->dev is checked before being used.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/mac80211/iface.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 06aac0aaae64..e49264981a7b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1455,8 +1455,10 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 			ieee80211_mesh_init_sdata(sdata);
 		break;
 	case NL80211_IFTYPE_MONITOR:
-		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
-		sdata->dev->netdev_ops = &ieee80211_monitorif_ops;
+		if (sdata->dev) {
+			sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
+			sdata->dev->netdev_ops = &ieee80211_monitorif_ops;
+		}
 		sdata->u.mntr.flags = MONITOR_FLAG_CONTROL |
 				      MONITOR_FLAG_OTHER_BSS;
 		break;
-- 
2.17.0

