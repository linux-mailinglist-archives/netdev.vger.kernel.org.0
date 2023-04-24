Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057236ECEE0
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjDXNgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbjDXNfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:35:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5AD196;
        Mon, 24 Apr 2023 06:35:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2261F62332;
        Mon, 24 Apr 2023 13:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E89BC433EF;
        Mon, 24 Apr 2023 13:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682343335;
        bh=HMtBQELFN9fhTXYtgqc3NqK66rbPQYn9IisD7ItTMJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NM031X7OQ1oQl17XIpcIdy+hf7ZonNI+EzmBBgUzCBQ0S74xtwh/Ymixk+XDsQUAF
         fJkfHmV9k4Lgrca7VvZgiWCDBHJKxrKaFZuKmb+rqmQL+3z7G2wCtqTbyHdhF2/Eke
         I2c910Juoo+Y1tsSSgqNiDaAJcvCFJhUHzlmPXNtduPcWLltv4hcx1+MNE+LRKdTlR
         TFjP7QKY9mkpfSBgQ/5yBHrQeF3kcSoxxM4YCD/Ph5RGyBISko70DffBHtjZCydxdi
         lBsEUexSd3NKLgxZ1Wp1ffBIDwSCqw2LtLgWmFZGORbFHioN0WrHnw9sllFif/6cWA
         L7HqHO6O6VmXQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pqwMC-0003kM-A7; Mon, 24 Apr 2023 15:35:52 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Matthias Kaehlcke <mka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 2/2] Bluetooth: fix use-bdaddr-property quirk
Date:   Mon, 24 Apr 2023 15:35:42 +0200
Message-Id: <20230424133542.14383-3-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230424133542.14383-1-johan+linaro@kernel.org>
References: <20230424133542.14383-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devices that lack persistent storage for the device address can indicate
this by setting the HCI_QUIRK_INVALID_BDADDR which causes the controller
to be marked as unconfigured until user space has set a valid address.

The related HCI_QUIRK_USE_BDADDR_PROPERTY was later added to similarly
indicate that the device lacks a valid address but that one may be
specified in the devicetree.

As is clear from commit 7a0e5b15ca45 ("Bluetooth: Add quirk for reading
BD_ADDR from fwnode property") that added and documented this quirk and
commits like de79a9df1692 ("Bluetooth: btqcomsmd: use
HCI_QUIRK_USE_BDADDR_PROPERTY"), the device address of controllers with
this flag should be treated as invalid until user space has had a chance
to configure the controller in case the devicetree property is missing.

As it does not make sense to allow controllers with invalid addresses,
restore the original semantics, which also makes sure that the
implementation is consistent (e.g. get_missing_options() indicates that
the address must be set) and matches the documentation (including
comments in the code, such as, "In case any of them is set, the
controller has to start up as unconfigured.").

Fixes: e668eb1e1578 ("Bluetooth: hci_core: Don't stop BT if the BD address missing in dts")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 net/bluetooth/hci_sync.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index f45598b5a532..cc925a240f3b 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4570,16 +4570,14 @@ static int hci_dev_setup_sync(struct hci_dev *hdev)
 	 * BD_ADDR invalid before creating the HCI device or in
 	 * its setup callback.
 	 */
-	invalid_bdaddr = test_bit(HCI_QUIRK_INVALID_BDADDR, &hdev->quirks);
-
+	invalid_bdaddr = test_bit(HCI_QUIRK_INVALID_BDADDR, &hdev->quirks) ||
+			 test_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
 	if (!ret) {
 		if (test_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks) &&
 		    !bacmp(&hdev->public_addr, BDADDR_ANY))
 			hci_dev_get_bd_addr_from_property(hdev);
 
-		if ((invalid_bdaddr ||
-		     test_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks)) &&
-		    bacmp(&hdev->public_addr, BDADDR_ANY) &&
+		if (invalid_bdaddr && bacmp(&hdev->public_addr, BDADDR_ANY) &&
 		    hdev->set_bdaddr) {
 			ret = hdev->set_bdaddr(hdev, &hdev->public_addr);
 			if (!ret)
-- 
2.39.2

