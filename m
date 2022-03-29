Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5404EB140
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 18:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239145AbiC2QFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 12:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239148AbiC2QFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 12:05:42 -0400
Received: from smtp6.emailarray.com (smtp6.emailarray.com [65.39.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D8D275FD
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 09:03:58 -0700 (PDT)
Received: (qmail 73382 invoked by uid 89); 29 Mar 2022 16:03:55 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 29 Mar 2022 16:03:55 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net] ptp: ocp: handle error from nvmem_device_find
Date:   Tue, 29 Mar 2022 09:03:54 -0700
Message-Id: <20220329160354.4035-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nvmem_device_find returns a valid pointer or IS_ERR().
Handle this properly.

Fixes: 0cfcdd1ebcfe ("ptp: ocp: add nvmem interface for accessing eeprom")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index c3d0fcf609e3..0feaa4b45317 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1214,10 +1214,9 @@ ptp_ocp_nvmem_device_get(struct ptp_ocp *bp, const void * const tag)
 static inline void
 ptp_ocp_nvmem_device_put(struct nvmem_device **nvmemp)
 {
-	if (*nvmemp != NULL) {
+	if (!IS_ERR_OR_NULL(*nvmemp))
 		nvmem_device_put(*nvmemp);
-		*nvmemp = NULL;
-	}
+	*nvmemp = NULL;
 }
 
 static void
@@ -1241,13 +1240,15 @@ ptp_ocp_read_eeprom(struct ptp_ocp *bp)
 		}
 		if (!nvmem) {
 			nvmem = ptp_ocp_nvmem_device_get(bp, tag);
-			if (!nvmem)
-				goto out;
+			if (IS_ERR(nvmem)) {
+				ret = PTR_ERR(nvmem);
+				goto fail;
+			}
 		}
 		ret = nvmem_device_read(nvmem, map->off, map->len,
 					BP_MAP_ENTRY_ADDR(bp, map));
 		if (ret != map->len)
-			goto read_fail;
+			goto fail;
 	}
 
 	bp->has_eeprom_data = true;
@@ -1256,7 +1257,7 @@ ptp_ocp_read_eeprom(struct ptp_ocp *bp)
 	ptp_ocp_nvmem_device_put(&nvmem);
 	return;
 
-read_fail:
+fail:
 	dev_err(&bp->pdev->dev, "could not read eeprom: %d\n", ret);
 	goto out;
 }
-- 
2.31.1

