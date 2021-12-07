Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5272C46B1B2
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 05:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbhLGEFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 23:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhLGEFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 23:05:43 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD3CC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 20:02:13 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id bu11so11996968qvb.0
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 20:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6HDqaaXBBQ7MGDRLLbEs+u7qNrZqI377kTFfTyB8oTM=;
        b=jhhG3ZXkxCdU01jMRRJFp0V0HiiBqnXZ+xFOgzkiU8LOeRQT1Q16WIHiXDbq2eqNgX
         rMtyh6mweBEhdvnFFbMtMasxCjfvtcONc3I/XruJjVL+2wo508uawkzyUpvLbmKpBmJH
         eKu37+sNw9mfBzpO/Taur9sGroYF9Dhl+HnZoKL84AFXgIipZ08FFSJvuKK4XG9JmgAE
         O/Wk9Dzgh3A/RxvFgafcZtulHfQbbuet07Oer6DbZG329lTiX7eKdwZNAx4WdeMEIRrc
         mLOYCEDZL6ZKX/0VAzZ9oEP5ORMcfG/hbFO2ZqBXfjKinCMrbtak/BmaYEcma6QkPZoF
         OW7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6HDqaaXBBQ7MGDRLLbEs+u7qNrZqI377kTFfTyB8oTM=;
        b=Grt3FtF2rcPw/gZCOLTi2vluMwIeXoBPvPRgdH/pzBophda80A4AbiujZEOy9fnc4P
         6KcHupKdnMXxLSzYiB9BoSVru+M7G+PqP/a3kFE4B0u7gFet5MRlg5iPXUzdGP2J3fG3
         7DzvqPi3A9dTOTbZWXqS9jSIiJMn8wX/GsF0fN0o4VQLBSALc0SW+A6wIxlSxLDwRhAj
         vwFQN40Yg3N4YAxjo/VtKZ5nclr66Iv/xn7HmjOWz1ABwRsVhzc4nYxbHjxYe9xJr7y8
         L2DamBuZFDZb5WIPF5Tdt8OfXZnilw2Xfx+i2yem/cxzji7jL7Sl+UuMz7CC5TzoFKlK
         Z43A==
X-Gm-Message-State: AOAM5324FoP7mWqnwH6YXg8AJ6bJB+ebQYuAkkzGtUq1NGllMHBfjm5s
        koyh1HITri1CbdwLmG9cVbPRDal0L/Bx/A==
X-Google-Smtp-Source: ABdhPJyErIzJcxpyXgxLng4cDQxR9b+Lt08oev8kVH67ksi4N7E9ML0idoS2faRYolAUtOweJj6uZA==
X-Received: by 2002:ad4:56a6:: with SMTP id bd6mr41772010qvb.129.1638849732565;
        Mon, 06 Dec 2021 20:02:12 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 14sm8526393qtx.84.2021.12.06.20.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 20:02:12 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 2/5] net: track netdev refcnt with obj_cnt
Date:   Mon,  6 Dec 2021 23:02:05 -0500
Message-Id: <e09681e82af58902bf50254a380c491cfd8d36e0.1638849511.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1638849511.git.lucien.xin@gmail.com>
References: <cover.1638849511.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two types are added into obj_cnt to count dev_hold and dev_put,
and all it does is put obj_cnt_track_by_dev() into these two
functions.

