Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4D755181E
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 14:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242136AbiFTMCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 08:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242039AbiFTMCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 08:02:35 -0400
Received: from smtp11.infineon.com (smtp11.infineon.com [IPv6:2a00:18f0:1e00:4::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B36186E4;
        Mon, 20 Jun 2022 05:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1655726555; x=1687262555;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bkHDpmBEWnraMUb/Sst3HBAGHKmFjwjIRjj6H3I//YI=;
  b=CzlbhINuGDysLD0xQygc2g1PgBzP7hWBT75uDOjJX312w0R4uKfpl1nh
   v+F9qtJ1YB+0c5AQJwdySAgP3PDoKyyozM4SOcPeBUdeIzVySsdDYoNZe
   oukrQGDDdjxkvxZpuXjHQV6c7k6GHlnDYfSY/y//N/hKM2ZA24WDMFCUS
   E=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="301894347"
X-IronPort-AV: E=Sophos;i="5.92,306,1650924000"; 
   d="scan'208";a="301894347"
Received: from unknown (HELO mucxv002.muc.infineon.com) ([172.23.11.17])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 14:02:33 +0200
Received: from MUCSE812.infineon.com (MUCSE812.infineon.com [172.23.29.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv002.muc.infineon.com (Postfix) with ESMTPS;
        Mon, 20 Jun 2022 14:02:32 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 20 Jun
 2022 14:02:31 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 20 Jun 2022 14:02:30 +0200
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
Subject: [PATCH 0/4] Bluetooth: hci_bcm: Improve FW load time on CYW55572
Date:   Mon, 20 Jun 2022 14:01:25 +0200
Message-ID: <cover.1655723462.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE805.infineon.com (172.23.29.31) To
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

Hakan Jansson (4):
  dt-bindings: net: broadcom-bluetooth: Add CYW55572 DT binding
  Bluetooth: hci_bcm: Add DT compatible for CYW55572
  Bluetooth: hci_bcm: Prevent early baudrate setting in autobaud mode
  Bluetooth: hci_bcm: Increase host baudrate for CYW55572 in autobaud
    mode

 .../bindings/net/broadcom-bluetooth.yaml      |  1 +
 drivers/bluetooth/hci_bcm.c                   | 24 +++++++++++++------
 2 files changed, 18 insertions(+), 7 deletions(-)


base-commit: 0b537674e072a37dec2fcefef4df2317b58aaa3f
-- 
2.25.1

