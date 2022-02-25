Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B664C4F16
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 20:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbiBYTqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 14:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235411AbiBYTqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 14:46:48 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D446B21046D
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 11:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645818375; x=1677354375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f5+yvV7jQdjctTYVZiAL7m81521tP1twFlhfHSCMWyc=;
  b=HfuSq4hB9AZFIY/o5JJGNWXfgYEnep+oxIjN/SIONipchPhE6D4gTkIi
   gbx//Yf5z7fJAG8YJle79QhaIxhUnXJhZ5dUetv3Q8PF0LVu3BzgUxK2L
   QTyYIwjMzuGpaeRmylDkjGUf8JRmNHd5ozpq370oMuSbFX6gx46gn0IVa
   13QgNwY72SN6/1QkWfgMTU59d4G+XSGjhdub6hUab8lM44UkNZHz7GA/D
   MS317mjQN2k36VoCZuaNJeLmlR4OyrGYaIjLAVxZt/UZ2E1t0FFQScLtH
   uHBjtptNWRB9dnNWXR5Kz47QnwBqZJPnTmKqKYKSOno+mthvv1i1yw8zC
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="339004868"
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="339004868"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 11:46:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="707972190"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 25 Feb 2022 11:46:11 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Slawomir Laba <slawomirx.laba@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Phani Burra <phani.r.burra@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 7/8] iavf: Fix missing check for running netdev
Date:   Fri, 25 Feb 2022 11:46:13 -0800
Message-Id: <20220225194614.136571-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220225194614.136571-1-anthony.l.nguyen@intel.com>
References: <20220225194614.136571-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

The driver was queueing reset_task regardless of the netdev
state.

Do not queue the reset task in iavf_change_mtu if netdev
is not running.

Fixes: fdd4044ffdc8 ("iavf: Remove timer for work triggering, use delaying work instead")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index da50ea3e44c2..be97ac251802 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3905,8 +3905,11 @@ static int iavf_change_mtu(struct net_device *netdev, int new_mtu)
 		iavf_notify_client_l2_params(&adapter->vsi);
 		adapter->flags |= IAVF_FLAG_SERVICE_CLIENT_REQUESTED;
 	}
-	adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-	queue_work(iavf_wq, &adapter->reset_task);
+
+	if (netif_running(netdev)) {
+		adapter->flags |= IAVF_FLAG_RESET_NEEDED;
+		queue_work(iavf_wq, &adapter->reset_task);
+	}
 
 	return 0;
 }
-- 
2.31.1