Here is an example to track the refcnt of a netdev named dummy0:

  # sysctl -w obj_cnt.control="clear" # clear the old result

  # sysctl -w obj_cnt.type=0x3     # enable dev_hold/put track
  # sysctl -w obj_cnt.name=dummy0  # count dev_hold/put(dummy0)
  # sysctl -w obj_cnt.nr_entries=4 # save 4 frames' call trace

  # ip link add dummy0 type dummy
  # ip link set dummy0 up
  # ip link set dummy0 down
  # ip link del dummy0

  # sysctl -w obj_cnt.control="scan"  # print the new result
  # dmesg
  OBJ_CNT: obj_cnt_dump: obj: ffff894402397000, type: dev_put, cnt: 1,:
       in_dev_finish_destroy+0x6a/0x80
       rcu_do_batch+0x164/0x4b0
       rcu_core+0x249/0x350
       __do_softirq+0xf5/0x2ea
  OBJ_CNT: obj_cnt_dump: obj: ffff894402397000, type: dev_hold, cnt: 1,:
       inetdev_init+0xff/0x1c0
       inetdev_event+0x4b7/0x600
       raw_notifier_call_chain+0x41/0x50
       register_netdevice+0x481/0x580
  ...
  OBJ_CNT: obj_cnt_dump: obj: ffff894402397000, type: dev_put, cnt: 1,:
       rx_queue_release+0xa8/0xb0
       kobject_release+0x43/0x140
       net_rx_queue_update_kobjects+0x13c/0x190
       netdev_unregister_kobject+0x4a/0x80
  OBJ_CNT: obj_cnt_dump: obj: ffff894402397000, type: dev_put, cnt: 3,:
       fib_nh_common_release+0x10f/0x120
       fib6_info_destroy_rcu+0x73/0xc0
       rcu_do_batch+0x164/0x4b0
       rcu_core+0x249/0x350
  ...

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/netdevice.h | 11 +++++++++++
 include/linux/obj_cnt.h   |  2 ++
 lib/obj_cnt.c             |  2 ++
 3 files changed, 15 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 69dca1edd5a6..4cbcd34829da 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -49,6 +49,7 @@
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
 #include <linux/ref_tracker.h>
+#include <linux/obj_cnt.h>
 
 struct netpoll_info;
 struct device;
@@ -3815,6 +3816,14 @@ extern unsigned int	netdev_budget_usecs;
 /* Called by rtnetlink.c:rtnl_unlock() */
 void netdev_run_todo(void);
 
+static inline void obj_cnt_track_by_dev(void *obj, struct net_device *dev, int type)
+{
+#ifdef CONFIG_OBJ_CNT
+	if (dev)
+		obj_cnt_track(type, dev->ifindex, dev->name, obj);
+#endif
+}
+
 /**
  *	dev_put - release reference to device
  *	@dev: network device
@@ -3825,6 +3834,7 @@ void netdev_run_todo(void);
 static inline void dev_put(struct net_device *dev)
 {
 	if (dev) {
+		obj_cnt_track_by_dev(dev, dev, OBJ_CNT_DEV_PUT);
 #ifdef CONFIG_PCPU_DEV_REFCNT
 		this_cpu_dec(*dev->pcpu_refcnt);
 #else
@@ -3843,6 +3853,7 @@ static inline void dev_put(struct net_device *dev)
 static inline void dev_hold(struct net_device *dev)
 {
 	if (dev) {
+		obj_cnt_track_by_dev(dev, dev, OBJ_CNT_DEV_HOLD);
 #ifdef CONFIG_PCPU_DEV_REFCNT
 		this_cpu_inc(*dev->pcpu_refcnt);
 #else
diff --git a/include/linux/obj_cnt.h b/include/linux/obj_cnt.h
index e5185f7022d1..bb2d37484a32 100644
--- a/include/linux/obj_cnt.h
+++ b/include/linux/obj_cnt.h
@@ -3,6 +3,8 @@
 #define _LINUX_OBJ_CNT_H
 
 enum {
+	OBJ_CNT_DEV_HOLD,
+	OBJ_CNT_DEV_PUT,
 	OBJ_CNT_TYPE_MAX
 };
 
diff --git a/lib/obj_cnt.c b/lib/obj_cnt.c
index 19ced2303452..12a1fdafd632 100644
--- a/lib/obj_cnt.c
+++ b/lib/obj_cnt.c
@@ -15,6 +15,8 @@ static unsigned int		obj_cnt_num;
 static spinlock_t		obj_cnt_lock;
 
 static char *obj_cnt_str[OBJ_CNT_TYPE_MAX] = {
+	"dev_hold",
+	"dev_put"
 };
 
 struct obj_cnt {
-- 
2.27.0

