Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF3D598F6D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 23:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347132AbiHRVYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 17:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347105AbiHRVYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 17:24:17 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB05D0772
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 14:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660857419; x=1692393419;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tExBpa3O5D1jZpgs9Z5EKf/JBmi28ZaRaqvxiMOpCt4=;
  b=adDvzKcu3WV7H882b04FmyufELUi5pGJZY6NKeSg98qf2X61r4zcjxYW
   qYVp2rdbrHBSAMyQ4lQIuBD+rZdDLnjasY+J/lED3Gy7pbJD8C60fuNG0
   WmxyGyfBSSYG04UIB7MIRmNQuy2PYmQAsQaYxN70Ov0m4zdgpLcg6Bx6j
   BjOZyGub5oPxOdMGOo5CBt6U3PUty3bRuN15ZcnuYIzqNPS1Fohstub6q
   9LXPbtyqPeRsuwP9lrBLAYtPG5Sq0fc8bczSoKJaGgKQIySLD/WqaZ15a
   la4cAa9z/UAQWAsn6iL7ay89CHBBU/C9TaAp+fnhHK5bJvhmXeC4Pwbld
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="293661513"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="293661513"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 14:15:28 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="641016158"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 14:15:28 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [iproute2-next 0/2] devlink: remove dl_argv_parse_put
Date:   Thu, 18 Aug 2022 14:15:19 -0700
Message-Id: <20220818211521.169569-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.394.gc50926e1f488
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series removes the dl_argv_parse_put function which both parses the
command line arguments and places them into the netlink header.

This was originally sent as an RFC at
https://lore.kernel.org/netdev/20220805234155.2878160-1-jacob.e.keller@intel.com/

Since there is some ongoing work around policy code being generated from
YAML, I thought it best to wait on the devlink policy portion of this series
for now.

Jiri mentioned he wanted to base some work on top of this, so I am sending
just the cleanup patches.

The primary motivation for this is due to the fact that dl_argv_parse_put
requires a netlink header, meaning a command must have already been
prepared. This prevents addition of a different netlink command to get the
policy data, and thus prevents us from using this variant while checking
netlink policy.

Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org

Jacob Keller (2):
  devlink: use dl_no_arg instead of checking dl_argc == 0
  devlink: remove dl_argv_parse_put

 devlink/devlink.c | 587 ++++++++++++++++++++++++++--------------------
 1 file changed, 329 insertions(+), 258 deletions(-)


base-commit: 700a8991f05e6e37889101196a531cf82777bdf7
-- 
2.37.1.394.gc50926e1f488

