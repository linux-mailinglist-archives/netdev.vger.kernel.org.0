Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE1AF7EC85
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 08:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfHBGSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 02:18:03 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35750 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbfHBGSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 02:18:03 -0400
Received: by mail-pl1-f196.google.com with SMTP id w24so33233107plp.2
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 23:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=dWbWjZu5Hov9e3N3TH+SWmOQQPAbzWsfhIcgH5he0eA=;
        b=LwKbjZRkk9RVEjDEFGTkhy5pMTq/OXdRIDeB/9BJuopqMi7jEh2aYTfaoFPIf4TyRi
         VRGighDBSxILZTvgOCw0hY4LBWycrZ8llmow/OIu4SGwLuFRNfSusxsNFFP+aMO9Rq/b
         t6VtiinfCdTgsBtHRcxY/B4cR/Cv0QsODnYbQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dWbWjZu5Hov9e3N3TH+SWmOQQPAbzWsfhIcgH5he0eA=;
        b=AzEKQLfbGVHsLufgcQPvBk3ujXnJxezAvpB8ZnegjSh0IjItPdVGkTJYbN5NBynedM
         CuFnxsGFOz5fjL7mgIkZBHtxjLAbyBiqIEzDHV6Q10qLVMBmR2YdI+AzHybmOsxQzZXn
         SPVfTgcmltLl1a35j4f+PdnzmGdIpcnnwzFt+qj8OsXNpLkWjLW1K3ySnVf1OSHv5qk6
         oF1nEvq3FBQZg2qwZoKb3SQVseHKvfwZUoGMc6RmeeWZtXWgSGkGCDg1ZRIbs/FsXEDd
         kGC0ApkrZFCXGQ17O5Tg7GodbFvYrRzdLRuOLEZoNz458KXl0U16NiYkOfxQ5N9ZyIBk
         T/pA==
X-Gm-Message-State: APjAAAUJj67g5GTG0UH6ZvMD4D7s37HZ8B4lVYWgoDIAmZ8jC/bQPkGB
        YUytkWWV+VbKe2iCRrfdwpGDaQ==
X-Google-Smtp-Source: APXvYqxVxrn/SQSnjLxyUnj5Fcp8fYO/LvyTJsTlSjPiTMV7g7OKAIyrHCRAtrZIzaWnPD/QhlNUUg==
X-Received: by 2002:a17:902:d892:: with SMTP id b18mr121463708plz.165.1564726682828;
        Thu, 01 Aug 2019 23:18:02 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i124sm135163213pfe.61.2019.08.01.23.18.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 23:18:02 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, hslester96@gmail.com,
        Rasesh Mody <rmody@marvell.com>, <GR-Linux-NIC-Dev@marvell.com>
Subject: [PATCH net-next] cnic: Explicitly initialize all reference counts to 0.
Date:   Fri,  2 Aug 2019 02:17:51 -0400
Message-Id: <1564726671-7094-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver is relying on zero'ed allocated memory and does not
explicitly call atomic_set() to initialize the ref counts to 0.  Add
these atomic_set() calls so that it will be more straight forward
to convert atomic ref counts to refcount_t.

Reported-by: Chuhong Yuan <hslester96@gmail.com>
Cc: Rasesh Mody <rmody@marvell.com>
Cc: <GR-Linux-NIC-Dev@marvell.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/cnic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index 57dc3cb..155599d 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -4096,12 +4096,16 @@ static int cnic_cm_alloc_mem(struct cnic_dev *dev)
 {
 	struct cnic_local *cp = dev->cnic_priv;
 	u32 port_id;
+	int i;
 
 	cp->csk_tbl = kvcalloc(MAX_CM_SK_TBL_SZ, sizeof(struct cnic_sock),
 			       GFP_KERNEL);
 	if (!cp->csk_tbl)
 		return -ENOMEM;
 
+	for (i = 0; i < MAX_CM_SK_TBL_SZ; i++)
+		atomic_set(&cp->csk_tbl[i].ref_count, 0);
+
 	port_id = prandom_u32();
 	port_id %= CNIC_LOCAL_PORT_RANGE;
 	if (cnic_init_id_tbl(&cp->csk_port_tbl, CNIC_LOCAL_PORT_RANGE,
@@ -5480,6 +5484,7 @@ static struct cnic_dev *cnic_alloc_dev(struct net_device *dev,
 	cdev->unregister_device = cnic_unregister_device;
 	cdev->iscsi_nl_msg_recv = cnic_iscsi_nl_msg_recv;
 	cdev->get_fc_npiv_tbl = cnic_get_fc_npiv_tbl;
+	atomic_set(&cdev->ref_count, 0);
 
 	cp = cdev->cnic_priv;
 	cp->dev = cdev;
-- 
2.5.1

