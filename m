Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0660C588C4
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfF0Rjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:39:33 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42352 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfF0Rjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:39:32 -0400
Received: by mail-pg1-f194.google.com with SMTP id k13so1332951pgq.9;
        Thu, 27 Jun 2019 10:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2kq4qqQIO8L6xHtZAgwES+mymmw0wgMAnnlfW7U7BZI=;
        b=PT45Lu6o796+IjEYC0wtX8I6f0iR+Qa+0pHCRRuz8v4i/XjVTAInbbJZ8oLLP9dHkC
         n9nT++v6fN5vpsJGfcxv0SLT/8t9rZTrsgDm7q/3XRl/Ia2DbsExiLcp4fZmRDrGNnqo
         FMYEPLgaaxg4/aRbjD5AziNLJUXcH+c44GETv6S7e4/xc7dCtC2Kq0HKFcIQEIdRPBho
         +tywostlOW/7MxPdSO2lr3GrbUI35Ln+kVjVIGTt4RpRllGT9mAprtVmLuSnNwc3OFaw
         jvCr3euxvSCXQIl1KS3+OhDmCv7IDJk+KFUoOnNZlmdtURG7HXJnjbIDf6ewDpRrnxHA
         x8kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2kq4qqQIO8L6xHtZAgwES+mymmw0wgMAnnlfW7U7BZI=;
        b=eJ8DpCL8ADGsihKT/Oj2YyB4cdhNl+qGohPi/qEWSJXr3+TC4VgYtNBjuriCAUtWZ7
         /uEXD1pKFR0w1PO1OBm4hdherAZir62qyFUEeGiiKdD/xopdluzpOsXKZy2SK/QQmIsl
         d1WktuAzotb8tDFxzBDgEXBlFeZn8YMUx45FlstxgdP0tik0AN9TfXQPVYdnBs+5fgUf
         aXsLmPp+qQBwS/a4e0EuweVz1FcWv+MLZUvIjvp4ZKK3U6jNRAPAApW5S/NMti8e7H+s
         L7VJ2YvqSeQzjDRfpEsaqF0XKAbOD/LodJ7vaz+4m4VqEMS+Grf/qkLOpWejCwT0wqTh
         DQRw==
X-Gm-Message-State: APjAAAWib75echmw9XG1XvvAd7QourRHyv24U+o3TpZ3ewrYRndMaHs6
        kEFguIDHxi/Oo04d3Q+kg4U=
X-Google-Smtp-Source: APXvYqzNAVJiKS0MlKW3HGoIIbMl366WJhMaLV6VWr78W39LWMhp7Q53vgH0FObrYvZdZTcdN9pa4A==
X-Received: by 2002:a63:fc15:: with SMTP id j21mr4830348pgi.217.1561657171752;
        Thu, 27 Jun 2019 10:39:31 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id w197sm5035790pfd.41.2019.06.27.10.39.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:39:31 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Allison Randal <allison@lohutok.net>,
        YueHaibing <yuehaibing@huawei.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        zhong jiang <zhongjiang@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        Colin Ian King <colin.king@canonical.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 37/87] ethernet: atlx: remove memset after pci_alloc_consistent in atl1.c
Date:   Fri, 28 Jun 2019 01:39:22 +0800
Message-Id: <20190627173924.3783-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pci_alloc_consistent calls dma_alloc_coherent directly.
In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/atheros/atlx/atl1.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 7c767ce9aafa..b5c6dc914720 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -1060,8 +1060,6 @@ static s32 atl1_setup_ring_resources(struct atl1_adapter *adapter)
 		goto err_nomem;
 	}
 
-	memset(ring_header->desc, 0, ring_header->size);
-
 	/* init TPD ring */
 	tpd_ring->dma = ring_header->dma;
 	offset = (tpd_ring->dma & 0x7) ? (8 - (ring_header->dma & 0x7)) : 0;
-- 
2.11.0

