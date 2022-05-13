Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7058A525E25
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 11:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378529AbiEMIs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 04:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378547AbiEMIsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 04:48:18 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9139013CA31
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 01:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652431697; x=1683967697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JHOt+B+/ynJYw1lbcMJasr1MkUyzKCtam36/u54HyEY=;
  b=P4Dj5FKTSeJVN1x1dI3PC9SwHlmCky34oYRI82tcn+VKi45PR4uMNfUi
   +qibugwwroQ1WUwuA4eoKk/sqrXGAPjfTFm2qUNd0UxmVak7Y6nTyXA2P
   EvWSsSLaNnu9fXPoOMjvzSdQMWZMlqHt5SQwxceWNjcl7hvuR3+RQwvyj
   t3b1mnl5B8VzTGJXP6cPwZg0S0xJwhiYvRZRzK8pjfZJFHM+k8yU92fYB
   CkRE5fXIqXSUj6w/Q5C2oDpmif4ly7hLVDwYhN+9i+vlpqBsY6EZPDF2c
   hcxXX92Ru55q1amy9Avxpcj91/7oz/SFao8trayHHaAL205OSxdIwoI8W
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="356682861"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="356682861"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 01:48:13 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="595122657"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 01:48:11 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RFC 5/6] vDPA: answer num of queue pairs = 1 to userspace when VIRTIO_NET_F_MQ == 0
Date:   Fri, 13 May 2022 16:39:34 +0800
Message-Id: <20220513083935.1253031-6-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220513083935.1253031-1-lingshan.zhu@intel.com>
References: <20220513083935.1253031-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue pair,
so when userspace querying queue pair numbers, it should return mq=1
than zero

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 030d96bdeed2..50a11ece603e 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -818,9 +818,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
 	u16 val_u16;
 
 	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
-		return 0;
+		val_u16 = 1;
+	else
+		val_u16 = le16_to_cpu((__force __le16)config->max_virtqueue_pairs);
 
-	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
 	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
 }
 
-- 
2.31.1

