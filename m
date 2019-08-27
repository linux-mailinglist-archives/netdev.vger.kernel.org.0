Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75D99F31D
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 21:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbfH0TRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 15:17:36 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38881 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730963AbfH0TRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 15:17:08 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 Aug 2019 22:17:03 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7RJGuGs026842;
        Tue, 27 Aug 2019 22:17:01 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, cohuck@redhat.com, davem@davemloft.net
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>
Subject: [PATCH v1 2/5] mdev: Make mdev alias unique among all mdevs
Date:   Tue, 27 Aug 2019 14:16:51 -0500
Message-Id: <20190827191654.41161-3-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190827191654.41161-1-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190827191654.41161-1-parav@mellanox.com>
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
v0->v1:
 - Fixed inclusiong of alias for NULL check
 - Added ratelimited debug print for sha1 hash collision error
---
 drivers/vfio/mdev/mdev_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 62d29f57fe0c..4b9899e40665 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -375,6 +375,13 @@ int mdev_device_create(struct kobject *kobj, struct device *dev,
 			ret = -EEXIST;
 			goto mdev_fail;
 		}
+		if (tmp->alias && alias && strcmp(tmp->alias, alias) == 0) {
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

