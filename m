Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5D662E7C8
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240713AbiKQWJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240882AbiKQWIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:08:41 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D0272120
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668722895; x=1700258895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9yAvMt38yYTJZgHl5/iwzS7wXadfU7uVKQDdrPukOl8=;
  b=hWyeROKP5ewzBuxorzOEGuJ0jl+hvjdht9cXAkyxAr4h2xH92SqxNX1Y
   3qbpwUSr4WnX14l1mZ/6nyEwuzSMhFQtKl6D5mYyQVLTVmiOzYEnHWTOM
   haUntKDj7UV87TuNgx81W/PtW/wp6KdhJbt/ffMSbSsRTsfY6j9MRFvkg
   tq8QisX/p0+3Xnhj+/hm8hXdEnJ3YHIp51IiqVU7BnYjfCE3y/lwvUqQ3
   zwj13AfRWMRQD/Jc6mrhV9picwdjJJsFgO1io05IaJQq/qW9MXClrlEzD
   ycLJuIn7rXxjLiiNpN/M9OlbaJ7+SAo545fwzKdK9XYacHWPx180w6XjP
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="313001216"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="313001216"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="672975620"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="672975620"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:12 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/8] devlink: use min_t to calculate data_size
Date:   Thu, 17 Nov 2022 14:07:57 -0800
Message-Id: <20221117220803.2773887-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221117220803.2773887-1-jacob.e.keller@intel.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
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

The calculation for the data_size in the devlink_nl_read_snapshot_fill
function uses an if statement that is better expressed using the min_t
macro.

Noticed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/core/devlink.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 96afc7013959..932476956d7e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6410,14 +6410,10 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 	*new_offset = start_offset;
 
 	while (curr_offset < end_offset) {
-		u32 data_size;
+		u32 data_size = min_t(u32, end_offset - curr_offset,
+				      DEVLINK_REGION_READ_CHUNK_SIZE);
 		u8 *data;
 
-		if (end_offset - curr_offset < DEVLINK_REGION_READ_CHUNK_SIZE)
-			data_size = end_offset - curr_offset;
-		else
-			data_size = DEVLINK_REGION_READ_CHUNK_SIZE;
-
 		data = &snapshot->data[curr_offset];
 		err = devlink_nl_cmd_region_read_chunk_fill(skb, devlink,
 							    data, data_size,
-- 
2.38.1.420.g319605f8f00e

