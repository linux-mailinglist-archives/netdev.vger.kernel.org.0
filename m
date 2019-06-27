Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93A658902
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfF0RoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:44:21 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43548 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbfF0RoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:44:20 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so1336914pgv.10;
        Thu, 27 Jun 2019 10:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jTEpnDLcJgOgMeNGqNa8r3yAUVyGipHsMFib578GHIM=;
        b=GO/fnGWQJZ9eBKz+jiSVxT3PzpO3nUo8WbF7XRHHP15WyaBEQpcR7qPFB2vOMcU3As
         NnaF5+EuAen9WSupT3Lk2YuPgZEOKP1EtA7C4Z8e2Kq0Zh4pOFuxTs9QWLTggnJJwjBv
         mYH4Pkcyb4lnBuZynDdti+MgBPMszSahByWOem3dzdjSpLbP4F1FMjjoKozbe9xhs1Xj
         /V0eCeqfF9dr0VXTyx8ubgKWaP/9dajHbGh8iMLUhEa4T9VZd1G+tVdtkvjqcuEqXku2
         saEpotKA4iwR/y3oGHTpZYMEdKGx09Pute+n9JHNot2rjvTYhoG5YvhrYGDJaSRLsPep
         kLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jTEpnDLcJgOgMeNGqNa8r3yAUVyGipHsMFib578GHIM=;
        b=MLHfhh+A0J3vFMxE/yKr0IEFW7b6g/D/0/xeeTpGzC41E4KLefOW3VnuD5yTI46WwP
         swRJQsbI14IjQjRqhRRaziJyded5BuSYIHcP0kpDrHl4+q1PFWRMy9mgD026fn+meCSO
         lXyv+lHEKd8LEZVQmh7+YpuSs8UJasl9VVP6UQo688smb8mJdyLAzRsAWbs5mD6uNn6/
         vNRc0ipjBXFYhO8Zb2ojvYpZ57E/UjcXEclNnrXnHUVdnU31USOjnLmxAbzOyYyi9tDZ
         fgu1W7Mf0/lGG3ryOri9frZ3yFGNLkvvPY8jBw+0eSpJWMAgnz1U/5oSIeLDTYMvg+Hl
         WYow==
X-Gm-Message-State: APjAAAX1blcXYQMh4XQfjWI4+XDT06UpKSvrjyIquOAU7K8oJC6en+UL
        iWLZ0SJNxDYSYpAJK6QSjRsHa3P9wdBiHQ==
X-Google-Smtp-Source: APXvYqwZ4n5gMkO5mN+hcC9u5z1H8ijW4j1IVjgz149vY7alsqnjYZjyo3t2zRROvqsKy45x+IZYeg==
X-Received: by 2002:a63:1d5:: with SMTP id 204mr5013007pgb.207.1561657459905;
        Thu, 27 Jun 2019 10:44:19 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id x128sm5280391pfd.17.2019.06.27.10.44.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:44:19 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 82/87] ethernet: netxen: remove memset after pci_alloc_persistent
Date:   Fri, 28 Jun 2019 01:44:13 +0800
Message-Id: <20190627174413.5413-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pci_alloc_persistent calls dma_alloc_coherent directly.
In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
index 433052f734ed..5e9f8ee99800 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
@@ -442,10 +442,8 @@ nx_fw_cmd_create_tx_ctx(struct netxen_adapter *adapter)
 		goto out_free_rq;
 	}
 
-	memset(rq_addr, 0, rq_size);
 	prq = rq_addr;
 
-	memset(rsp_addr, 0, rsp_size);
 	prsp = rsp_addr;
 
 	prq->host_rsp_dma_addr = cpu_to_le64(rsp_phys_addr);
@@ -755,7 +753,6 @@ int netxen_alloc_hw_resources(struct netxen_adapter *adapter)
 		return -ENOMEM;
 	}
 
-	memset(addr, 0, sizeof(struct netxen_ring_ctx));
 	recv_ctx->hwctx = addr;
 	recv_ctx->hwctx->ctx_id = cpu_to_le32(port);
 	recv_ctx->hwctx->cmd_consumer_offset =
-- 
2.11.0

