Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355475A9480
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 12:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbiIAKZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 06:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbiIAKY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 06:24:58 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C76BC0A;
        Thu,  1 Sep 2022 03:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662027897; x=1693563897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=naLk2YiNHCZm3464X+DKcA0rSEwd3MmdrZMnwC4yXq8=;
  b=L6PkeszHekLHuf9DuiKWN+3fWsBGjhYkXtzyz4JFFrGdJQlaML9egKmE
   4PevFyMQPzPrV+5X7qeqYhoaB7dXXrp/z7ZDmDI2Dwx/CKawxjcyNQmk0
   9mmJvt+R6pk9GfPSXYVGiXy1QR4rFQKtQGlIb8PHhl4+FdovasP3Zu0t4
   ZN/KM0tSk+DVl4bZcyKxCxKBa6+qHJ71j/wnygNmJVdch7aAWDhU2OS7Q
   hEDqdeeBHYq9DqinGPhNdj2HIA6m5k1aPs3/3KSO4EUcV/vlCh0LV1gRH
   v1KXih+i7NkukbuzHI3sl1JS3DEY/opkRtuNrlyD7Ma7TjZybTb3S+cWk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321825558"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="321825558"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 03:24:56 -0700
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="642276438"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 03:24:55 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RFC 2/4] vDPA: support ioctl VHOST_GET/SET_VRING_ENDIAN
Date:   Thu,  1 Sep 2022 18:15:59 +0800
Message-Id: <20220901101601.61420-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220901101601.61420-1-lingshan.zhu@intel.com>
References: <20220901101601.61420-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit add ioctl VHOST_GET_VRING_ENDIAN and
VHOST_SET_VRING_ENDIAN support for vhost_vdpa.

So that QEMU can be aware of the endian-ness of the vDPA device.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vhost/vdpa.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 166044642fd5..084fbf04c6bb 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -547,11 +547,41 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 
 		vq->last_avail_idx = vq_state.split.avail_index;
 		break;
-	}
+	case VHOST_SET_VRING_ENDIAN:
+		if (!ops->set_vq_endian)
+			return -EOPNOTSUPP;
+
+		if (copy_from_user(&s, argp, sizeof(s)))
+			return -EFAULT;
+
+		if (s.num != VHOST_VRING_LITTLE_ENDIAN &&
+		    s.num != VHOST_VRING_BIG_ENDIAN)
+			return -EINVAL;
+
+		if (ops->get_status(vdpa) & VIRTIO_CONFIG_S_DRIVER_OK)
+			return -EFAULT;
+
+		r = ops->set_vq_endian(vdpa, s.index, s.num);
+		if (r)
+			return -EFAULT;
+
+		return 0;
+	case VHOST_GET_VRING_ENDIAN:
+		if (!ops->get_vq_endian)
+			return -EOPNOTSUPP;
+
+		s.index = idx;
+		s.num = ops->get_vq_endian(vdpa, idx);
+
+		if (copy_to_user(argp, &s, sizeof(s)))
+			return -EFAULT;
+
+		return 0;
 
 	r = vhost_vring_ioctl(&v->vdev, cmd, argp);
 	if (r)
 		return r;
+	}
 
 	switch (cmd) {
 	case VHOST_SET_VRING_ADDR:
-- 
2.31.1

