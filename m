Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832D65A9489
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 12:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbiIAKZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 06:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234119AbiIAKZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 06:25:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC64CF582;
        Thu,  1 Sep 2022 03:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662027900; x=1693563900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z5PGIJ24d2/V8jR3uKC69UP3AbGrpcu/ETrBJkm8rrQ=;
  b=UBsawSrK26fpjiAP0v2ToxrAYYK/Orhpbb0jaeKjBIIwRmMuSHvXnMpI
   +neiY4i3cEnQLTP7dXPwrCSvNlh1e4AGrNuQ1xlPyEyKRMn8XexddzcPH
   dKS2tOJxS4sBnnV1rcfb8fJUaixywhN4KTMFWF6HpCHJb0S2DYI1o/Kox
   4IvL0kxu28iBrj/84EUESyr32zRo83jLDVbYXNWz0eE3I/favNdEmUc0k
   tlvnSqSlJWTibwKOhzPr0XBPIGYMe8/V0Vj5HfIi/dihud3ubYYKTmdMp
   l/oUaGDSrHh2N5pM6g/M2oCgvgi5hpLqsa2C44MvXm+8NPVxqbZGbiAjR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321825567"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="321825567"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 03:25:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="642276453"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 03:24:58 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RFC 4/4] vDPA: report device endian-ness to userspace through netlink
Date:   Thu,  1 Sep 2022 18:16:01 +0800
Message-Id: <20220901101601.61420-5-lingshan.zhu@intel.com>
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

This commit introduces a new netlink attr VDPA_ATTR_DEV_ENDIAN
to report device endian-ness to usersapce.

So the userspace tools can be aware of the endian-ness of
the device, even uninitialized legacy/transitional devices.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c       | 3 +++
 include/uapi/linux/vdpa.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 8a08caf573d1..d361f951ff63 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -848,6 +848,9 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 			      VDPA_ATTR_PAD))
 		return -EMSGSIZE;
 
+	if (nla_put_u8(msg, VDPA_ATTR_DEV_ENDIAN, le))
+		return -EMSGSIZE;
+
 	return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
 }
 
diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
index 25c55cab3d7c..bb9797781f97 100644
--- a/include/uapi/linux/vdpa.h
+++ b/include/uapi/linux/vdpa.h
@@ -51,6 +51,7 @@ enum vdpa_attr {
 	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
 	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
 	VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
+	VDPA_ATTR_DEV_ENDIAN,			/* u8 */
 
 	/* new attributes must be added above here */
 	VDPA_ATTR_MAX,
-- 
2.31.1

