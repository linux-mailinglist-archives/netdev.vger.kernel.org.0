Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7BB6027A0
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 10:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiJRIzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 04:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiJRIzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 04:55:11 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98DC23146
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 01:55:07 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id EF31A504ED5;
        Tue, 18 Oct 2022 11:50:57 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru EF31A504ED5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666083059; bh=/BxLrncmI5OsbceTLHQWc0ag8hMBO+Buuj8v+CmNPVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSXrBTIL9P9MCu2hImL/NGt4KhFl5hFL7Jtxp+JvChn6+XFwcTlRhfyJ4gm5HKSh1
         NPpyUSOqlrD4KkaMK/Wv7e7njZ/rUnON0N0XFVKxZbKWvwNWdjDXiMXNhTzuVO+OiB
         X29Ca6mWbB5oZR8E/Xd7NHgZ4bzQLYWUnra1o8qc=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: [PATCH net-next v2 5/5] ptp: ocp: remove flash image header check fallback
Date:   Tue, 18 Oct 2022 11:54:18 +0300
Message-Id: <20221018085418.2163-6-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221018085418.2163-1-vfedorenko@novek.ru>
References: <20221018085418.2163-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

Previously there was a fallback mode to flash firmware image without
proper header. But now we have different supported vendors and flashing
wrong image could destroy the hardware. Remove fallback mode and force
header check. Both vendors have published firmware images with headers.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 drivers/ptp/ptp_ocp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 18baababb3e2..fa2cd7668c53 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1531,11 +1531,9 @@ ptp_ocp_devlink_fw_image(struct devlink *devlink, const struct firmware *fw,
 	hdr = (const struct ptp_ocp_firmware_header *)fw->data;
 	if (memcmp(hdr->magic, OCP_FIRMWARE_MAGIC_HEADER, 4)) {
 		devlink_flash_update_status_notify(devlink,
-			"No firmware header found, flashing raw image",
+			"No firmware header found, cancel firmware upgrade",
 			NULL, 0, 0);
-		offset = 0;
-		length = fw->size;
-		goto out;
+		return -EINVAL;
 	}
 
 	if (be16_to_cpu(hdr->pci_vendor_id) != bp->pdev->vendor ||
-- 
2.27.0

