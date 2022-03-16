Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F684DAEB3
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 12:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355260AbiCPLN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 07:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355244AbiCPLNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 07:13:24 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43FA64BE0
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 04:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647429129; x=1678965129;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/UEnuXCrSN2AgWnR5cJ2BOkbfokoZMrbzdVHWDzfKhE=;
  b=FDoWYDiMc8/UYHn8B0jcoeGpdm+Xzcoeu9BsMOR9aGmRAmSfOdxLEY4K
   ++jfGFredjNK7fHFMZ69bje6yYl+DYtmx0MciysX05bUa0tjcfV5MG+Mc
   pXv2XgEqbSy0eQielmN/46Nf/hGpZ0DHCqpLfniixmUlm/Ro4OXc5RJgJ
   m6mnWzJwEyEHeX0STS8ViKDNMfmBNH/u3vGGI013OXdOrL7hUabMiwSZQ
   XjejDgEsqg9szL3NRSFGzUP1VVGJFS+mU0/JXR3ehSOepfoyxebIyY70Y
   NBdiyDupSEcUqgKpxssUluKdB5IDoZoH1nfpU9wKqvg3BWdsTZvDTJEbh
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238717917"
X-IronPort-AV: E=Sophos;i="5.90,186,1643702400"; 
   d="scan'208";a="238717917"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 04:12:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,186,1643702400"; 
   d="scan'208";a="820568968"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2022 04:12:07 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22GBC69V016809;
        Wed, 16 Mar 2022 11:12:06 GMT
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org
Subject: [PATCH iproute2-next v5 0/2] GTP support for ip link and tc flowers
Date:   Wed, 16 Mar 2022 12:08:13 +0100
Message-Id: <20220316110815.46779-1-wojciech.drewek@intel.com>
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
 include/uapi/linux/pkt_cls.h |  16 +++++
 ip/Makefile                  |   2 +-
 ip/iplink.c                  |   2 +-
 ip/iplink_gtp.c              | 128 +++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        |  29 +++++++-
 man/man8/tc-flower.8         |  10 +++
 tc/f_flower.c                | 123 ++++++++++++++++++++++++++++++++-
 8 files changed, 307 insertions(+), 5 deletions(-)
 create mode 100644 ip/iplink_gtp.c

-- 
2.31.1

