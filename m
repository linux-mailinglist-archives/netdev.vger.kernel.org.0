Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331172B425F
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgKPLNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbgKPLNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 06:13:50 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF46C0613CF;
        Mon, 16 Nov 2020 03:13:50 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id b3so8196887pls.11;
        Mon, 16 Nov 2020 03:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=44RUaPFcwFiB3nkeuTIXUu39UgaMmkBucMAXuU99ZwQ=;
        b=TIcuSgUWSWuwn2Jjx1KnB6sHrdeMikkoB9olf3FVb3jeqC3BzKywc7h6cKpbHMBeX3
         +NEr1FzsgcBQBmtEwqaNPYoOya73w9zL+Q90R2ToYPhHOsPcvJesPpVSyjwmnxm0LpJN
         1QXDy+xlDUxI9Nu8Sw+nfSJ5trm8df+m7JZhLzjAQknzTVRjM3byAfcJqtOeDYoHg7+9
         HTK20aO3/V2kwQWHCWudepK15mqqNhP/wJwxPayM6HtQGGDZskemvInKngX5aDttsBdP
         iw8ua714FhhRDHCdNCl3+rbbG7pUQk/XSXEnBP/DjOucqNkTTo0OTG+T7Oj0b1sQUR1p
         /rmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=44RUaPFcwFiB3nkeuTIXUu39UgaMmkBucMAXuU99ZwQ=;
        b=hnC4DjkcSCuLH/YToLtSAh3QFkBqC341dPv7XWSZSR26QBYvwhIub7EAkFW7qCOPD5
         Xho9Wu2Z3C+F8wWFPNYrXpXhS6ho34WqhYCHpL7xuIi+dzkd1RScnpBmpcSvWSM7pHbZ
         11F+d6RMMR6PRnBgSi9GRUUQS8yuM9f7xnbflCOOu/OIuwtyc+8XDx2u9R8Gyn4LFB3z
         /7igP7cqvD1BAudzz5j6YOozvwtfnVioa7kFjibO1v9Lcy9sDjSiC//48Eu9wtdz1UAK
         kYkNS3QEheEBrKsAskunY3VrH76SeP3IWiPtalCHGVKcjbiTS3bvUZzy3oyJudKmhTc+
         oDpA==
X-Gm-Message-State: AOAM533O/AHffv50KY2ZUYqsSL9unQsyHnAXBXWfnllLQGAG6njDSE5v
        Bb+h2E14duFwe1/vLYHllUY=
X-Google-Smtp-Source: ABdhPJyZfCFm7Pec1GQujbx90ewEdjqUNaZF5VJN51QlLDhc5+u0TOr06c1NI6pNZtLBSC/TZGogQQ==
X-Received: by 2002:a17:902:361:b029:d7:cd0b:e6f2 with SMTP id 88-20020a1709020361b02900d7cd0be6f2mr12816425pld.77.1605525230298;
        Mon, 16 Nov 2020 03:13:50 -0800 (PST)
Received: from localhost.localdomain ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id u24sm19486826pfm.81.2020.11.16.03.13.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2020 03:13:49 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, kuba@kernel.org, john.fastabend@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v3 2/5] i40e: remove unnecessary sw_ring access from xsk Tx
Date:   Mon, 16 Nov 2020 12:12:44 +0100
Message-Id: <1605525167-14450-3-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605525167-14450-1-git-send-email-magnus.karlsson@gmail.com>
References: <1605525167-14450-1-git-send-email-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Remove the unnecessary access to the software ring for the AF_XDP
zero-copy driver. This was used to record the length of the packet so
that the driver Tx completion code could sum this up to produce the
total bytes sent. This is now performed during the transmission of the
packet, so no need to record this in the software ring.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 567fd67..20d2632 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -392,7 +392,6 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 {
 	unsigned int sent_frames = 0, total_bytes = 0;
 	struct i40e_tx_desc *tx_desc = NULL;
-	struct i40e_tx_buffer *tx_bi;
 	struct xdp_desc desc;
 	dma_addr_t dma;
 
@@ -404,9 +403,6 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma,
 						 desc.len);
 
-		tx_bi = &xdp_ring->tx_bi[xdp_ring->next_to_use];
-		tx_bi->bytecount = desc.len;
-
 		tx_desc = I40E_TX_DESC(xdp_ring, xdp_ring->next_to_use);
 		tx_desc->buffer_addr = cpu_to_le64(dma);
 		tx_desc->cmd_type_offset_bsz =
@@ -415,7 +411,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 				   0, desc.len, 0);
 
 		sent_frames++;
-		total_bytes += tx_bi->bytecount;
+		total_bytes += desc.len;
 
 		xdp_ring->next_to_use++;
 		if (xdp_ring->next_to_use == xdp_ring->count)
-- 
2.7.4

