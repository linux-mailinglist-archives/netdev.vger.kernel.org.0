Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB214DB998
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352464AbiCPUlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343814AbiCPUlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:41:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3F65F8EB
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647463201; x=1678999201;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G/IsyO70e8OkkjO0FSU43HwrZ5V2UptkMOOpHpbXjBY=;
  b=eRCGDHqIje2z4JvqWzY6QNMHa48A7jftk2M4ntohzDlILb7u3+9jw7j4
   V0sFjg5/Tya/3aeeBuqvpPTu2z/BGueYQuhjK/k9z/axBdIHzS1gJjW4x
   im4alptZXEkELeqT2HXwYR6xiHz8ORmGSHQfUWZLztaauUHtdveI57D8n
   PzLmCK7AMR8kNBQ9a7NolpSbYM7u2kncCdat2ENHdxMf6S+r4lHcSMa9u
   S0VmjdMvcEsfU5h/uPv2OGnDhCu+fgDL4De6qT8/O8cBnmo9jzm9xHQs6
   tdY5qmKCDosd/GTd7IoACzgCyC1VL07FbJhZrTu0RhXt3LEHEcolS/nQd
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="236653295"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="236653295"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 13:40:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="646799205"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 16 Mar 2022 13:39:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, wojciech.drewek@intel.com,
        pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, Hulk Robot <hulkci@huawei.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/4] ice: fix return value check in ice_gnss.c
Date:   Wed, 16 Mar 2022 13:40:23 -0700
Message-Id: <20220316204024.3201500-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220316204024.3201500-1-anthony.l.nguyen@intel.com>
References: <20220316204024.3201500-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

kthread_create_worker() and tty_alloc_driver() return ERR_PTR()
and never return NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Fixes: 43113ff73453 ("ice: add TTY for GNSS module for E810T device")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index 755e1580f368..35579cf4283f 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -125,7 +125,7 @@ static struct gnss_serial *ice_gnss_struct_init(struct ice_pf *pf)
 	 * writes.
 	 */
 	kworker = kthread_create_worker(0, "ice-gnss-%s", dev_name(dev));
-	if (!kworker) {
+	if (IS_ERR(kworker)) {
 		kfree(gnss);
 		return NULL;
 	}
@@ -253,7 +253,7 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
 	int err;
 
 	tty_driver = tty_alloc_driver(1, TTY_DRIVER_REAL_RAW);
-	if (!tty_driver) {
+	if (IS_ERR(tty_driver)) {
 		dev_err(ice_pf_to_dev(pf), "Failed to allocate memory for GNSS TTY\n");
 		return NULL;
 	}
-- 
2.31.1

