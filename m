Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C788696ECB
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjBNVB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjBNVB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:01:26 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACA628236
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676408485; x=1707944485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XdQERGiLHuUWEuH1ilQnd8gcc6aswjrEnR65SaAwOpU=;
  b=iDMvTZ44RhPlbAQhk1FcMVnyddH9m7mgFR/Cj9XudEGQwTOdNDCIZfmA
   7opB3jOvqN74khDezer+PXzdaqRfTJMbIjsqANXxry540VXgklc0KbUc6
   PLXXRXn0uaxuMn8uZczTgzasyaHaW0poFU+VcXIWapX4u+ktNnh+4diZ8
   TtuCeeOA49n+E9C+aStxfqug/GZ/phqsk4/aM0I0YScqIOOQwd1uYhh3k
   tSasju13ZlVzDTZsAC99UgqyYyf6rkyHxNVgQrDJRwkW7EVgTP64pMd8f
   Qxr/HywTzKkkriBxicop3wSP6kJY1Gzv/w8TgnksG0JU0ZPouvQ1eWxwt
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="417490090"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="417490090"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:01:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="699677923"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="699677923"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:01:23 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        edumazet@google.com, Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next v1 2/2] net/core: refactor promiscuous mode message
Date:   Tue, 14 Feb 2023 13:01:17 -0800
Message-Id: <20230214210117.23123-3-jesse.brandeburg@intel.com>
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

The kernel stack can be more consistent by printing the IFF_PROMISC
aka promiscuous enable/disable messages with the standard netdev_info
message which can include bus and driver info as well as the device.

typical command usage from user space looks like:
ip link set eth0 promisc <on|off>

But lots of utilities such as bridge, tcpdump, etc put the interface into
promiscuous mode.

old message:
[  406.034418] device eth0 entered promiscuous mode
[  408.424703] device eth0 left promiscuous mode

new message:
[  406.034431] ice 0000:17:00.0 eth0: entered promiscuous mode
[  408.424715] ice 0000:17:00.0 eth0: left promiscuous mode

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
I'm unsure about this one because it's changing a long standard kernel
message to a slightly different format. I think the new way looks better
and has more information.
---
 net/core/dev.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ad1e6482e1c1..357081b0113c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8321,9 +8321,8 @@ static int __dev_set_promiscuity(struct net_device *dev, int inc, bool notify)
 		}
 	}
 	if (dev->flags != old_flags) {
-		pr_info("device %s %s promiscuous mode\n",
-			dev->name,
-			dev->flags & IFF_PROMISC ? "entered" : "left");
+		netdev_info(dev, "%s promiscuous mode\n",
+			    dev->flags & IFF_PROMISC ? "entered" : "left");
 		if (audit_enabled) {
 			current_uid_gid(&uid, &gid);
 			audit_log(audit_context(), GFP_ATOMIC,
-- 
2.31.1

