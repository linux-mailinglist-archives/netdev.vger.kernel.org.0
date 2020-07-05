Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44B3215029
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgGEWWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEWWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:22:50 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57676C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:22:50 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b92so16157393pjc.4
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 15:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/D/Pxb8Hjv8mpxwdV5rvi3y4JacHT5Wst3nyBaexfWw=;
        b=eq+d9jCc067MOa4rHqX4BLnwp/wDPAS3Fol/H7K+wVdN/JIRCTB78ysfSSW0Fcyf9p
         wWoiwEh0gpeaksYP/kxgnMochCQIWRzq1hXmbNcPoe6uVxAiqNhMH9lnKJuJYzCYqfdw
         xqPr6R8RRGtacQAe7I6oc9NMzQHIgAePJT3Ww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/D/Pxb8Hjv8mpxwdV5rvi3y4JacHT5Wst3nyBaexfWw=;
        b=nuQ1C7MVnIWw2b3TzMGGc0sXDkh49xlWHY4hUPOKM9jzqsGnfpw5sVqqwHc7ad2k4x
         +cqR/zNgPiPAvBY70WQRB1xBvfzUqVpKBuvVXcWkX+CmjBcmu3NNFqSw1Lb9zzryDddx
         pywjK2WS+zhHJIjJTrsD1KpA0GRA2GW0yMEJ6uKxnYtqXfC/q46rNNysFY2vSabvq0LG
         jYTmrHKf1rBIwXaiJhxk3IwLnJyd0AnnSszY87sJGInhhhVx2ldtO9sox5sJ3QGKZYFp
         kwNKkj8OK9l597aWrhQd0YQgHXa5zJd9nwAk9A/nM0cRbWa63dSeF0Bc1oh91GtK0Rma
         7wOA==
X-Gm-Message-State: AOAM530llnwF5xz10piZduFlzBg9B3PP6fU3tsLlE1/+xuqp3t/cX6Cg
        cmSB+79ZTEHYl/H63Mp1SRSLCg==
X-Google-Smtp-Source: ABdhPJwUkO2yheyVXep+8n7J1E23weZ4qr5F6RxhlExiPh2aBDyXDGikPBQm587VE11MCpTUD+XzjA==
X-Received: by 2002:a17:90b:2351:: with SMTP id ms17mr36985402pjb.105.1593987769811;
        Sun, 05 Jul 2020 15:22:49 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i184sm16843251pfc.73.2020.07.05.15.22.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Jul 2020 15:22:49 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v3 5/8] bnxt_en: Return correct RSS indirection table entries to ethtool -x.
Date:   Sun,  5 Jul 2020 18:22:09 -0400
Message-Id: <1593987732-1336-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
References: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have the logical indirection table, we can return these
proper logical indices directly to ethtool -x instead of the physical
IDs.

v3: Use ALIGN() to round up the RSS table size.

Reported-by: Jakub Kicinski <kicinski@fb.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 6b88143..8bc4a7f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1275,6 +1275,10 @@ static int bnxt_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 
 static u32 bnxt_get_rxfh_indir_size(struct net_device *dev)
 {
+	struct bnxt *bp = netdev_priv(dev);
+
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		return ALIGN(bp->rx_nr_rings, BNXT_RSS_TABLE_ENTRIES_P5);
 	return HW_HASH_INDEX_SIZE;
 }
 
@@ -1288,7 +1292,7 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_vnic_info *vnic;
-	int i = 0;
+	u32 i, tbl_size;
 
 	if (hfunc)
 		*hfunc = ETH_RSS_HASH_TOP;
@@ -1297,9 +1301,10 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
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

