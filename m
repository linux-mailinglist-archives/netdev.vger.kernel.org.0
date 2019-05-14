Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6101CB82
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 17:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfENPMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 11:12:39 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40702 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfENPMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 11:12:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id d31so8785980pgl.7;
        Tue, 14 May 2019 08:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dm8dUNxqFzjXYzf0vGZtO+jODptjt86dBovZ/zou7XQ=;
        b=sogj6wWy95JqrPPufFa+ZSyM7IOQfJmlJr4GYywOR6eOQdPqHFZ6EfId0QvBNb1FAx
         x1IRKOkT4GfhS3SWhu7Vl5OUFq3MLKk+5Ysakj0zr0x0K+aVue6tyQAPgMfyCP6RGEFK
         ON0wqym0Nwd0PMVTgKgReyrTMahF1xi4cj54OL1pf2/mZX2w/eOyjeOc203lT+ClvnDj
         SMrPgnSwAv29eSBMKljzyeV4yfmOS+/OJGqyqtbjtY7L/e+mT3o5mddhpxSjIcyw3Pud
         RJQ4P7PkhndIa5v+1lOOZzKcHGImyWrspw1/bYi6jm0S+91VLtoe5HmcAMuvqfGTPi38
         hrMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dm8dUNxqFzjXYzf0vGZtO+jODptjt86dBovZ/zou7XQ=;
        b=f3vrzNvtsa+4OhboNaItqqCLykRWP1tpSKKmrnbwri3C4DXIKLwNbcTH7nRpNNAw+V
         7uIofNRCiCmI9CI4F4sUj/Kfsqycz2dGOXNeGGjg11tLRw+W44ei767mG2cGDhNVS9aJ
         SBTrMYCY/F0t0IBTU+S3l378ioEeXT2M/s8v4mBC1MJrErgtuqa1I0oKjLzc7R0nRkFq
         xkbf3mU9hUOkeVnRK9Ntf04qtHoo7OKK5seeygN0Tdt0WcFOzc8iZz9pZP8/ulblfyoo
         3pCcrrtjCHqFw55x0MEUw6+Hcmo9DdAnruKDUyQ13HQMWWekp40r/O8K4dCGYiXPfG2A
         CXug==
X-Gm-Message-State: APjAAAUVgo/FJ9ZNUqXmKu7YEU20DcXBRh8hEPptpBGG0uxY7UszlcxY
        Bzq+7HkSuMU6tkfFS3BUiTI=
X-Google-Smtp-Source: APXvYqzAyPFaPbFrljCpc0Bf0GPmNvStDgQwNXkbonx+P0pHd5cQafypjlEVkHS4KfhQ1Uhk+l0Amg==
X-Received: by 2002:a63:27c3:: with SMTP id n186mr35491171pgn.189.1557846758716;
        Tue, 14 May 2019 08:12:38 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn (89.208.248.35.16clouds.com. [89.208.248.35])
        by smtp.googlemail.com with ESMTPSA id i65sm25426594pgc.3.2019.05.14.08.12.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 08:12:38 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] atm: iphase: Avoid copying pointers to user space.
Date:   Tue, 14 May 2019 23:11:59 +0800
Message-Id: <20190514151205.5143-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ia_cmds.sub_cmd is MEMDUMP_DEV in ia_ioctl,
nullify the pointer fields of iadev before copying
the whole structure to user space.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/atm/iphase.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 70 insertions(+), 3 deletions(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 5278c57dce73..3ca73625fb1a 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -2746,11 +2746,71 @@ static int ia_change_qos(struct atm_vcc *vcc, struct atm_qos *qos, int flags)
 	IF_EVENT(printk(">ia_change_qos\n");)  
 	return 0;  
 }  
