Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D355EB841
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiI0DCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiI0DAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:00:47 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDAC6545;
        Mon, 26 Sep 2022 19:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664247534; x=1695783534;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2YQiwSWKHyCzhjsVYpVZs2o9N9e+lxz8vW92n7gfnJ4=;
  b=mMwv5SjwjsFc5FYzxGEamK8bU4mDVJd2gNIxAw6H7qv0RSIYkyit0JIN
   ibB05gM6VjT51N/j8wlXx7AhP4RmxTL2VoIj6cF4mdiRsMLRF0ojgp5ha
   L/+u2LKpG2MfiJPBycu8OUPe39+4tYxTYpy3Rroiu8NdsM2kOsjAcCj9a
   srjccsDvaO5O9+jKI03zJ/OEHC1CqqLE7NGUPH3tACrtNUHyhXaZEUWmY
   SAi+xzheRWLmWZbks79X0F2bwWNbcrP/P9/ubV9ToIzxTmCZBf9F9s84a
   2V8t9Mh1w+LJWu55X41BIHWp0CxNNTA6sJtTdFdSLQS5IIR1D/PTDBVWi
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="387490752"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="387490752"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 19:58:54 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="652105656"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="652105656"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 19:58:52 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 3/6] vDPA: check VIRTIO_NET_F_RSS for max_virtqueue_paris's presence
Date:   Tue, 27 Sep 2022 10:50:32 +0800
Message-Id: <20220927025035.4972-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220927025035.4972-1-lingshan.zhu@intel.com>
References: <20220927025035.4972-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio 1.2 spec says:
max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ or
VIRTIO_NET_F_RSS is set.

So when reporint MQ to userspace, it should check both
VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS.

unused parameter struct vdpa_device *vdev is removed

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index e7765953307f..829fd4cfc038 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -800,13 +800,13 @@ static int vdpa_nl_cmd_dev_get_dumpit(struct sk_buff *msg, struct netlink_callba
 	return msg->len;
 }
 
-static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
-				       struct sk_buff *msg, u64 features,
+static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
 				       const struct virtio_net_config *config)
 {
 	u16 val_u16;
 
-	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
+	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0 &&
+	    (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
 		return 0;
 
 	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
-- 
2.31.1

