Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9695313F27
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 13:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfEELR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 07:17:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34486 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727681AbfEELRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 07:17:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id c13so5019392pgt.1
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 04:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6g1NH37ee6Lvn3jYSBSr30ntX8RMPyzSX0Qdby8jzow=;
        b=N6Mtbfjm/hyBzB9izWPmUrmU57v3U7a0XxL8ujnxx2tjy4UHB4U326Gg/KFaxEeBbd
         wv5GpRC3qBs+FgKwa1f4lDTBkyUUtRBNmq7yKSrXmho6pYdBo77P7beRy3p4YzemWrFK
         kzd/IEXLDpDUzSxNT+s++/GcQ+o/O8YJOioCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6g1NH37ee6Lvn3jYSBSr30ntX8RMPyzSX0Qdby8jzow=;
        b=LG4R5QJMaEifsP9eKrQh+0Te3g3DbzEf0SRgNptUePgApWa64ivLOVp+FbHTQ/yeKZ
         0VUVV10UonstmMn/mTV9lXlOYQxPwAYcctWLWfqQBoOxJYrCAnxRJPydZa1UcEYSILiz
         TrKjgTzeFdbeu+nNq5k6jIhezPwD2h967tcCbxrxKdhIOYZAfldAFDH4duC5n/hiYGyo
         gp4C0zh8/Ix5/KK72sxNqcLYyKxrmUtk6L9z+k/DCXDZP8QTW0i0ZgrGCB7AMSdYCjJI
         6HYGAbVOnGUdEzO+IAxBo9cI9X87pMb5SAFGUB+F62qaQQ90P0CjenNcIKvxdZRzvCp1
         Kb7g==
X-Gm-Message-State: APjAAAUbw6ClqlCEqdFJIZSjUV89iRiIJlvbLXupzVw6mAPS3syqwmEq
        O3mx1v9lOakwpZPkF6kCqKyquhzufXI=
X-Google-Smtp-Source: APXvYqznIAtxHlAafJWMys30UxEXHttaCOacDDDDtuDA81FGwnH47ZTDWGTe9VMsVXmTqTwn6CbdsA==
X-Received: by 2002:a63:f212:: with SMTP id v18mr22497941pgh.231.1557055044146;
        Sun, 05 May 2019 04:17:24 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id 10sm9378902pfh.14.2019.05.05.04.17.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 04:17:23 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 04/11] bnxt_en: Check new firmware capability to display extended stats.
Date:   Sun,  5 May 2019 07:17:01 -0400
Message-Id: <1557055028-14816-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
References: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Newer firmware now advertises the capability for extended stats
support.  Check the new capability in addition to the existing
version check.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b7a6005..4e0fec2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3470,7 +3470,8 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 alloc_ext_stats:
 	/* Display extended statistics only if FW supports it */
 	if (bp->hwrm_spec_code < 0x10804 || bp->hwrm_spec_code == 0x10900)
-		return 0;
+		if (!(bp->fw_cap & BNXT_FW_CAP_EXT_STATS_SUPPORTED))
+			return 0;
 
 	if (bp->hw_rx_port_stats_ext)
 		goto alloc_tx_ext_stats;
@@ -3485,7 +3486,8 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 	if (bp->hw_tx_port_stats_ext)
 		goto alloc_pcie_stats;
 
-	if (bp->hwrm_spec_code >= 0x10902) {
+	if (bp->hwrm_spec_code >= 0x10902 ||
+	    (bp->fw_cap & BNXT_FW_CAP_EXT_STATS_SUPPORTED)) {
 		bp->hw_tx_port_stats_ext =
 			dma_alloc_coherent(&pdev->dev,
 					   sizeof(struct tx_port_stats_ext),
@@ -6526,6 +6528,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->flags |= BNXT_FLAG_ROCEV2_CAP;
 	if (flags & FUNC_QCAPS_RESP_FLAGS_PCIE_STATS_SUPPORTED)
 		bp->fw_cap |= BNXT_FW_CAP_PCIE_STATS_SUPPORTED;
+	if (flags & FUNC_QCAPS_RESP_FLAGS_EXT_STATS_SUPPORTED)
+		bp->fw_cap |= BNXT_FW_CAP_EXT_STATS_SUPPORTED;
 
 	bp->tx_push_thresh = 0;
 	if (flags & FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 178ece3..647f7c0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1482,6 +1482,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_OVS_64BIT_HANDLE		0x00000400
 	#define BNXT_FW_CAP_TRUSTED_VF			0x00000800
 	#define BNXT_FW_CAP_PCIE_STATS_SUPPORTED	0x00020000
+	#define BNXT_FW_CAP_EXT_STATS_SUPPORTED		0x00040000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
 	u32			hwrm_spec_code;
-- 
2.5.1

