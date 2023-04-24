Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A006ECEE3
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjDXNgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbjDXNfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:35:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCA68A69;
        Mon, 24 Apr 2023 06:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A56623E2;
        Mon, 24 Apr 2023 13:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D9EC433A8;
        Mon, 24 Apr 2023 13:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682343335;
        bh=6QodnrciojxglL0zQGk0v0AqbE8UmmLAXDHHgyq63Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cblEhHml42NOB7BxU1wxTznX+PWdsNzxQA50FF9CxEUN5jyRM+VXzU4Cqxnm3DgfJ
         4zg0L2fmt3ttvm8IZ4YfZW0TjsInkEpQmKJkzZ3cWhiEqtutW8GOQFeEGoMeLHQJas
         Z1CetNq0w4LXkXYoV3z+/CBsi3glZzFd3Rq1S4B6zEUyUseEI6pXVnKqFEjiYMn/4C
         qpHDwST6zE7EJedGXFBfpBAOHaK6jgixlVqL7EXjJpRYWHYpqbOBQenlpAFbPVvoot
         qL/JMkuBMNL27QUV+zj7N43DB63ScEmurslQdt0HWcplzmqMlWDfIghf6P7f8VrX/y
         ORe3LQmdgG1aQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pqwMC-0003kK-7G; Mon, 24 Apr 2023 15:35:52 +0200
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
Subject: [PATCH 1/2] Bluetooth: fix invalid-bdaddr quirk for non-persistent setup
Date:   Mon, 24 Apr 2023 15:35:41 +0200
Message-Id: <20230424133542.14383-2-johan+linaro@kernel.org>
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

Once configured, the device address must be set on every setup for
controllers with HCI_QUIRK_NON_PERSISTENT_SETUP to avoid marking the
controller as unconfigured and requiring the address to be set again.

Fixes: 740011cfe948 ("Bluetooth: Add new quirk for non-persistent setup settings")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 net/bluetooth/hci_sync.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index a8785126df75..f45598b5a532 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4573,23 +4573,17 @@ static int hci_dev_setup_sync(struct hci_dev *hdev)
 	invalid_bdaddr = test_bit(HCI_QUIRK_INVALID_BDADDR, &hdev->quirks);
 
 	if (!ret) {
-		if (test_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks)) {
-			if (!bacmp(&hdev->public_addr, BDADDR_ANY))
-				hci_dev_get_bd_addr_from_property(hdev);
-
-			if (bacmp(&hdev->public_addr, BDADDR_ANY) &&
-			    hdev->set_bdaddr) {
-				ret = hdev->set_bdaddr(hdev,
-						       &hdev->public_addr);
-
-				/* If setting of the BD_ADDR from the device
-				 * property succeeds, then treat the address
-				 * as valid even if the invalid BD_ADDR
-				 * quirk indicates otherwise.
-				 */
-				if (!ret)
-					invalid_bdaddr = false;
-			}
+		if (test_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks) &&
+		    !bacmp(&hdev->public_addr, BDADDR_ANY))
+			hci_dev_get_bd_addr_from_property(hdev);
+
+		if ((invalid_bdaddr ||
+		     test_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks)) &&
+		    bacmp(&hdev->public_addr, BDADDR_ANY) &&
+		    hdev->set_bdaddr) {
+			ret = hdev->set_bdaddr(hdev, &hdev->public_addr);
+			if (!ret)
+				invalid_bdaddr = false;
 		}
 	}
 
-- 
2.39.2

