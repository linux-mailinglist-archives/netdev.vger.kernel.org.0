Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F56F5EB83F
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiI0DC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiI0DA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:00:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9237D65B3;
        Mon, 26 Sep 2022 19:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664247538; x=1695783538;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MHeKxmQI7dzVqsMFENR/yfS8078fH4WgIzsF3Ed1w8E=;
  b=iZgPI08RylYt0WGX1wyH7Q9Xt8ClPBtWAYnI6BsszDF4Qq60Rz0skxCk
   RE19aE5xKXi3HwZyt3LQnerD5DGp1qZf4jgZDkYFcFUWxK0u7a2s2kxDp
   /x4+K9fJ/PM8SJiedAUP3HgqwZNRpsCbc948KdDp3aBtMQdkyFr1THcFL
   4WjYhnWADhvaa1Ug1U34cruez4Pmzt7iFKoVvEe/5AWWACh2OHVf2QBce
   fXPgec+6+AuQfc67UxilMXC8CtWDwEoc98/3EvPuK0FW1vADvXp5bJrry
   Ykotc4rKm1w+/DrPrUhMzAcBXN9t9Q/ebohjLfU3rj3GF75WY6AFOBt1Z
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="387490762"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="387490762"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 19:58:58 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="652105671"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="652105671"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 19:58:56 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 5/6] vDPA: fix spars cast warning in vdpa_dev_net_mq_config_fill
Date:   Tue, 27 Sep 2022 10:50:34 +0800
Message-Id: <20220927025035.4972-6-lingshan.zhu@intel.com>
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

This commit fixes spars warnings: cast to restricted __le16
in function vdpa_dev_net_mq_config_fill()

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 84a0c3877d7c..fa7f65279f79 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -809,7 +809,8 @@ static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
 	    (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
 		return 0;
 
-	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
+	val_u16 = __virtio16_to_cpu(true, config->max_virtqueue_pairs);
+
 	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
 }
 
-- 
2.31.1

