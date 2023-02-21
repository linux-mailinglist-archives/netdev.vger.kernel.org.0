Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6296469D89E
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 03:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbjBUCkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 21:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbjBUCjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 21:39:48 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45999234F4;
        Mon, 20 Feb 2023 18:39:47 -0800 (PST)
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 1F82B406AF;
        Tue, 21 Feb 2023 02:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1676947185;
        bh=jXActFRB2e7tUmIdxW8pUWDAQLwCu7muuixpsDg2eGI=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=e4Ciw8nS8VyWd/Hlq1uY4k0iXL6mawE03a+E7f+uHpGRMxjqcMUZB4A2TCKWs9Rgv
         3mQ5xstI8CQbAyu3J53uPXgjTv1xyWdq+tLJiQxHnUL3ZOvknwFS5yii+ppZSL2UQ7
         T/dmABd3kAYjP5h+djhbeWZNeUmezY/sju4eS3/Q8eFsFNAJWQqIzbGa/6GaglRup7
         U9AZU+YVjrxUkije1FIJBHSBbjxSvCPzlf3v4O4D82Yd+2r8rCexOGoMKJQM5X1L1W
         g8ZkXRFEOK8KbqJK0bqlYEAEeg/ntBSkZzvf3zZpa6Rn8Pze0i6m8rxbk26cNb+NIv
         XlDlvgJknCSXw==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH v8 RESEND 1/6] r8169: Disable ASPM L1.1 on 8168h
Date:   Tue, 21 Feb 2023 10:38:44 +0800
Message-Id: <20230221023849.1906728-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
References: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ASPM L1/L1.1 gets enabled based on [0], but ASPM L1.1 was actually
disabled too [1].

So also disable L1.1 for better compatibility.

[0] https://bugs.launchpad.net/bugs/1942830
[1] https://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-oem/+git/focal/commit/?id=c9b3736de48fd419d6699045d59a0dd1041da014

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v8:
 - New patch.

 drivers/net/ethernet/realtek/r8169_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 45147a1016bec..1c949822661ae 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5224,13 +5224,13 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Disable ASPM L1 as that cause random device stop working
 	 * problems as well as full system hangs for some PCIe devices users.
-	 * Chips from RTL8168h partially have issues with L1.2, but seem
-	 * to work fine with L1 and L1.1.
+	 * Chips from RTL8168h partially have issues with L1.1 and L1.2, but
+	 * seem to work fine with L1.
 	 */
 	if (rtl_aspm_is_safe(tp))
 		rc = 0;
 	else if (tp->mac_version >= RTL_GIGA_MAC_VER_46)
-		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
+		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_1 | PCIE_LINK_STATE_L1_2);
 	else
 		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
 	tp->aspm_manageable = !rc;
-- 
2.34.1

