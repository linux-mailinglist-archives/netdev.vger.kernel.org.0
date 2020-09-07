Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA56325F8F6
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgIGK6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:58:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:22272 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728997AbgIGK4c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:56:32 -0400
IronPort-SDR: Fi2BxiXIs5V4QkmCjam/RW2oPzFuFNIbW3Kimih4mQP4p+OPoHd8DdQkL6rmUCfDFrEgNC8YvJ
 Zoz0j+hK5p2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9736"; a="137503293"
X-IronPort-AV: E=Sophos;i="5.76,401,1592895600"; 
   d="scan'208";a="137503293"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2020 03:56:29 -0700
IronPort-SDR: JA86N/wbR8enXwdxb0GTA+atgPjvf+Wnmuy+kBFgiTQNXZb4VlfmWeWv/gmZDumON9bPwmKcPA
 FjXaRm6BnIcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,401,1592895600"; 
   d="scan'208";a="303698283"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga006.jf.intel.com with ESMTP; 07 Sep 2020 03:56:26 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 2/2] vhost_net: introduce vhost_net_set_backend_features()
Date:   Mon,  7 Sep 2020 18:52:20 +0800
Message-Id: <20200907105220.27776-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200907105220.27776-1-lingshan.zhu@intel.com>
References: <20200907105220.27776-1-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduced a new function
vhost_net_set_backend_features() which is a wrap of
vhost_set_backend_features() with necessary mutex lockings.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vhost/net.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 531a00d703cd..e01da77538c8 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1679,6 +1679,13 @@ static long vhost_net_set_owner(struct vhost_net *n)
 	return r;
 }
 
+static void vhost_net_set_backend_features(struct vhost_dev *dev, u64 features)
+{
+	mutex_lock(&dev->mutex);
+	vhost_set_backend_features(dev, features);
+	mutex_unlock(&dev->mutex);
+}
+
 static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 			    unsigned long arg)
 {
@@ -1715,7 +1722,7 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 		if (features & ~VHOST_NET_BACKEND_FEATURES)
 			return -EOPNOTSUPP;
-		vhost_set_backend_features(&n->dev, features);
+		vhost_net_set_backend_features(&n->dev, features);
 		return 0;
 	case VHOST_RESET_OWNER:
 		return vhost_net_reset_owner(n);
-- 
2.18.4

