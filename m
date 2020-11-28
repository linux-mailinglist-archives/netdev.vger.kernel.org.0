Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304542C7359
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389726AbgK1VuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387814AbgK1VkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 16:40:02 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17028C0613D1;
        Sat, 28 Nov 2020 13:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=cLViv87Sd5/WI1F3sh0RUkFslM622GS1dHyu4cz2mHc=; b=RmXEmFKUkit0IQMFSSYtrynDQV
        x0Kb0z1oiAxxbC7tWYH0UmZyPJlUUPrmg1ciyyWuHgVnxtDIe8hQuX1ArHBGOT1DQvgraRCLbZulU
        ZNVmxJLVEyFCsFUB/l4aQF4HPHBcBZyACeMi0PsDo01RPMH7FVwofJtGZzWhlzTUMGutYz6YxV7ko
        a6YUYBkcFBBv1IF2b2r+0b4rSYLCCwfWXHknuGSrliO9b2ZPJzpVw7AU9vbLe97TGaJBtwQl67X/Y
        W/CoZbOyJwDDvoxyruHZkNrZP765HhUgQ3rBCcrYdhAfsIxttZgr1czN+GkD3KPmKqu7ggsqe75yx
        rTmydCAQ==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kj7vz-0002PT-6P; Sat, 28 Nov 2020 21:39:11 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Eli Cohen <eli@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
Subject: [PATCH v4] vdpa: mlx5: fix vdpa/vhost dependencies
Date:   Sat, 28 Nov 2020 13:39:05 -0800
Message-Id: <20201128213905.27409-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/vdpa/mlx5/ uses vhost_iotlb*() interfaces, so select
VHOST_IOTLB to make them be built.

However, if VHOST_IOTLB is the only VHOST symbol that is
set/enabled, the object file still won't be built because
drivers/Makefile won't descend into drivers/vhost/ to build it,
so make drivers/Makefile build the needed binary whenever
VHOST_IOTLB is set, like it does for VHOST_RING.

Fixes these build errors:
ERROR: modpost: "vhost_iotlb_itree_next" [drivers/vdpa/mlx5/mlx5_vdpa.ko] undefined!
ERROR: modpost: "vhost_iotlb_itree_first" [drivers/vdpa/mlx5/mlx5_vdpa.ko] undefined!

Fixes: 29064bfdabd5 ("vdpa/mlx5: Add support library for mlx5 VDPA implementation")
Fixes: aff90770e54c ("vdpa/mlx5: Fix dependency on MLX5_CORE")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Eli Cohen <eli@mellanox.com>
Cc: Parav Pandit <parav@mellanox.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: netdev@vger.kernel.org
---
v2: change from select to depends on VHOST (Saeed)
v3: change to depends on VHOST_IOTLB (Jason)
v4: use select VHOST_IOTLB (Michael); also add to drivers/Makefile

 drivers/Makefile     |    1 +
 drivers/vdpa/Kconfig |    1 +
 2 files changed, 2 insertions(+)

--- linux-next-20201127.orig/drivers/vdpa/Kconfig
+++ linux-next-20201127/drivers/vdpa/Kconfig
@@ -32,6 +32,7 @@ config IFCVF
 
 config MLX5_VDPA
 	bool
+	select VHOST_IOTLB
 	help
 	  Support library for Mellanox VDPA drivers. Provides code that is
 	  common for all types of VDPA drivers. The following drivers are planned:
--- linux-next-20201127.orig/drivers/Makefile
+++ linux-next-20201127/drivers/Makefile
@@ -143,6 +143,7 @@ obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
 obj-$(CONFIG_BCMA)		+= bcma/
 obj-$(CONFIG_VHOST_RING)	+= vhost/
+obj-$(CONFIG_VHOST_IOTLB)	+= vhost/
 obj-$(CONFIG_VHOST)		+= vhost/
 obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_GREYBUS)		+= greybus/
