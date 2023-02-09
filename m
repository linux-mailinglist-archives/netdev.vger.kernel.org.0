Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75973690F35
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBIR3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjBIR27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:28:59 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85E3193E1
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 09:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675963737; x=1707499737;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oVIuAQAMNBYJVYTyTls0X8hw6tNWp/NHeO5KPp+lf1w=;
  b=YqpR+9vK+ygtPeddzOJYF9zpVZo/onoQxoe9wroJnibmmleeFMk+q0RA
   j/FcZWIHa69S3RqKv3HvOhwRKZglNcMlHoo5dQMIrJ1Asb5KLrWi5CUNV
   2hyfMVh4mM6XjDCzF23gj74kcqAUu4R7wzhSVl2+HMyRceH1dbH0KV2Ln
   33PXYpfmXK4Okrw5viCxh2YVh+ZatGcu7b31B0zaIKUkFIEPrdSuMLnN6
   JJw1AbAeaQT7xP2vKqQo7uMzHSnMIzmzI1+se5AKVqjxukRKXmusrk6VS
   jodK2PL8SboBD/o/mGx+xuay6qoFHtUlpeID63n7kptrKUZh4Si74B2E7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="318196949"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="318196949"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 09:28:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="791680922"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="791680922"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga004.jf.intel.com with ESMTP; 09 Feb 2023 09:28:56 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Natalia Petrova <n.petrova@fintech.ru>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/1] i40e: Add checking for null for nlmsg_find_attr()
Date:   Thu,  9 Feb 2023 09:28:33 -0800
Message-Id: <20230209172833.3596034-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
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

From: Natalia Petrova <n.petrova@fintech.ru>

The result of nlmsg_find_attr() 'br_spec' is dereferenced in
nla_for_each_nested(), but it can take NULL value in nla_find() function,
which will result in an error.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 51616018dd1b ("i40e: Add support for getlink, setlink ndo ops")
Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 53d0083e35da..4626d2a1af91 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13167,6 +13167,8 @@ static int i40e_ndo_bridge_setlink(struct net_device *dev,
 	}
 
 	br_spec = nlmsg_find_attr(nlh, sizeof(struct ifinfomsg), IFLA_AF_SPEC);
+	if (!br_spec)
+		return -EINVAL;
 
 	nla_for_each_nested(attr, br_spec, rem) {
 		__u16 mode;
-- 
2.38.1

