Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1DC6E5383
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 22:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjDQU7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 16:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjDQU72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 16:59:28 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B8DC665
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 13:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681765049; x=1713301049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u/8gtaBJAhofbgNR+JM9QGKRFkfVm5ojJF0rDyeQAOU=;
  b=X0cUfVttOz2ybjGloLRAB1ojDMlGi6vd2mq4ZRGTU035ufh02QIVc4J9
   tVX4VXKA+DF0wdmsNBizo/1VBK+b8BRDaEDsWuRecdKtW6/pvmFAIXOqd
   pkAlK6X3197Ux0QiAGU9b3xzmEa4+jggX1kqqVobS3fxcK16jgVA8q2qt
   fDfhxUoGXLmcu9gxcOwvMsGSG2R2S09mwThDIO7KdslwsMImrvFtXk5bL
   HfkfsN3nG/QBtVKtsMg4mRohnev+3UKtDxMCA83svPocuqD7EAWZp9X92
   fo2U1Epih/85MGEPSu7MpnjxMz3Cfb9K01O4apcuTL2x6oeyVi5BcaFgq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="410222176"
X-IronPort-AV: E=Sophos;i="5.99,205,1677571200"; 
   d="scan'208";a="410222176"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 13:55:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="690818638"
X-IronPort-AV: E=Sophos;i="5.99,205,1677571200"; 
   d="scan'208";a="690818638"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga002.jf.intel.com with ESMTP; 17 Apr 2023 13:55:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        anthony.l.nguyen@intel.com,
        Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net 2/2] i40e: fix i40e_setup_misc_vector() error handling
Date:   Mon, 17 Apr 2023 13:52:45 -0700
Message-Id: <20230417205245.1030733-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230417205245.1030733-1-anthony.l.nguyen@intel.com>
References: <20230417205245.1030733-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

Add error handling of i40e_setup_misc_vector() in i40e_rebuild().
In case interrupt vectors setup fails do not re-open vsi-s and
do not bring up vf-s, we have no interrupts to serve a traffic
anyway.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6313575a4b6c..7c30abd0dfc2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11059,8 +11059,11 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 					     pf->hw.aq.asq_last_status));
 	}
 	/* reinit the misc interrupt */
-	if (pf->flags & I40E_FLAG_MSIX_ENABLED)
+	if (pf->flags & I40E_FLAG_MSIX_ENABLED) {
 		ret = i40e_setup_misc_vector(pf);
+		if (ret)
+			goto end_unlock;
+	}
 
 	/* Add a filter to drop all Flow control frames from any VSI from being
 	 * transmitted. By doing so we stop a malicious VF from sending out
-- 
2.38.1

