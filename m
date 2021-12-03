Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECFF46703E
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378262AbhLCCvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350635AbhLCCvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:22 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52476C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:59 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id i12so1494630pfd.6
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7qwiO23AB0bDvllXH4j2dl319YdLwYZlD78jd251Gbg=;
        b=CbJiqzNEUc6seRSRhV9xRgGFCOoHbC7s5cxnG2HYxaaA5w3y3kSVMDWZ/6A0FkAZzg
         uCqlbJae867GUDIIAOUFG3DfPi5OEEnySYA9sX8O+VNTvYLJBxo+7B40OIykMdKmKoCu
         CX3i9sEem7Oxb4cO0m60MC27aCBCET5jpAxlyKHVXpQbc/qeMm/2lHK7KPgLnsjb31P5
         zI6vMCaYJE3/uFLxipYFZh0nY7WT2p7H1xa3oM5z+PvFj8HULwtZim3erHfo5RzSd1Ow
         ac0m+TJ+GEJf2/Kg9kJ6j70/w7fxlJAQHIL7ZLAuMYO3RnTGDRG3ql5GNURNR4zIjEp4
         jTzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7qwiO23AB0bDvllXH4j2dl319YdLwYZlD78jd251Gbg=;
        b=7lZRZKTvOCM+Y6yCJGAjo7pumCznvMNsTqvWdkESiXDF12ynWcv2MoqJaABkLmRN+b
         dSaAQ0yWODT3kcLb5WkPcaWMo/bfdB/mtN2YBxLT1vhlf+6ChwvR8X+mgvGsrNB+Bf+Y
         zfkwxfkVMKRddB3oWXN2TqFuWy6WJmr+2S03dSkpDK5fbh44uTYvSO5Aqf6GihgmrGpp
         xatGfuozVEe0SSBn8fvzsAVS05PopypVyngM4FofoptKC21Ta1VoKljeD+obEcqOG6WN
         IoVK230oRhaLF71mXrgzHppAp8Itpyi7uyc5HvOOr23r6LZhLgIQBEvek2WIahk4NUYA
         ISAg==
X-Gm-Message-State: AOAM5303go0r2nkN/RWvryVv7gaC7RFE362NBxV4B1khdsm+TTCquBsF
        ECOHl9LHK5A4w0m3Bvlgx/o=
X-Google-Smtp-Source: ABdhPJx7nmMPmk+IcGZeBph86A7BBv7CRTR/OpNy5BUknqL4ZYj2p1799YmUFjuymUxtkK+znvtE3A==
X-Received: by 2002:a05:6a00:24cd:b0:49f:a4d8:3d43 with SMTP id d13-20020a056a0024cd00b0049fa4d83d43mr16542981pfv.49.1638499678871;
        Thu, 02 Dec 2021 18:47:58 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:58 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 13/23] net: add net device refcount tracker to struct neighbour
Date:   Thu,  2 Dec 2021 18:46:30 -0800
Message-Id: <20211203024640.1180745-14-eric.dumazet@gmail.com>
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
 include/net/neighbour.h | 1 +
 net/core/neighbour.c    | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 55af812c3ed5704813bd64aa760246255aa5f93f..190b07fe089ef5c900a0d97df0bc4d667d8bdcd6 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -158,6 +158,7 @@ struct neighbour {
 	struct list_head	managed_list;
 	struct rcu_head		rcu;
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
 	u8			primary_key[0];
 } __randomize_layout;
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 72ba027c34cfea6f38a9e78927c35048ebfe7a7f..fb340347e4d88f0058383697071cfb5bfbd9f925 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -624,7 +624,7 @@ ___neigh_create(struct neigh_table *tbl, const void *pkey,
 
 	memcpy(n->primary_key, pkey, key_len);
 	n->dev = dev;
-	dev_hold(dev);
+	dev_hold_track(dev, &n->dev_tracker, GFP_ATOMIC);
 
 	/* Protocol specific setup. */
 	if (tbl->constructor &&	(error = tbl->constructor(n)) < 0) {
@@ -880,7 +880,7 @@ void neigh_destroy(struct neighbour *neigh)
 	if (dev->netdev_ops->ndo_neigh_destroy)
 		dev->netdev_ops->ndo_neigh_destroy(dev, neigh);
 
-	dev_put(dev);
+	dev_put_track(dev, &neigh->dev_tracker);
 	neigh_parms_put(neigh->parms);
 
 	neigh_dbg(2, "neigh %p is destroyed\n", neigh);
-- 
2.34.1.400.ga245620fadb-goog

