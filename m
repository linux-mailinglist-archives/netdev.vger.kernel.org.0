Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9669062155D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbiKHOKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235193AbiKHOKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:10:51 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5D3E5D;
        Tue,  8 Nov 2022 06:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667916650; x=1699452650;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=78UClQ5hZwRvjI4tqAdHLzPjsIcZ5QgMjnTJ3lC01cU=;
  b=DFlRThY+8a5/yj9kbajLA6c/57kVWz7ugdV8I1SeXsZQBocMZiz7D+h2
   r1JJWSkizXZY9+YoVI6a0seGtgGkkxcpefQJA3P5GwP0usSfSQPxz0uAB
   XgLdBb2V/JzkO2QOmy+FM4Hnnbfhbnas+EQuJJPoowyQP3LW+xgwQlGe+
   FyYJLIKVdP0U1w0oY6qQnEWDNjEI48s0maddu7AmeqqAgajCAFEl7F3gz
   9IxVDRMGv0bNEaPjaM4eDL+0+KTaBXFOIOujuGzVdZ9LzkJfYkS7JBj+D
   JRyWI/vqBSGTgAfcwfQuWZWp9Bp0XfQqeH9H0DRpr2IKLEtCOnaycosZz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="396995452"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="396995452"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 06:10:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="699934682"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="699934682"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 08 Nov 2022 06:10:48 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id CA42615C; Tue,  8 Nov 2022 16:11:12 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [resend, PATCH net-next v1 1/1] mac_pton: Don't access memory over expected length
Date:   Tue,  8 Nov 2022 16:11:08 +0200
Message-Id: <20221108141108.62974-1-andriy.shevchenko@linux.intel.com>
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
v1[resend]: used net-next (Jakub)
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

