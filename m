Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6873D588CE
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfF0Rkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:40:51 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37557 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbfF0Rkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:40:51 -0400
Received: by mail-pg1-f195.google.com with SMTP id 25so1344197pgy.4;
        Thu, 27 Jun 2019 10:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=t46mtjbtI3kfKQtCDE30bMwLgnekms1c5N/WXLRHQCM=;
        b=Aq1KMHWJHzmkqUp/kisIB0tLK4uQnRYkLDW/KonVJWvyc6GcMMAhseSmCIpRdIdAAZ
         Adfq5lxDw383Bw1yNCSWEaNJu4guwPQN4x1ffx9jAM9I1OfZ/juIr4tUGXPjg+LyRkU6
         pzc2C/If59rU3wumJQorRmUk98tOSyYOFtvwn+73oDlrR0F+w24AEvex3rPRj3X+dwB8
         isDfw6l7CgH9uO5LKaAdEezQncZKvgXfHpuKjcw+mfxgBefY6SYAWDb34IAxXPk/kDC4
         MRtE9YHOuZrhRCYh0yq3WZROprdPUmCmpc3FpQQHLQjFQ9yhpyd9xGhD1OAJbgFrXgFB
         RyUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=t46mtjbtI3kfKQtCDE30bMwLgnekms1c5N/WXLRHQCM=;
        b=VsJiXdIdZ3XFvbBQvRVoi0zS1ZzZ8QYw+bpgGc9iauhQmsylp8gIaCu68X+M1n5qYc
         tvP9S1eXwKtRAOgf1n++Mz2DoruDPtJC26xp96Errmp7S88WCYmMerCA6x3SfQCPva0c
         6BhsSGD6FonHdUrZhfydSOcbL+WnBIaj6seZu5x5TKwNoqDy2hZT3yAJL0dY7e/cqr38
         LweX97SLd2s9Lgs+y9XR8t1XJ/cOpSLmMGAH9sUqMWLIxNc1z4mXXrGbvuXZkb/6BVFQ
         EpyLQoD/vM//6YEGVOsQXTpQmF2duGt79sKLO4IAzadR09o/1Qrw9iv3E7LsycvgXvR2
         EwHg==
X-Gm-Message-State: APjAAAWujcvFJDFJgySK5FuL5+NF7+DTTKQyBZlhv6XxQCFLvMMOXEkQ
        uAqpJC7A2QNG7ojn0puXDpc=
X-Google-Smtp-Source: APXvYqx5uHL095Y9377Xj6V6dq9bqSsdNQRvILwVJLCBicRDa5beyUZ6jc6HAAsA8JExMVhOk0eEwg==
X-Received: by 2002:a65:448b:: with SMTP id l11mr4797285pgq.74.1561657250380;
        Thu, 27 Jun 2019 10:40:50 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id 125sm5862104pfg.23.2019.06.27.10.40.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:40:49 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Colin Ian King <colin.king@canonical.com>,
        Yang Wei <albin_yang@163.com>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Mao Wenan <maowenan@huawei.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 38/87] ethernet: atlx: remove memset after pci_alloc_consistent in atl2.c
Date:   Fri, 28 Jun 2019 01:40:39 +0800
Message-Id: <20190627174040.4180-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pci_alloc_consitent calls dma_alloc_coherent directly.
In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/atheros/atlx/atl2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 3a3fb5ce0fee..3aba38322717 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -291,7 +291,6 @@ static s32 atl2_setup_ring_resources(struct atl2_adapter *adapter)
 		&adapter->ring_dma);
 	if (!adapter->ring_vir_addr)
 		return -ENOMEM;
-	memset(adapter->ring_vir_addr, 0, adapter->ring_size);
 
 	/* Init TXD Ring */
 	adapter->txd_dma = adapter->ring_dma ;
-- 
2.11.0

