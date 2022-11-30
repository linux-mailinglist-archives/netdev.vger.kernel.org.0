Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5696B63D5B1
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbiK3Mf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiK3Mfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:35:52 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2A67722B;
        Wed, 30 Nov 2022 04:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669811752; x=1701347752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RgyhU5bmK96xArXf/6a/u43HPi5BukzWqwYI+tdpOpA=;
  b=hp9eV7KLqmJnZijuhtn10/C6xUvAXeXj4MdMEGA1Gzr1Tyi1t3ZpuBlG
   gwx7sTVYG849cm/kSFKG/aWOcI92MtwEJ2sQICvOF3b7Ocd4I/jgM0foj
   dLCbOlDsxZWtteUgA/0c+bIckvvk+/rmS/I1XC7QKq4QZAaWe7XW47AIm
   r/HBWCs28Yhx/TgQIsDY138Mm+ytbAVFq5raeJQyI3OYfTyothr7eMm+U
   s2SP5109Ib2JDsDjr5E8ljyODGqMJiWviXiAOMswiYYXY6hx5tNXviqa9
   YdjRbqjmoxj9Ym7ft2hDic3fKeK8UlgI0rkB9P5C8gHvDRDyA5HzJ2gFA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="315413002"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="315413002"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 04:35:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="621868380"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="621868380"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 30 Nov 2022 04:35:48 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id ECC5D6A; Wed, 30 Nov 2022 14:36:14 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net-next v3 2/2] net: thunderbolt: Use bitwise types in the struct thunderbolt_ip_frame_header
Date:   Wed, 30 Nov 2022 14:36:13 +0200
Message-Id: <20221130123613.20829-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221130123613.20829-1-andriy.shevchenko@linux.intel.com>
References: <20221130123613.20829-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main usage of the struct thunderbolt_ip_frame_header is to handle
the packets on the media layer. The header is bound to the protocol
in which the byte ordering is crucial. However the data type definition
doesn't use that and sparse is unhappy, for example (17 altogether):

  .../thunderbolt.c:718:23: warning: cast to restricted __le32

  .../thunderbolt.c:966:42: warning: incorrect type in assignment (different base types)
  .../thunderbolt.c:966:42:    expected unsigned int [usertype] frame_count
  .../thunderbolt.c:966:42:    got restricted __le32 [usertype]

Switch to the bitwise types in the struct thunderbolt_ip_frame_header to
reduce this, but not completely solving (9 left), because the same data
type is used for Rx header handled locally (in CPU byte order).

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v3: no changes
v2: changed only types without splitting the data type (Mika)
 drivers/net/thunderbolt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index c73d419f1456..4ed7f5b547e3 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -58,10 +58,10 @@
  * supported then @frame_id is filled, otherwise it stays %0.
  */
 struct thunderbolt_ip_frame_header {
-	u32 frame_size;
-	u16 frame_index;
-	u16 frame_id;
-	u32 frame_count;
+	__le32 frame_size;
+	__le16 frame_index;
+	__le16 frame_id;
+	__le32 frame_count;
 };
 
 enum thunderbolt_ip_frame_pdf {
-- 
2.35.1

