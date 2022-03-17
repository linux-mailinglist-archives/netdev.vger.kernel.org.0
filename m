Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259D14DCB7B
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbiCQQdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236581AbiCQQdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:33:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD202214FBB
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647534716; x=1679070716;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Pc/IPoCzgZAu5IQhNM3WrpSkFLY/CHoDuI0WUo4ToYg=;
  b=TKI6Wd5wxogJ4H0AZiKqkCNqC0hOuM4mFE5B8+ScqCBBOgjKt3OVgu8S
   noZ57GNfJl/YFKUfm3yyc6gpi7UpgTOVdy2NhjGlYZs8evQxvQQWCrYOn
   Ook22SE53nspBJSYodP/hpiDRIujqylWHkZTzVecbo1GjEi43oIsgd5Bz
   ZscWDOj2N7c5oQzkn+8kmZ/H+87twMsgSpJ4kiqA3yLxNcfRezO2a/S8x
   ox1x3XYfD3QQ4WzCn3Hnc53ZXFhoP2vNHtWMU7ZExY5qx5pTjvH8huZ9B
   KEJdQVlh2IIpmhJ+f4HkwdIwvn9YfbClCisjmZR6Pza7b0T+9c+W0bo2t
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="239070832"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="239070832"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 09:31:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="645151460"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 17 Mar 2022 09:31:51 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22HGVoCm012391;
        Thu, 17 Mar 2022 16:31:50 GMT
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, jiri@mellanox.com
Subject: [PATCH iproute2-next v7 0/2] GTP support for ip link and tc flowers
Date:   Thu, 17 Mar 2022 17:27:53 +0100
Message-Id: <20220317162755.4359-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduces GTP support to iproute2. Since this patch
series it is possible to create net devices of GTP type. Then, those
devices can be used in tc in order to offload GTP packets. New field
in tc flower (gtp_opts) can be used to match on QFI and PDU type.

Kernel changes (merged):
https://lore.kernel.org/netdev/164708701228.11169.15700740251869229843.git-patchwork-notify@kernel.org/

---
v4: updated link to merged kernel changes
v5: restore changelogs, they were missing in
    previous version

Wojciech Drewek (2):
  ip: GTP support in ip link
  f_flower: Implement gtp options support

 include/uapi/linux/if_link.h |   2 +
 include/uapi/linux/pkt_cls.h |  16 ++++
 ip/Makefile                  |   2 +-
 ip/iplink.c                  |   2 +-
 ip/iplink_gtp.c              | 140 +++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        |  29 +++++++-
 man/man8/tc-flower.8         |  10 +++
 tc/f_flower.c                | 123 +++++++++++++++++++++++++++++-
 8 files changed, 319 insertions(+), 5 deletions(-)
 create mode 100644 ip/iplink_gtp.c

-- 
2.31.1

