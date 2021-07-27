Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E743D7C67
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhG0Rno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhG0Rno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:43:44 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A75C061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:43 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso5892356pjf.4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N+iRzCc5w+nQ3FtDNsr4EOv16/0Zg5i++kmtnA72Sz0=;
        b=G79ifbr8ePs3x4FtPhH/ykorW63aFvWzoUHNmB5dz+xhSBWqXbOqdULVnzdzWV09GQ
         XRungCLi6H7CpVb1uNulNsQbzbZUbXDmHCo9G3TX2Ute7a2ZAfCZXqD1JoTJrRFZm26L
         laPMGGTimCE7nwiYGkMAVwqmCQv5UhiN8yX/Yiwjk34e1tjLdOR9Hu5avrv0Gb6envpe
         fLBduTepioq6jzGeOySwk6nALDSiMyuGVCvGfQCvnTv03zkZFwCnguBT9bM+sIff35+2
         HXX1vyCE6ahk9lliifjdfeaqNOM73K8A2G5UCi9BrJ4PPN7aZHvDPRiKGLOUXAD64SA4
         LYiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N+iRzCc5w+nQ3FtDNsr4EOv16/0Zg5i++kmtnA72Sz0=;
        b=UO8RghxpDb7CeSYvVIAKOAIvugAT4dnMlakjscnIH97KGEfnOdNYGcBqdJ9GHdP6aK
         uvjTDwurANdtJv4bsojElxxC1hiE2hjwIEtaacAxoDDCbjxeyDt3onDEtG4lSr+wYAej
         /H1IVVn63RUuZE0u27ohs7L3ceyTY96G5nmsFjVnOQoh/h5cWdM1iefyrwZrdmEp2hrv
         NJIOsNxenge9Cpg983tT3J7cw/y2Fj9bZGG+eJdDO13tumT5jEDTJiy+cs+1oz/nTypq
         ouGjAa1hIs+jjuTR7Bm8qD2Oz+pUbUKoYRoApcEoQH5VR0cjDmwxNsLF+AYE2kqeh58m
         5FiQ==
X-Gm-Message-State: AOAM531XTArFjBacu73vaamkxcebcJVnb806r7O5JCb3OesMCfxvyztl
        s/PFkHv/7FpTxUipnufvLxGukg==
X-Google-Smtp-Source: ABdhPJzC2lAundGMKUSyuVeJ7F52LsLO3HprO5B+gfu/WVX+BE4O66+TPf7CLSN1B1nBWD7JrrsLsw==
X-Received: by 2002:a17:90b:3905:: with SMTP id ob5mr9348401pjb.211.1627407823512;
        Tue, 27 Jul 2021 10:43:43 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t9sm4671944pgc.81.2021.07.27.10.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:43:43 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 01/10] ionic: minimize resources when under kdump
Date:   Tue, 27 Jul 2021 10:43:25 -0700
Message-Id: <20210727174334.67931-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727174334.67931-1-snelson@pensando.io>
References: <20210727174334.67931-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running in a small kdump kernel, we can play nice and
minimize our resource use to help make sure that kdump is
successful in its mission.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index af3a5368529c..e839680070ba 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/cpumask.h>
+#include <linux/crash_dump.h>
 
 #include "ionic.h"
 #include "ionic_bus.h"
@@ -2834,8 +2835,14 @@ int ionic_lif_alloc(struct ionic *ionic)
 
 	lif->ionic = ionic;
 	lif->index = 0;
-	lif->ntxq_descs = IONIC_DEF_TXRX_DESC;
-	lif->nrxq_descs = IONIC_DEF_TXRX_DESC;
+
+	if (is_kdump_kernel()) {
+		lif->ntxq_descs = IONIC_MIN_TXRX_DESC;
+		lif->nrxq_descs = IONIC_MIN_TXRX_DESC;
+	} else {
+		lif->ntxq_descs = IONIC_DEF_TXRX_DESC;
+		lif->nrxq_descs = IONIC_DEF_TXRX_DESC;
+	}
 
 	/* Convert the default coalesce value to actual hw resolution */
 	lif->rx_coalesce_usecs = IONIC_ITR_COAL_USEC_DEFAULT;
@@ -3519,6 +3526,7 @@ int ionic_lif_size(struct ionic *ionic)
 	unsigned int min_intrs;
 	int err;
 
+	/* retrieve basic values from FW */
 	lc = &ident->lif.eth.config;
 	dev_nintrs = le32_to_cpu(ident->dev.nintrs);
 	neqs_per_lif = le32_to_cpu(ident->lif.rdma.eq_qtype.qid_count);
@@ -3526,6 +3534,15 @@ int ionic_lif_size(struct ionic *ionic)
 	ntxqs_per_lif = le32_to_cpu(lc->queue_count[IONIC_QTYPE_TXQ]);
 	nrxqs_per_lif = le32_to_cpu(lc->queue_count[IONIC_QTYPE_RXQ]);
 
+	/* limit values to play nice with kdump */
+	if (is_kdump_kernel()) {
+		dev_nintrs = 2;
+		neqs_per_lif = 0;
+		nnqs_per_lif = 0;
+		ntxqs_per_lif = 1;
+		nrxqs_per_lif = 1;
+	}
+
 	/* reserve last queue id for hardware timestamping */
 	if (lc->features & cpu_to_le64(IONIC_ETH_HW_TIMESTAMP)) {
 		if (ntxqs_per_lif <= 1 || nrxqs_per_lif <= 1) {
-- 
2.17.1

