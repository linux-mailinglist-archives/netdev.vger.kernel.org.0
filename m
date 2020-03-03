Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6612176DE3
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgCCEQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:16:06 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43242 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgCCEQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:16:05 -0500
Received: by mail-pf1-f194.google.com with SMTP id s1so772559pfh.10
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 20:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=omLW27ISR6OibziXSfi5be6HG4rkQoni8p1KLgyQoXg=;
        b=wX1qU0Ug9ctQy389QGAKR4/lOXQIWJCvCTBvwXGwqGZuwbvEVYYeHmg9h51vgjmPfs
         5nrEOe7DF3lGtwl85tNTKr3783YhtyQ9Krj4WKHQ5OknYn/tHREgN5WYFgAMQF9imX+/
         IaUdY4QYyjpv3yZ4aFIHN+OJDL5HUm9amJ1zN/RWcpk2lmWsnuesjs3cJUtDchIyDCaE
         gt1miVRP7HNgoAjZHznMDd1e1YdjS7lZST2aQDTFRl7/71drMV5NyFsJjMkU3nJBylre
         gDqSq3KS2zWWVNtK8pJsrKORV42DoER1/dFzg2x9dDd3I3H9YG25T8bQnitv+PxTiDXJ
         dc2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=omLW27ISR6OibziXSfi5be6HG4rkQoni8p1KLgyQoXg=;
        b=kkcW8UuudBmFxljFhwoAwpd987hcLCv2SSYAW6jyY1kkbirJhWV3xnDMM3DuD24c3V
         1+BSEH7Kc7juFHb+cN/4XWbosKVHirhPN6J2F/hj9JWGHP6zsvLt4uGX4OcGiIvFXujN
         Iaam7/yNlq4/nYRqZaYcINM8z28Rz2721Znrj9h47DGN22BJ+GRkGYUinCs9CyBw17Dq
         iDiHuih3Kn4fzwJ96tMxknkh9qzydxNfO8kriAzlpCslVqdpuspqkOh+rizuMeJYJwAt
         pJclrKke/1m7RgeytV5XZ0ivxhqvEFA0N6yn9ZZqy+9Io8x5dGhpU5/5i9NzS5et5S8B
         4WTw==
X-Gm-Message-State: ANhLgQ0Dz+oJdXzH8KnhSCYFVZpIiH+o8SLfYkkvWWQCK/D/SRP9A1h9
        5FBWA6AD/aaHbcbNKDQOtSXI4Q==
X-Google-Smtp-Source: ADFU+vshPKfPxtpbpy1h1pJDrk60gYbWYzhUizKphG+PXP7ZjUZvW6XsKQv12zFgaSQbyeEj4iKSLA==
X-Received: by 2002:a63:5c4:: with SMTP id 187mr2328542pgf.348.1583208962941;
        Mon, 02 Mar 2020 20:16:02 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t7sm396682pjy.1.2020.03.02.20.16.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 20:16:02 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/8] ionic: improve irq numa locality
Date:   Mon,  2 Mar 2020 20:15:40 -0800
Message-Id: <20200303041545.1611-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303041545.1611-1-snelson@pensando.io>
References: <20200303041545.1611-1-snelson@pensando.io>
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

