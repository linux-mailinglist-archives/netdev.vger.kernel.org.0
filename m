Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0352FB3FD
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389514AbhASFZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 00:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbhASFJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 00:09:07 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31829C061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:08:17 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id p15so10898933pjv.3
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RrnaBA59g8hmY68FB0uGiq3ZH+VPCQ5FzAHu8kuBTi0=;
        b=z29oA79dAO5Eg7HZO4XMx7s4Ru1t6D4M4NVANOro1w57eBqbuK5z40d+Qfh6c0LbgC
         Y3SzDl9749VBiVqMUEhWNpnv6VXOKn4EbZGzPoP6p3zJNYcEoPiwNKGbZYp//xWpgCnt
         pcWIqCz/aqP67Alc6pvRiSfhwkrdZG5lEqALPS5umJQawGjAsoAUkm33kyib9HD3bZ0T
         xlXGOdq1d1gKgS5o7raqJgDN8e3wJWBej+6sG0IlKUBBLHf2n1dzUGy+NIWlJHaq0Rws
         emd0ei9stYdWFRjReNAbLbab0FE/1bD5BjdzyG2fHGjUXREk6M9UHhqEaF+Kbc3vLimJ
         bCJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RrnaBA59g8hmY68FB0uGiq3ZH+VPCQ5FzAHu8kuBTi0=;
        b=HWmp+v6OQ4jN97SI01gLazgpdkkbvA7gGFmcncA7kNZjelI1MHPjrLYymWcB97ELyy
         LZKMecHRcJWtPcZhzOmKwRewMwXgxf0ldFMny650G/qL3aoxdeHKJFSKzBTAS+RGrTuP
         gnJfttTSPriDeHOqhjDU/HwsVSOYKsg+2Q10opNGfAkVNfXMavgBC5GBZF9Y529OmaQ6
         j0ZVzK+ngHK6UrA5N7TIYWlxP3cv/Ax82/HPektXMyM3eeVM4ilKJk8oMuKPFe6EVBd2
         ryXKfzjtgMbxT3RuJKnngq+mieZeRtgIxY0r5cIwBd4SitCy2v+rRiQ7aqrDUiGiiFyq
         IVCg==
X-Gm-Message-State: AOAM5313d6znbxI8ohb76JWD01FW4yzcuGmFDSkTTkC/lKM+d613qOdh
        lhifWs4Ek6YEZxF3dkUCAitG
X-Google-Smtp-Source: ABdhPJw4iOZN6+kzePO+c/3w2zGQ9FmnKraKZf5KGu+Sgb+AzphhRcL6QARmaJLEVogXeAFcq0yGgg==
X-Received: by 2002:a17:902:ba89:b029:dd:7fe3:ddf5 with SMTP id k9-20020a170902ba89b02900dd7fe3ddf5mr2695697pls.33.1611032896783;
        Mon, 18 Jan 2021 21:08:16 -0800 (PST)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id j6sm1101822pjd.33.2021.01.18.21.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 21:08:16 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v3 07/11] vdpa: Pass the netlink attributes to ops.dev_add()
Date:   Tue, 19 Jan 2021 13:07:52 +0800
Message-Id: <20210119050756.600-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119045920.447-1-xieyongji@bytedance.com>
References: <20210119045920.447-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass the netlink attributes to ops.dev_add() so that we
could get some device specific attributes when creating
a vdpa device.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa.c              | 2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 3 ++-
 include/linux/vdpa.h             | 4 +++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 50cab930b2e5..81a099ec390e 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -443,7 +443,7 @@ static int vdpa_nl_cmd_dev_add_set_doit(struct sk_buff *skb, struct genl_info *i
 		goto err;
 	}
 
-	vdev = pdev->ops->dev_add(pdev, name, device_id);
+	vdev = pdev->ops->dev_add(pdev, name, device_id, info->attrs);
 	if (IS_ERR(vdev))
 		goto err;
 
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 1ffcef67954f..ce24a40f5b00 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -728,7 +728,8 @@ static const struct vdpa_config_ops vdpasim_net_batch_config_ops = {
 };
 
 static struct vdpa_device *
-vdpa_dev_add(struct vdpa_parent_dev *pdev, const char *name, u32 device_id)
+vdpa_dev_add(struct vdpa_parent_dev *pdev, const char *name,
+		u32 device_id, struct nlattr **attrs)
 {
 	struct vdpasim *simdev;
 
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index b264c627e94b..7b84badc6741 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -6,6 +6,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/vhost_iotlb.h>
+#include <net/genetlink.h>
 
 /**
  * vDPA callback definition.
@@ -354,6 +355,7 @@ static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
  *		@pdev: parent device to use for device addition
  *		@name: name of the new vdpa device
  *		@device_id: device id of the new vdpa device
+ *		@attrs: device specific attributes
  *		Driver need to add a new device using vdpa_register_device() after
  *		fully initializing the vdpa device. On successful addition driver
  *		must return a valid pointer of vdpa device or ERR_PTR for the error.
@@ -364,7 +366,7 @@ static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
  */
 struct vdpa_dev_ops {
 	struct vdpa_device* (*dev_add)(struct vdpa_parent_dev *pdev, const char *name,
-				       u32 device_id);
+				       u32 device_id, struct nlattr **attrs);
 	void (*dev_del)(struct vdpa_parent_dev *pdev, struct vdpa_device *dev);
 };
 
-- 
2.11.0

