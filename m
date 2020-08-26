Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F6925351D
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgHZQmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbgHZQm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:42:26 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7803C061757
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:25 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id m34so1298476pgl.11
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9Dcu0ODgktyQopGmsvvfnLYcxiTT+wl+JncOEgcVoIU=;
        b=gsIWnPkUddiymgCMqsDYxP5kOKNpwsNbNXJ8Ivk4o2TW5JU+sSTwBikgah0INcqiBt
         4HmWBfeLAMm5iJu54sp+uf7Hz96wT8TcDZiHw804KGT5wgaeUZw/IAGFHa9ZgCr8sX0o
         mLQxlzQGPm8+QVLXAR0ONb+NpBGubeSlEKx7K1Yc02+4qu/u8Jlwi7pPyj3NpReluz06
         D5+A0r4fFU70EH9h4aquhtTICkFoIfpGXy/Ti1GZ4r7Xjg7yB/qmonaxd6M4rXIeVgzd
         UdgHcn8Y6EXPrz/EIyrleYkBApsh58jY8Ag4BRrgP5Zw80lzWfbfiD9o578nnZP+FhYK
         hxQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9Dcu0ODgktyQopGmsvvfnLYcxiTT+wl+JncOEgcVoIU=;
        b=lgEBTeoWp28Fmgx+oL6Gzdr/4wSUYzSTdUjEe9XlRxwo8PkTL9mdtThxB9fQOFj2Dh
         BQMBow9/mL3LiQ3u2g5yY55JRXlZbGdBifrsF+6st5A0JGg4w2AebVX9zvRQwxkyW9Dt
         BjXORxzU/0b0D6zqNF3v7Glrx3oxuspbyo98nlwP13p9Wyl3SLNQfi9D6j8zW1hVB8hk
         KZxvBWELeiHjQYkyocsGGm0vLTCjSC8BGuxgkVqJ+PC/yXGAd0PYtqDqTHnmH8mI8M7t
         IzoHSu+cx2VEbcGT/07ZJ6BNIaoiL1R9spg7BcmuDMb5SSOo+APtb10ieU0WL9YpaIKe
         kqBw==
X-Gm-Message-State: AOAM532Q3cr/8e50e3VWvRqESkiq6qwkVxCxsdL9qhPO1Wn+QkDO9H2+
        ioohVoRGL5901uhPvFTjqLW9xLeN0y9Njw==
X-Google-Smtp-Source: ABdhPJzYOoZ+TPLMkjFtBgNwa/0FNvOS+omNxVYFwj9nNuVjk7oa0CKfoIXua11uxxZLptsyymApWg==
X-Received: by 2002:aa7:9ecb:: with SMTP id r11mr3900193pfq.283.1598460145016;
        Wed, 26 Aug 2020 09:42:25 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h193sm2986052pgc.42.2020.08.26.09.42.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:42:24 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 03/12] ionic: use kcalloc for new arrays
Date:   Wed, 26 Aug 2020 09:42:05 -0700
Message-Id: <20200826164214.31792-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826164214.31792-1-snelson@pensando.io>
References: <20200826164214.31792-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kcalloc for allocating arrays of structures.

Following along after
commit e71642009cbdA ("ionic_lif: Use devm_kcalloc() in ionic_qcq_alloc()")
there are a couple more array allocations that can be converted
to using devm_kcalloc().

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index e95e3fa8840a..d73beddc30cc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -522,7 +522,6 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 static int ionic_qcqs_alloc(struct ionic_lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
-	unsigned int q_list_size;
 	unsigned int flags;
 	int err;
 	int i;
@@ -552,9 +551,9 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 		ionic_link_qcq_interrupts(lif->adminqcq, lif->notifyqcq);
 	}
 
-	q_list_size = sizeof(*lif->txqcqs) * lif->nxqs;
 	err = -ENOMEM;
-	lif->txqcqs = devm_kzalloc(dev, q_list_size, GFP_KERNEL);
+	lif->txqcqs = devm_kcalloc(dev, lif->ionic->ntxqs_per_lif,
+				   sizeof(*lif->txqcqs), GFP_KERNEL);
 	if (!lif->txqcqs)
 		goto err_out_free_notifyqcq;
 	for (i = 0; i < lif->nxqs; i++) {
@@ -565,7 +564,8 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 			goto err_out_free_tx_stats;
 	}
 
-	lif->rxqcqs = devm_kzalloc(dev, q_list_size, GFP_KERNEL);
+	lif->rxqcqs = devm_kcalloc(dev, lif->ionic->nrxqs_per_lif,
+				   sizeof(*lif->rxqcqs), GFP_KERNEL);
 	if (!lif->rxqcqs)
 		goto err_out_free_tx_stats;
 	for (i = 0; i < lif->nxqs; i++) {
-- 
2.17.1

