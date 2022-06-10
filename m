Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A09546B5C
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349989AbiFJRD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349703AbiFJRD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:03:56 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31D936309;
        Fri, 10 Jun 2022 10:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654880636; x=1686416636;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KCOq1PpyCcIxMgdXYIM64iFVa3doD4/Vl/wvD0yNXSI=;
  b=M5g9APZQUC328TYHXhfksKykvnPuwMEbs/Qnr1jkEJZjThpPj7i1zlmo
   BO+ellMsBtoYlQ6MENAcn6f782wKQMlGwsBYats2fCsAbxZdg53rS24EK
   uV49s2kAcrYapF2Ja8AV7DaYtPTwVaTyUqIVb9INrGkmA6wQCsxQ3/+fJ
   +4sJ/nhHC6H9iPDUxFgJcGLhBPJHOuazcDBAyyW9/y7xBRiZShYGoPoMf
   J4D4QTPixvkFjcE9Q+uEvEXUEcz1lNvr9HOlFSuXJNTrjmcL+jkgZOIXG
   yr9IsaXaexmuTLUpEAPJbOxM+Ze+3B9MoewJBuEJcTXEleSqpr2nFuida
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="266452751"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="266452751"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 10:03:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638218739"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 10:03:52 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH v2 0/6] Configurable VLAN mode for NCSI driver
Date:   Sat, 11 Jun 2022 00:59:34 +0800
Message-Id: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently kernel NCSI driver only supports the "VLAN + non-VLAN" mode
(Mode #2), but this mode is an optional mode [1] defined in NCSI spec
and some NCSI devices like Intel E810 Network Adapter [2] does not
support that mode. This patchset adds a new "ncsi,vlan-mode" device
tree property for configuring the VLAN mode of NCSI device.

[1] Table 58 - VLAN Enable Modes
    https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.0.0.pdf
[2] 12.6.5.4.3 VLAN
    https://cdrdv2.intel.com/v1/dl/getContent/613875

v2:
- Fix indentation

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

