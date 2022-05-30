Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D674538549
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241644AbiE3PsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 11:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242623AbiE3PrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 11:47:22 -0400
Received: from smtp11.infineon.com (smtp11.infineon.com [IPv6:2a00:18f0:1e00:4::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF497985B2;
        Mon, 30 May 2022 08:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1653922976; x=1685458976;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2Fwi2HwRKBpC/iRQvdO6bnyE3pjO58eZV/y2mUE9RjE=;
  b=MM+vxTg0mme95jvvHqc35alevbTYaXa2HJ/TibxD/dee4giJlPPCQhxA
   UCfbjm6+WVtjzpEJsCogcN43Th5XyfGiA3TZPEszFzh6akgx6iIYP1D2x
   HlRh+vy25cGgWTTjJQl5G+RewfpoQouJDh+fwllDAg61tf95ZKoIGcwVS
   g=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="298846056"
X-IronPort-AV: E=Sophos;i="5.91,263,1647298800"; 
   d="scan'208";a="298846056"
Received: from unknown (HELO mucxv003.muc.infineon.com) ([172.23.11.20])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 17:02:53 +0200
Received: from MUCSE803.infineon.com (MUCSE803.infineon.com [172.23.29.29])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv003.muc.infineon.com (Postfix) with ESMTPS;
        Mon, 30 May 2022 17:02:53 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE803.infineon.com
 (172.23.29.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 30 May
 2022 17:02:53 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 30 May 2022 17:02:52 +0200
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
Subject: [PATCH v3 0/2] Bluetooth: hci_bcm: Autobaud mode support
Date:   Mon, 30 May 2022 17:02:16 +0200
Message-ID: <cover.1653916330.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE808.infineon.com (172.23.29.34) To
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

These patches add a DT property, "brcm,requires-autobaud-mode", to control
autobaud mode selection.

Changes v2 -> v3:
- Rename DT property and modify description in binding document

Changes v1 -> v2:
- Modify description in binding document

Hakan Jansson (2):
  dt-bindings: net: broadcom-bluetooth: Add property for autobaud mode
  Bluetooth: hci_bcm: Add support for FW loading in autobaud mode

 .../bindings/net/broadcom-bluetooth.yaml      |  7 +++++
 drivers/bluetooth/btbcm.c                     | 31 ++++++++++++++-----
 drivers/bluetooth/btbcm.h                     |  8 ++---
 drivers/bluetooth/hci_bcm.c                   | 16 ++++++++--
 4 files changed, 47 insertions(+), 15 deletions(-)


base-commit: 677fb7525331375ba2f90f4bc94a80b9b6e697a3
-- 
2.25.1

