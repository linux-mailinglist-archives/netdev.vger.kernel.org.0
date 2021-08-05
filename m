Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24193E1434
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241106AbhHELzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhHELzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 07:55:13 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8848C061765;
        Thu,  5 Aug 2021 04:54:58 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1628164495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DWfoldmLRLq80DZdsLCKJEoZaBQ6+NbZZHi/F4hDQ/s=;
        b=qp8pE5Ns0L6FGItYvYTd+qjUmHViF2N72s5huxJj0qYVBp+S1hwFf0D0p6Nuv19l7AHeMs
        cg4QYCgSyQ2qz1njp9zJSyxphIW6YrHoBn7kkFmao40fDhWPOOBkCK/jOGVgiVN3V4fL0e
        yc3ydWbJnyjB/O+sY9hNU/tuLwmsKMo=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] netdevice: add the case if dev is NULL
Date:   Thu,  5 Aug 2021 19:54:34 +0800
Message-Id: <20210805115434.19248-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the case if dev is NULL in dev_{put, hold}, so the caller doesn't
need to care whether dev is NULL or not.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/linux/netdevice.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1b4d4509d04b..135c943699d0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4143,11 +4143,13 @@ void netdev_run_todo(void);
  */
 static inline void dev_put(struct net_device *dev)
 {
+	if (dev) {
 #ifdef CONFIG_PCPU_DEV_REFCNT
-	this_cpu_dec(*dev->pcpu_refcnt);
+		this_cpu_dec(*dev->pcpu_refcnt);
 #else
-	refcount_dec(&dev->dev_refcnt);
+		refcount_dec(&dev->dev_refcnt);
 #endif
+	}
 }
 
 /**
@@ -4158,11 +4160,13 @@ static inline void dev_put(struct net_device *dev)
  */
 static inline void dev_hold(struct net_device *dev)
 {
+	if (dev) {
 #ifdef CONFIG_PCPU_DEV_REFCNT
-	this_cpu_inc(*dev->pcpu_refcnt);
+		this_cpu_inc(*dev->pcpu_refcnt);
 #else
-	refcount_inc(&dev->dev_refcnt);
+		refcount_inc(&dev->dev_refcnt);
 #endif
+	}
 }
 
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
-- 
2.32.0

