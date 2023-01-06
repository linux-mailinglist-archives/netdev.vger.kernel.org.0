Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA323660118
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbjAFNTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbjAFNT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:19:27 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1452E7682C;
        Fri,  6 Jan 2023 05:19:26 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7C6F026B8B;
        Fri,  6 Jan 2023 13:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673011163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=kAERvk5nBFa12V2mZMiTZvP60v0XGkRfhjbzVAQuTyw=;
        b=KoonKBdqVvpkdxegu6pG4IIpAzTIWP1YVsgfTGDmIEyWBLDkV1vUsCGeEuGagMEymkLlQI
        1a46Sety7WRP8zuE6rODKmsi/ePQzaMFMnkJGv2FW2OqZAxjMeMWyz4iMIUYHYF+7txIT+
        QVKX9hfbGiVk4ETEXzBnUwdR4SkknoE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673011163;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=kAERvk5nBFa12V2mZMiTZvP60v0XGkRfhjbzVAQuTyw=;
        b=mVOGvsNkU0K+hZCpdmecHUjBvj1vb+B5uiCNA6nsXp0agsu2GmF9XWw5hpwtBKCJOu/bD/
        saclmeVmvMxVQqCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 59D17139D5;
        Fri,  6 Jan 2023 13:19:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +sfIFdsfuGOBWAAAMHmgww
        (envelope-from <iivanov@suse.de>); Fri, 06 Jan 2023 13:19:23 +0000
From:   "Ivan T. Ivanov" <iivanov@suse.de>
To:     aspriel@gmail.com, marcan@marcan.st
Cc:     franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        rmk+kernel@armlinux.org.uk, stefan.wahren@i2se.com,
        pbrobinson@gmail.com, jforbes@fedoraproject.org, kvalo@kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com,
        "Ivan T. Ivanov" <iivanov@suse.de>, stable@vger.kernel.org
Subject: [PATCH v2] brcmfmac: Prefer DT board type over DMI board type
Date:   Fri,  6 Jan 2023 15:19:05 +0200
Message-Id: <20230106131905.81854-1-iivanov@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The introduction of support for Apple board types inadvertently changed
the precedence order, causing hybrid SMBIOS+DT platforms to look up the
firmware using the DMI information instead of the device tree compatible
to generate the board type. Revert back to the old behavior,
as affected platforms use firmwares named after the DT compatible.

Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")

[1] https://bugzilla.opensuse.org/show_bug.cgi?id=1206697#c13

Cc: stable@vger.kernel.org
Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
Reviewed-by: Hector Martin <marcan@marcan.st>
---
Changes since v1
Rewrite commit message according feedback.
https://lore.kernel.org/all/20230106072746.29516-1-iivanov@suse.de/

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index a83699de01ec..fdd0c9abc1a1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -79,7 +79,8 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 	/* Apple ARM64 platforms have their own idea of board type, passed in
 	 * via the device tree. They also have an antenna SKU parameter
 	 */
-	if (!of_property_read_string(np, "brcm,board-type", &prop))
+	err = of_property_read_string(np, "brcm,board-type", &prop);
+	if (!err)
 		settings->board_type = prop;
 
 	if (!of_property_read_string(np, "apple,antenna-sku", &prop))
@@ -87,7 +88,7 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 
 	/* Set board-type to the first string of the machine compatible prop */
 	root = of_find_node_by_path("/");
-	if (root && !settings->board_type) {
+	if (root && err) {
 		char *board_type;
 		const char *tmp;
 
-- 
2.35.3

