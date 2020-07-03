Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CBB2134D3
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 09:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgGCHUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 03:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgGCHUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 03:20:11 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE83FC08C5C1
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 00:20:10 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o8so30959706wmh.4
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 00:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=C1PIbvf/F3pEJD8SJioHJm7gGXKJLRSVJjjUJ3WEdiI=;
        b=WRSNX8BrQQxb6AIiNgu6wBE3sassKT4ocJWzNAHm4lmbU4DtF+G9ur2YN9PkyPCUoY
         j3lcnTFgYnoX+huC59j9JIe1554fGD+TQxQKhAg7WUVi4Ilrzsb4taaqFfpVFsC5zdT9
         d3wxPowVgP7TgjvMqGJ29WYIHeGbYPhfRm4yA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=C1PIbvf/F3pEJD8SJioHJm7gGXKJLRSVJjjUJ3WEdiI=;
        b=kldPlIiPhO6s00GaSIOINR8ce9qCncoaYMf3Swrdk9JRmQZABLTULumIcZ2XmEHDCz
         X7fbFYfJa4CTl87kfOLB/KH9KfpY2+YCCEiCZ05T+22rqyRyrg8qRwRE9ql8j1RhU0Zd
         A/WH4avmZDiG70+he/2g2BTwL9jAAbKkykMx5yB+ftE4LeK3CPX4YGZC//WpwEbca4B+
         +QSYvvwNqLpEokoayXANogpeD/cwlnn3VopiqH2zTmOto3uHsfGzpQTjwwtTdn/ClVOt
         Az5340cBFf9xFKQSBxmS1wu98mnvME5NeSf1qS8OjsORHomVs+2UTJrTI+U78i+WZLV0
         xgAQ==
X-Gm-Message-State: AOAM530APFdOTAEjOu51b1QOlogNZBnutCEk9mesYO2N93l4NOINz4H5
        Rnfd24nMEVgat22wzIoT9YCCAg==
X-Google-Smtp-Source: ABdhPJx3pM0wKHv1ZtOi+DFAF0uSdI/TqBJb7RK2t74QtzDTpV8Psu2rU0E0m636GGB/JWMK3oF8Sg==
X-Received: by 2002:a1c:e143:: with SMTP id y64mr4972304wmg.90.1593760809481;
        Fri, 03 Jul 2020 00:20:09 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a22sm12529564wmj.9.2020.07.03.00.20.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2020 00:20:09 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 5/8] bnxt_en: Return correct RSS indirection table entries to ethtool -x.
Date:   Fri,  3 Jul 2020 03:19:44 -0400
Message-Id: <1593760787-31695-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
References: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have the logical indirection table, we can return these
proper logical indices directly to ethtool -x instead of the physical
IDs.

Reported-by: Jakub Kicinski <kicinski@fb.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 6b88143..46f3978 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1275,6 +1275,12 @@ static int bnxt_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 
 static u32 bnxt_get_rxfh_indir_size(struct net_device *dev)
 {
+	struct bnxt *bp = netdev_priv(dev);
+
+	if (bp->flags & BNXT_FLAG_CHIP_P5) {
+		return (bp->rx_nr_rings + BNXT_RSS_TABLE_ENTRIES_P5 - 1) &
+		       ~(BNXT_RSS_TABLE_ENTRIES_P5 - 1);
+	}
 	return HW_HASH_INDEX_SIZE;
 }
 
@@ -1288,7 +1294,7 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_vnic_info *vnic;
-	int i = 0;
+	u32 i, tbl_size;
 
 	if (hfunc)
 		*hfunc = ETH_RSS_HASH_TOP;
@@ -1297,9 +1303,10 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 		return 0;
 
 	vnic = &bp->vnic_info[0];
-	if (indir && vnic->rss_table) {
-		for (i = 0; i < HW_HASH_INDEX_SIZE; i++)
-			indir[i] = le16_to_cpu(vnic->rss_table[i]);
+	if (indir && bp->rss_indir_tbl) {
+		tbl_size = bnxt_get_rxfh_indir_size(dev);
+		for (i = 0; i < tbl_size; i++)
+			indir[i] = bp->rss_indir_tbl[i];
 	}
 
 	if (key && vnic->rss_hash_key)
-- 
1.8.3.1

