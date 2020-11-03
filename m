Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EAE2A3FD8
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgKCJTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgKCJTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:19:22 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48129C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 01:19:22 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 13so13653965pfy.4
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 01:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wyxxcSZc1SJ6rvTowrOjryo8LHecdATP5X2cPcq3mdc=;
        b=uMhEzYwLkJsxI6qmsLBnZdyfixHm1vT+X8J7R1fezQf4fafyH8EYQZg2DwxxH+zJX3
         mieH5UHhjzfzUEoVwhbnWMdb1zJelrkBFQ8mvxhrj9UZFzgYEQ7arHFJAkvUECzRYMjy
         dMwon+G4adttFTTK4TZYO3JxgaGVZP3uaiXlMSliSQOjW6hHcTD/Hs8KEfaCkAN4fw+k
         42wncShiNuPiyOLwY7b3tlv8hilSTxbaPBb5/dIXf8E7ucGpyw7aF6LUrVy7/7p2l6Xy
         HaG9KXZejPEIxd2pwdQ5MC+10RoD0XdSUUJvYzLU5eEGbwZIhJCVRauVrrmjjwzzsg7T
         24lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wyxxcSZc1SJ6rvTowrOjryo8LHecdATP5X2cPcq3mdc=;
        b=e6Hjp2bmWrJYHmy3WfnB+FY3M5h4WB2R+REnvptTAZ0cvZE7j4ukQjdpcTaw1/fQhD
         /kSDcxLaMypGNTDCxGe2BGK5KA4ALuxofxo7/crp2V94Ei5bxD1owmy7SdyhoKQgWGFj
         5aMjg/K/Vkp7H/81SgFeQ50ZsJ2jsVfDElrXTCGsfFEgXTwQiggEwsbgB3Wb5o6Vspxh
         BVLtKoMLuQjCcqRgU/L6oJfKjEi92+BudPRmjD2O9YJ4rBVzbeabf4l4g4ruos/6hLRu
         6HsvsoZTTfZPaekEb0Yq8HCVpWek2OuL6w8/h3vbZQ+pYAbIZPAWSwxyMsApL8L/qLgg
         Qt9A==
X-Gm-Message-State: AOAM533INCmJ0fMRynaB3vlmvuN4xkf1yyPHEYrK0gEIHP5iTFZrT6pF
        3bvFvFSM4dce0dfer97/YtY=
X-Google-Smtp-Source: ABdhPJyajSSutkaxnYVxtSOjHaOlfXBq4a3N1or4cIxsOzk4tGwJH4paYGCe6ceYjejYvKArgS7EKg==
X-Received: by 2002:a17:90a:7089:: with SMTP id g9mr2862637pjk.4.1604395161941;
        Tue, 03 Nov 2020 01:19:21 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id f204sm17178063pfa.189.2020.11.03.01.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 01:19:21 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v4 7/8] net: smc: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 14:48:22 +0530
Message-Id: <20201103091823.586717-8-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201103091823.586717-1-allen.lkml@gmail.com>
References: <20201103091823.586717-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 net/smc/smc_cdc.c |  6 +++---
 net/smc/smc_wr.c  | 14 ++++++--------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index b1ce6ccbfaec..f23f558054a7 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -389,9 +389,9 @@ static void smc_cdc_msg_recv(struct smc_sock *smc, struct smc_cdc_msg *cdc)
  * Context:
  * - tasklet context
  */
-static void smcd_cdc_rx_tsklet(unsigned long data)
+static void smcd_cdc_rx_tsklet(struct tasklet_struct *t)
 {
-	struct smc_connection *conn = (struct smc_connection *)data;
+	struct smc_connection *conn = from_tasklet(conn, t, rx_tsklet);
 	struct smcd_cdc_msg *data_cdc;
 	struct smcd_cdc_msg cdc;
 	struct smc_sock *smc;
@@ -411,7 +411,7 @@ static void smcd_cdc_rx_tsklet(unsigned long data)
  */
 void smcd_cdc_rx_init(struct smc_connection *conn)
 {
-	tasklet_init(&conn->rx_tsklet, smcd_cdc_rx_tsklet, (unsigned long)conn);
+	tasklet_setup(&conn->rx_tsklet, smcd_cdc_rx_tsklet);
 }
 
 /***************************** init, exit, misc ******************************/
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 1e23cdd41eb1..cbc73a7e4d59 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -131,9 +131,9 @@ static inline void smc_wr_tx_process_cqe(struct ib_wc *wc)
 	wake_up(&link->wr_tx_wait);
 }
 
-static void smc_wr_tx_tasklet_fn(unsigned long data)
+static void smc_wr_tx_tasklet_fn(struct tasklet_struct *t)
 {
-	struct smc_ib_device *dev = (struct smc_ib_device *)data;
+	struct smc_ib_device *dev = from_tasklet(dev, t, send_tasklet);
 	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
 	int i = 0, rc;
 	int polled = 0;
@@ -435,9 +435,9 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
 	}
 }
 
-static void smc_wr_rx_tasklet_fn(unsigned long data)
+static void smc_wr_rx_tasklet_fn(struct tasklet_struct *t)
 {
-	struct smc_ib_device *dev = (struct smc_ib_device *)data;
+	struct smc_ib_device *dev = from_tasklet(dev, t, recv_tasklet);
 	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
 	int polled = 0;
 	int rc;
@@ -698,10 +698,8 @@ void smc_wr_remove_dev(struct smc_ib_device *smcibdev)
 
 void smc_wr_add_dev(struct smc_ib_device *smcibdev)
 {
-	tasklet_init(&smcibdev->recv_tasklet, smc_wr_rx_tasklet_fn,
-		     (unsigned long)smcibdev);
-	tasklet_init(&smcibdev->send_tasklet, smc_wr_tx_tasklet_fn,
-		     (unsigned long)smcibdev);
+	tasklet_setup(&smcibdev->recv_tasklet, smc_wr_rx_tasklet_fn);
+	tasklet_setup(&smcibdev->send_tasklet, smc_wr_tx_tasklet_fn);
 }
 
 int smc_wr_create_link(struct smc_link *lnk)
-- 
2.25.1

