Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7476E467034
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378218AbhLCCut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378237AbhLCCus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:50:48 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97BFC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:25 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id nn15-20020a17090b38cf00b001ac7dd5d40cso1292569pjb.3
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TRGi1Y/v8gSjSr7WA85PbfYUHy9YzOpPnxw4XG0Peio=;
        b=Ok2yZDfF+zoIY5VsR7ayreU4Hq8iZad7esL4l7fF0XuoPBy7sg3HXUlxaDac5f1l1R
         zmjtF5X8TMS4gDwhd4WtoOqLgZJmM2BW51kZhSr4YxfmD9f6mi+7h/ZRAmtgZxxJNruq
         tcddc6AEOMsETdhoqxpue9aQFBQOBP8nlwNg6+jpALSAdvLhDFjsYIblxDyz2l1NVTgD
         jSWyMyntBkc6tgD0MPC4tKfMy8Mx348wsFe04nel5ES0BdDavwZ48vi+E3VTy2IPueN7
         cBKmno9dwEKzJt5vcOAVzzfmluRYd9NDJZcNI9WubZx0TQOrFeioHcpPqHGwZSK/rwg7
         gakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TRGi1Y/v8gSjSr7WA85PbfYUHy9YzOpPnxw4XG0Peio=;
        b=vNG9RjfPllx/bGNBsqCOA0tmJ6kkBTOIkRQZMAxzvJxbpWaXQo91Z1yW8WEmL6dJVa
         1gLPGueN1d7kSXQjOKB1rHoWz8CqX/fnn2BtxCXSHHnrUnEczgCFg3VbYGIK6M6QS1JG
         /7krlY1iREkXK7IQgnFfxK+8zl8Zd8xgkQ/O+ORvtjvGswP/MFj3dmsJTpNmdaeunT7e
         vV69TRxWJvqas6gXDX8/PqC1sF2G/QmDQ6BzP1VmIoUAiQrqzs3lIEJq2bClaUTOmqoN
         ZI9ER8O3M4C7OCR6Ggw1T2qsB3DTEgqllO80JAfoucBCkg5+onMzHl1qVw7pL5Os0Yw7
         +Leg==
X-Gm-Message-State: AOAM530tzmJeHcAIcYTJyka85M5F5ZmM18T2XSMCmuentRErYuBt0sF+
        mwwTDeGryK0uqId/hjLKEN2LaKWWYjg=
X-Google-Smtp-Source: ABdhPJyZzxXzxNoAvRNXld32U0acdoiPhSF7TmYeMdnDi17p+J0AE9VE9P8V8A21WABN6JtPO2wrsA==
X-Received: by 2002:a17:902:a717:b0:142:76bc:da69 with SMTP id w23-20020a170902a71700b0014276bcda69mr19739560plq.12.1638499645356;
        Thu, 02 Dec 2021 18:47:25 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:25 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 04/23] net: add net device refcount tracker to struct netdev_rx_queue
Date:   Thu,  2 Dec 2021 18:46:21 -0800
Message-Id: <20211203024640.1180745-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This helps debugging net device refcount leaks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 2 ++
 net/core/net-sysfs.c      | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index daeda6ae8d6520c38ff0ce18bac2dc957940de5d..5bda48d81240e010bffb1cfa96e7a84c733a919a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -741,6 +741,8 @@ struct netdev_rx_queue {
 #endif
 	struct kobject			kobj;
 	struct net_device		*dev;
+	netdevice_tracker		dev_tracker;
+
 #ifdef CONFIG_XDP_SOCKETS
 	struct xsk_buff_pool            *pool;
 #endif
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index affe34d71d313498d8fae4a319696250aa3aef0a..27a7ac2e516f65dbfdb2a2319e6faa27c7dd8f31 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1004,7 +1004,7 @@ static void rx_queue_release(struct kobject *kobj)
 #endif
 
 	memset(kobj, 0, sizeof(*kobj));
-	dev_put(queue->dev);
+	dev_put_track(queue->dev, &queue->dev_tracker);
 }
 
 static const void *rx_queue_namespace(struct kobject *kobj)
@@ -1044,7 +1044,7 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
 	/* Kobject_put later will trigger rx_queue_release call which
 	 * decreases dev refcount: Take that reference here
 	 */
-	dev_hold(queue->dev);
+	dev_hold_track(queue->dev, &queue->dev_tracker, GFP_KERNEL);
 
 	kobj->kset = dev->queues_kset;
 	error = kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
-- 
2.34.1.400.ga245620fadb-goog

