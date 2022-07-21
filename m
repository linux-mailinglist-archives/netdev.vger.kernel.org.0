Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A8557D5B1
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 23:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiGUVPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 17:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbiGUVP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 17:15:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DEF4B0FE;
        Thu, 21 Jul 2022 14:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658438125; x=1689974125;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IgQ+/HMuFU5/Y784herXZ7Q8bHscE6snojWqY83h2XY=;
  b=h7tgSgY9SKbM9jeLKqPxssKLk58QOWsLNjAGTx+ErSNyKGqwzoO924Lr
   9WJGgijAiMw45zrYShdk7PKp55xZWCoMXbKl8pCJUTk0Agv6M6sVJl1zZ
   ZmliPFmMVZwvMyy5GRDsJc4Mi8WqQVcw8V9oTsGtnuZS6ceE0NC3JC/Hp
   lZTp1Kh0g5pioVRbD4WQRAWh42SNNfSNv20SRT7QVcySX5/BAzamAM1en
   VNBPWNCc0OH1RQOnl4HT6FT6UdzIgLZ/OCqx9dupMKW2BWuoy47X8HVtt
   tWO/LOKCczHUzsGH83c6exCgJnPt+NivqKhQEuy4kEApamP60i4SW+QpL
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="312892778"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="312892778"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 14:14:59 -0700
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="925816204"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 14:14:59 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-doc@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [iproute2-next v2 0/3] devlink: support dry run attribute for flash update
Date:   Thu, 21 Jul 2022 14:14:48 -0700
Message-Id: <20220721211451.2475600-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.35.1.456.ga9c7032d4631
In-Reply-To: <20220721211451.2475600-1-jacob.e.keller@intel.com>
References: <20220721211451.2475600-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow users to request a dry run of a flash update by adding the
DEVLINK_ATTR_DRY_RUN.

Because many devlink commands do not validate and reject unknown attributes,
this could have unexpected side effects on older kernels which lack the
attribute. To handle this, check the socket and determine the maximum
attribute the kernel supports. Only allow passing the DEVLINK_ATTR_DRY_RUN
for kernels which have the attribute.

This allows a user to validate that a flash update will be accepted by the
driver and device without being forced to commit to updating.

Changes since v1
* Add Cc for maintainers
* Make dl_kernel_supports_dry_run more generic

Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: linux-doc@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: intel-wired-lan@lists.osuosl.org

Jacob Keller (3):
  update <linux/devlink.h> UAPI header
  mnlg: add function to get CTRL_ATTR_MAXATTR value
  devlink: add dry run attribute support to devlink flash

 devlink/devlink.c            | 45 +++++++++++++++++++++++++++--
 devlink/mnlg.c               | 56 ++++++++++++++++++++++++++++++++++++
 devlink/mnlg.h               |  1 +
 include/uapi/linux/devlink.h |  8 ++++++
 4 files changed, 108 insertions(+), 2 deletions(-)


base-commit: 4cb0bec3744ac4f8d21de0e769f170e4059c6b9e
-- 
2.36.1

