Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B210425F8F3
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgIGK4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:56:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:22272 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728956AbgIGK4Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:56:25 -0400
IronPort-SDR: ecpX33UHRVEzHaSabuW1+xN9eA5VcsJuIEQubFYY10aBjyd2GDfDk0F0ltNbWMwV9McTxz7U77
 q8Z/R8m9LYrg==
X-IronPort-AV: E=McAfee;i="6000,8403,9736"; a="137503292"
X-IronPort-AV: E=Sophos;i="5.76,401,1592895600"; 
   d="scan'208";a="137503292"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2020 03:56:25 -0700
IronPort-SDR: RlfK2hmzUDMq+BUJoWCcda1pTnQZOYWGwj+y9pd31yA7kQp25F1DXYKFPrfHNlh8MGAP7Pp6kO
 2zdmw6sVhMAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,401,1592895600"; 
   d="scan'208";a="303698276"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga006.jf.intel.com with ESMTP; 07 Sep 2020 03:56:22 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 1/2] vhost: remove mutex ops in vhost_set_backend_features
Date:   Mon,  7 Sep 2020 18:52:19 +0800
Message-Id: <20200907105220.27776-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200907105220.27776-1-lingshan.zhu@intel.com>
References: <20200907105220.27776-1-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vhost_vdpa ioctl SET_BACKEND_FEATURES path, currect code
would try to acquire vhost dev mutex twice
(first shown in vhost_vdpa_unlocked_ioctl), which can lead
to a dead lock issue.
This commit removed mutex operations in vhost_set_backend_features.
As a compensation for vhost_net, a followinig commit will add
needed mutex lock/unlock operations in a new function
vhost_net_set_backend_features() which is a wrap of
vhost_set_backend_features().

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vhost/vhost.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b45519ca66a7..e03c9e6f058f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2591,14 +2591,12 @@ void vhost_set_backend_features(struct vhost_dev *dev, u64 features)
 	struct vhost_virtqueue *vq;
 	int i;
 
-	mutex_lock(&dev->mutex);
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
 		mutex_lock(&vq->mutex);
 		vq->acked_backend_features = features;
 		mutex_unlock(&vq->mutex);
 	}
-	mutex_unlock(&dev->mutex);
 }
 EXPORT_SYMBOL_GPL(vhost_set_backend_features);
 
-- 
2.18.4

