Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D0C53B1BD
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 04:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbiFBCsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 22:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbiFBCs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 22:48:27 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709ED1E734D
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 19:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654138106; x=1685674106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JHOt+B+/ynJYw1lbcMJasr1MkUyzKCtam36/u54HyEY=;
  b=n4MFcujUdWlIRGGzMum7J52cg31yK8IWWoXYxPFnbZFSGwooORfh8unu
   K+pg8nwxuzuzaAw9HiEYjury1ghfB9p+Y9/4Apf6ijUVaQDjx0QRlCwuv
   RwLdjyyPZ17bRadtte15BmT+9shfQvDt+di2Y7W7okoXEUmej95DuegUs
   M7yvkNYP/DrTJX+tcbxNSY9MLQ0icMpK4T1i+XD0Qhg7zdr0QFXiX99MC
   80Utgj0WdNolNpNjGW9GtsxxIwbFvTNM42TjrGltfLh7D/jPiUhs0QDgA
   W77ZkYnoBWRqHwA5bJX4T7exsKlrZnh/jvyisjjsadkcGPob4x0+pQr5C
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="275874630"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="275874630"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 19:48:26 -0700
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="612608893"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 19:48:24 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 5/6] vDPA: answer num of queue pairs = 1 to userspace when VIRTIO_NET_F_MQ == 0
Date:   Thu,  2 Jun 2022 10:38:44 +0800
Message-Id: <20220602023845.2596397-6-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220602023845.2596397-1-lingshan.zhu@intel.com>
References: <20220602023845.2596397-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

