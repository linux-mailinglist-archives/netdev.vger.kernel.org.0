Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02273179F1A
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgCEFXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:23:35 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:47054 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgCEFXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 00:23:33 -0500
Received: by mail-pf1-f195.google.com with SMTP id o24so2159937pfp.13
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 21:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=omLW27ISR6OibziXSfi5be6HG4rkQoni8p1KLgyQoXg=;
        b=Ka693Pcg/9hyajoI+1moiHAh9GCYNupnbMA/AdbZd9Ua4CLpeQ4ARas2+3daap/5OZ
         gQX268CaCYcbk0pKVya2xptwudWL2I6TaVvK+/VSqd37f1wHpkEh9HKzkubAuVmEDMeB
         x+eK9MfYr9j5+ISFMfcLu+qStSVzM925sL0J2yg8UsnAXI0ah7tnQAyjA/0KDrThibBG
         STUHJq8IQS07ght+Ab98k6Qo3pfZFBNto9XI35t+QKgikXYeig3CWZbfHdQKCFhIAEi2
         TrafSVcPaIxu8dExdC8r6tOcvtMDusHhXWyfLSvyJ8Rjhy3bfi6OXI/KpZ8WibhPUygL
         na3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=omLW27ISR6OibziXSfi5be6HG4rkQoni8p1KLgyQoXg=;
        b=J0it7acwyBmbG7vrgj59uf8BuV35G3ABajDxtVyu1KBQoIrH1J5eTqWGTne/ua1WrO
         PVPOQClbMFuoKUz1/FYg+ZsHOFxpcq1XnTz8wVVGvHXZ5hVvpfDFE7obm2Dit9/N+M9W
         ZDl8Tkre6LfT8Tpvp5wdsbIPl8tJlaQDyR+pzWMWC190zx8dLCvQlS7FVApYpME/5ehS
         HaY1NlyiT0gVgDMuetZtU5fN7ky4Y6XVD3I+kKlaFJz7omQ/lLbDN29DR4XkWB/pxAZl
         Mh5ud24y4fsx+oT6zS0w4R5+RXiRsRUYy389j3ocG2FwrTwtf5f0+lftWn2vQ0GA7Qjn
         5KsA==
X-Gm-Message-State: ANhLgQ2fY3+vGkvHajCfIfxVgVbVHIOGyNcMQb4XT264U3QZ090PoN+l
        meJCxPX8xp4ARpAbl56a4rptj/VtsuM=
X-Google-Smtp-Source: ADFU+vvN5v/JzIXjq+flBhC1IVCE/TXVTwBhzcSBp6CrNiqRSjAPV/PB4nMrJiiFT+9ZzXlL4cOVFA==
X-Received: by 2002:a63:8e44:: with SMTP id k65mr5675519pge.452.1583385811245;
        Wed, 04 Mar 2020 21:23:31 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h2sm29337759pgv.40.2020.03.04.21.23.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 21:23:30 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 3/8] ionic: improve irq numa locality
Date:   Wed,  4 Mar 2020 21:23:14 -0800
Message-Id: <20200305052319.14682-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200305052319.14682-1-snelson@pensando.io>
References: <20200305052319.14682-1-snelson@pensando.io>
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

