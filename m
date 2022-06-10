Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C8B546AFF
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349867AbiFJQuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349887AbiFJQt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:49:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3767527CD1;
        Fri, 10 Jun 2022 09:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654879796; x=1686415796;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ASHUK70l3jcIuhh1boRG1NOD4kHVjzcknTDu0uZ1whM=;
  b=WOJCqrMNu1lUvIlcXVoQMudYsVI59l4XiQq/rCI0eStd0FeMsima5FKt
   ToOY81Jkm+uOZDfUACzjiS40qFgHkFhK1DwBMpKQYJssJNmbn5xXG37j2
   b7KyxmgnvLhI9R9O3fX31vQKFC7VqB61KP4pVa9ymQG33L5nv27cxZJOI
   +JvwqR/1uY3VGSISJeVq+8VjQs8/+1e5dQYwMyaaYZnBUvgWIzSG5imgN
   FUWtma/mwvfKCCzmfFN/9aoKxjZ13GSpifh5kWZeYjPrfCULcTWGMCpvq
   /qpxbjpR6WJbrV5SevC1LJPgkf52rWXP38ARlfoxjVkCpkjsMas3IZpLT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="339432521"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="339432521"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:49:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="760587687"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:49:48 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 0/6] Configurable VLAN mode for NCSI driver
Date:   Sat, 11 Jun 2022 00:48:02 +0800
Message-Id: <20220610164808.2323340-1-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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

