Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4023D3AB394
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 14:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbhFQMbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 08:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhFQMbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 08:31:33 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3DEC061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 05:29:25 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id n20so3748472edv.8
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 05:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CD/f1NuuPJqwwoOxLQwFRHkaQmEa5HY+bEtI0xO5DwQ=;
        b=CbWfkSRyuyLofbkCg5CgirKz7oz5cMMB7+5ybhRpRQox2YlJFmDDmBYsCvEvypXmhq
         L0oDKuqLfG6Vk2rtIL40zz/zPFHOwNJ4FWabQUdWw4Rtpk5xqDRZtPrJTVty+IHX7Vnz
         aMCBSZeor2Hw0glpA6EHDCccQ6zgY6syazhRjsaIw2Dlrep3KhlDmDD5fdpq7ssFFwTE
         xlivH9W16rr2A7L72ogspUTiw1bYa+bw/g7Ka7nM16l0XYo/g0n2qN0bAFFBQrNJNDya
         2lhVbVEPvj2XBlKrp07ycrmLe6Wo6ZbdBAUJm1zisgX+Kp8qQzkr+NLsXK2B76CDo7z1
         rrjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CD/f1NuuPJqwwoOxLQwFRHkaQmEa5HY+bEtI0xO5DwQ=;
        b=FPq7qb/dy0AT4F5TsdT2xCek2QtdmUNkAuaPctSxBvIIV+vBclDRknJZHjMOiu6sLd
         Lh4qvZQPB5/Dq97OdjHV18iRNewlqN0jBvH8IXs2GL+bkp3JngSHrwxR2X529cgKhYYC
         kYK4BmuZaCpJAID+4Whyawjpo1HwHNodZ2D2EfY7hvUOKyyIAH5VjpPQkWSLt2B9IPKt
         8y+Na0DzPLK9EX+qhiJjFLqjRz/QPgvRBgdagPY8bNW5BiuO6G64A7HpDIH+0mI0DlNu
         LYVtxMayOg5yQ5XQ5tfDJvJ1MVh0D1wZVl4CNkCQsTDCN71vNNkJPrbmDPIMKhuiraKG
         Cf5Q==
X-Gm-Message-State: AOAM531qAr8BYzerD3G0ZVWwc+KrsTCYbVvnDBxV45l7lQHfgMu6Q+TA
        dNqq1Lf5OUzjSvtKmJ7Ffgg=
X-Google-Smtp-Source: ABdhPJxKA7yLfB4EYVkHh0RkoW9gX7iJMRe3r6YxDRtU3NNsBGG4VnqQc1D9uhunNTtmIPNHn0JlLw==
X-Received: by 2002:a05:6402:524b:: with SMTP id t11mr6225713edd.327.1623932963998;
        Thu, 17 Jun 2021 05:29:23 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id de10sm3706179ejc.65.2021.06.17.05.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 05:29:23 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        grant.likely@arm.com, calvin.johnson@oss.nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 2/3] driver core: add a helper to setup both the of_node and fwnode of a device
Date:   Thu, 17 Jun 2021 15:29:04 +0300
Message-Id: <20210617122905.1735330-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210617122905.1735330-1-ciorneiioana@gmail.com>
References: <20210617122905.1735330-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

There are many places where both the fwnode_handle and the of_node of a
device need to be populated. Add a function which does both so that we
have consistency.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - new patch

 drivers/base/core.c    | 7 +++++++
 include/linux/device.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 628e33939aca..b6836bfa985c 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4723,6 +4723,13 @@ void device_set_of_node_from_dev(struct device *dev, const struct device *dev2)
 }
 EXPORT_SYMBOL_GPL(device_set_of_node_from_dev);
 
+void device_set_node(struct device *dev, struct fwnode_handle *fwnode)
+{
+	dev->fwnode = fwnode;
+	dev->of_node = to_of_node(fwnode);
+}
+EXPORT_SYMBOL_GPL(device_set_node);
+
 int device_match_name(struct device *dev, const void *name)
 {
 	return sysfs_streq(dev_name(dev), name);
diff --git a/include/linux/device.h b/include/linux/device.h
index 38a2071cf776..a1e7cab2c7bf 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -819,6 +819,7 @@ int device_online(struct device *dev);
 void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode);
 void set_secondary_fwnode(struct device *dev, struct fwnode_handle *fwnode);
 void device_set_of_node_from_dev(struct device *dev, const struct device *dev2);
+void device_set_node(struct device *dev, struct fwnode_handle *fwnode);
 
 static inline int dev_num_vf(struct device *dev)
 {
-- 
2.31.1

