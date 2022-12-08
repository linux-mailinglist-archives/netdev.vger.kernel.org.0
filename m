Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042F264664F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiLHBLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiLHBLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:38 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98C28B394
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461896; x=1701997896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g4QGfIesznF6QI8eeukcbQ72FnrpCVMFQYdJvcqQpUw=;
  b=a01xxeJAnqNTydUyRK/EDSQvYxOr4riKpRjyM5adWJyjb2vnKoCR+Xzt
   3DWzGOM4YY45HVq+0ca2tHTamHYc2YiKT4bnpHOuqHyAqxi7PoypRe4wY
   ldAzQgFcRMk/LUeEbMdXRns8+gnxysF1xDqF4vqr3UeRLU9GhTfZY+XHK
   zwqT+DAcYswxOtGzIMUhCzn0qXVvB5XYgacgC0I+4UxSYbAKsiYIOafw5
   qDQWyBjLggTxa1jcsfpeOeIvIHMfDIcl83ucNeNHqsCz3XBrZ+P62JSPS
   MuzJokE7So6PpczWRDx3SIyakNJj22zdbqwRfK/U9PknNQ40zkpRGkv//
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672877"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672877"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445370"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445370"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH ethtool v2 07/13] ethtool: avoid null pointer dereference
Date:   Wed,  7 Dec 2022 17:11:16 -0800
Message-Id: <20221208011122.2343363-8-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'$ scan-build make' reports:

Description: Array access (from variable 'arg') results in a null
pointer dereference
File: /git/ethtool/netlink/parser.c
Line: 782

Description: Dereference of null pointer (loaded from variable 'p')
File: /git/ethtool/netlink/parser.c
Line: 794

Both of these bugs are prevented by checking the input in
nl_parse_char_bitset(), which is called from nl_sset() via the kernel
callback, specifically for the parsing of the wake-on-lan options (-s
wol). None of the other functions in this file seem to have the issue of
deferencing data without checking for validity first. This could
"technically" allow nlctxt->argp to be NULL, and scan-build is limited
in it's ability to parse for bugs only at file scope in this case.
This particular bug should be unlikely to happen because the kernel
builds/parses the netlink structure before handing it to the
application. However in the interests of being able to run this
scan-build tool regularly, I'm still sending the initial version of this
patch as I tried several other ways to fix the bug with an earlier check
for NULL in nl_sset, but it won't prevent the scan-build error due to
the file scope problem.

CC: Michal Kubecek <mkubecek@suse.cz>
Fixes: 81a30f416ec7 ("netlink: add bitset command line parser handlers")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
v2: updated commit message with more nuance after feedback from ethtool
maintainer. I'd be open to fixing this a different way but this seemed
the most straight-forward with the smallest amount of code changed.
v1: original version
---
 netlink/parser.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/netlink/parser.c b/netlink/parser.c
index 70f451008eb4..c573a9598a9f 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -874,7 +874,7 @@ int nl_parse_bitset(struct nl_context *nlctx, uint16_t type, const void *data,
  * optionally followed by '/' and another numeric value (mask, unless no_mask
  * is set), or a string consisting of characters corresponding to bit indices.
  * The @data parameter points to struct char_bitset_parser_data. Generates
- * biset nested attribute. Fails if type is zero or if @dest is not null.
+ * bitset nested attribute. Fails if type is zero or if @dest is not null.
  */
 int nl_parse_char_bitset(struct nl_context *nlctx, uint16_t type,
 			 const void *data, struct nl_msg_buff *msgbuff,
@@ -882,7 +882,7 @@ int nl_parse_char_bitset(struct nl_context *nlctx, uint16_t type,
 {
 	const struct char_bitset_parser_data *parser_data = data;
 
-	if (!type || dest) {
+	if (!type || dest || !*nlctx->argp) {
 		fprintf(stderr, "ethtool (%s): internal error parsing '%s'\n",
 			nlctx->cmd, nlctx->param);
 		return -EFAULT;
-- 
2.31.1

