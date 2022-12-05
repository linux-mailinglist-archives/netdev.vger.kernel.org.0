Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C59643896
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 00:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiLEXAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 18:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiLEXAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 18:00:04 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79224BF69
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 15:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670281203; x=1701817203;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=e4PUpXnqUY62HtFQnM/0HRFWdhxxpc/082mqJomr11w=;
  b=RXUifrYJv+iHem+VBZI6w8IXmX9z3PrC6n2OiPS0DH8mzAT/EgVXmcRS
   uycsEGlnBgFnjjJ/ZU0VmmHLnho23Yu3/utzD0ANx/1GkQTS1RS9rrc67
   q+v/CryeBruRNuC8qVMKoezSD4yE8Jf2oQMkd5twJ2QGLP9UQtuxE9j89
   nYxUDlWPFPVHL+ithdub75so0bUelao7EYMUHgizLyLJRmqSdio7aWt/r
   mzpaBeY6w76b9Xnn1gsSty+QHk5Y8V+rwCWdcetvtFaLEXknluM1mOq8K
   UiF2xGTHqR3KkwR5/dA+EQQccgZKCCj+0UqDSS//reNk7Nug9vxdmgF19
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="316508739"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="316508739"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 15:00:03 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="734768891"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="734768891"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 15:00:03 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH iproute2-next v2 1/1] devlink: support direct region read requests
Date:   Mon,  5 Dec 2022 14:59:31 -0800
Message-Id: <20221205225931.2563966-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
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
Changes since v2:
* Fixed placement of mnl_attr_put
* Added proper Cc's

 devlink/devlink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 8aefa101b2f8..8d22c141049c 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -8535,8 +8535,8 @@ static int cmd_region_read(struct dl *dl)
 	int err;
 
 	err = dl_argv_parse(dl, DL_OPT_HANDLE_REGION | DL_OPT_REGION_ADDRESS |
-			    DL_OPT_REGION_LENGTH | DL_OPT_REGION_SNAPSHOT_ID,
-			    0);
+			    DL_OPT_REGION_LENGTH,
+			    DL_OPT_REGION_SNAPSHOT_ID);
 	if (err)
 		return err;
 
@@ -8545,6 +8545,10 @@ static int cmd_region_read(struct dl *dl)
 
 	dl_opts_put(nlh, dl);
 
+	/* If user didn't provide a snapshot id, perform a direct read */
+	if (!(dl->opts.present & DL_OPT_REGION_SNAPSHOT_ID))
+		mnl_attr_put(nlh, DEVLINK_ATTR_REGION_DIRECT, 0, NULL);
+
 	pr_out_section_start(dl, "read");
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_region_read_cb, dl);
 	pr_out_section_end(dl);
-- 
2.38.1.420.g319605f8f00e

