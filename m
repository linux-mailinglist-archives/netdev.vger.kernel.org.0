Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9C95EEB4C
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbiI2Byo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiI2Bya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:54:30 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119EB120BD6;
        Wed, 28 Sep 2022 18:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664416462; x=1695952462;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7nbGYvfVKm8H9yHeHgCQyHCtntkkvKbVAT9Sh7K1VU=;
  b=L6eB+2gCj6pIK/mW/0h9oitb1kSC+TRXRDDe9TyY9/5Qr4MkpBcS8li9
   QOwJ/Fvhf7vYXDE1by59seWoK1r8XJiGYp2lhm0JeLEPDZBhjweNEvkRi
   fvcux0DjFq8D+n6vA0Ypas1hccCunybZm7WPmtuR4aG5t5mYqqR7c2YIe
   s+L594o0CGOWp9RArCWhWpyjOrWLsD4NURLcM29e7diD8dH5AfEm2zoBt
   0590Jom32aWgRCsU2nCEBm1uAaG8U8bEfOkXhYaMK9BW9DoU5Ptb1nekx
   ZkKWU30LqQUHkasI3ocJ7FXb9xT0Cbvww72dEp9NvoO8VXb9me29XZuIN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="365814000"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="365814000"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 18:54:21 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="950931704"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="950931704"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 18:54:21 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 5/6] vDPA: fix spars cast warning in vdpa_dev_net_mq_config_fill
Date:   Thu, 29 Sep 2022 09:45:54 +0800
Message-Id: <20220929014555.112323-6-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220929014555.112323-1-lingshan.zhu@intel.com>
References: <20220929014555.112323-1-lingshan.zhu@intel.com>
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

This commit fixes spars warnings: cast to restricted __le16
in function vdpa_dev_net_mq_config_fill()

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 4b13bb7f355d..f10403c86af7 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -808,7 +808,8 @@ static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
 	    (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
 		return 0;
 
-	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
+	val_u16 = __virtio16_to_cpu(true, config->max_virtqueue_pairs);
+
 	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
 }
 
-- 
2.31.1

