Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EAEA183A
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 13:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbfH2LUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 07:20:02 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43758 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728170AbfH2LTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 07:19:19 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 29 Aug 2019 14:19:15 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7TBJ8v3020002;
        Thu, 29 Aug 2019 14:19:13 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, cohuck@redhat.com, davem@davemloft.net
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>
Subject: [PATCH v2 2/6] mdev: Make mdev alias unique among all mdevs
Date:   Thu, 29 Aug 2019 06:19:00 -0500
Message-Id: <20190829111904.16042-3-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190829111904.16042-1-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190829111904.16042-1-parav@mellanox.com>
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
Changelog:
v1->v2:
 - Moved alias NULL check at beginning
v0->v1:
 - Fixed inclusiong of alias for NULL check
 - Added ratelimited debug print for sha1 hash collision error
---
 drivers/vfio/mdev/mdev_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 3bdff0469607..c9bf2ac362b9 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -388,6 +388,13 @@ int mdev_device_create(struct kobject *kobj, struct device *dev,
 			ret = -EEXIST;
 			goto mdev_fail;
 		}
+		if (alias && tmp->alias && strcmp(alias, tmp->alias) == 0) {
+			mutex_unlock(&mdev_list_lock);
+			ret = -EEXIST;
+			dev_dbg_ratelimited(dev, "Hash collision in alias creation for UUID %pUl\n",
+					    uuid);
+			goto mdev_fail;
+		}
 	}
 
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
-- 
2.19.2

