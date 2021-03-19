Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C434342073
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhCSPCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbhCSPCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:02:38 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2323C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:02:38 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id w11so3080797ply.6
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nDT2IpQMcqDtWsYJSr9LHOMMWtQLCuVBeJsdx3ljwz4=;
        b=KfGTLeHjaBvnQ6qYHr33cEW2Xgw3g+gKKB8fH1VpCVq9fj3BhxvgChtaacf89DL5JB
         SnjonNBN6P+q/9kL6aZLfRNFHgL4yfwa2qS3bozj7ooG/112ZDjHsAkjz2L0t9g7KR7v
         eSQ0D62BD/G7CVeQ2BO643mNsdgYMSkylUdEl+gngTLTP9ySZ4x8H25rP4NQwEZ239EY
         554mR5A75R5yz0dpJytNHLbMZJB32j2Dnu98Bce9EjKPsKNYq3EJHX2qBnB4Oq706Q7H
         Zv9tNstf4i6mNh/emHuKz6nMP4iyin19jJR78RhY2LOaERJLstWKNdR1aGWtXHIKBHWj
         nrcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nDT2IpQMcqDtWsYJSr9LHOMMWtQLCuVBeJsdx3ljwz4=;
        b=CZ9yxtLP8SBLEt+ZfEcaxw3CzvjMMNn3fNLr+7DgwaGKGZxJ/uVKPsILfOmohSwVBv
         9n1GkRcJsuJzRvJRs5CKQJZIyJ0M73X00Za2zRtfwhqsD03YbaqBPaOhsJsJ30tCW/yc
         SJiDrQAkFRqn+8GKNSXzYGuqYrnXLc54P1AKALuQntKAa8wFvsAstyf4OALTHPY0WeBP
         2bEdw/DHKtUQ/i046FJfZ//dLYVbBjxZGXjJW2/UDWDn5hdq6Zjt5GkgffdgrFcZB1+z
         jhFm0DlC5Iwo2yDy718RRrgR0eEnO0wgIb5Gu1/WC1ZWrxLgUXYRCtN59a0G4dDjY+jF
         6PKg==
X-Gm-Message-State: AOAM5302d7GwwW71b0X3kn0Q1kUvf04QvT18B7GPzQkkIzevkWjlChRU
        9qZ75NlWJH5CvXjuRO+gjy8=
X-Google-Smtp-Source: ABdhPJwt4x4i/jbvMV+bo7BCApkjKYIR7ssW9BdybwlMGypz/i4518Ml8nET3/YwpRJDFJkBvUIN5A==
X-Received: by 2002:a17:90b:108f:: with SMTP id gj15mr10286747pjb.177.1616166158062;
        Fri, 19 Mar 2021 08:02:38 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:50e8:41b5:c2f1:f936])
        by smtp.gmail.com with ESMTPSA id i7sm6050212pfq.184.2021.03.19.08.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 08:02:36 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: add CONFIG_PCPU_DEV_REFCNT
Date:   Fri, 19 Mar 2021 08:02:32 -0700
Message-Id: <20210319150232.354084-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

I was working on a syzbot issue, claiming one device could not be
dismantled because its refcount was -1

unregister_netdevice: waiting for sit0 to become free. Usage count = -1

It would be nice if syzbot could trigger a warning at the time
this reference count became negative.

This patch adds CONFIG_PCPU_DEV_REFCNT options which defaults
to per cpu variables (as before this patch) on SMP builds.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 13 +++++++++++++
 net/Kconfig               |  8 ++++++++
 net/core/dev.c            | 10 ++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4940509999beeb93ca4ad214e65d68e622a484cb..8f003955c485b81210ed56f7e1c24080b4bb46eb 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2092,7 +2092,12 @@ struct net_device {
 	u32                     proto_down_reason;
 
 	struct list_head	todo_list;
+
+#ifdef CONFIG_PCPU_DEV_REFCNT
 	int __percpu		*pcpu_refcnt;
+#else
+	refcount_t		dev_refcnt;
+#endif
 
 	struct list_head	link_watch_list;
 
@@ -4044,7 +4049,11 @@ void netdev_run_todo(void);
  */
 static inline void dev_put(struct net_device *dev)
 {
+#ifdef CONFIG_PCPU_DEV_REFCNT
 	this_cpu_dec(*dev->pcpu_refcnt);
+#else
+	refcount_dec(&dev->dev_refcnt);
+#endif
 }
 
 /**
@@ -4055,7 +4064,11 @@ static inline void dev_put(struct net_device *dev)
  */
 static inline void dev_hold(struct net_device *dev)
 {
+#ifdef CONFIG_PCPU_DEV_REFCNT
 	this_cpu_inc(*dev->pcpu_refcnt);
+#else
+	refcount_inc(&dev->dev_refcnt);
+#endif
 }
 
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
diff --git a/net/Kconfig b/net/Kconfig
index 0ead7ec0d2bd9ccbbfeab32f1892a9afd2a3eb77..9c456acc379e78caa9e45d4f1335802a05663a0f 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -245,6 +245,14 @@ source "net/l3mdev/Kconfig"
 source "net/qrtr/Kconfig"
 source "net/ncsi/Kconfig"
 
+config PCPU_DEV_REFCNT
+	bool "Use percpu variables to maintain network device refcount"
+	depends on SMP
+	default y
+	help
+	  network device refcount are using per cpu variables if this option is set.
+	  This can be forced to N to detect underflows (with a performance drop).
+
 config RPS
 	bool
 	depends on SMP && SYSFS
diff --git a/net/core/dev.c b/net/core/dev.c
index 4961fc2e9b1967c0d63b53cd809d52b43be0ed4b..edde830df1a483535372014034d5b1ee1ff6210a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10312,11 +10312,15 @@ EXPORT_SYMBOL(register_netdev);
 
 int netdev_refcnt_read(const struct net_device *dev)
 {
+#ifdef CONFIG_PCPU_DEV_REFCNT
 	int i, refcnt = 0;
 
 	for_each_possible_cpu(i)
 		refcnt += *per_cpu_ptr(dev->pcpu_refcnt, i);
 	return refcnt;
+#else
+	return refcount_read(&dev->dev_refcnt);
+#endif
 }
 EXPORT_SYMBOL(netdev_refcnt_read);
 
@@ -10674,9 +10678,11 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev = PTR_ALIGN(p, NETDEV_ALIGN);
 	dev->padded = (char *)dev - (char *)p;
 
+#ifdef CONFIG_PCPU_DEV_REFCNT
 	dev->pcpu_refcnt = alloc_percpu(int);
 	if (!dev->pcpu_refcnt)
 		goto free_dev;
+#endif
 
 	if (dev_addr_init(dev))
 		goto free_pcpu;
@@ -10740,7 +10746,9 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	return NULL;
 
 free_pcpu:
+#ifdef CONFIG_PCPU_DEV_REFCNT
 	free_percpu(dev->pcpu_refcnt);
+#endif
 free_dev:
 	netdev_freemem(dev);
 	return NULL;
@@ -10783,8 +10791,10 @@ void free_netdev(struct net_device *dev)
 	list_for_each_entry_safe(p, n, &dev->napi_list, dev_list)
 		netif_napi_del(p);
 
+#ifdef CONFIG_PCPU_DEV_REFCNT
 	free_percpu(dev->pcpu_refcnt);
 	dev->pcpu_refcnt = NULL;
+#endif
 	free_percpu(dev->xdp_bulkq);
 	dev->xdp_bulkq = NULL;
 
-- 
2.31.0.291.g576ba9dcdaf-goog

