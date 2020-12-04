Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAD72CED57
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388120AbgLDLnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:43:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:38666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730032AbgLDLnb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 06:43:31 -0500
Date:   Fri, 4 Dec 2020 12:44:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607082170;
        bh=CQGde8dYRlqueEwvc7knY4CB9w4yHC8OY/IAzf3YxK8=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=tSQHZ4Oy383lMi/uHhG6/0wGOQXxLiB3LUfuHensu29AD+wOBN1igyRMiqJHGya9c
         XU6K5R+KCB8TR74Yiiw5rFfDPj7Nlbyzp9X7DxcgmK143cGPnHF9aLcndZrdw9YC7k
         mgVm7a/Z68vtSqNa1f6Z3BNBK1pegmV/pM40/CoE=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     broonie@kernel.org, lgirdwood@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jgg@nvidia.com,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] driver core: auxiliary bus: make remove function return
 void
Message-ID: <X8ohB1ks1NK7kPop@kroah.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <X8og8xi3WkoYXet9@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8og8xi3WkoYXet9@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

There's an effort to move the remove() callback in the driver core to
not return an int, as nothing can be done if this function fails.  To
make that effort easier, make the aux bus remove function void to start
with so that no users have to be changed sometime in the future.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/driver-api/auxiliary_bus.rst | 2 +-
 drivers/base/auxiliary.c                   | 5 ++---
 include/linux/auxiliary_bus.h              | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/driver-api/auxiliary_bus.rst b/Documentation/driver-api/auxiliary_bus.rst
index 5dd7804631ef..2312506b0674 100644
--- a/Documentation/driver-api/auxiliary_bus.rst
+++ b/Documentation/driver-api/auxiliary_bus.rst
@@ -150,7 +150,7 @@ and shutdown notifications using the standard conventions.
 	struct auxiliary_driver {
 		int (*probe)(struct auxiliary_device *,
                              const struct auxiliary_device_id *id);
-		int (*remove)(struct auxiliary_device *);
+		void (*remove)(struct auxiliary_device *);
 		void (*shutdown)(struct auxiliary_device *);
 		int (*suspend)(struct auxiliary_device *, pm_message_t);
 		int (*resume)(struct auxiliary_device *);
diff --git a/drivers/base/auxiliary.c b/drivers/base/auxiliary.c
index eca36d6284d0..c44e85802b43 100644
--- a/drivers/base/auxiliary.c
+++ b/drivers/base/auxiliary.c
@@ -82,13 +82,12 @@ static int auxiliary_bus_remove(struct device *dev)
 {
 	struct auxiliary_driver *auxdrv = to_auxiliary_drv(dev->driver);
 	struct auxiliary_device *auxdev = to_auxiliary_dev(dev);
-	int ret = 0;
 
 	if (auxdrv->remove)
-		ret = auxdrv->remove(auxdev);
+		auxdrv->remove(auxdev);
 	dev_pm_domain_detach(dev, true);
 
-	return ret;
+	return 0;
 }
 
 static void auxiliary_bus_shutdown(struct device *dev)
diff --git a/include/linux/auxiliary_bus.h b/include/linux/auxiliary_bus.h
index 3580743d0e8d..d67b17606210 100644
--- a/include/linux/auxiliary_bus.h
+++ b/include/linux/auxiliary_bus.h
@@ -19,7 +19,7 @@ struct auxiliary_device {
 
 struct auxiliary_driver {
 	int (*probe)(struct auxiliary_device *auxdev, const struct auxiliary_device_id *id);
-	int (*remove)(struct auxiliary_device *auxdev);
+	void (*remove)(struct auxiliary_device *auxdev);
 	void (*shutdown)(struct auxiliary_device *auxdev);
 	int (*suspend)(struct auxiliary_device *auxdev, pm_message_t state);
 	int (*resume)(struct auxiliary_device *auxdev);
-- 
2.29.2

