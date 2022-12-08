Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC3564664E
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiLHBLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiLHBLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:40 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C0C8BD10
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461898; x=1701997898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bba6QTOiuyIhGnMtVCyu3Ljw2VYb+lFq+UabP2aHO8g=;
  b=MHqhVZ3AUYDrI6cPYf6tzAh41w0C+dxrh7WfMK6zkZ1wx6zGhxDERLqv
   90SlHBoI9Zvw5MQpdcGO9b+oEc6FvMRXkXK53Yqy+bhX/8zIpEC/W8Luz
   nrV82mFnX8a6fdGT1S5KflXYwdYpizheO3MZZLtv0mPPbK8bSTFoLIzNt
   Sr6lu8U6NV2eeLF8GmyO0kQ9N2BT3rFQaAe06utSQOgcn7yyexUxeSxYd
   efsWBytLcFSdKtS7BuDvp15yLqjj/YLEHpBviZqb5eqP0AIcLly82siFI
   hPT+55JAXjfdbnHX4sonQAmLTPUdVkd1TKWBNg8s4Gp0H1VtTz0ZaOVYy
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672884"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672884"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445366"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445366"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH ethtool v2 05/13] ethtool: fix extra warnings
Date:   Wed,  7 Dec 2022 17:11:14 -0800
Message-Id: <20221208011122.2343363-6-jesse.brandeburg@intel.com>
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

'$ scan-build make' reports

netlink/permaddr.c:44:2: warning: Value stored to 'ifinfo' is never read [deadcode.DeadStores]
        ifinfo = mnl_nlmsg_put_extra_header(nlhdr, sizeof(*ifinfo));
        ^        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

So just remove the extra assignment which is never used.

Fixes: 7f3585b22a4b ("netlink: add handler for permaddr (-P)")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 netlink/permaddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/netlink/permaddr.c b/netlink/permaddr.c
index 006eac6c0094..dccb0c6cfdb7 100644
--- a/netlink/permaddr.c
+++ b/netlink/permaddr.c
@@ -41,7 +41,7 @@ static int permaddr_prep_request(struct nl_socket *nlsk)
 	nlhdr->nlmsg_type = RTM_GETLINK;
 	nlhdr->nlmsg_flags = nlm_flags;
 	msgbuff->nlhdr = nlhdr;
-	ifinfo = mnl_nlmsg_put_extra_header(nlhdr, sizeof(*ifinfo));
+	mnl_nlmsg_put_extra_header(nlhdr, sizeof(*ifinfo));
 
 	if (devname) {
 		uint16_t type = IFLA_IFNAME;
-- 
2.31.1

