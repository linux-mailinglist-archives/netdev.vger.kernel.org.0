Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9020561AA8
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 14:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbiF3MqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 08:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234645AbiF3MqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 08:46:10 -0400
Received: from smtp14.infineon.com (smtp14.infineon.com [IPv6:2a00:18f0:1e00:4::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D1E21E26;
        Thu, 30 Jun 2022 05:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1656593169; x=1688129169;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QnKUrF1xtCRy+TRTqlyWJSzVsbsYzCUcUrYS+EXrtGc=;
  b=pzfroQz0VBN7n3OSG0EVsJSCLZvne6JedFDmdW0uXZhEECUJU9usoJr9
   mUaZS5Z7bX6fTzk15MjP37JYWiPg0SungtQO5qpMQX5jXXbOwYQGURWJH
   OXo6FeH6/pEubYLRPrr1pawiMW4iULEdw4I3BUjYdaSpZTyGYKbCBGEMd
   0=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="129108385"
X-IronPort-AV: E=Sophos;i="5.92,234,1650924000"; 
   d="scan'208";a="129108385"
Received: from unknown (HELO mucxv003.muc.infineon.com) ([172.23.11.20])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:46:06 +0200
Received: from MUCSE819.infineon.com (MUCSE819.infineon.com [172.23.29.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv003.muc.infineon.com (Postfix) with ESMTPS;
        Thu, 30 Jun 2022 14:46:05 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE819.infineon.com
 (172.23.29.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 30 Jun
 2022 14:46:05 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 14:46:03 +0200
From:   Hakan Jansson <hakan.jansson@infineon.com>
CC:     Hakan Jansson <hakan.jansson@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
Subject: [PATCH v2 0/5] Bluetooth: hci_bcm: Improve FW load time on CYW55572
Date:   Thu, 30 Jun 2022 14:45:19 +0200
Message-ID: <cover.1656583541.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE824.infineon.com (172.23.29.55) To
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

These patches add an optional device specific data member to specify max
baudrate of a device when in autobaud mode. This allows the host to set a
first baudrate higher than "init speed" to improve FW load time.

The host baudrate will later be changed to "init speed" (as usual) once FW
loading is complete and the device has been reset to begin normal
operation.

Changes v1 -> v2:
- Add patch to tighten DT binding constraints after feedback in:
    https://lore.kernel.org/linux-devicetree/174363bc-e8e5-debd-f8f6-a252d2bbddb9@infineon.com/
- Add actual baud rates and example FW load time in commit message:
    https://lore.kernel.org/linux-devicetree/72cd312f-f843-6a85-b9e7-db8fcb952af8@infineon.com/

Hakan Jansson (5):
  dt-bindings: net: broadcom-bluetooth: Add CYW55572 DT binding
  dt-bindings: net: broadcom-bluetooth: Add conditional constraints
  Bluetooth: hci_bcm: Add DT compatible for CYW55572
  Bluetooth: hci_bcm: Prevent early baudrate setting in autobaud mode
  Bluetooth: hci_bcm: Increase host baudrate for CYW55572 in autobaud
    mode

 .../bindings/net/broadcom-bluetooth.yaml      | 17 +++++++++++++
 drivers/bluetooth/hci_bcm.c                   | 24 +++++++++++++------
 2 files changed, 34 insertions(+), 7 deletions(-)


base-commit: 681ec6abcd7f051f7fc318068a3ac09772ebef7e
-- 
2.25.1

