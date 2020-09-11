Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5494A265693
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 03:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgIKBXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 21:23:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:44532 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbgIKBXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 21:23:46 -0400
IronPort-SDR: HwEKFlv/WPHS8JIwffrsa+C4kluuL0A+nKTweE5eOgN2JG/YJWpRcE2ZI9Sc3ACY2e2MjJhjob
 IEKs/qLSvD5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="158704644"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="158704644"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:46 -0700
IronPort-SDR: YUVGJTUZ/x3pYTEWefygicmfRLnWpRLhfpfMOftyOO5/l9ihdm6JE/SQBPqxyRMWvCFn6SEnaU
 Fyv/kQWbMFaQ==
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="449808154"
Received: from jbrandeb-desk.jf.intel.com ([10.166.244.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:45 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [RFC PATCH net-next v1 08/11] drivers/net/ethernet: handle one warning explicitly
Date:   Thu, 10 Sep 2020 18:23:34 -0700
Message-Id: <20200911012337.14015-9-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200911012337.14015-1-jesse.brandeburg@intel.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While fixing the W=1 builds, this warning came up because the
developers used a very tricky way to get structures initialized
to a non-zero value, but this causes GCC to warn about an
override. In this case the override was intentional, so just
disable the warning for this code with a #pragma.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/renesas/sh_eth.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 586642c33d2b..659530f9c117 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -45,6 +45,13 @@
 #define SH_ETH_OFFSET_DEFAULTS			\
 	[0 ... SH_ETH_MAX_REGISTER_OFFSET - 1] = SH_ETH_OFFSET_INVALID
 
+/* use some intentionally tricky logic here to initialize the whole struct to
+ * 0xffff, but then override certain fields, requiring us to indicate that we
+ * "know" that there are overrides in this structure, and we'll need to disable
+ * that warning from W=1 builds
+ */
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Woverride-init"
 static const u16 sh_eth_offset_gigabit[SH_ETH_MAX_REGISTER_OFFSET] = {
 	SH_ETH_OFFSET_DEFAULTS,
 
@@ -332,6 +339,7 @@ static const u16 sh_eth_offset_fast_sh3_sh2[SH_ETH_MAX_REGISTER_OFFSET] = {
 
 	[TSU_ADRH0]	= 0x0100,
 };
+#pragma GCC diagnostic pop
 
 static void sh_eth_rcv_snd_disable(struct net_device *ndev);
 static struct net_device_stats *sh_eth_get_stats(struct net_device *ndev);
-- 
2.27.0

