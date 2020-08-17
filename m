Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B6A245FD6
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgHQIZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgHQIZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:25:53 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74A1C061388;
        Mon, 17 Aug 2020 01:25:53 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d19so7755380pgl.10;
        Mon, 17 Aug 2020 01:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iIAfZhwD4u3KlLMECiacU1MTufzkqZbS33SY7LcQr7A=;
        b=hG2G6TIwKMJXy2HRahBQraJOgltWGzLG9JNMpZ4RSRhs60XANefCGvnE5soeTXpm4f
         8W7Y1YPZgS9l2UmuOoypi4PZ1qdPVFJ7QEteda3ogrOSn5313M/EE7BZgy5sZrFHhrui
         KdAhYg0gLgoy5pBrKOtjZKJGxtOE+4FM1rRssMpDabVK+1mj2agBXV7RnGvo3Sx7vvv/
         0qRK+BXn24CXmouDGXQ2sXFDJUTEkNWdlyk/l+2QSR8ANbeQbj1pMPLjbCHHoaPzPyjG
         PaFqIMtn8VpzTLw8Vd06NvM257eWA0mBFfDHBaMuUka7/3j5nCdVQi91g8S89hQuYSye
         dqZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iIAfZhwD4u3KlLMECiacU1MTufzkqZbS33SY7LcQr7A=;
        b=dO9onWG2PDjPteApDsRRrlbaP3SELq1IlLkkWQh9jSDO2ii6zy3xiTmV5ni32Tuh/0
         77zZaIIwAiqJTtzW+CC74F1/waQYmOqNrq0K8h95tN2LUXtymWvbpv1leikfhvRWSHaV
         94UICcPFicCtg3oYS8YAKOhTi/sd8pHTtNY/SvPXlo4Wm5C/r4oyaJJdbyNywVrfkdGZ
         xVYgRDYYOsdFuJXtdGe3Jg1g2I9q7ahoiEZQQ+X9HbgMjWmSuG7JqDPUVazBOZdUwLSj
         YDipVV4wWIxP7G4LI92XBgXBz+tkA5MxB9hW6cBrNwOsI2WdAwt2yhYzdkIOtqi+1KEG
         evOg==
X-Gm-Message-State: AOAM530bXA2HpAwNnzOLNGZRR9cMZgN29kcyXHsenLVIzXBuSS9PjfE5
        p7xE44otWogc720J6ovTOqI=
X-Google-Smtp-Source: ABdhPJyHdid6AeC6n0Zvp88ugK0l2FhFHXTm5Bvo/3+IlJzMqY2dzIOg8iBwBCBZqkwkbk4eX5A4Ng==
X-Received: by 2002:aa7:80d6:: with SMTP id a22mr10784840pfn.275.1597652753273;
        Mon, 17 Aug 2020 01:25:53 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:25:52 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com
Cc:     keescook@chromium.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 10/20] ethernet: ibmvnic: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:24 +0530
Message-Id: <20200817082434.21176-12-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817082434.21176-1-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5afb3c9c52d2..7c565e167521 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4797,9 +4797,9 @@ static irqreturn_t ibmvnic_interrupt(int irq, void *instance)
 	return IRQ_HANDLED;
 }
 
-static void ibmvnic_tasklet(void *data)
+static void ibmvnic_tasklet(struct tasklet_struct *t)
 {
-	struct ibmvnic_adapter *adapter = data;
+	struct ibmvnic_adapter *adapter = from_tasklet(adapter, t, tasklet);
 	struct ibmvnic_crq_queue *queue = &adapter->crq;
 	union ibmvnic_crq *crq;
 	unsigned long flags;
@@ -4934,8 +4934,7 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 
 	retrc = 0;
 
-	tasklet_init(&adapter->tasklet, (void *)ibmvnic_tasklet,
-		     (unsigned long)adapter);
+	tasklet_setup(&adapter->tasklet, (void *)ibmvnic_tasklet);
 
 	netdev_dbg(adapter->netdev, "registering irq 0x%x\n", vdev->irq);
 	snprintf(crq->name, sizeof(crq->name), "ibmvnic-%x",
-- 
2.17.1

