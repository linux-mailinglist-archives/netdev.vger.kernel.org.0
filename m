Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BC2640773
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 14:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiLBNGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 08:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiLBNGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 08:06:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB72D9B13;
        Fri,  2 Dec 2022 05:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=R7QSmaJ8mKSkWjHTNr6g3I7WTgaE9twKd2xR5v0EOJM=; b=0zqpUrnwH6ek6MQcUQKJ/QEUBV
        +Qwxfz2UJhHMR26ym5AzDDx8ejmsdzlHvV8LEUcOfWcCiNzkmV1R9g00DZRm+qNffE468omt76Z+O
        7tnCTGC/ajA1ZinI5Xs3Cb65Yv/Bn3r7G2fKpmFk0jN2gTjpP8akuMWzIa9SaQG08ICZ6VdVfxDw0
        UxVmdrv8esqswPrLNg0vy/hLPoloNlrNuGzKsJ5D53ms2N4PuCxUbeFYY9ZOiYNADyTS+6IRUaSrH
        Bn39EevQ4+/rGq8no5eGQ0q1+2HIvT6Qh3F0NIyNRPoqLeUFO1k6dPFM1U88tNka1SOgofKn4K9fm
        JOsZfCHQ==;
Received: from [2001:4bb8:192:26e7:bcd3:7e81:e7de:56fd] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p15jv-00GY2K-VG; Fri, 02 Dec 2022 13:06:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] wifi: ath11k_pci: add a soft dependency on qrtr-mhi
Date:   Fri,  2 Dec 2022 14:06:00 +0100
Message-Id: <20221202130600.883174-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While ath11k_pci can load without qrtr-mhi, probing the actual hardware
will fail when qrtr and qrtr-mhi aren't loaded with

   failed to initialize qmi handle: -517

Add a MODULE_SOFTDEP statement to bring the module in (and as a hint
for kernel packaging) for those cases where it isn't autoloaded already
for some reason.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/wireless/ath/ath11k/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 99cf3357c66e16..9d58856cbf8a94 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -1037,6 +1037,8 @@ module_exit(ath11k_pci_exit);
 MODULE_DESCRIPTION("Driver support for Qualcomm Technologies 802.11ax WLAN PCIe devices");
 MODULE_LICENSE("Dual BSD/GPL");
 
+MODULE_SOFTDEP("pre: qrtr-mhi");
+
 /* QCA639x 2.0 firmware files */
 MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/" ATH11K_BOARD_API2_FILE);
 MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/" ATH11K_AMSS_FILE);
-- 
2.30.2

