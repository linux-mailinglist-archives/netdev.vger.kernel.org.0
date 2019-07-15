Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A77A682A4
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 05:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbfGODTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 23:19:51 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43007 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729088AbfGODTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 23:19:50 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so7547370plb.9;
        Sun, 14 Jul 2019 20:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+B0jx+4muj+M4b7c2kQfV0uSbE8FiTxBXwM9XgPCIac=;
        b=rUrV/W2cFJNaa8vePeI9kEWvofvtQd3wBD4YW63KnfV+rcI+vl/TeWgDn1ZWBbJF+d
         4PhGeWEFU9VVCds7ZsnsSapiOLg8VcaUaz2PBh9LPeEOu3GXL+cnPGQ406XBCMZ1nvqm
         9jfFFnT0DMHGLUz1+sz+FOYuvQ19Nfwvpr822BFWOzV5thNTCtV/hf2qW+3//T6uwDIk
         cyEDHmxDdFtBrIgVGR4P7jiVcksY5TCWKSd2pyYTj0lNNQMyfveZ508iYGk8ICDqmP6Q
         M7690uJe75Qu3fgoe3g2UZefqxultpC2Pncsj/IwKbWZ1ED4qPc2sIwvzbw+TCEF8x9L
         vtJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+B0jx+4muj+M4b7c2kQfV0uSbE8FiTxBXwM9XgPCIac=;
        b=V5IQ2fhJFjap+UxAWrmgmSZI8hkILL8SlSj92Os9dNHQwA75JKwQ9KKAqMwDZ5b+jx
         cqcrNzxMR0IQRbldov1MitbLyEtDmhKmLAipEWpBUiyYGyXuKWQ2EL3o06LulPNGFRPi
         yOaqZw9s0xm2VtPiUdb70Y4r4U4vkQ1XadIlIkOZ4tPPg/ZmUKD+ApuqhbzWJJCcrjhH
         E2CuKECCz/43K/qAX7XY74eaPCnW0fucZYwr5ZXAtN8cp7YN+8fdxZ113cZfni57wYS/
         6dhlUBv3DdaE2C0I5nfB4echMD+DX0ZuGFCjfF09y2ZvI5TGew/oWUmF9xaj4jU+XAn2
         45og==
X-Gm-Message-State: APjAAAWxt9VQXF7Bd6BoVEKuOtSMLF9BGSVPXW5SAEq/eK3HAN1ukuLU
        wlOtaz0QJoB1N5kjjmH2hbI=
X-Google-Smtp-Source: APXvYqwQR7EYn7nM9TgFm/nKnIR49M8lFOUn+x0miZZg3gxoz/XgR4qWm5y30xqPSsvlAzLYNlmvmQ==
X-Received: by 2002:a17:902:a612:: with SMTP id u18mr25087040plq.181.1563160789988;
        Sun, 14 Jul 2019 20:19:49 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id 2sm21006045pgm.39.2019.07.14.20.19.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jul 2019 20:19:49 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v3 20/24] wireless: Remove call to memset after dma_alloc_coherent
Date:   Mon, 15 Jul 2019 11:19:41 +0800
Message-Id: <20190715031941.7120-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 518a2f1925c3
("dma-mapping: zero memory returned from dma_alloc_*"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v3:
  - Use actual commit rather than the merge commit in the commit message

 drivers/net/wireless/ath/ath10k/ce.c                     | 5 -----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c  | 2 --
 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c | 2 --
 drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c | 2 --
 4 files changed, 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index eca87f7c5b6c..294fbc1e89ab 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1704,9 +1704,6 @@ ath10k_ce_alloc_dest_ring_64(struct ath10k *ar, unsigned int ce_id,
 	/* Correctly initialize memory to 0 to prevent garbage
 	 * data crashing system when download firmware
 	 */
-	memset(dest_ring->base_addr_owner_space_unaligned, 0,
-	       nentries * sizeof(struct ce_desc_64) + CE_DESC_RING_ALIGN);
-
 	dest_ring->base_addr_owner_space =
 			PTR_ALIGN(dest_ring->base_addr_owner_space_unaligned,
 				  CE_DESC_RING_ALIGN);
@@ -2019,8 +2016,6 @@ void ath10k_ce_alloc_rri(struct ath10k *ar)
 		value |= ar->hw_ce_regs->upd->mask;
 		ath10k_ce_write32(ar, ce_base_addr + ctrl1_regs, value);
 	}
-
-	memset(ce->vaddr_rri, 0, CE_COUNT * sizeof(u32));
 }
 EXPORT_SYMBOL(ath10k_ce_alloc_rri);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 4ea5401c4d6b..5f0437a3fd82 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1023,8 +1023,6 @@ brcmf_pcie_init_dmabuffer_for_device(struct brcmf_pciedev_info *devinfo,
 			       address & 0xffffffff);
 	brcmf_pcie_write_tcm32(devinfo, tcm_dma_phys_addr + 4, address >> 32);
 
-	memset(ring, 0, size);
-
 	return (ring);
 }
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 3aa3714d4dfd..5ec1c9bc1612 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -244,8 +244,6 @@ static int pearl_alloc_bd_table(struct qtnf_pcie_pearl_state *ps)
 
 	/* tx bd */
 
-	memset(vaddr, 0, len);
-
 	ps->bd_table_vaddr = vaddr;
 	ps->bd_table_paddr = paddr;
 	ps->bd_table_len = len;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
index 9a4380ed7f1b..1f91088e3dff 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
@@ -199,8 +199,6 @@ static int topaz_alloc_bd_table(struct qtnf_pcie_topaz_state *ts,
 	if (!vaddr)
 		return -ENOMEM;
 
-	memset(vaddr, 0, len);
-
 	/* tx bd */
 
 	ts->tx_bd_vbase = vaddr;
-- 
2.11.0

