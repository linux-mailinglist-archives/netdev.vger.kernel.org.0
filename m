Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7C1525E13
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 11:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378512AbiEMIs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 04:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378546AbiEMIsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 04:48:18 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F242913D149
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 01:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652431697; x=1683967697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kLUq46zVK743yTschuwvLfc05xi0p506NfSw+A8rRIQ=;
  b=bG4EqXHN7S2x+HAwQ1rtQCifoRKcRj3t/l+IKDsuRp1jUt4jn+Iyb9ru
   JEX1/NlffJ7vKIpjLqby0BrH6dHpGY/+2xA1DAED+fwCYHMmjt1wTB1/Z
   5/42pNStuuGE2IehXmhIhzJVCuN/cWCrLPTMoukl+2A/zyYHCxUKmxeji
   ajf2L76zxUl5a69/Qx7zLC93i4S/DVZFudUSLkMsjsuOBhTvkG/pSIua+
   +jjDHuCNgCqIdsDMK5Ssconw2Rk0+vV5Sr0dnKnUe+Jj8Zv1vtoJCaoYo
   qvnuEOxHZIXeVPlKiYZtQccMD954uttfgHgYho+n/H+zf0+V+Q9kK/Jng
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="356682865"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="356682865"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 01:48:14 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="595122677"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 01:48:13 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RFC 6/6] vDPA: fix 'cast to restricted le16' warnings in vdpa_dev_net_config_fill()
Date:   Fri, 13 May 2022 16:39:35 +0800
Message-Id: <20220513083935.1253031-7-lingshan.zhu@intel.com>
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

This commit fixes spars warnings: cast to restricted __le16
in function vdpa_dev_net_config_fill()

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/vdpa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 50a11ece603e..2719ce9962fc 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -837,11 +837,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
 		    config.mac))
 		return -EMSGSIZE;
 
-	val_u16 = le16_to_cpu(config.status);
+	val_u16 = le16_to_cpu((__force __le16)config.status);
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
 		return -EMSGSIZE;
 
-	val_u16 = le16_to_cpu(config.mtu);
+	val_u16 = le16_to_cpu((__force __le16)config.mtu);
 	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
 		return -EMSGSIZE;
 
-- 
2.31.1

