Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544FA63B392
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbiK1UnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbiK1UnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:43:08 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB161A068
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669668186; x=1701204186;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=67+M9s2vsNxh22kJv/ZAX0nd8Rr3W/o5Y22iVqthvB8=;
  b=T9dA8BNNfXn4mMpMQsUk8WQ+oOMX2pWthrdorMnNyD3JjpyB1ddjS4C5
   HbSO+mcIl+zTUjk313Rk6laCEQZ8Jxi6s4Jbs288M29U7Z76GCd0Fuldf
   kXcx/9Nq+5xyZGmc/qgC9eDgqIt6A9Jh9PZwj+QYnabCNLGE6CUyid9xi
   MIRUkDYSHonvNFGoM7ITEjEtO1OGuX+TyB6qYyEzw45uoxmiWf0RiYAC7
   BFoBLLfZqtzPSgEDtUYdzCgZdEhwKKX7QI1lj/Ivo4F0VUBtD9YZR0DDe
   9Mwl3JTuUqDfwnDbwfcgOf3l4fChSHgCt6dwFbtMNCdenwl48z9BhewVV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="313649894"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="313649894"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:43:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="594008790"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="594008790"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:43:04 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH iproute2-next] devlink: support direct region read requests
Date:   Mon, 28 Nov 2022 12:42:56 -0800
Message-Id: <20221128204256.1200695-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel has gained support for reading from regions without needing to
create a snapshot. To use this support, the DEVLINK_ATTR_REGION_DIRECT
attribute must be added to the command.

For the "read" command, if the user did not specify a snapshot, add the new
attribute to request a direct read. The "dump" command will still require a
snapshot. While technically a dump could be performed without a snapshot it
is not guaranteed to be atomic unless the region size is no larger than
256 bytes.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
This depends on https://lore.kernel.org/netdev/20221128203647.1198669-1-jacob.e.keller@intel.com/T/#t

 devlink/devlink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 8aefa101b2f8..5057b09505ef 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -8535,11 +8535,15 @@ static int cmd_region_read(struct dl *dl)
 	int err;
 
 	err = dl_argv_parse(dl, DL_OPT_HANDLE_REGION | DL_OPT_REGION_ADDRESS |
-			    DL_OPT_REGION_LENGTH | DL_OPT_REGION_SNAPSHOT_ID,
-			    0);
+			    DL_OPT_REGION_LENGTH,
+			    DL_OPT_REGION_SNAPSHOT_ID);
 	if (err)
 		return err;
 
+	/* If user didn't provide a snapshot id, perform a direct read */
+	if (!(dl->opts.present & DL_OPT_REGION_SNAPSHOT_ID))
+		mnl_attr_put(nlh, DEVLINK_ATTR_REGION_DIRECT, 0, NULL);
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_READ,
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
 

base-commit: 2ed09c3bf8aca185b2f3eb369ae435503f9b9826
-- 
2.38.1.420.g319605f8f00e

