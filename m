Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01ADF69454B
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 13:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjBMMKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 07:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjBMMKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 07:10:09 -0500
Received: from smtp-out-12.comm2000.it (smtp-out-12.comm2000.it [212.97.32.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AC05FD3;
        Mon, 13 Feb 2023 04:09:44 -0800 (PST)
Received: from francesco-nb.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-12.comm2000.it (Postfix) with ESMTPSA id 149BCBA1877;
        Mon, 13 Feb 2023 13:09:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1676290172;
        bh=GbEIxLl6y8dz6WJwUG7aLe6/sMDkURLygpPDcrzPJAE=;
        h=From:To:Cc:Subject:Date;
        b=y/cHB2uJ4HGW62nr/5wsuGo+YWegiqYd/CqAUlvQ0/VbjdVKGfGFjX+3gweoDCigd
         cdtdM7vjfFjtnnlIm/IcmM6gNp+BKkNeW3pBeTzOTuVvWUN9K7Fl81f9xbAjAe+q3Q
         JSeE1GjreZYhAtV6zOLkK9Wq138anu6uOyOd9ciXiuWaBLm8oaXnGjmK6QnEQ7Fwr9
         ctfvDVf5K3TfKpUsbDmIcFzPQ7cKmj3FpmJuJl9D3OLPoLIT3pP7vPd9HhgnvvGD6P
         A0BEVZ8eXOm07OllpJG/e+usO9VbSdGMPHuUBPiQHFva8kZY15h9ga0IpjIDZvOCKF
         NKiTlM6ngEAwQ==
From:   Francesco Dolcini <francesco@dolcini.it>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3 0/5] Bluetooth: hci_mrvl: Add serdev support for 88W8997
Date:   Mon, 13 Feb 2023 13:09:21 +0100
Message-Id: <20230213120926.8166-1-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Francesco Dolcini <francesco.dolcini@toradex.com>

Add serdev support for the 88W8997 from NXP (previously Marvell). It includes
support for changing the baud rate. The command to change the baud rate is
taken from the user manual UM11483 Rev. 9 in section 7 (Bring-up of Bluetooth
interfaces) from NXP.

v3:
 - Use __hci_cmd_sync_status instead of __hci_cmd_sync 

v2:
 - Fix the subject as pointed out by Krzysztof. Thanks!
 - Fix indentation in marvell-bluetooth.yaml
 - Fix compiler warning for kernel builds without CONFIG_OF enabled

Stefan Eichenberger (5):
  dt-bindings: bluetooth: marvell: add 88W8997
  dt-bindings: bluetooth: marvell: add max-speed property
  Bluetooth: hci_mrvl: use maybe_unused macro for device tree ids
  Bluetooth: hci_mrvl: Add serdev support for 88W8997
  arm64: dts: imx8mp-verdin: add 88W8997 serdev to uart4

 .../bindings/net/marvell-bluetooth.yaml       | 20 ++++-
 .../dts/freescale/imx8mp-verdin-wifi.dtsi     |  5 ++
 drivers/bluetooth/hci_mrvl.c                  | 90 ++++++++++++++++---
 3 files changed, 104 insertions(+), 11 deletions(-)

-- 
2.25.1

