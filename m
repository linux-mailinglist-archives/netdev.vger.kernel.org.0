Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDEE6D086B
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 16:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbjC3OhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 10:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjC3OhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 10:37:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B59F5BA0;
        Thu, 30 Mar 2023 07:37:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B5EE6219D1;
        Thu, 30 Mar 2023 14:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680187041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=BspglNfkJsUS3r3lZLHtaMvBOeJH8poZYcalK2MjJCo=;
        b=ZRAEANHjfjlm+/1Rnu369fVYRGG3XxIkifyQlbE3ZuIbYhwGZdqXQoaJDUvHqFAsCsVGad
        22CfTKt2mh5JQZsCYRDwYU22l70i2nVCesaVFhopS0uS4yOGOdTfopvbtVfxKp5C1ftrLL
        MFnaVDjZU/YjU+0gbN+NHeuqa5dczuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680187041;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=BspglNfkJsUS3r3lZLHtaMvBOeJH8poZYcalK2MjJCo=;
        b=gyFQC9v0shXwm3T/y/HeCn0C4d119rgfEFucqMMGOqrVyBl7wbuh4WK0NA5byfaYwBZfUu
        r2OOy8DwATUs8TCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 95841133E0;
        Thu, 30 Mar 2023 14:37:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YvK2I6GeJWRkMAAAMHmgww
        (envelope-from <tiwai@suse.de>); Thu, 30 Mar 2023 14:37:21 +0000
From:   Takashi Iwai <tiwai@suse.de>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] ath11k: pci: Add more MODULE_FIRMWARE() entries
Date:   Thu, 30 Mar 2023 16:37:18 +0200
Message-Id: <20230330143718.19511-1-tiwai@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As there are a few more models supported by the driver, let's add the
missing MODULE_FIRMWARE() entries for them.  The lack of them resulted
in the missing device enablement on some systems, such as the
installation image of openSUSE.

While we are at it, use the wildcard instead of listing each firmware
files individually for each.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---

I can rewrite without wildcards if it's preferred, too.
But IMO this makes easier to maintain.

 drivers/net/wireless/ath/ath11k/pci.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 0aeef2948ff5..379f7946a29e 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -1039,7 +1039,8 @@ module_exit(ath11k_pci_exit);
 MODULE_DESCRIPTION("Driver support for Qualcomm Technologies 802.11ax WLAN PCIe devices");
 MODULE_LICENSE("Dual BSD/GPL");
 
-/* QCA639x 2.0 firmware files */
-MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/" ATH11K_BOARD_API2_FILE);
-MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/" ATH11K_AMSS_FILE);
-MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/" ATH11K_M3_FILE);
+/* firmware files */
+MODULE_FIRMWARE(ATH11K_FW_DIR "/QCA6390/hw2.0/*");
+MODULE_FIRMWARE(ATH11K_FW_DIR "/QCN9074/hw1.0/*");
+MODULE_FIRMWARE(ATH11K_FW_DIR "/WCN6855/hw2.0/*");
+MODULE_FIRMWARE(ATH11K_FW_DIR "/WCN6855/hw2.1/*");
-- 
2.35.3

