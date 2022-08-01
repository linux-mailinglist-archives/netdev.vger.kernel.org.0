Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEDC586AB1
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 14:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbiHAMVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 08:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbiHAMUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 08:20:19 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700A66359;
        Mon,  1 Aug 2022 05:00:14 -0700 (PDT)
Received: from integral2.. (unknown [125.160.110.15])
        by gnuweeb.org (Postfix) with ESMTPSA id 1DD627E24B;
        Mon,  1 Aug 2022 12:00:09 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1659355213;
        bh=1CxphM8mT7LexVSNdtj4rN64OESklygPtbgpgoZ2cjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdkuVedwwkU8KBKc1UvD6yl1x1Rxj154rCtYlaHEC1eX/hh/5iJNNTYDgtyfztW9K
         P5PFyJtVvClMepGqYyPY/Xcq6PxEzEXEiykCKzd1L4MFd16+DOcIhjrYWRb0YFdf9R
         oj2dkSc/BrXDbIKaUJDKEaRDTZg4i+7HTNYrv5a0eB+19LzDLWdm+I3vXRAtdX2Kjy
         ZbuUPB7+FvgNxTAuzjGGPFPNFr+v7Ut/r4otyT50HOGADXsq1DOheiVsY/mAekIuxF
         lCKxx8BtFwb3RTPdHbuwGUoGzjf1TnnME3qsw0SrSwSi7tJOBoyKfHFerw9tSocyv9
         NelvvgqFFfZZg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Moshe Shemesh <moshe@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kbuild Mailing List <kbuild@lists.01.org>,
        kbuild-all Mailing List <kbuild-all@lists.01.org>
Subject: [PATCH] net: devlink: Fix missing mutex_unlock() call
Date:   Mon,  1 Aug 2022 18:59:56 +0700
Message-Id: <20220801115742.1309329-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <202207311503.QBFSGqiL-lkp@intel.com>
References: <202207311503.QBFSGqiL-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Commit 2dec18ad826f forgets to call mutex_unlock() before the function
returns in the error path:

   New smatch warnings:
   net/core/devlink.c:6392 devlink_nl_cmd_region_new() warn: inconsistent \
   returns '&region->snapshot_lock'.

Make sure we call mutex_unlock() in this error path.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 2dec18ad826f52658f7781ee995d236cc449b678 ("net: devlink: remove region snapshots list dependency on devlink->lock")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 net/core/devlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 889e7e3d3e8a..5da5c7cca98a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6315,8 +6315,10 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 
 		snapshot = devlink_region_snapshot_get_by_id(region,
 							     snapshot_id);
-		if (WARN_ON(!snapshot))
-			return -EINVAL;
+		if (WARN_ON(!snapshot)) {
+			err = -EINVAL;
+			goto unlock;
+		}
 
 		msg = devlink_nl_region_notify_build(region, snapshot,
 						     DEVLINK_CMD_REGION_NEW,

base-commit: 0a324c3263f1e456f54dd8dc8ce58575aea776bc
-- 
Ammar Faizi

