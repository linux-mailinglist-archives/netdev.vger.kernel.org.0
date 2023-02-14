Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553A8696ECA
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbjBNVB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbjBNVBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:01:25 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18812823B
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676408484; x=1707944484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GXLHiMIDgAttvwbqRAYYGaig24AOFGRXzHGq4FyP91Y=;
  b=LKJC82x3D5VDOfwRMgrYtpZG+9RkWP/9xx1t8gy0WjMhELWm9jxi3Lc9
   pNPA287rrMVzxgoPVSnzSS98jYL4msb1PCWhf2yqPF0sTMKWJ8qZ02V5W
   RArruP4Q9JRBvOtaI/6KcYdR625BTT6JAwUf+kEVogLwVTWzmBt5eZggJ
   fMPTvn0hSmE1sAYAeetjceMaPkjRHEjtvQ8Ajgrbl89GMbJ7VXxBOgfSe
   KCYFZf781xP2ZL5nLe4CIMb2lJPW/IO+L1t/pFI0FN4ZDB7RQS0q+4poA
   NL4pkR1gjRSJLKezuyLQgN4V5lI516DP87lIB0yLMcOYnYbQmTg+rV67K
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="417490084"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="417490084"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:01:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="699677921"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="699677921"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:01:23 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        edumazet@google.com, Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next v1 1/2] net/core: print message for allmulticast
Date:   Tue, 14 Feb 2023 13:01:16 -0800
Message-Id: <20230214210117.23123-2-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230214210117.23123-1-jesse.brandeburg@intel.com>
References: <20230214210117.23123-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the user sets or clears the IFF_ALLMULTI flag in the netdev, there are
no log messages printed to the kernel log to indicate anything happened.
This is inexplicably different from most other dev->flags changes, and
could suprise the user.

Typically this occurs from user-space when a user:
ip link set eth0 allmulticast <on|off>

However, other devices like bridge set allmulticast as well, and many
other flows might trigger entry into allmulticast as well.

The new message uses the standard netdev_info print and looks like:
[  413.246110] ixgbe 0000:17:00.0 eth0: entered allmulticast mode
[  415.977184] ixgbe 0000:17:00.0 eth0: left allmulticast mode

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7307a0c15c9f..ad1e6482e1c1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8391,6 +8391,8 @@ static int __dev_set_allmulti(struct net_device *dev, int inc, bool notify)
 		}
 	}
 	if (dev->flags ^ old_flags) {
+		netdev_info(dev, "%s allmulticast mode\n",
+			    dev->flags & IFF_ALLMULTI ? "entered" : "left");
 		dev_change_rx_flags(dev, IFF_ALLMULTI);
 		dev_set_rx_mode(dev);
 		if (notify)
-- 
2.31.1

