Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA675636B62
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbiKWUjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240322AbiKWUin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:38:43 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA98126FB
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669235922; x=1700771922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PK9z6NgQkH90eSjHv7SiIGtbV7FGI/SIasEzYrooYNU=;
  b=Mc15I8TM8jVLWgI/Y+FuPE/lwDC8x4SiPOhCWufflt0BlaEYSrS1mWq4
   QHlpfOnt9c4rT8hpNjkUV7i73IBO9wwe29nhaXVCY/BaPRDZm+DeRPkqY
   N/33Zz93S/A1uGaB5b0p4gwYiGfFmC+QdHDTC7mSQOQSTFDv3Dfdm7izj
   h6wJx5VvuSppa7BqCpDB8bjRMTAedRamCX7g1zFjkVbNV1BOvRU5XTkrX
   MKPnuYftZmkZrYlEhV9cnQsBprmA+ekUmkTr/Ke9JZKFMOSJAZ8rPCSSH
   Txms132ImZ0dN7UTJzyLmNknIuEzQEL3shEsgCVeUy4ucPMAwz8RPPxgX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315307127"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315307127"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:38:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="619756043"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="619756043"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:38:41 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/9] devlink: use min_t to calculate data_size
Date:   Wed, 23 Nov 2022 12:38:26 -0800
Message-Id: <20221123203834.738606-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221123203834.738606-1-jacob.e.keller@intel.com>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
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

The calculation for the data_size in the devlink_nl_read_snapshot_fill
function uses an if statement that is better expressed using the min_t
macro.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
Changes since v1:
* Moved to 1/9 of the series
* No longer combined declaration of data_size with its assignment

 net/core/devlink.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index d93bc95cd7cb..a490b8850179 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6485,10 +6485,8 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 		u32 data_size;
 		u8 *data;
 
-		if (end_offset - curr_offset < DEVLINK_REGION_READ_CHUNK_SIZE)
-			data_size = end_offset - curr_offset;
-		else
-			data_size = DEVLINK_REGION_READ_CHUNK_SIZE;
+		data_size = min_t(u32, end_offset - curr_offset,
+				  DEVLINK_REGION_READ_CHUNK_SIZE);
 
 		data = &snapshot->data[curr_offset];
 		err = devlink_nl_cmd_region_read_chunk_fill(skb, devlink,
-- 
2.38.1.420.g319605f8f00e

