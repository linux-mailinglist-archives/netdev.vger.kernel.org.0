Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 230E4111B8B
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 23:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfLCWRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 17:17:44 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38789 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbfLCWRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 17:17:44 -0500
Received: by mail-pg1-f194.google.com with SMTP id t3so2290514pgl.5
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 14:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=gOiQKDfthf8G0KEVnwtmodx5PmsW177/hj+2YFX/cus=;
        b=4BUfK/q7E/ys79xBNckEjDoOuOt1KKSSXeIPXzNKK7vqOm9RXctYxloS7EzNRreGhB
         BH35eg+BU/17i5/iOg8BXbsf9ZMgMaDBcpfvOFLIAQaIadct+zrcvLGVeEayS04vAS0k
         q5y9MyKn7oHyGukbB0xcFnCJAAGuRmG/11JOUFxpn3EheB87gfb+OQ8RP0yset5MCRNk
         TJhAPyzuXnG+LDeVGc1BgpFLqRDmes29FdvQ02Rdm+MYjMrnRWgNPqGBn7hUhnHL/ve+
         ZWdCUTYi6ajtLFfhkKNIEyFcgJ/sWO8BvaAAIMiXZ0tm3mudaObcxwV4qzCt5tSMDc9P
         giMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gOiQKDfthf8G0KEVnwtmodx5PmsW177/hj+2YFX/cus=;
        b=AUhUQrCS2BgOpCGW4KflWkZpFFTcluPztfBFyD9NGX/XNDPGI4zxBVCWjP+4Sg9m49
         1LGxUTdN/cmDMsS2yQAgCBKPFYr5fb61KJRRnr97C6PdR18pJEZ92EBIPivyTmKOewyg
         ggODknoz7i37dkq5pcRHUk/LHPxSkTEUiONG02Nd3lOTcvyLVwuwzar4t71CZeDd0dgG
         BWQgvjQj/3ql4kExuy6J+qcIaxUEpM/3mWCkgcBe4K8ExXIHSWgz1x0wBDNWGPPsGPZ5
         S1wwIywi47QINYLZmxZPg4jy6EQ3X8Krc2nRyh1Fwv+1wyCGzNryVExOb/jLLxPTd4ay
         VQNw==
X-Gm-Message-State: APjAAAU6lluN8PuLLa/eMElG0hhb5g1x1EOvZmIdmw4fXlsiSyQiiRYB
        HrTSLuzLzCL+alP2XbDaAxn7pznYK3U=
X-Google-Smtp-Source: APXvYqyHwxyoHJXt6x1fnRk68yIw0eiw5ti0YRHuwgtbnqsKNm0vvQvb+/ONga2GFTPjQ1vQ92LVhw==
X-Received: by 2002:a63:5657:: with SMTP id g23mr7717777pgm.452.1575411463499;
        Tue, 03 Dec 2019 14:17:43 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id d23sm4606289pfo.176.2019.12.03.14.17.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Dec 2019 14:17:42 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: keep users rss hash across lif reset
Date:   Tue,  3 Dec 2019 14:17:34 -0800
Message-Id: <20191203221734.70798-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the user has specified their own RSS hash key, don't
lose it across queue resets such as DOWN/UP, MTU change,
and number of channels change.  This is fixed by moving
the key initialization to a little earlier in the lif
creation.

Also, let's clean up the RSS config a little better on
the way down by setting it all to 0.

Fixes: aa3198819bea ("ionic: Add RSS support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 60fd14df49d7..ef8258713369 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1381,12 +1381,9 @@ int ionic_lif_rss_config(struct ionic_lif *lif, const u16 types,
 
 static int ionic_lif_rss_init(struct ionic_lif *lif)
 {
-	u8 rss_key[IONIC_RSS_HASH_KEY_SIZE];
 	unsigned int tbl_sz;
 	unsigned int i;
 
-	netdev_rss_key_fill(rss_key, IONIC_RSS_HASH_KEY_SIZE);
-
 	lif->rss_types = IONIC_RSS_TYPE_IPV4     |
 			 IONIC_RSS_TYPE_IPV4_TCP |
 			 IONIC_RSS_TYPE_IPV4_UDP |
@@ -1399,12 +1396,18 @@ static int ionic_lif_rss_init(struct ionic_lif *lif)
 	for (i = 0; i < tbl_sz; i++)
 		lif->rss_ind_tbl[i] = ethtool_rxfh_indir_default(i, lif->nxqs);
 
-	return ionic_lif_rss_config(lif, lif->rss_types, rss_key, NULL);
+	return ionic_lif_rss_config(lif, lif->rss_types, NULL, NULL);
 }
 
-static int ionic_lif_rss_deinit(struct ionic_lif *lif)
+static void ionic_lif_rss_deinit(struct ionic_lif *lif)
 {
-	return ionic_lif_rss_config(lif, 0x0, NULL, NULL);
+	int tbl_sz;
+
+	tbl_sz = le16_to_cpu(lif->ionic->ident.lif.eth.rss_ind_tbl_sz);
+	memset(lif->rss_ind_tbl, 0, tbl_sz);
+	memset(lif->rss_hash_key, 0, IONIC_RSS_HASH_KEY_SIZE);
+
+	ionic_lif_rss_config(lif, 0x0, NULL, NULL);
 }
 
 static void ionic_txrx_disable(struct ionic_lif *lif)
@@ -1729,6 +1732,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 		dev_err(dev, "Failed to allocate rss indirection table, aborting\n");
 		goto err_out_free_qcqs;
 	}
+	netdev_rss_key_fill(lif->rss_hash_key, IONIC_RSS_HASH_KEY_SIZE);
 
 	list_add_tail(&lif->list, &ionic->lifs);
 
-- 
2.17.1

