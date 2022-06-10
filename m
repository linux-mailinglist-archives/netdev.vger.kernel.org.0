Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91219546AC7
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345716AbiFJQrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241054AbiFJQrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:47:47 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4039EABF61;
        Fri, 10 Jun 2022 09:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654879666; x=1686415666;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ASHUK70l3jcIuhh1boRG1NOD4kHVjzcknTDu0uZ1whM=;
  b=anmp8LhLhxah4UzDCjR/c7zUXQtBXt+GKrCUAfEBSq5wZI2ShtwOwe1V
   IOSn1qfhHbbwixlXJjPXYr4KN3HpSPLRDjhsuxmUB8gAuX10LBgOMn5/p
   jnSIP1fPxi9mtT/9UGCZGln1yM4fc4JymsskgN3svholtkXD+gNsSc7xC
   uRtvwSy6DjcsHKVSeVbJeyW6M99WJf9fbQZTr0c1nTJJMs3DUIjpCgCWF
   pCEvK90q2ODCkkUw/JQBepTrvQZnrKuZJIyAbZGFugcFLw/eU0g1yWHTr
   hkM3CJPvYtfUk7ve0rVo7/Y7LohSyF/RDetSTu+HjhWUjL0bqWlU4ygAk
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="275209596"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="275209596"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:47:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638211025"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:47:42 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 0/6] Configurable VLAN mode for NCSI driver
Date:   Sat, 11 Jun 2022 00:45:49 +0800
Message-Id: <20220610164555.2322930-1-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently kernel kernel NCSI driver only supports the "VLAN + non-VLAN"
mode (Mode #2), but this mode is an optional mode [1] defined in NCSI
specification and some NCSI devices like Intel E810 Network Adapter [2]
does not support that mode. This patchset adds a new "ncsi,vlan-mode"
device tree property for configuring the VLAN mode of NCSI device.

[1] Table 58 - VLAN Enable Modes
    https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.0.0.pdf
[2] 12.6.5.4.3 VLAN
    https://cdrdv2.intel.com/v1/dl/getContent/613875

Jiaqing Zhao (6):
  net/ncsi: Fix value of NCSI_CAP_VLAN_ANY
  net/ncsi: Rename NCSI_CAP_VLAN_NO to NCSI_CAP_VLAN_FILTERED
  net/ncsi: Enable VLAN filtering when callback is registered
  ftgmac100: Remove enable NCSI VLAN filtering
  dt-bindings: net: Add NCSI bindings
  net/ncsi: Support VLAN mode configuration

 .../devicetree/bindings/net/ncsi.yaml         | 34 ++++++++++++++
 MAINTAINERS                                   |  2 +
 drivers/net/ethernet/faraday/ftgmac100.c      |  3 --
 include/dt-bindings/net/ncsi.h                | 15 ++++++
 net/ncsi/internal.h                           |  5 +-
 net/ncsi/ncsi-manage.c                        | 46 ++++++++++++++++---
 6 files changed, 93 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ncsi.yaml
 create mode 100644 include/dt-bindings/net/ncsi.h

-- 
2.34.1

