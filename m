Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E486389E3
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiKYMfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiKYMfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:35:10 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501994B760
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 04:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669379709; x=1700915709;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mc7Od7XYGYoGaurxyko9c2tZRfh+P5cEKjX66w/8Ywc=;
  b=JWOYxS7vt8amxNbLdgsTAssNMCnd6BCvxn6pwDfkzQtARjCtvE7/9A+W
   j7l9ijKOmyPazy4NnSoOfQxY9TOADUs9MLttQEoeReM9U/PR5p2QM22Aw
   9lpkzR2Nmp3f5vJB9cJeTOP3QSvKSurEI13aB0DxDO2gC53o64mORdGSJ
   gCsVvEwJSCLQX2lLVdbiek/8TikRtKwxmIT4URhTJ4YeMDw6C24RXgJXx
   Ig9/SRKoLMCXpoWRImO24eREdabYqlhWqEaNlHG8KmsOJuqTmH2k3sXJ3
   VIDgw7jS+oJBkSdH/TpGTwXKKV6M0R8o1X2RSKniVDdZHmV+asboKx28U
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="314510218"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="314510218"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:34:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="711264052"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="711264052"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:34:53 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, przemyslaw.kitszel@intel.com,
        jiri@resnulli.us, wojciech.drewek@intel.com, dsahern@gmail.com,
        stephen@networkplumber.org,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH iproute2-next 5/5] devlink: Add documentation for tx_prority and tx_weight
Date:   Fri, 25 Nov 2022 13:34:21 +0100
Message-Id: <20221125123421.36297-6-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221125123421.36297-1-michal.wilczynski@intel.com>
References: <20221125123421.36297-1-michal.wilczynski@intel.com>
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

New netlink attributes tx_priority and tx_weight were added.
Update the man page for devlink-rate to account for new attributes.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 man/man8/devlink-rate.8 | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/man/man8/devlink-rate.8 b/man/man8/devlink-rate.8
index cc2f50c38619..bcec3c31673a 100644
--- a/man/man8/devlink-rate.8
+++ b/man/man8/devlink-rate.8
@@ -26,12 +26,16 @@ devlink-rate \- devlink rate management
 .RI "{ " DEV/PORT_INDEX " | " DEV/NODE_NAME " } "
 .RB [ " tx_share \fIVALUE " ]
 .RB [ " tx_max \fIVALUE " ]
+.RB [ " tx_priority \fIN " ]
+.RB [ " tx_weight \fIN " ]
 .RB "[ {" " parent \fINODE_NAME " | " noparent " "} ]"
 
 .ti -8
 .BI "devlink port function rate add " DEV/NODE_NAME
 .RB [ " tx_share \fIVALUE " ]
 .RB [ " tx_max \fIVALUE " ]
+.RB [ " tx_priority \fIN " ]
+.RB [ " tx_weight \fIN " ]
 .RB "[ {" " parent \fINODE_NAME " | " noparent " "} ]"
 
 .ti -8
@@ -83,6 +87,20 @@ rate group.
 .PP
 .BI tx_max " VALUE"
 - specifies maximum tx rate value.
+.PP
+.BI tx_priority " N"
+- allows for usage of strict priority arbiter among siblings. This arbitration
+scheme attempts to schedule nodes based on their priority as long as the nodes
+remain within their bandwidth limit. The higher the priority the higher the
+probability that the node will get selected for scheduling.
+.PP
+.BI tx_weight " N"
+- allows for usage of Weighted Fair Queuing arbitration scheme among siblings.
+This arbitration scheme can be used simultaneously with the strict priority.
+As a node is configured with a higher rate it gets more BW relative to it's
+siblings. Values are relative like a percentage points, they basically tell
+how much BW should node take relative to it's siblings.
+.PP
 .TP 8
 .I VALUE
 These parameter accept a floating point number, possibly followed by either a
@@ -123,6 +141,10 @@ To specify in IEC units, replace the SI prefix (k-, m-, g-, t-) with IEC prefix
 (ki-, mi-, gi- and ti-) respectively. Input is case-insensitive.
 .RE
 .PP
+.TP 8
+.I N
+These parameter accept integer meaning weight or priority of a node.
+.PP
 .BI parent " NODE_NAME \fR| " noparent
 - set rate object parent to existing node with name \fINODE_NAME\fR or unset
 parent. Rate limits of the parent node applied to all it's children. Actual
-- 
2.37.2

