Return-Path: <netdev+bounces-3739-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7769D708798
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:12:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 565181C2114F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21BBF28C1E;
	Thu, 18 May 2023 18:06:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1367D28C1C;
	Thu, 18 May 2023 18:06:56 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F346F3;
	Thu, 18 May 2023 11:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684433215; x=1715969215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IFz+u9AmH8GLo5eeLDHIHY4bJ+Z3eR8A8KVZ2XTbC2I=;
  b=Bs5Mhc433uvChoWUaVaDGAn2lIvriF3YcvOovZCuTcID6fRiLKO3qziv
   +5Yo44zcQSfcdE8IfBSavYd0p3adVV193Bk+bS+kkD0hLp4gsFvIIH9nM
   MTsZ6ARdyV7/WlMlvwfSf/yLPrqv1uctG1wEqV9kS5V8xWx9byOMQ/HBO
   eBOLXH7v1BQAUmF5EWIS1zg3LmpDPGYiPhzrzOUmEqNGW9POlaIPbh2Xo
   bgAL/+2PVFhWwJ5wTlefg3GTZG74IiqgB4FNBfi7IlQKV1O9seucaYbFY
   viqk3fAnyvUbZTFSH326YGT/Ss8+g5D1qLvbUdK7BgI3gxgW39GObh9C/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="350984995"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="350984995"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 11:06:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="948780483"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="948780483"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2023 11:06:23 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	tirthendu.sarkar@intel.com,
	maciej.fijalkowski@intel.com,
	bjorn@kernel.org
Subject: [PATCH bpf-next 13/21] xsk: report ZC multi-buffer capability via xdp_features
Date: Thu, 18 May 2023 20:05:37 +0200
Message-Id: <20230518180545.159100-14-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Introduce new xdp_feature NETDEV_XDP_ACT_NDO_ZC_SG that will be used to
find out if user space that wants to do ZC multi-buffer will be able to
do so against underlying ZC driver.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 include/uapi/linux/netdev.h | 4 ++--
 net/xdp/xsk_buff_pool.c     | 6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 639524b59930..bfca07224f7b 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -33,8 +33,8 @@ enum netdev_xdp_act {
 	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
 	NETDEV_XDP_ACT_RX_SG = 32,
 	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
-
-	NETDEV_XDP_ACT_MASK = 127,
+	NETDEV_XDP_ACT_NDO_ZC_SG = 128,
+	NETDEV_XDP_ACT_MASK = 255,
 };
 
 enum {
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 0a9f8ea68de3..43cca5fa90cf 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -189,6 +189,12 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 		goto err_unreg_pool;
 	}
 
+	if (!(netdev->xdp_features & NETDEV_XDP_ACT_NDO_ZC_SG) &&
+	    flags & XDP_USE_SG) {
+		err = -EOPNOTSUPP;
+		goto err_unreg_pool;
+	}
+
 	bpf.command = XDP_SETUP_XSK_POOL;
 	bpf.xsk.pool = pool;
 	bpf.xsk.queue_id = queue_id;
-- 
2.34.1