+
+static void ia_nullify_pointers(IADEV *src, IADEV *dest)
+{
+	memset(dest, 0, sizeof(IADEV));
+	dest->tx_dma_q.qlen = src->tx_dma_q.qlen;
+	dest->tx_dma_q.lock = src->tx_dma_q.lock;
+	dest->tx_backlog.qlen = src->tx_backlog.qlen;
+	dest->tx_backlog.lock = src->tx_backlog.lock;
+	dest->tx_lock = src->tx_lock;
+	dest->tx_return_q.data.timestamp = src->tx_return_q.data.timestamp;
+	dest->close_pending = src->close_pending;
+	dest->close_wait.lock = src->close_wait.lock;
+	dest->timeout_wait.lock = src->timeout_wait.lock;
+	dest->num_tx_desc = src->num_tx_desc;
+	dest->tx_buf_sz = src->tx_buf_sz;
+	dest->rate_limit = src->rate_limit;
+	dest->tx_cell_cnt = src->tx_cell_cnt;
+	dest->tx_pkt_cnt = src->tx_pkt_cnt;
+	dest->rx_dma_q.qlen = src->rx_dma_q.qlen;
+	dest->rx_dma_q.lock = src->rx_dma_q.lock;
+	dest->rx_lock = src->rx_lock;
+	dest->num_rx_desc = src->num_rx_desc;
+	dest->rx_buf_sz = src->rx_buf_sz;
+	dest->rxing = src->rxing;
+	dest->rx_pkt_ram = src->rx_pkt_ram;
+	dest->rx_tmp_cnt = src->rx_tmp_cnt;
+	dest->rx_tmp_jif = src->rx_tmp_jif;
+	dest->drop_rxpkt = src->drop_rxpkt;
+	dest->drop_rxcell = src->drop_rxcell;
+	dest->rx_cell_cnt = src->rx_cell_cnt;
+	dest->rx_pkt_cnt = src->rx_pkt_cnt;
+	dest->mem = src->mem;
+	dest->real_base = src->real_base;
+	dest->pci_map_size = src->pci_map_size;
+	dest->irq = src->irq;
+	dest->bus = src->bus;
+	dest->dev_fn = src->dev_fn;
+	dest->phy_type = src->phy_type;
+	dest->num_vc = src->num_vc;
+	dest->memSize = src->memSize;
+	dest->memType = src->memType;
+	dest->ffL = src->ffL;
+	dest->rfL = src->rfL;
+	dest->carrier_detect = src->carrier_detect;
+	dest->tx_dma_cnt = src->tx_dma_cnt;
+	dest->rx_dma_cnt = src->rx_dma_cnt;
+	dest->NumEnabledCBR = src->NumEnabledCBR;
+	dest->rx_mark_cnt = src->rx_mark_cnt;
+	dest->CbrTotEntries = src->CbrTotEntries;
+	dest->CbrRemEntries = src->CbrRemEntries;
+	dest->CbrEntryPt = src->CbrEntryPt;
+	dest->Granularity = src->Granularity;
+	dest->sum_mcr = src->sum_mcr;
+	dest->sum_cbr = src->sum_cbr;
+	dest->LineRate = src->LineRate;
+	dest->n_abr = src->n_abr;
+	dest->host_tcq_wr = src->host_tcq_wr;
+	dest->tx_dle_dma = src->tx_dle_dma;
+	dest->rx_dle_dma = src->rx_dle_dma;
+}
   
 static int ia_ioctl(struct atm_dev *dev, unsigned int cmd, void __user *arg)  
 {  
    IA_CMDBUF ia_cmds;
-   IADEV *iadev;
+   IADEV *iadev, *output;
    int i, board;
    u16 __user *tmps;
    IF_EVENT(printk(">ia_ioctl\n");)  
@@ -2769,8 +2829,15 @@ static int ia_ioctl(struct atm_dev *dev, unsigned int cmd, void __user *arg)
 	switch (ia_cmds.sub_cmd) {
        	  case MEMDUMP_DEV:     
 	     if (!capable(CAP_NET_ADMIN)) return -EPERM;
-	     if (copy_to_user(ia_cmds.buf, iadev, sizeof(IADEV)))
-                return -EFAULT;
+	     output = kmalloc(sizeof(IADEV), GFP_KERNEL);
+	     if (!output)
+		     return -ENOMEM;
+	     ia_nullify_pointers(iadev, output);
+	     if (copy_to_user(ia_cmds.buf, output, sizeof(IADEV))) {
+		     kfree(output);
+		     return -EFAULT;
+	     }
+	     kfree(output);
              ia_cmds.status = 0;
              break;
           case MEMDUMP_SEGREG:
-- 
2.11.0

