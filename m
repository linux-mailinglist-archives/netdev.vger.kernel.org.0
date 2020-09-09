Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D983D262AC6
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgIIIqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729808AbgIIIp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:45:59 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23799C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:45:59 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u13so1591200pgh.1
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nrLJ1wxGaA9ONEh/pOZ2pIe/eGFDTsPnlUFuXEF5U7Q=;
        b=U92Ifl+UoXjQjymBcD3UQyWITzndeqj4PNDWD8KIoVjZgXa/X1I6tC30DEqnh+WvAX
         N8U2axoBhW1Tgq6pMRFrqpNns5ovTA0qDAam3mBhdmlyMI22xMBBHvsYgF4c2QirGz0v
         2+w0IdtCKn8Hs8XJe6IjW/eLDyAaAR9X1tIvd/hvbye8xKp8hcYv2RYF0ZLlIKpXxVUC
         Q8sx6ijPjOnemhjk8mmWplKrIAN+4T7X2wgvbCLzEP/3k9hWKrtrdaj0bxJJg9bNtMXh
         a7N6AaXSDCcs3m1Cm3MyjIy2io/55KM9KylXF6rX6vExxvVWq15KHJqXT313qsn1xGPC
         lTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nrLJ1wxGaA9ONEh/pOZ2pIe/eGFDTsPnlUFuXEF5U7Q=;
        b=QSsq9LzfG34vNIr7uiUoCz3J6A5DwilkjLuC0TO5eWwxkVlQTunJT2ffB1pjaumX+y
         C0Z9Bqi+8dgUpUrTwHzpQupjDlNEqRjTLSSBYUytEpnuHDICrBLQS9bF9lzfyHh8zJAb
         5o86FsMCwicsZdcZIIeG/cn1eGV3/eH7LADxt/STRkM0qYaYlHqQK/q4gjUOsDInqQoQ
         twy3YpQEh9TKkPYXHQpOf0WwvbQ0tp9YW0mAjx+B7GK/3/Sl/o0/57gyZDb5b83tkwHj
         lz+84HUnlGmifFUA0Ti2DdGSoeFncuPzranvAjRiuA6xHymn8vLbHed05fC/mdGadXCE
         9/VA==
X-Gm-Message-State: AOAM532yfA/aTOTJStutuL9Y2ma3aUlvSoPvPeW3b8Y4DBTHLIZqFZRQ
        7n8lO0DJLmAJg2RxlxkYnq0=
X-Google-Smtp-Source: ABdhPJwhO1UHj0xX8vFdRj673c2I6xPabA0H9WeVXGSld7GrDKDCp3wvpBJTQNc+uf9i3PH+fN4VeQ==
X-Received: by 2002:a63:1455:: with SMTP id 21mr2341060pgu.52.1599641158714;
        Wed, 09 Sep 2020 01:45:58 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:45:58 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 10/20] ethernet: ibmvnic: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:15:00 +0530
Message-Id: <20200909084510.648706-11-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200909084510.648706-1-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index d3a774331afc..1a3e65bae17f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4810,9 +4810,9 @@ static irqreturn_t ibmvnic_interrupt(int irq, void *instance)
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
@@ -4947,8 +4947,7 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 
 	retrc = 0;
 
-	tasklet_init(&adapter->tasklet, (void *)ibmvnic_tasklet,
-		     (unsigned long)adapter);
+	tasklet_setup(&adapter->tasklet, (void *)ibmvnic_tasklet);
 
 	netdev_dbg(adapter->netdev, "registering irq 0x%x\n", vdev->irq);
 	snprintf(crq->name, sizeof(crq->name), "ibmvnic-%x",
-- 
2.25.1

