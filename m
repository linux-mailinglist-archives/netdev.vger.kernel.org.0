Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE00519B18
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 11:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346730AbiEDJIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 05:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiEDJIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 05:08:10 -0400
Received: from smtp14.infineon.com (smtp14.infineon.com [IPv6:2a00:18f0:1e00:4::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BFA1705B;
        Wed,  4 May 2022 02:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1651655075; x=1683191075;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pmRtOTWex9hNEf+BFE9wMMYebJAIk/+hxIQsxl8B6Ls=;
  b=Yi2opl/gZSSMawr92FqfCTsvQoRfoMP/I95xaAkgDxcc4XRutJoazvfM
   wb65/3Jekecy9KsyTvj45MMc03wDF0eK2axCv5Q1dFh9K9JBe+l9nAw11
   zsFX21J8ajXXXpLraKxBUA/AFXK8qlT7FvpEOyl/03vYVZWVs8dlVDqAb
   s=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="119183638"
X-IronPort-AV: E=Sophos;i="5.91,197,1647298800"; 
   d="scan'208";a="119183638"
Received: from unknown (HELO mucxv002.muc.infineon.com) ([172.23.11.17])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 11:04:33 +0200
Received: from MUCSE814.infineon.com (MUCSE814.infineon.com [172.23.29.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv002.muc.infineon.com (Postfix) with ESMTPS;
        Wed,  4 May 2022 11:04:33 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 4 May 2022
 11:04:32 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 4 May 2022 11:04:32 +0200
From:   Hakan Jansson <hakan.jansson@infineon.com>
CC:     Hakan Jansson <hakan.jansson@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
Subject: [PATCH 0/2] Bluetooth: hci_bcm: Autobaud mode support
Date:   Wed, 4 May 2022 11:03:38 +0200
Message-ID: <cover.1651647576.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE815.infineon.com (172.23.29.41) To
 MUCSE807.infineon.com (172.23.29.33)
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices (e.g. CYW5557x) require autobaud mode to enable FW loading.
Autobaud mode can also be required on some boards where the controller device
is using a non-standard baud rate when first powered on.

Only a limited subset of HCI commands are supported in autobaud mode.

These patches add a DT property, "brcm,uses-autobaud-mode", to control autobaud
mode selection.

Hakan Jansson (2):
  dt-bindings: net: broadcom-bluetooth: Add property for autobaud mode
  Bluetooth: hci_bcm: Add support for FW loading in autobaud mode

 .../bindings/net/broadcom-bluetooth.yaml      |  7 +++++
 drivers/bluetooth/btbcm.c                     | 31 ++++++++++++++-----
 drivers/bluetooth/btbcm.h                     |  8 ++---
 drivers/bluetooth/hci_bcm.c                   | 15 +++++++--
 4 files changed, 46 insertions(+), 15 deletions(-)


base-commit: 48b57999e38745b707abe233019786cc097df3c9
-- 
2.25.1

