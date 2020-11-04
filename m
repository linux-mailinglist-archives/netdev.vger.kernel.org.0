Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05C52A65F3
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbgKDOJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730160AbgKDOJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:09:47 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191E3C0613D3;
        Wed,  4 Nov 2020 06:09:47 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id x13so16692999pgp.7;
        Wed, 04 Nov 2020 06:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YzZ/wVl7IVpa6qekpbqcxmPtcuUgeOFQO5frBo5Xdhk=;
        b=S+f8J1BLMMB2KLffbLNDm3H2iEhiqrofNTZMdAIHgyAZTWE5+4lZap6IBaHV0YHHbO
         r1HX/6xG4F4e7/gcil+Zz/zn4tMVMb36GNIYuBDwfBWEDHPMaXkL4yrMprN4a7B6kFsa
         KTaouOc3GsDSdhdYA7rmj5uRc3BnwW/oTQEZNHKnjrocE8aUzkJNuXJXXC2txlGCqiEp
         t74ZVW1XQDLKFWUiPdmUxZscbk+QDIUbYh2lSVZ7rlNyksyb8N/nLMAt/Oms0lZJnrx6
         JRgRkyYSIooMayxIUtMdVRrNR8iATdXjXjO5U2D/+Er6z9ABYVibR7p2Gwgk2RugtQpA
         S/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YzZ/wVl7IVpa6qekpbqcxmPtcuUgeOFQO5frBo5Xdhk=;
        b=kUaXBwloTcqCgQg+tlhx1V4Z4vjYFb9tZgQ/u3Q06ardHd1V1vN/lr8YEYEevP0LtR
         lNh3Astbw7h+O/XViKt6LPpep940jiuh0Epe64xTgD+uasqrMQa4WKDKMYwPjqfZgNWK
         YqUIPPa49vCNsn28wE91qBPNn552HifkSXWh7OhmxT3ylO3apvAbw6UAf6eqbgIB0fye
         BRcBrzBS/wKA8eMFzm/7X9HMWDeLY3E/n7UmtNGWjpxpqqN/PGKV1XEVOmWX/IVi+W0T
         GVNHTW41llVVY8HIbU8V0bUifvJuikiT0sBfTp6yqch0Ug3vIuRTxcuGpyfLN1ja5ZLr
         1WNA==
X-Gm-Message-State: AOAM530YdDrHP6PvN4qaWlxSmOw5C0PT6SbLnu0t2GrFCcXIkiJIyoGk
        42wZq+roGCSBTWTgPznbPOI=
X-Google-Smtp-Source: ABdhPJxXLDKaUdff+0Jfv4EqzSjr4mGB/LwOQjUs0rs4hf2CocTMEUfHXdUUN58KhXCOFZopjGo9pQ==
X-Received: by 2002:a17:90a:e996:: with SMTP id v22mr4816309pjy.170.1604498986698;
        Wed, 04 Nov 2020 06:09:46 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q123sm2724818pfq.56.2020.11.04.06.09.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:09:46 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 3/6] i40e: remove unnecessary sw_ring access from xsk Tx
Date:   Wed,  4 Nov 2020 15:08:59 +0100
Message-Id: <1604498942-24274-4-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
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
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index f8815b3..eabe1a3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -394,7 +394,6 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 {
 	unsigned int sent_frames = 0, total_bytes = 0;
 	struct i40e_tx_desc *tx_desc = NULL;
-	struct i40e_tx_buffer *tx_bi;
 	struct xdp_desc desc;
 	dma_addr_t dma;
 
@@ -406,9 +405,6 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma,
 						 desc.len);
 
-		tx_bi = &xdp_ring->tx_bi[xdp_ring->next_to_use];
-		tx_bi->bytecount = desc.len;
-
 		tx_desc = I40E_TX_DESC(xdp_ring, xdp_ring->next_to_use);
 		tx_desc->buffer_addr = cpu_to_le64(dma);
 		tx_desc->cmd_type_offset_bsz =
@@ -417,7 +413,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 				   0, desc.len, 0);
 
 		sent_frames++;
-		total_bytes += tx_bi->bytecount;
+		total_bytes += desc.len;
 
 		xdp_ring->next_to_use++;
 		if (xdp_ring->next_to_use == xdp_ring->count)
-- 
2.7.4

