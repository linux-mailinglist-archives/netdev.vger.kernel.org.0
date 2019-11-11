Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F89F728D
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 11:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfKKKyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 05:54:43 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39477 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKKKyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 05:54:43 -0500
Received: by mail-wm1-f65.google.com with SMTP id t26so12700414wmi.4
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 02:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lToaTmvr8fy0RpR4xphta47cdM5tajY9+snWlAWAmmk=;
        b=m/C0zTKIOmGC5v630lFUm3qIJArxvuUUaaagoZd/CTNqt14WZj7HquPC7t+WgpqiDD
         AE7/WfQ6ispw1Ey8zKxbxi7kQOJsQ+xaLbKs+8pwDec4LCiyFfElohL+DVNOn7R2sRr9
         NTEHJ5I2Xj77N1pC05GLg8mcd/8eX4UpNpLYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lToaTmvr8fy0RpR4xphta47cdM5tajY9+snWlAWAmmk=;
        b=eF0fY3DHzIZs2FS7IPWgalDsZmjtPJf6ju0d2LvPoynPOEXlDDYwxD/mpRO9hOdLru
         G5bIPPUYzyppZ04WNMZ7Iigx0pNdJ32h5BOl/3/WuK24RDJjMfFPd2SgzRpHXZkMjhh/
         b8eW1HtjSXOujWjAEPFjDypm2861FFs4PjLGNIZGUmQG2rjwngpuZGUES4LR01VaKqPK
         wGktVw6W+UmhJJH2s1Gyx7ss29tlsS2HJwDlSlSeJqktGP+396lPAFuYNXrlY0STREAS
         eyM2NMY6a6csFPFO4Q4iMyOeICrEkorcMSQFN1StFPHVnlYmuayM6l8jYS5yG1SiGX9d
         RLAQ==
X-Gm-Message-State: APjAAAVdnZCbewJB/r9ArlULxNhFEkr8oh4r13aCtUhnmjE/vZoXYmhl
        8gxbRQm/Rt6KuRGQ9rKH5KvnS4w7TOww49qq
X-Google-Smtp-Source: APXvYqzEHvqlLf7DlW4OFCMB7eDjAjua2in9y4YUdN6gCY38kbdvIzivc2fryHjd8+TbjBf6uTTvbw==
X-Received: by 2002:a1c:a406:: with SMTP id n6mr21168439wme.90.1573469680641;
        Mon, 11 Nov 2019 02:54:40 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:6be3:785e:4546:dd8f])
        by smtp.gmail.com with ESMTPSA id z9sm6172585wrv.35.2019.11.11.02.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 02:54:39 -0800 (PST)
From:   Arthur Fabre <afabre@cloudflare.com>
To:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Charles McLachlan <cmclachlan@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Arthur Fabre <afabre@cloudflare.com>
Subject: [PATCH net-next] sfc: trace_xdp_exception on XDP failure
Date:   Mon, 11 Nov 2019 10:51:00 +0000
Message-Id: <20191111105100.2992-1-afabre@cloudflare.com>
X-Mailer: git-send-email 2.24.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sfc driver can drop packets processed with XDP, notably when running
out of buffer space on XDP_TX, or returning an unknown XDP action.
This increments the rx_xdp_bad_drops ethtool counter.

Call trace_xdp_exception everywhere rx_xdp_bad_drops is incremented to
easily monitor this from userspace.

This mirrors the behavior of other drivers.

Signed-off-by: Arthur Fabre <afabre@cloudflare.com>
---
 drivers/net/ethernet/sfc/rx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index a7d9841105d8..5bfe1f6112a1 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -678,6 +678,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 				  "XDP is not possible with multiple receive fragments (%d)\n",
 				  channel->rx_pkt_n_frags);
 		channel->n_rx_xdp_bad_drops++;
+		trace_xdp_exception(efx->net_dev, xdp_prog, xdp_act);
 		return false;
 	}
 
@@ -724,6 +725,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 				netif_err(efx, rx_err, efx->net_dev,
 					  "XDP TX failed (%d)\n", err);
 			channel->n_rx_xdp_bad_drops++;
+			trace_xdp_exception(efx->net_dev, xdp_prog, xdp_act);
 		} else {
 			channel->n_rx_xdp_tx++;
 		}
@@ -737,6 +739,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 				netif_err(efx, rx_err, efx->net_dev,
 					  "XDP redirect failed (%d)\n", err);
 			channel->n_rx_xdp_bad_drops++;
+			trace_xdp_exception(efx->net_dev, xdp_prog, xdp_act);
 		} else {
 			channel->n_rx_xdp_redirect++;
 		}
@@ -746,6 +749,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 		bpf_warn_invalid_xdp_action(xdp_act);
 		efx_free_rx_buffers(rx_queue, rx_buf, 1);
 		channel->n_rx_xdp_bad_drops++;
+		trace_xdp_exception(efx->net_dev, xdp_prog, xdp_act);
 		break;
 
 	case XDP_ABORTED:
-- 
2.24.0.rc2

