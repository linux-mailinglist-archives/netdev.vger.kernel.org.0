Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5DFA178975
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgCDEU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:20:26 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44553 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgCDEUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 23:20:25 -0500
Received: by mail-pg1-f193.google.com with SMTP id a14so340942pgb.11
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 20:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=omLW27ISR6OibziXSfi5be6HG4rkQoni8p1KLgyQoXg=;
        b=19lIKLQxsyxKIA7sxifB3gXFdCfyL3kUs+tibihLM8UT9LJKtAenGcR4SYEHML1Ye5
         IWGjQSP+R98IxQ4XlW8PbCsXS6vLhWe7QcfMPOS68X8723lPv46gsNuoXpCygfQkV80N
         n8CY0tKMmQqcFbnQUG0WUPqDkQor8DYGoR9oBd//VM5vbxI1ZVDPPexvCPsuNOQw9EBk
         zP2fqv5olvcs+QOb/KQQhHTATxIzshhWa3rBO4wAvfu2ZBIbajwVNSUqlBUR61UoyYY1
         q+Vl4xfN9YhiMkIiJomvEG6OOQMSQ2ztLo4LChSYtnwhawbgEjGC8IWii18Sbnvzd+Lq
         8g5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=omLW27ISR6OibziXSfi5be6HG4rkQoni8p1KLgyQoXg=;
        b=qj1ltlaBXu43XvNIuKz/WKSU10lEBvOattJmoCwExxRKKSbO+onIdlAwFdZ6aRIR2F
         Pq/TY/KrM1vrXcZfFIP5FHAFRT0PjC6+P3BK67cKDV2ZbAHQ9pZlej/kiUWNZToTdAWt
         1DdHREdRXnDZ16kFKQDm957GnGambTisY0W30fx+1+Aj5w6vOmNAkmT7BNY9EHvvD85o
         65MYqYHALUFZDP9T0vvRbd4xBSH4CFDRcqQH92Dmy9RVymrQQq67h2CmM8kRdu00zYYC
         1t7bW3Wry0NgfsjCyGAzJ0Nbyex/C4C+vVWpaaNR/dwEGOm+VK9A8mOBU0zDe5nnrwI0
         a9wA==
X-Gm-Message-State: ANhLgQ3045q311egta/zNnFPvjarqAnPKku7G+cyLSFar0xwI1ftDzLd
        KneMo6SG94m3i/4Cnjr+VBbvg3gshAU=
X-Google-Smtp-Source: ADFU+vvF5AwWQo+3nvDwA/2rwBr4iPraBil4pBoZW4pOCHe9APndJBXPXUW2Vdp/64Bpiyj0Bpq9NQ==
X-Received: by 2002:a63:7e49:: with SMTP id o9mr881552pgn.80.1583295624628;
        Tue, 03 Mar 2020 20:20:24 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c2sm671702pjo.28.2020.03.03.20.20.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 20:20:24 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 3/8] ionic: improve irq numa locality
Date:   Tue,  3 Mar 2020 20:20:08 -0800
Message-Id: <20200304042013.51970-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200304042013.51970-1-snelson@pensando.io>
References: <20200304042013.51970-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spreading the interrupts across the CPU cores is good for load
balancing, but not necessarily as good when using a CPU/core
that is not part of the NUMA local CPU.  If it can be localized,
the kernel's cpumask_local_spread() service will pick a core
that is on the node close to the PCI device.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 1b7e18fe83db..7df49b433ae5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -424,8 +424,9 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		ionic_intr_mask_assert(idev->intr_ctrl, new->intr.index,
 				       IONIC_INTR_MASK_SET);
 
-		new->intr.cpu = new->intr.index % num_online_cpus();
-		if (cpu_online(new->intr.cpu))
+		new->intr.cpu = cpumask_local_spread(new->intr.index,
+						     dev_to_node(dev));
+		if (new->intr.cpu != -1)
 			cpumask_set_cpu(new->intr.cpu,
 					&new->intr.affinity_mask);
 	} else {
-- 
2.17.1

