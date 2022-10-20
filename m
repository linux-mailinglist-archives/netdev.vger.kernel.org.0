Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0065606C0E
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 01:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJTXZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 19:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiJTXZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 19:25:26 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E8892CF8
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 16:25:19 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 6DB65504EEE;
        Fri, 21 Oct 2022 02:21:09 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 6DB65504EEE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666308070; bh=gSJc2hVPi+/cC5gO4Oe8MO5CLa+NDkKvF6zEYImcZXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hi+qjyWFOe5zJ+Wjk0q6UAQs01IEBOAYjC+rML1nvYIOcJ2vKdnwCitP7+/nZqXP3
         xyK0P4vwTrXEXMQQDGGKFF04fMjl4I2uwY9tLJ6oCeQSjJe0i7UllJf1k4JSOXqNoh
         PtaUsIjYFfTvZUtXu2l7P5dvVQGUM61Ryi0acsKI=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: [PATCH net-next v6 5/5] ptp: ocp: remove flash image header check fallback
Date:   Fri, 21 Oct 2022 02:24:33 +0300
Message-Id: <20221020232433.9593-6-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221020232433.9593-1-vfedorenko@novek.ru>
References: <20221020232433.9593-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 drivers/ptp/ptp_ocp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index d2d486ccd714..154d58cbd9ce 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1530,11 +1530,9 @@ ptp_ocp_devlink_fw_image(struct devlink *devlink, const struct firmware *fw,
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
@@ -1562,7 +1560,6 @@ ptp_ocp_devlink_fw_image(struct devlink *devlink, const struct firmware *fw,
 		return -EINVAL;
 	}
 
-out:
 	*data = &fw->data[offset];
 	*size = length;
 
-- 
2.27.0

