Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D79F17CA14
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 02:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgCGBEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 20:04:23 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39040 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgCGBEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 20:04:21 -0500
Received: by mail-pf1-f193.google.com with SMTP id w65so1382990pfb.6
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 17:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=omLW27ISR6OibziXSfi5be6HG4rkQoni8p1KLgyQoXg=;
        b=JbmkWp+tBwkEEKFlnwhir4CpNlpfcxjUzGX6OrbHJKjq9sqCpulALdyeYUgs6qRNcV
         5pRMSGwx33mTVP5vP3M1PK8Qi3FYbJmbMsz/1h4aPyp4TM/yNjTS51mkkOwesWarP4FW
         2gzNfuh16ZCTvHfJTdEGnRSRpTvqzBmrZn+2L2LHFjf0PlEC9uMy2dBzYk9P3mMrW3RN
         LAGsvyQlTvipAp/Y+hEDREXtkLR3zXrZULklMa2rdMmwDhoT7IbIG3LyHHqmjxVe2MN4
         +p5B5aNm65UrlpsvSgNdeoGZO4cB5Ab/Lp82AVwc0zGoNR17ZEY867LaZlGRThc6Ohhv
         KT+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=omLW27ISR6OibziXSfi5be6HG4rkQoni8p1KLgyQoXg=;
        b=jEV8UeUQoAy0+yMbY8NZFN7nf20O4STbYhTlybVw8DHkZ0cY1M3bv7qTxKR3PIa0rr
         pdc3VArCs4LlGCsotCU3dB/60Na6vJ3USk/Q5oDmIaijm6/4FVM58jkZ4c+wI8I18vH+
         m5Z3p7uWN/GJJ0kSidBX0hb/c8jmFKpR569pfpejV5Ih7ST+YeiUdA15LYedHLE+AM+u
         CCSUwPF+c7aSO9CFo+TRMKjSiEfDmziEmDSO+/oMLttMYP6QguxAtbV09f3qF8Sw1O8S
         a1XyPhpQPIauD8z07ZgupPj38WEQoGWbGECOt3vyPkxrY+DF2t/phDGc1OWyHAyfN+gA
         f5MQ==
X-Gm-Message-State: ANhLgQ10/kF5NMo/kVtPM4Siy0x61lKELZEk+8c5NGuEGTN0GmN8NRv4
        OIKsEool0UDkufo0v/Vu6WA5qm7slg0=
X-Google-Smtp-Source: ADFU+vtz2JW5x4TAvMyJ4i8N0eK1pav4qdJzhnqLPE64CyTAPvA5yVIk02irohZ9KQShCBtdBkenIw==
X-Received: by 2002:a63:7ce:: with SMTP id 197mr5978343pgh.429.1583543060103;
        Fri, 06 Mar 2020 17:04:20 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o66sm23224949pfb.93.2020.03.06.17.04.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Mar 2020 17:04:19 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 3/8] ionic: improve irq numa locality
Date:   Fri,  6 Mar 2020 17:04:03 -0800
Message-Id: <20200307010408.65704-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200307010408.65704-1-snelson@pensando.io>
References: <20200307010408.65704-1-snelson@pensando.io>
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

