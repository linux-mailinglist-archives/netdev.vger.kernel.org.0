Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCE76EC099
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 16:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjDWOwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 10:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjDWOwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 10:52:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9007A197;
        Sun, 23 Apr 2023 07:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682261537; x=1713797537;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=srdNvnLtJM4cXhiaa6KO7TQ2+8tSqelv/CbI9RrmN3k=;
  b=ULgDoLEVY1Nx4ZxXaJvd4b132SbWYXonthN1+gpxxIFdYaP9V+WY22ZX
   AIQwmne8BdEef+vVIHL5UaHgizC7ZyqugENtftUv5psxxogOHSE0VhRJB
   j2948zGnRwoKT1i9frb/QOy2kOb8zfP5TfR7CgnDeKQguAJGurhM6m3Mt
   Jc95b2gLG0Y8/KKW6nhUtXiTmOoJr6Qbnw0i8h3+Epu9FM4WfRQEQDKSk
   wVSiy9Twh3IpBkpHNBNoaHZH/PUY6X3A1Tsq6gF+I8GO+Jf0q+wSDNOZY
   Efe2MPmwHGct8plOa1ofJo5+xAAQTZX3BkhfepKnBPBcWqFAwOxGbFOcD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="325890212"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="325890212"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 07:52:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="836680631"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="836680631"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by fmsmga001.fm.intel.com with ESMTP; 23 Apr 2023 07:51:58 -0700
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     jgg@ziepe.ca, leon@kernel.org, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, parav@nvidia.com,
        netdev@vger.kernel.org, rain.1986.08.12@gmail.com
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH rdma-next v4 1/8] RDMA/rxe: Creating listening sock in newlink function
Date:   Sun, 23 Apr 2023 22:48:15 +0800
Message-Id: <20230423144822.1797465-2-yanjun.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230423144822.1797465-1-yanjun.zhu@intel.com>
References: <20230423144822.1797465-1-yanjun.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

Originally when the module rdma_rxe is loaded, the sock listening on udp
port 4791 is created. Currently moving the creating listening port to
newlink function.

So when running "rdma link add" command, the sock listening on udp port
4791 is created.

Tested-by: Rain River <rain.1986.08.12@gmail.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 7a7e713de52d..89b24bc34299 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -194,6 +194,10 @@ static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
 		goto err;
 	}
 
+	err = rxe_net_init();
+	if (err)
+		return err;
+
 	err = rxe_net_add(ibdev_name, ndev);
 	if (err) {
 		rxe_err("failed to add %s\n", ndev->name);
@@ -210,12 +214,6 @@ static struct rdma_link_ops rxe_link_ops = {
 
 static int __init rxe_module_init(void)
 {
-	int err;
-
-	err = rxe_net_init();
-	if (err)
-		return err;
-
 	rdma_link_register(&rxe_link_ops);
 	pr_info("loaded\n");
 	return 0;
-- 
2.27.0

