Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68ED5EEB48
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbiI2By3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbiI2ByV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:54:21 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051937B2B5;
        Wed, 28 Sep 2022 18:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664416458; x=1695952458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b33SD8HDAWV7qaNky28KuKEyYahR5SVNndzd9VjTGYc=;
  b=DU8YAesLu4OeV1Srl76fbu6nBofzZ3U0Ixy50nYFJgRbJovurCWk89Cu
   bYkwCxpWZy3p9c1A8hnYrXUcM4QWhvEkPcMhWvigNt4NJzIWQ7qN2pfOA
   DxqdPcIzPJPXqCiAPhGnNYsdmM4zSSA4F4VYeOFmWyOSdVFXcnwapbNGX
   GPWgr+Cf5BGgU9Clwr0f2TsRz/1FVKBpKzkQoKd5yySEm7LSBeNUmWQ5Q
   Fp5jmfe+P4/6Y/78Wo30pyjn218x66cu5iaSfIvzHlmhy2+qsUWZF9f+V
   o6wCUlwZGI/9QaKKLtj6X+gJ1d4hG1Y7+2kSP0n253iFS/OreqaNPofhn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="365813994"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="365813994"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 18:54:17 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="950931690"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="950931690"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 18:54:17 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 3/6] vDPA: check VIRTIO_NET_F_RSS for max_virtqueue_paris's presence
Date:   Thu, 29 Sep 2022 09:45:52 +0800
Message-Id: <20220929014555.112323-4-lingshan.zhu@intel.com>
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

virtio 1.2 spec says:
max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ or
VIRTIO_NET_F_RSS is set.

So when reporint MQ to userspace, it should check both
VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS.

unused parameter struct vdpa_device *vdev is removed

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 52b7f5d23127..70448deb9cd9 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -799,13 +799,13 @@ static int vdpa_nl_cmd_dev_get_dumpit(struct sk_buff *msg, struct netlink_callba
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

