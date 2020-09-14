Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867CA2685E6
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgINHa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgINHaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:25 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5EFC06178A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:23 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u13so10851652pgh.1
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JO+T9dbCdHvGYLM7G+u1+Z2xx4BQwKAORkQ/sO6UQkE=;
        b=ThzXhUyLHORpKwbQSBro4e7lObLX4X0q2Mac1ocPSEppHEddJpaR6LbRx92SRH1Gtl
         yqexmYedRx5O9I97wFdzTv5/DJCVNaiDzkOwuP3tgYBthmW3h3Ml5/jxpye5lLANFJIO
         4dV4uf+SzPkS9QHs4kVomHv3v/PM3yb6epBtxaMlOUXKkNqa9knd5jzX5yO6aBd81bjg
         qA/uAM8BFGqKPYHX/71Ccik1eu+yoU51S79KEhH5OCCJE0zVg4AQleY+C0Hoax7BbqVB
         EFpX2MJ91ONvyw+YTHqTSt8X2mKqJKKPkeacHNb+ErMoQ/L6nyol267Qwu3U4Y4OPB+O
         T98w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JO+T9dbCdHvGYLM7G+u1+Z2xx4BQwKAORkQ/sO6UQkE=;
        b=MM3Wia2XHp4SHLZ7R50mufUAfOhsvyA2EnOS8mfzT0IT4cN8dmJHZLE6Ijl6uuFr0H
         RDHrMmqziuMzSMYI3ZtETwwF/h+Ntdkk99Y/Yaqh24KCgCDdA+Zz0ZcjJE42UhCI+pPU
         CQlpvsRJcHxhUom/Hsz93KkUZfsS//APHnmvy3ftdyeYXwy3GvMArYky8TD7QGQjZCkM
         B6tokVUcTzpxENhaMq38zyif5p5LzsKgWkq5tcO/rd3MyGwAjV3V4evMSOgT/MMDNQxY
         whFZQVrPglNsIwSRk+aIQ2it9ZNPZcT10CxGw3EsvDHMl4BbiwY7ypIKVK+BVnbXgHKN
         D1Og==
X-Gm-Message-State: AOAM5324v2XPPMspaGEvk+bY2U/S+RQyZOSf1590+4UAdwCJOKsOIKPY
        ByxnJY6Nsv9XbSt/E3xoBz0=
X-Google-Smtp-Source: ABdhPJyiNkbXb/Wrgz4FOiRWp47YN1uP9O1iJDzlOmEE4bGiyPEX0xetGC4vucxG5+yn1OOF19KyTg==
X-Received: by 2002:a63:4b63:: with SMTP id k35mr10108706pgl.142.1600068623620;
        Mon, 14 Sep 2020 00:30:23 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:23 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 08/20] net: hinic: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:27 +0530
Message-Id: <20200914072939.803280-9-allen.lkml@gmail.com>
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
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index ca8cb68a8d20..f304a5b16d75 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
@@ -370,9 +370,9 @@ static void eq_irq_work(struct work_struct *work)
  * ceq_tasklet - the tasklet of the EQ that received the event
  * @ceq_data: the eq
  **/
-static void ceq_tasklet(unsigned long ceq_data)
+static void ceq_tasklet(struct tasklet_struct *t)
 {
-	struct hinic_eq *ceq = (struct hinic_eq *)ceq_data;
+	struct hinic_eq *ceq = from_tasklet(ceq, t, ceq_tasklet);
 
 	eq_irq_handler(ceq);
 }
@@ -782,8 +782,7 @@ static int init_eq(struct hinic_eq *eq, struct hinic_hwif *hwif,
 
 		INIT_WORK(&aeq_work->work, eq_irq_work);
 	} else if (type == HINIC_CEQ) {
-		tasklet_init(&eq->ceq_tasklet, ceq_tasklet,
-			     (unsigned long)eq);
+		tasklet_setup(&eq->ceq_tasklet, ceq_tasklet);
 	}
 
 	/* set the attributes of the msix entry */
-- 
2.25.1

