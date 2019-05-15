Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C581E9B8
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 10:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfEOID3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 04:03:29 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33497 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfEOID2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 04:03:28 -0400
Received: by mail-pg1-f193.google.com with SMTP id h17so976467pgv.0
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 01:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=raTHMxknDARRCrS5ioiUqBMsld3X7nmVvoXdPy+/O3M=;
        b=TWMrSXSSkhX0jovy2Dfm3myTVY8Fj6fK4FpXYY4Kz/N+qJbnegtdQWRGqhKwXba0Rd
         H99xWKibyXwGkFsXYPxbMTxKHUzXk4h48Muxgoz8fFZ0v8jr2xvr0M9o0VC4u/7wlGDZ
         tBlGNBwrnhVgbglZZJchyX9bD47FOAnLPde+l9YXbA+rj6V5JCumW3bo5dadIrfkMtxA
         V1Rg8hPLwrBjYvDvygXIb3wNK7wIOd02k0zF1POt2GaKc1reBIX1onY87qDqVsZcYshj
         VgSNFRdLH/FFETVAR/PL6CRjkePb1lPpdru3IgiXVDhCnjJHWdsCNvfu9mFW6MWrBaYI
         Vl9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=raTHMxknDARRCrS5ioiUqBMsld3X7nmVvoXdPy+/O3M=;
        b=DcOo5dgYA4OqOw8WvsRya61k5GpeKh9WKlgfxM/RJrU6So34LY2giN1jDStw73f8MM
         Ec6a1z4P1OxQcHBBLrLDsHCW3ZJE+43VT9kaAcrWrbnJamoCe7vtxjUtwiBYMaSi7sj3
         j3t3zCcq5mZ3+V/PMK7G7MWcl/Wk7cKcO5cOhpNK73YMeVcpCVqAc0WI2YXMrqgCZ4j5
         Lyjysh31TdG9MtZDjNpH9XcYhDkbXXFzQxYoctiTyINC4WqxF8QP4GvoGJPjOhG6iXXZ
         GCtYtXRH19YRTLGNzSBRNhnKUnxeK0a6u551IyZmLYJu15XdCqeYNafR3prMIuA1VMjS
         MlIA==
X-Gm-Message-State: APjAAAX4U0kvEsjZPdOX7x11k90b4jzTc/qvkUkTo/GdQZ2Xf6fYGgui
        YDCig/k1o28tfZ49e9vdUDvLxA9dNvM=
X-Google-Smtp-Source: APXvYqzD8xRb+55b3T3/F/4No+D4ytaQknh168I4uCyH9JOZe/M+kPvXYrpiLyTQfhN+vX8EPKhiqA==
X-Received: by 2002:aa7:881a:: with SMTP id c26mr38348558pfo.254.1557907407552;
        Wed, 15 May 2019 01:03:27 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 37sm3104572pgn.21.2019.05.15.01.03.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 01:03:26 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>
Subject: [RFC 1/2] netvsc: invoke xdp_generic from VF frame handler
Date:   Wed, 15 May 2019 01:03:18 -0700
Message-Id: <20190515080319.15514-2-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190515080319.15514-1-sthemmin@microsoft.com>
References: <20190515080319.15514-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP generic does not work correctly with the Hyper-V/Azure netvsc
device because of packet processing order. Only packets on the
synthetic path get seen by the XDP program. The VF device packets
are not seen.

By the time the packets that arrive on the VF are handled by
netvsc after the first pass of XDP generic (on the VF) has already
been done.

A fix for the netvsc device is to do this in the VF packet handler.
by directly calling do_xdp_generic() if XDP program is present
on the parent device.

A riskier but maybe better alternative would be to do this netdev core
code after the receive handler is invoked (if RX_HANDLER_ANOTHER
is returned).

Fixes: 0c195567a8f6 ("netvsc: transparent VF management")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 06393b215102..bb0fc1869bde 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1999,9 +1999,15 @@ static rx_handler_result_t netvsc_vf_handle_frame(struct sk_buff **pskb)
 	struct net_device_context *ndev_ctx = netdev_priv(ndev);
 	struct netvsc_vf_pcpu_stats *pcpu_stats
 		 = this_cpu_ptr(ndev_ctx->vf_stats);
+	struct bpf_prog *xdp_prog;
 
 	skb->dev = ndev;
 
+	xdp_prog = rcu_dereference(ndev->xdp_prog);
+	if (xdp_prog &&
+	    do_xdp_generic(xdp_prog, skb) != XDP_PASS)
+		return RX_HANDLER_CONSUMED;
+
 	u64_stats_update_begin(&pcpu_stats->syncp);
 	pcpu_stats->rx_packets++;
 	pcpu_stats->rx_bytes += skb->len;
-- 
2.20.1

