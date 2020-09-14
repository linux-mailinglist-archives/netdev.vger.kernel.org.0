Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8FB2685E8
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgINHbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgINHac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:32 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC12EC06178C
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:31 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mm21so5018308pjb.4
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2CEMibo/3pmE65avwd9BlqeQS4O/HCjh0nWtrS3bnHs=;
        b=iDdq5CPCzBjGutOfWaZWd00hg/HoXVOyh2qzixV7oyXpWrh30ir0NWeHg5+NL9WqPy
         cxqipdlssfErkqL283sfmk9DICHleVUWSf6WPq8+HzF1IGCWYb9dw/vCugODrAkYFUa4
         om3Iev6HrzziCQuT5HjxCQqwZyXiCbP4gx0j6FppbHtKvUttXu71QqArZ0DiVIMwDMRO
         4Wl6c6GEeQpVph7prYkOrCuWBSpZh+l/mPAkmZ4ajnUcZYNXAqlAO0TTxT3Jbm487fw/
         6Yu3rme5+BIZw0+yWyJq28YvdtwNPKaD0RgRixR77G2bKsCZoluq4hFAT3f9QISG1Uf8
         4ZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2CEMibo/3pmE65avwd9BlqeQS4O/HCjh0nWtrS3bnHs=;
        b=h0rRXFxZl3Nl4g3qjusW99f9a+MF/rX7YwE/XIoFcUPZuqB/e2eOztuNvYOsVflhD6
         feW9TAJuicoYs5CWnqz84Fe00g7pcIdVq0gzDgkxxKspePiLTmOxDgOpB8hS5omaNt7d
         XzozD5SHZBO2Nl1QNMM5v7exZbZGgX6hIo0IHvsFjVKdEeoFMYHWrxZQRTLgRWKKbAKr
         nJMLD1nUUOvi1HLPIccW+W2rNwAnvtwDYJewOkAD1WgfHQrZ9RYJE/U9d0d5L4yFBQ+o
         p0t14uRF3crhxOWBxUMWnOrz5j6JOAGzWM+76mgGkFd1XoS8RIfMVS01mgKWWIXr4vgj
         T4Ng==
X-Gm-Message-State: AOAM531Cw2ijneRAwv12IOZsHL0a/r8duwVxBtyNRbG3dzNlK6JviD9p
        4EP+bLJgrZjSxTHF/pZU4nk=
X-Google-Smtp-Source: ABdhPJwi2ULttJ/1Qe2K2uamjuS6Nl62EMp/k5pcuUAhsBFvr7aNn1pxzDD31/EcZTENkN+9JsG6cQ==
X-Received: by 2002:a17:90a:fa8b:: with SMTP id cu11mr12639092pjb.10.1600068631561;
        Mon, 14 Sep 2020 00:30:31 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:31 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 10/20] ibmvnic: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:29 +0530
Message-Id: <20200914072939.803280-11-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914072939.803280-1-allen.lkml@gmail.com>
References: <20200914072939.803280-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
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

