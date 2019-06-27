Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45FB258935
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfF0Rqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:46:53 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42663 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfF0Rqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:46:52 -0400
Received: by mail-pl1-f195.google.com with SMTP id ay6so1669525plb.9;
        Thu, 27 Jun 2019 10:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jgFxVRkoXuinu080KjskguZb99gQ02Kmo20z6z3TuCs=;
        b=KWDLboKPVrn2kgTEUwUKGWcYCUHsW8yUQ0c87nYNOsqQZsr65TIsHelKuWJI0dduX4
         aMR1k/KkvYvbwPTZmjdwy3gsdaifNkpozb7KD2/+aC924uv2aUIPihE9iPhcxBjJMoAw
         pQDqweShYgLKzh5SgGFYsNHcO3oYjaR5J7c+SRWt1ODP2sNWad53UrwyjrthWV42pEGR
         D/KQp3v/lE3BvNZ7KzoDQ/MW4jG4v3P1jVDrWYGazkq+Wk2mLullvyv9z9QDx+uy/tMB
         ZZpT+AOsr8VLcn1REBP2wNgTGc2kdYMb/bfok8tNymV0Yg+Ypg04TiI/xt+XFNYxDdOb
         Gmog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jgFxVRkoXuinu080KjskguZb99gQ02Kmo20z6z3TuCs=;
        b=CLRz8e+dwx2R3f834+ygMnkhcQ54xOBdYoPXOb+aoF2mObGiGhaYSCwh1znlhC6toZ
         3pkC6EWr3vAs8y2eDIyPr/19GQt76cKgnaMyVeRB8HKVe4BOlR2bj/rz3j7HwDo0/mi5
         M/1TWEQuv0Kmdr/PHNwkyCABBGSla2NbAWlRhAJVrVU+/YUPYZibH+EbeK77o4ddSues
         gwLViHDJVQzbT0BHtoUSxGU04cPSMR3bGXJT6O/f7VgLzhsQMPzT4MiOKQRyY3hF+ZYp
         QKfNz3b+vXWTDlQHimxo5YqUeDvaU4VNVgCDVSnnLv3HVwMLM5DAMYZVugrjpwKWXZXb
         nTmA==
X-Gm-Message-State: APjAAAVPQqPsz0tDpre6wV4Lu0wdNlKVEGPwt8afG1tH9wVS1MpU3Tut
        Jnd8FDjV5/NnkuzYD8mU8cw=
X-Google-Smtp-Source: APXvYqxozJHdezegoomvgR7KH4bqh89jnehQIHg51OvxeciQqHg+AcSm82tFnJNB7eC7SSaKUS19sw==
X-Received: by 2002:a17:902:bc83:: with SMTP id bb3mr6252031plb.56.1561657611914;
        Thu, 27 Jun 2019 10:46:51 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id f3sm5932117pfg.165.2019.06.27.10.46.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:46:51 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 75/87] ethernet: marvell: remove memset after pci_alloc_consistent
Date:   Fri, 28 Jun 2019 01:46:45 +0800
Message-Id: <20190627174645.6521-1-huangfq.daxian@gmail.com>
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
 drivers/net/ethernet/marvell/skge.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 35a92fd2cf39..9ac854c2b371 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -2558,8 +2558,6 @@ static int skge_up(struct net_device *dev)
 		goto free_pci_mem;
 	}
 
-	memset(skge->mem, 0, skge->mem_size);
-
 	err = skge_ring_alloc(&skge->rx_ring, skge->mem, skge->dma);
 	if (err)
 		goto free_pci_mem;
-- 
2.11.0

