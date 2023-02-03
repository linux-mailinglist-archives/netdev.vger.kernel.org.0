Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7574689B15
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbjBCOH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbjBCOHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:07:08 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BB6A58C2;
        Fri,  3 Feb 2023 06:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675433088; x=1706969088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u+t+Nxtc784jnlWxX2i/aMwjTnnQt1oZefzR6lfuUXU=;
  b=hDo02lTvTxvxMcSbUwAgl2PWbFsPdBsynl0eYYyiqymEvNFPpbujALZH
   GhoKBZL0Yxa+ibcoUy6QgQb8EKAKdoqpHDv/L24PwqWCf12AEWj4Oetd1
   nCzXpSHInWgR6k+qP4LKomhRPZ5qSAi6BPLySt03TVgUSfwez7+tbDNp8
   K+9sXOrb9tNuG6180gyJbiw0EDjefPZJv2z3mjq6/XYt60g4n1E1ar0kx
   Vn+tr/uTlWeUHm7Wa5M+zsO0fQKhpCGxqwGGQs6m6j5T/kHYlYn161xti
   sn2dzK8TEHrkqwNln1xxZr1dB+wdSDu8uvIS19kvvl8YItk/k6OQf3AxV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="356094862"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="356094862"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 06:04:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="729273245"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="729273245"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 03 Feb 2023 06:04:44 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 55FF43B9; Fri,  3 Feb 2023 16:05:22 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        tipc-discussion@lists.sourceforge.net
Cc:     Andy Shevchenko <andy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Subject: [PATCH v1 2/3] genetlink: Use string_is_valid() helper
Date:   Fri,  3 Feb 2023 16:05:00 +0200
Message-Id: <20230203140501.67659-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203140501.67659-1-andriy.shevchenko@linux.intel.com>
References: <20230203140501.67659-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use string_is_valid() helper instead of cpecific memchr() call.
This shows better the intention of the call.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 net/netlink/genetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 600993c80050..d7616c1bda93 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -13,7 +13,7 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/socket.h>
-#include <linux/string.h>
+#include <linux/string_helpers.h>
 #include <linux/skbuff.h>
 #include <linux/mutex.h>
 #include <linux/bitmap.h>
@@ -457,7 +457,7 @@ static int genl_validate_assign_mc_groups(struct genl_family *family)
 
 		if (WARN_ON(grp->name[0] == '\0'))
 			return -EINVAL;
-		if (WARN_ON(memchr(grp->name, '\0', GENL_NAMSIZ) == NULL))
+		if (WARN_ON(!string_is_valid(grp->name, GENL_NAMSIZ)))
 			return -EINVAL;
 	}
 
-- 
2.39.1

