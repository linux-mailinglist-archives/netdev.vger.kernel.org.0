Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D91DF9D785
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 22:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbfHZUle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 16:41:34 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37879 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727658AbfHZUle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 16:41:34 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Aug 2019 23:41:32 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7QKfPDQ021168;
        Mon, 26 Aug 2019 23:41:30 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, cohuck@redhat.com, davem@davemloft.net
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>
Subject: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Date:   Mon, 26 Aug 2019 15:41:17 -0500
Message-Id: <20190826204119.54386-3-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190826204119.54386-1-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mdev alias should be unique among all the mdevs, so that when such alias
is used by the mdev users to derive other objects, there is no
collision in a given system.

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/vfio/mdev/mdev_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index e825ff38b037..6eb37f0c6369 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -375,6 +375,11 @@ int mdev_device_create(struct kobject *kobj, struct device *dev,
 			ret = -EEXIST;
 			goto mdev_fail;
 		}
+		if (tmp->alias && strcmp(tmp->alias, alias) == 0) {
+			mutex_unlock(&mdev_list_lock);
+			ret = -EEXIST;
+			goto mdev_fail;
+		}
 	}
 
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
-- 
2.19.2

