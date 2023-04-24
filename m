Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0A76ECC53
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 14:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjDXMu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 08:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbjDXMuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 08:50:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C184C0E;
        Mon, 24 Apr 2023 05:50:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D25E61F2D;
        Mon, 24 Apr 2023 12:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67E2C433EF;
        Mon, 24 Apr 2023 12:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682340602;
        bh=doty7Nzt+HL2eXizgefudpBTTJskbLd1/KbCneDfvBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3E+bHqoklmEQDfyF6vGU4XrflewNvEr9ugq5EkTvqYq3TkA3rdNPFnPVzpLpayR2
         aC3CRIGGm2dcI9JX6c4CwWlQswX5IK1JlTdAVWnmsaTZYIxgZ54/aZTpMP+2mMxVa+
         OyJRsQPIiKlmPESbtEYJB1uihIgBkfWITm5Lv4kGrhgcoQn0SCjd1UpP7CEaVzqjh0
         TosHtmvyg6tk02NV7ZOzk83U3D6Upz6tJ3Pq803oSo5TEsNuObxbsRd3i8e49Dygzp
         Im7YTrRwN01AC1vo2VvgrO5exFWwRwi563bvuN6YVqUqLbGkBcJATcKISR8B09jE5e
         qlxFb5cmRj8CQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pqve7-0003IX-6f; Mon, 24 Apr 2023 14:50:19 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] Bluetooth: fix debugfs registration
Date:   Mon, 24 Apr 2023 14:48:51 +0200
Message-Id: <20230424124852.12625-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230424124852.12625-1-johan+linaro@kernel.org>
References: <20230424124852.12625-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit ec6cef9cd98d ("Bluetooth: Fix SMP channel registration for
unconfigured controllers") the debugfs interface for unconfigured
controllers will be created when the controller is configured.

There is however currently nothing preventing a controller from being
configured multiple time (e.g. setting the device address using btmgmt)
which results in failed attempts to register the already registered
debugfs entries:

	debugfs: File 'features' in directory 'hci0' already present!
	debugfs: File 'manufacturer' in directory 'hci0' already present!
	debugfs: File 'hci_version' in directory 'hci0' already present!
	...
	debugfs: File 'quirk_simultaneous_discovery' in directory 'hci0' already present!

Add a controller flag to avoid trying to register the debugfs interface
more than once.

Fixes: ec6cef9cd98d ("Bluetooth: Fix SMP channel registration for unconfigured controllers")
Cc: stable@vger.kernel.org      # 4.0
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 include/net/bluetooth/hci.h | 1 +
 net/bluetooth/hci_sync.c    | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 400f8a7d0c3f..b8bca65bcd79 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -335,6 +335,7 @@ enum {
 enum {
 	HCI_SETUP,
 	HCI_CONFIG,
+	HCI_DEBUGFS_CREATED,
 	HCI_AUTO_OFF,
 	HCI_RFKILLED,
 	HCI_MGMT,
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 632be1267288..a8785126df75 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4501,6 +4501,9 @@ static int hci_init_sync(struct hci_dev *hdev)
 	    !hci_dev_test_flag(hdev, HCI_CONFIG))
 		return 0;
 
+	if (hci_dev_test_and_set_flag(hdev, HCI_DEBUGFS_CREATED))
+		return 0;
+
 	hci_debugfs_create_common(hdev);
 
 	if (lmp_bredr_capable(hdev))
-- 
2.39.2

