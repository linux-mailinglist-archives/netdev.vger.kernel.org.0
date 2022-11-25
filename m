Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1D26389E0
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiKYMeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiKYMep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:34:45 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1344B765
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 04:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669379680; x=1700915680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7zKbHAX3n0NFpyDvwuLA3NrJ64DBiBl37zzHOBUz9JQ=;
  b=Ux8WyWVp9OM9HKmDB8mgC/OoSwMkY3pCMcN3petlxedAstwqEiZLzi48
   7r5WysM4mFHn4YP5Kxbj9sYBA/FJjN4ayJJPFGJ9wnDXaU7rljJFz1Qm9
   uqZMhL5z/i5D8qqPI9Rsx78nGTW+PzBbtUGdr4qvJXc0u6WyrctTrtRI6
   GNmNXc2Ep5p9C7+Yr1PmaZ/77FOg3jP99Ls74VwkLd/1VEcA2CGNu+Uez
   N2TdRI4ltENlbPHteEOsCVfiJFBnoBA9Z5h2EC0nAAVP5zTCXPqYSJagO
   6RZUHagCybHutZsIbzQ3vsaXFiVe7ow9YZgIXzkcDYdaMFsSObTA7EYUw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="314510191"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="314510191"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:34:40 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="711263997"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="711263997"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:34:38 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, przemyslaw.kitszel@intel.com,
        jiri@resnulli.us, wojciech.drewek@intel.com, dsahern@gmail.com,
        stephen@networkplumber.org,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH iproute2-next 1/5] devlink: Fix setting parent for 'rate add'
Date:   Fri, 25 Nov 2022 13:34:17 +0100
Message-Id: <20221125123421.36297-2-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221125123421.36297-1-michal.wilczynski@intel.com>
References: <20221125123421.36297-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 devlink/devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 8aefa101b2f8..5cff018a2471 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -5030,7 +5030,8 @@ static int cmd_port_fn_rate_add(struct dl *dl)
 	int err;
 
 	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
-			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX);
+			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX |
+			    DL_OPT_PORT_FN_RATE_PARENT);
 	if (err)
 		return err;
 
-- 
2.37.2

