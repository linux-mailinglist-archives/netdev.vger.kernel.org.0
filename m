Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97942AD453
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 12:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbgKJLCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 06:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgKJLCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 06:02:14 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5788C0613CF;
        Tue, 10 Nov 2020 03:02:12 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 10so11111643pfp.5;
        Tue, 10 Nov 2020 03:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KQXOqU3sgAKcC6WLzuY/tSnBXRqhvqvJ7oAX30tadAw=;
        b=J4S9UgYKANhxiw2JmO3tlzoy5UuSeHrXUJCm0oVAE7sN+LrVEDHg2UxiD99M5qNGGm
         blEFWXeW+4xeniL2ggf6nJuaU80JpCYjGgRyZd9NFL3lxuEeWNZxvT5R6hfwLtL0Cpls
         KORD1J0PVKV1/BVlcTJl+FGLs5/3cierBUEx8vNzJMrh8FAo0sAzgJAPVJddki2BFI5f
         7HB4QlCg6HpCmTX5j6CxeUycukZI+wz2j2ktrXwspHooEuNoDFkRw64brjF6z2bdL4WU
         fT26VWnb8FrHnvlk410js1EX/LxlDFRUet0MOajNOPswMD2GVNFJBv4B9K8lsVDGpcQe
         7Xfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KQXOqU3sgAKcC6WLzuY/tSnBXRqhvqvJ7oAX30tadAw=;
        b=YUBIPlWLyhfw/Ze60bEkoufizs67kf+dIzeqAeuqlyIEkyS38URMDfvSQIyX5BfeZ/
         PS36JJ8ME5olTQEQxT9FyyD5MEHBNmKncAWFolDL1cY5BYG7OugpifobKjho+IrOxOM3
         OJjyVYbP6mEQJefHeM5kU3IdH/USgyv43rCMsXjY40xRLP2XBcWHTjvLIDT4bTobqyGv
         dWcBGr/fSTHY3FwYiNnOL99GT346A5Hr2P0qYY/ETjpJmfCA4ezVRwoSYikjLjFBTTTF
         2LaJAGYKTyZmH1XYVaXCGGKze7jh5qT62L1XV1niAVJ2pvqC2VMC4vggHV9j7unOXePt
         lGNA==
X-Gm-Message-State: AOAM532vf28zgDzuncqJqyxot07tkN5kmuolinpwiLrEN1OcbJMLPf3t
        88gZAJHRX3LMDhCTc5Xm5fc=
X-Google-Smtp-Source: ABdhPJwRGuwTsExWngoV4BxMxccDa3HVjgGDrCrK4lSaC31y1Ni9oHZqVYAKWALykQm97u8XgALuaw==
X-Received: by 2002:a62:1901:0:b029:18c:659c:e55f with SMTP id 1-20020a6219010000b029018c659ce55fmr469087pfz.51.1605006132418;
        Tue, 10 Nov 2020 03:02:12 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id 22sm3012024pjb.40.2020.11.10.03.02.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Nov 2020 03:02:11 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, kuba@kernel.org, john.fastabend@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v2 2/5] i40e: remove unnecessary sw_ring access from xsk Tx
Date:   Tue, 10 Nov 2020 12:01:31 +0100
Message-Id: <1605006094-31097-3-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605006094-31097-1-git-send-email-magnus.karlsson@gmail.com>
References: <1605006094-31097-1-git-send-email-magnus.karlsson@gmail.com>
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
index 6acede0..61aa1fc 100644
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

