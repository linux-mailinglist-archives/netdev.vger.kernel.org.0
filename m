Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FD42CC05A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 16:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgLBPIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 10:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgLBPIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 10:08:20 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4593C0613D6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 07:07:39 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id w187so1419109pfd.5
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 07:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bL8GQBSptP0Gq3pqr4BlBhH/zVnBYN2CeKoCMXNaK1I=;
        b=uo17RS5PP7aNMn3Hyk4DS49/NlHZEGUzUaggsVxu+I9yNLTTE3MN1JrylLETQ8RkXy
         eosiIMktNPsdbdquRHAYXsfZcj0xCzSMSiqp8NVJfsKX/K98/7Gky2+UuvKXgolmP0Il
         0IO27UJuy2QKzThdKovd5a/CzMEi4Vu1jTXuBJtnW83mKZ7kvImfR5iE5WhYE5hTbRGU
         I4sXTOhetvK7nAn7KcaixbTO2+n2EgKGuSxOqhxWAFYeDgpO5ZO9ABc240xdPdfINHoE
         ae8i0HOp1uHPjAfqnbB0AeRIw9opYbYG4Sp8xL+UWhPrk+VUh5B/Wiw4ff72rgdoc2ng
         QUYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bL8GQBSptP0Gq3pqr4BlBhH/zVnBYN2CeKoCMXNaK1I=;
        b=ToHIe8zuRHSuomVoibVB8A+HXHjNN4axcSpOZvoeDVyjSteYHOrb5+a5Pf9QKljF2y
         hMTZQFolA80IY2SY2WQuQUJAt74wqzRu9FaIReXpD4SOHJqP36eyShD1jOlTCslYMXmm
         8krj0TO1Z89sDNU4aMsOWEIQsTylNMWpUbaVJfl6HucCIp6tIqE0bSQptOANsXFuFdUA
         pJyhrivbEv/O6StbglewjOgUHDJ1k9hly4rQ/7yIBeAXVYXlLtVNOSAXwCC5lV0ZzAw1
         sDUnocfJzb5sD8NSSRalce763W8hGREoYkzUFawuR66E9Q05PWQQj5XEOzvwFRznREc0
         UDUw==
X-Gm-Message-State: AOAM532tmmhhMZEIUbBdsVIpNJXr34YlfNa2VIyTZCAbRWYdoy49EBue
        Kix2Z4xNlb+LWDO35w9Ct4Q=
X-Google-Smtp-Source: ABdhPJw9ZoYVEZ77jgu/AcWe9PFdfzPR5IVCbe3FNDvNqMSTqUqhpD1JFduPPw6g9g10kPwMhJf9dg==
X-Received: by 2002:a63:7f03:: with SMTP id a3mr241963pgd.313.1606921659445;
        Wed, 02 Dec 2020 07:07:39 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id p21sm148537pfn.87.2020.12.02.07.07.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Dec 2020 07:07:38 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH net-next 1/3] i40: optimize for XDP_REDIRECT in xsk path
Date:   Wed,  2 Dec 2020 16:07:22 +0100
Message-Id: <20201202150724.31439-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201202150724.31439-1-magnus.karlsson@gmail.com>
References: <20201202150724.31439-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Optimize i40e_run_xdp_zc() for the XDP program verdict being
XDP_REDIRECT in the zsk zero-copy path. This path is only used when
having AF_XDP zero-copy on and in that case most packets will be
directed to user space. This provides a little over 100k extra packets
in throughput on my server when running l2fwd in xdpsock.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 67febc7b6798..fbf76c67d77d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -159,6 +159,13 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
+	if (likely(act == XDP_REDIRECT)) {
+		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
+		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
+		rcu_read_unlock();
+		return result;
+	}
+
 	switch (act) {
 	case XDP_PASS:
 		break;
@@ -166,10 +173,6 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->queue_index];
 		result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
 		break;
-	case XDP_REDIRECT:
-		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
-		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
-- 
2.29.0

