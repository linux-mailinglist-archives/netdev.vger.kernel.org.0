Return-Path: <netdev+bounces-3005-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79CF2704FCE
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:50:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 361BF28164E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3375928C06;
	Tue, 16 May 2023 13:50:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CF734CD9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:50:28 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13ED4D2
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 06:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684245025; x=1715781025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vQcJU3lSJAF6PsC5BotX8CiRprRz0zuovMimtLk2P4k=;
  b=j7f/DU8wG96saoCKkjwE76ZxTJuOwOz1VhSbNxx5oXxHwkdNFNy1qLMD
   A3I+JZO9GLG1W0TZqOt7dlh5I2I4mRsMfrrOxThV5JemaPZH0INDpSJ1S
   RjN9Ad4MVmbMtE/U2LGVxZFZL2FlTEF0zMmNXEGIfFAEsyLivG/G/FUSa
   2K3rJ7KIz2jijydMK1AeXvek9cfHCt/ABPOyQxXOUv+yZORsS5+PqS0yH
   Gs7XGl2VrFS55xkVSWB6Y+TSCIKbmIn7+qryYXhmCBngXdvgxPbw/ELzX
   bPcLMcAVNCVsx6N5ZMEAB/G7S/PXdc+1SKSy4UDgk/yDV02DEtfCucHK6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="350319896"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="350319896"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 06:50:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="651846494"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="651846494"
Received: from amlin-018-068.igk.intel.com ([10.102.18.68])
  by orsmga003.jf.intel.com with ESMTP; 16 May 2023 06:50:24 -0700
From: Mateusz Palczewski <mateusz.palczewski@intel.com>
To: j.vosburgh@gmail.com,
	andy@greyhouse.net,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	dbanerje@akamai.com,
	netdev@vger.kernel.org
Cc: Sebastian Basierski <sebastianx.basierski@intel.com>,
	Mateusz Palczewski <mateusz.palczewski@intel.com>
Subject: [PATCH iwl-net  v1 2/2] drivers/net/bonding: Added some delay while checking for VFs link
Date: Tue, 16 May 2023 09:44:47 -0400
Message-Id: <20230516134447.193511-3-mateusz.palczewski@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230516134447.193511-1-mateusz.palczewski@intel.com>
References: <20230516134447.193511-1-mateusz.palczewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Sebastian Basierski <sebastianx.basierski@intel.com>

Right now bonding driver checks if link is ready once.
VF interface takes a little more time to get ready than PF,
so driver needs to wait for it to be ready.
1000ms delay was set, if VF link will not be set within given amount
of time, for sure problems should be investigated elsewhere.

Fixes: b3c898e20b18 ("Revert "bonding: allow carrier and link status to determine link state"")
Signed-off-by: Sebastian Basierski <sebastianx.basierski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
---
 drivers/net/bonding/bond_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 710548dbd0c1..6d49fb25969e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -736,6 +736,8 @@ const char *bond_slave_link_status(s8 link)
  * It'd be nice if there was a good way to tell if a driver supports
  * netif_carrier, but there really isn't.
  */
+#define BOND_CARRIER_CHECK_TIMEOUT 1000
+
 static int bond_check_dev_link(struct bonding *bond,
 			       struct net_device *slave_dev, int reporting)
 {
@@ -743,12 +745,22 @@ static int bond_check_dev_link(struct bonding *bond,
 	int (*ioctl)(struct net_device *, struct ifreq *, int);
 	struct ifreq ifr;
 	struct mii_ioctl_data *mii;
+	int delay;
 
 	if (!reporting && !netif_running(slave_dev))
 		return 0;
 
+	for (delay = 0; delay < BOND_CARRIER_CHECK_TIMEOUT; delay++) {
+		mdelay(1);
+
+		if (bond->params.use_carrier &&
+		    netif_carrier_ok(slave_dev)) {
+			return BMSR_LSTATUS;
+		}
+	}
+
 	if (bond->params.use_carrier)
-		return netif_carrier_ok(slave_dev) ? BMSR_LSTATUS : 0;
+		return 0;
 
 	/* Try to get link status using Ethtool first. */
 	if (slave_dev->ethtool_ops->get_link)
-- 
2.31.1


