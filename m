Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3519A63ED85
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiLAKVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiLAKUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:20:24 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D101394915
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669890022; x=1701426022;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3CbHFe7+fRbKxzK9wZO7F4smGTNJ761jajOqCmekU+U=;
  b=aPRG6hia5eTM8XEUtT3ZsQp3TEPvcGujTdL4GLkMcS3HTrZ/CHNPyslw
   Go3MgIdMCrG6tUut/V8cP0akHiewEplSOnV5nOfrFGNeODZADwPXSP+eo
   drvwJhPTojjIDa4xFIHCKqXLOo17a4YxjYaN+BFlyEfoxvu8U7JGDyKqM
   JqdmgFHwzxASw4QVQ8J7pF7Qbw7HBQCceJsDMUeIvEjUv4mRSsvX+4Y3w
   yWMBmlMi7fVAi5N3NVVcjqcWplZINpbK8qtbYNG/oeeSTF9B3I0yGw1RF
   kxIwH/pXoQC2kugTHyXOpstIwSXYgq4P67OMyWdsWZkvANtXQn6+4FNXr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="342571277"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="342571277"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:18:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="595011352"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="595011352"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:18:25 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, przemyslaw.kitszel@intel.com,
        jiri@resnulli.us, wojciech.drewek@intel.com, dsahern@gmail.com,
        stephen@networkplumber.org,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH iproute2 v2] devlink: Fix setting parent for 'rate add'
Date:   Thu,  1 Dec 2022 11:18:10 +0100
Message-Id: <20221201101810.56207-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting a parent during creation of the node doesn't work, despite
documentation [1] clearly saying that it should.

[1] man/man8/devlink-rate.8

Example:
$ devlink port function rate add pci/0000:4b:00.0/node_custom parent node_0
  Unknown option "parent"

Fix this by passing DL_OPT_PORT_FN_RATE_PARENT as an argument to
dl_argv_parse() when it gets called from cmd_port_fn_rate_add().

Fixes: 6c70aca76ef2 ("devlink: Add port func rate support")
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v2:
 - Re-send to target iproute2 instead of iproute2-next

 devlink/devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 150b4e63..11daf0c3 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -5049,7 +5049,8 @@ static int cmd_port_fn_rate_add(struct dl *dl)
 	int err;
 
 	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
-			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX);
+			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX |
+			    DL_OPT_PORT_FN_RATE_PARENT);
 	if (err)
 		return err;
 
-- 
2.37.2

