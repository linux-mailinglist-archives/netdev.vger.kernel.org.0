Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A28D25DA9E
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbgIDNzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730718AbgIDNyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 09:54:40 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1501C061244;
        Fri,  4 Sep 2020 06:54:39 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h2so1209136plr.0;
        Fri, 04 Sep 2020 06:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=00gl+iNRqCD/06CwSuYnvYFJj+D6FqLV6Ha+6OdW5o0=;
        b=Gwve0xHqOESk5XRj2J5YoY/XY0pDvDUcYxoL58FBqKdVN1BIs4zdd3sOpy+MeOKCOM
         oFUMmc2jeF89PGEwjJk54Aq7DvFkrtBJaUrQAu/6cg5ZqpwcAyaUzRnIzi1mnOPOKzhM
         TdUu2VW1//Sla4CybPIA4ma6sT3pTurtil5ZXLUzT3E9wJNG0pa8faFRZxREJhGK9H4+
         ZvkyrdGYwQdVwHDldV6Jeqjo/+uwN9ye5WE75ZrlcoO4ZjjndDjAUu07DyqYzXc6xebk
         p8UlENYIAZvWRB0tHx82snhOYmp45rfSS48WmgAAtNxEn/5EjaCQ/7VRbIF33Nn1A1Cv
         wN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=00gl+iNRqCD/06CwSuYnvYFJj+D6FqLV6Ha+6OdW5o0=;
        b=X6JmRced95TvKYIZx2rMHr5mclqWspAteKJsom8ofj/gXjNwBtafGG6Z89yN2MgL4L
         r9DzSaHNSdOwsXw5XRVDMyXN2cxhrLkMs2wkU5udKRAW82O/iD5NdNOxBKUthDjqniAM
         73/sYbketqEd6YZGJJs0Dqciy3DSvXg3afDkUphy1WDK1rrpGbmzwzdbKxgRoN5FT3qy
         0wHa73KAPrtlTE0rbXxRXiFwoeRNUxaTgAn72LT4ytALFlLgRKJLs/cBw0PredKJMtZh
         yHtcre0bLCV+VMQIm8k5xpJuVP9UkF4N78xWLcTdk7ChWVKjhG8gmGyDEtiI4ZKM+R8H
         DyPQ==
X-Gm-Message-State: AOAM530S/8evzQqvMaIxPFDIkrEyosAhgGWBsfaePc9vL+3AOAvYb2zT
        yeFFsSZMD1xY4ZySz/4LIUs=
X-Google-Smtp-Source: ABdhPJzJbE5rpgp1DiX2blOXUdtGirT7ZFHRnzhE+YUtNvIjD9OForeut3ciweX78vAgCcr9gajPjA==
X-Received: by 2002:a17:90a:ca03:: with SMTP id x3mr8376030pjt.92.1599227679442;
        Fri, 04 Sep 2020 06:54:39 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id g9sm6931239pfr.172.2020.09.04.06.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 06:54:38 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 6/6] ixgbe, xsk: finish napi loop if AF_XDP Rx queue is full
Date:   Fri,  4 Sep 2020 15:53:31 +0200
Message-Id: <20200904135332.60259-7-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200904135332.60259-1-bjorn.topel@gmail.com>
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Make the AF_XDP zero-copy path aware that the reason for redirect
failure was due to full Rx queue. If so, exit the napi loop as soon as
possible (exit the softirq processing), so that the userspace AF_XDP
process can hopefully empty the Rx queue. This mainly helps the "one
core scenario", where the userland process and Rx softirq processing
is on the same core.

Note that the early exit can only be performed if the "need wakeup"
feature is enabled, because otherwise there is no notification
mechanism available from the kernel side.

This requires that the driver starts using the newly introduced
xdp_do_redirect_ext() and xsk_do_redirect_rx_full() functions.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 23 ++++++++++++++------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 3771857cf887..a4aebfd986b3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -93,9 +93,11 @@ int ixgbe_xsk_pool_setup(struct ixgbe_adapter *adapter,
 
 static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 			    struct ixgbe_ring *rx_ring,
-			    struct xdp_buff *xdp)
+			    struct xdp_buff *xdp,
+			    bool *early_exit)
 {
 	int err, result = IXGBE_XDP_PASS;
+	enum bpf_map_type map_type;
 	struct bpf_prog *xdp_prog;
 	struct xdp_frame *xdpf;
 	u32 act;
@@ -116,8 +118,13 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
 		break;
 	case XDP_REDIRECT:
-		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
+		err = xdp_do_redirect_ext(rx_ring->netdev, xdp, xdp_prog, &map_type);
+		if (err) {
+			*early_exit = xsk_do_redirect_rx_full(err, map_type);
+			result = IXGBE_XDP_CONSUMED;
+		} else {
+			result = IXGBE_XDP_REDIR;
+		}
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
@@ -235,8 +242,8 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	struct ixgbe_adapter *adapter = q_vector->adapter;
 	u16 cleaned_count = ixgbe_desc_unused(rx_ring);
+	bool early_exit = false, failure = false;
 	unsigned int xdp_res, xdp_xmit = 0;
-	bool failure = false;
 	struct sk_buff *skb;
 
 	while (likely(total_rx_packets < budget)) {
@@ -288,7 +295,7 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 
 		bi->xdp->data_end = bi->xdp->data + size;
 		xsk_buff_dma_sync_for_cpu(bi->xdp, rx_ring->xsk_pool);
-		xdp_res = ixgbe_run_xdp_zc(adapter, rx_ring, bi->xdp);
+		xdp_res = ixgbe_run_xdp_zc(adapter, rx_ring, bi->xdp, &early_exit);
 
 		if (xdp_res) {
 			if (xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR))
@@ -302,6 +309,8 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 
 			cleaned_count++;
 			ixgbe_inc_ntc(rx_ring);
+			if (early_exit)
+				break;
 			continue;
 		}
 
@@ -346,12 +355,12 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 	q_vector->rx.total_bytes += total_rx_bytes;
 
 	if (xsk_uses_need_wakeup(rx_ring->xsk_pool)) {
-		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
+		if (early_exit || failure || rx_ring->next_to_clean == rx_ring->next_to_use)
 			xsk_set_rx_need_wakeup(rx_ring->xsk_pool);
 		else
 			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool);
 
-		return (int)total_rx_packets;
+		return early_exit ? 0 : (int)total_rx_packets;
 	}
 	return failure ? budget : (int)total_rx_packets;
 }
-- 
2.25.1

