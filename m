Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAFC14EEAA6
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 11:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344702AbiDAJrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 05:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiDAJre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 05:47:34 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2232C1E374B;
        Fri,  1 Apr 2022 02:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648806345; x=1680342345;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iPVk1AbhvLpAXE9zsYU+rbkWVNWdng16JCTK2F51FWU=;
  b=haiq5nnHhg3dRRRydSB+DC6gPCAFUn7zfKhFwMPJnE0JUTYAk5KJbGVR
   O2MRvQgULitKUsS4lxRopw/M4fOfTVTfLuXMBK5pF+BRaRfD1VXN2ukev
   /QH2lLlPKnFjh3cbN3aBzwX4mMS7o9rpZx8rOOZ3jeh0KxO+DmZFVfwHA
   5sGbMAFkq5017QFDVvwJffjXtCNdiwzU3D8fGlH2JlXHQjURbwe8alUMR
   r5UjLlGu9A4n7SDWOwTkqxMQOIDmtfuxd/ZHfFx/w88dBqpNXZ+B1cnNy
   CDoGb657uVUlHLMGi8I+88B6I4o4LGBQ1xaEo9aCjWFO9wibTASvZHLcf
   w==;
X-IronPort-AV: E=Sophos;i="5.90,226,1643698800"; 
   d="scan'208";a="158947681"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2022 02:45:45 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Apr 2022 02:45:45 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Apr 2022 02:45:42 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <Divya.Koppera@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 0/3] net: phy: micrel: Remove latencies support lan8814
Date:   Fri, 1 Apr 2022 11:48:02 +0200
Message-ID: <20220401094805.3343464-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the latencies support both from the PHY driver and from the DT.
The IP already has some default latencies values which can be used to get
decent results. It has the following values(defined in ns):
rx-1000mbit: 429
tx-1000mbit: 201
rx-100mbit:  2346
tx-100mbit:  705

---
But to get better results the following values needs to be set:
rx-1000mbit: 459
tx-1000mbit: 171
rx-100mbit:  1706
tx-100mbit:  1345

We are proposing to use ethtool to set these latencies, the RFC can be found
here[1]

[1] https://lkml.org/lkml/2022/4/1/231

Horatiu Vultur (3):
  dt-bindings: net: micrel: Revert latency support and timestamping
    check
  net: phy: micrel: Remove latency from driver
  net: phy: micrel: Remove DT option lan8814,ignore-ts

 .../devicetree/bindings/net/micrel.txt        |  17 ---
 drivers/net/phy/micrel.c                      | 106 +-----------------
 2 files changed, 2 insertions(+), 121 deletions(-)

-- 
2.33.0

