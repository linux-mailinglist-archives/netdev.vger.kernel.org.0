Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A7A218670
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgGHLyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728637AbgGHLyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:54:31 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DC8C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:54:31 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f18so2698234wml.3
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NLLnXFDTuWUYMgr/y3maWZm1O8dc+yBuWYjSL2Wos4o=;
        b=g6kFZznNk7eLQq+KUYVyGUw+zI8VnWCFgUJ+o9QIZMmw3kg1aPfLepAGHb98rpG5lP
         HtcLHnhuznasfcopbJSc+jlK2nYLHYZyHsFukqdbUGLoSCner3469HgVVcgTw+vQTREB
         ixT+m1sT3Jm/QVtczwcKo9ldLSXYV1zJN11J8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NLLnXFDTuWUYMgr/y3maWZm1O8dc+yBuWYjSL2Wos4o=;
        b=FrAt7IrGfXvypUv93hRk5zxwIgf1v8NN0+F4In/GlssSWczNtWOSqid+ir5qHetbXX
         8+FA/zpcZbo2DAHDAAWkXKlAIo+pcB8PPjcyyqW8XAzCALamly9Lb97g3dJ+MlB08eve
         6GgFnrknA+3XsYOifbwFYfkMtT3DQtqlvlak/hbBxkGCUCSq/FJMStuOQx3NLuzj+65n
         X7zgQy56hES4CLQiwuqtXDTQcFfvKoG+BK6WVK0Uk07C06ljJMI2Ka9MWlAPsBQ0xmjg
         xvgCyA24k54Cz/arcv5qx9UTb/CiwznEknG1RcaE0qeX9jXfgT+Lsik9sHYAQ2DMfD2I
         jmlg==
X-Gm-Message-State: AOAM530JcAPDDKLklg7KaWAcPa4MyD17pRVxv0GVLHBeEn5OuwoAYcxs
        Q/xxnfAfoVQ+XlMKUmY/ENiYSqkpGfs=
X-Google-Smtp-Source: ABdhPJwle9CN8T9Kmwb5/o9JY/GCz5whVtEC8aKCLjrp3eg0NcOvkreovjiN6hYQixh+O2H3t1mzog==
X-Received: by 2002:a1c:a986:: with SMTP id s128mr9592182wme.121.1594209270002;
        Wed, 08 Jul 2020 04:54:30 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm6352888wrh.54.2020.07.08.04.54.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:54:29 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v4 6/9] bnxt_en: Return correct RSS indirection table entries to ethtool -x.
Date:   Wed,  8 Jul 2020 07:53:58 -0400
Message-Id: <1594209241-1692-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
References: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
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
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 995de93..1fe7c61 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1292,7 +1292,7 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_vnic_info *vnic;
-	int i = 0;
+	u32 i, tbl_size;
 
 	if (hfunc)
 		*hfunc = ETH_RSS_HASH_TOP;
@@ -1301,9 +1301,10 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
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

