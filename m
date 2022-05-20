Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E31B52EEB7
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 17:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350610AbiETPHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 11:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242315AbiETPHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 11:07:36 -0400
Received: from smtp2.infineon.com (smtp2.infineon.com [IPv6:2a00:18f0:1e00:4::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB8B16F93A;
        Fri, 20 May 2022 08:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1653059255; x=1684595255;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3K84TAUIKPuR5hEf0cY3ZPMTrE3YV21Mg2XlWai4oE8=;
  b=beEwY4PcL7v64qU6w/7pEUsl1a6Ly32+gRYehkwNjGJckyUr8tKexsva
   AbEljmrwOBfmjdhk32kQI+EIZbwDYIEUEOOu9sgBkcvBk16h6TinYEsLi
   Mw5he81FeCCsFbLvdrnD6b0Z18Ek1z83OIarjQFsjMbYQ193T/wuUJ8Da
   U=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="179026240"
X-IronPort-AV: E=Sophos;i="5.91,239,1647298800"; 
   d="scan'208";a="179026240"
Received: from unknown (HELO mucxv001.muc.infineon.com) ([172.23.11.16])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 17:07:31 +0200
Received: from MUCSE805.infineon.com (MUCSE805.infineon.com [172.23.29.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv001.muc.infineon.com (Postfix) with ESMTPS;
        Fri, 20 May 2022 17:07:30 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE805.infineon.com
 (172.23.29.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 20 May
 2022 17:07:30 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 20 May 2022 17:07:29 +0200
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
Subject: [PATCH v2 0/2] Bluetooth: hci_bcm: Autobaud mode support
Date:   Fri, 20 May 2022 17:07:12 +0200
Message-ID: <cover.1653057480.git.hakan.jansson@infineon.com>
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
Autobaud mode can also be required on some boards where the controller
device is using a non-standard baud rate when first powered on.

Only a limited subset of HCI commands are supported in autobaud mode.

These patches add a DT property, "brcm,uses-autobaud-mode", to control
autobaud mode selection.

Changes v1 -> v2:
- Modify description in binding document

Hakan Jansson (2):
  dt-bindings: net: broadcom-bluetooth: Add property for autobaud mode
  Bluetooth: hci_bcm: Add support for FW loading in autobaud mode

 .../bindings/net/broadcom-bluetooth.yaml      |  9 ++++++
 drivers/bluetooth/btbcm.c                     | 31 ++++++++++++++-----
 drivers/bluetooth/btbcm.h                     |  8 ++---
 drivers/bluetooth/hci_bcm.c                   | 15 +++++++--
 4 files changed, 48 insertions(+), 15 deletions(-)


base-commit: 48b57999e38745b707abe233019786cc097df3c9
-- 
2.25.1

