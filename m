Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878E85F5877
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 18:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiJEQmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 12:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiJEQms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 12:42:48 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC0021E24;
        Wed,  5 Oct 2022 09:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664988166; x=1696524166;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=myGO38GtiiAAqvpOv+BxX7HE12CY/V1A9ytld+bftDI=;
  b=BCkMG0flvj5to4FuYpE90MAE5APXElDDkyg2MhtRkWZp58wFermkhz0b
   WSJ+u8XqZxPDRLaXbiwsszpV01FYvhFbNyEbb83eL2kc0ocOROHygwdBY
   uHVtITUC0n1c0vHUjOMk/iqJ3DeS/aljeHPU2ZltvZ0G8RgPan19lVb8f
   PdNNdJJz6pf4N5y1CE5mnAv5CqdJOrQStt+zlO628VITINJbJX5bNfNt+
   1IOCw+c8tqFDfXCgRCyE3NC+d4MJo9Yt9JufNYCsyzLnTx5lg6S4IG1w1
   MgmQyoF9MsGKznnU2IWyXLcccJ2v1ZBZKn6xfks8Y2RC6CoV+6aGaqulh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="389496357"
X-IronPort-AV: E=Sophos;i="5.95,161,1661842800"; 
   d="scan'208";a="389496357"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 09:42:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="687025568"
X-IronPort-AV: E=Sophos;i="5.95,161,1661842800"; 
   d="scan'208";a="687025568"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 05 Oct 2022 09:42:42 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 9D54D155; Wed,  5 Oct 2022 19:43:02 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v1 1/1] mac_pton: Don't access memory over expected length
Date:   Wed,  5 Oct 2022 19:43:01 +0300
Message-Id: <20221005164301.14381-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The strlen() may go too far when estimating the length of
the given string. In some cases it may go over the boundary
and crash the system which is the case according to the commit
13a55372b64e ("ARM: orion5x: Revert commit 4904dbda41c8.").

Rectify this by switching to strnlen() for the expected
maximum length of the string.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/net_utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/net_utils.c b/lib/net_utils.c
index af525353395d..c17201df3d08 100644
--- a/lib/net_utils.c
+++ b/lib/net_utils.c
@@ -6,10 +6,11 @@
 
 bool mac_pton(const char *s, u8 *mac)
 {
+	size_t maxlen = 3 * ETH_ALEN - 1;
 	int i;
 
 	/* XX:XX:XX:XX:XX:XX */
-	if (strlen(s) < 3 * ETH_ALEN - 1)
+	if (strnlen(s, maxlen) < maxlen)
 		return false;
 
 	/* Don't dirty result unless string is valid MAC. */
-- 
2.35.1

