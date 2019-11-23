Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA33A107D64
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 08:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfKWHNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 02:13:10 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45032 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfKWHNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 02:13:10 -0500
Received: by mail-pf1-f195.google.com with SMTP id d199so108107pfd.11;
        Fri, 22 Nov 2019 23:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IkBEoocB6jcrJRHBAxY7pUmAGC9lo0I1WYe0yhTdIzw=;
        b=O6YC1C+TergPygOmd/dwu0F06HwAxkx+77ulJRMC5OdZQh6t71I4qrWugEWedGqYk7
         7b4fY1vawvQbknA7ntvALpN+Vz7681N+WGoYhR4rLdTnLVkPa9E9Pz3/oV+bD5AyyLs1
         9u01bZRAAmSrhYVp4NL7taaZrukQrMKfONS1EGNjQh0yE6jU4a4wa4Dpr/vTHhI0dhJ2
         z2aVk6bxZFXy471vlz7unD8l4wAHgjqJKZpbvFwTJ0M8jAb6R0EjaunW95VNHBMt2Ps0
         FebeXjWug5c+kP7qdznJhFoZR8qaa5mGyX7zwsA0XMCwDVJbTRU/jqyhVALxjFmJtRi4
         SlMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IkBEoocB6jcrJRHBAxY7pUmAGC9lo0I1WYe0yhTdIzw=;
        b=LeJf1sbZd1JRFYpGY0SUzg883SyRRzNz+R47iTPqYqznxNrAjkM+dzBRveWpBPVNXN
         gpLIIXjGOpc5BkkJdk2SkGq/VR6c6P+VOMXE1g065+Kc2WVlB691Rf8LGUUhZYIn0qA3
         bRLG7HIJfc/XKQfWpTp/2w4APDgA6OecPsoOS8uwRgz1leR1+EDWe/jd4Db/MLTmMEHf
         aVtOdEBjdei41O+KBBFLl6iDT4cde/Paf85EwrO/saWqEMkbyEderp14+Dj24YNyKb8b
         dy+fWGtvBzy+cLgjxjhs+gtS1xRyDxmBIGqIN1JoIp3wEzscbmroh383KhLhzBslC6l0
         p3EA==
X-Gm-Message-State: APjAAAUdEN/HTEAYj0f8gz/jqyYSFSoyKHz0YFP/d7qOrplHWaFP4k76
        ajoRmCUKtWEP+XzRcrWsGtAbpqTf6xzDJw==
X-Google-Smtp-Source: APXvYqxk+2WrgQEvB+QstknhQaSna7GdW0iWP4YV37Ev/9za62Vj3ilSDwJL4p6OZcr9QsDOO3ooRA==
X-Received: by 2002:a63:6705:: with SMTP id b5mr20718998pgc.23.1574493189229;
        Fri, 22 Nov 2019 23:13:09 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id 67sm798960pjz.27.2019.11.22.23.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 23:13:08 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com, tariqt@mellanox.com,
        saeedm@mellanox.com, maximmi@mellanox.com
Subject: [PATCH bpf-next v2 4/6] ixgbe: start using xdp_call.h
Date:   Sat, 23 Nov 2019 08:12:23 +0100
Message-Id: <20191123071226.6501-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191123071226.6501-1-bjorn.topel@gmail.com>
References: <20191123071226.6501-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

This commit starts using xdp_call.h and the BPF dispatcher to avoid
the retpoline overhead.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 25c097cd8100..9c5cea239258 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -37,6 +37,7 @@
 #include <net/mpls.h>
 #include <net/xdp_sock.h>
 #include <net/xfrm.h>
+#include <linux/xdp_call.h>
 
 #include "ixgbe.h"
 #include "ixgbe_common.h"
@@ -2193,6 +2194,8 @@ static struct sk_buff *ixgbe_build_skb(struct ixgbe_ring *rx_ring,
 	return skb;
 }
 
+DEFINE_XDP_CALL(ixgbe_xdp_call);
+
 static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 				     struct ixgbe_ring *rx_ring,
 				     struct xdp_buff *xdp)
@@ -2210,7 +2213,7 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 
 	prefetchw(xdp->data_hard_start); /* xdp_frame write */
 
-	act = bpf_prog_run_xdp(xdp_prog, xdp);
+	act = xdp_call_run(ixgbe_xdp_call, xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
 		break;
@@ -10273,6 +10276,8 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 			    adapter->xdp_prog);
 	}
 
+	xdp_call_update(ixgbe_xdp_call, old_prog, prog);
+
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
-- 
2.20.1

