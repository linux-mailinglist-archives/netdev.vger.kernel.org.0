Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D379858034F
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 19:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbiGYRH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 13:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236172AbiGYRH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 13:07:56 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55611CB39
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 10:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658768875; x=1690304875;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XnCZjKTAdiI5eNPsSIAzpkZJdGLG0TlvWIKpDW2Nfeg=;
  b=FE9Ng10QL7tpy5mCgL4yST7uGxNgK0AnPue91vFkocLugMw/1Trvbrze
   9LdBBy38hCjHKsa2Pd5aww9jkn45xA3iFlLsOb/xhZ3G0jOAokQypE7xx
   sk63292Km2cCQ5bhnYt7yGs2W4SA+G1WVb38w/3kjlQUeT7vcRgY8HZWO
   SeY19A353ayDGW6zUR5mbvbAUVTxmkVuY1Gxm15ZviUtL4S/5kKxL6c3B
   vkl1Y/bmzMIgWD5rx7wY17S4ey7Xd2mJmNuPXd/o3IWlrXUN68kIrilOO
   CiKKuo0NnW25Nzc1EJDyQ9xOwJfHD1FaYYvDWon7NYhm6HWv/RcRfUn7I
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="270785658"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="270785658"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 10:07:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="845577985"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 25 Jul 2022 10:07:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jun Zhang <xuejun.zhang@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: [PATCH net 3/3] iavf: enable tc filter configuration only if hw-tc-offload is on
Date:   Mon, 25 Jul 2022 10:04:52 -0700
Message-Id: <20220725170452.920964-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220725170452.920964-1-anthony.l.nguyen@intel.com>
References: <20220725170452.920964-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>

Allow configuration of tc filter only if NETIF_F_HW_TC is set for the
device.

Fixes: 0075fa0fadd0 ("i40evf: Add support to apply cloud filters")
Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Signed-off-by: Jun Zhang <xuejun.zhang@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3dbfaead2ac7..9279bb37e4aa 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3802,6 +3802,12 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
 		return -EINVAL;
 	}
 
+	if (!(adapter->netdev->features & NETIF_F_HW_TC)) {
+		dev_err(&adapter->pdev->dev,
+			"Can't apply TC flower filters, turn ON hw-tc-offload and try again");
+		return -EOPNOTSUPP;
+	}
+
 	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
 	if (!filter)
 		return -ENOMEM;
-- 
2.35.1

