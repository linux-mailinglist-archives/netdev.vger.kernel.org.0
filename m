Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D243107D66
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 08:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKWHNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 02:13:17 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40016 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfKWHNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 02:13:17 -0500
Received: by mail-pf1-f196.google.com with SMTP id i187so579833pfc.7;
        Fri, 22 Nov 2019 23:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sctTfzWpHtUmUt+M9jkjT3mJGxfzG3itlmwgzJd9BbU=;
        b=pNq9k4sIuQPG1x3mHulzSGwL15peIkA/tXuBuQR0hs7DrDKM948D7N0hW4z7CDEbyJ
         ouoOJNKojyRoYB3PPjGhWyiwTIQmzQpJlVURDyyRpgCf9R31J7GpKh9wjB0ijMycH67r
         QIQHaG+PFFF93Bhe57ir1wYpA7UTG8ZZmhxsCgboTRFDbVpj95woRg7OasSMPreSyuKW
         GzNwSYhSUsZryctyfJOzqYUBKP8r13nyB567WeD2vwenoHJnxFq/RKVq8BS0W+5aV+X5
         /79ivKEdT/PBr6eAEceOucxuTDpi9pBubW/esL3zJGQLKnFi9glOfMhRZqDDREeSiQ9O
         Gkeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sctTfzWpHtUmUt+M9jkjT3mJGxfzG3itlmwgzJd9BbU=;
        b=c2EuCeGFpv48JZ88EcFA2qRlLsyj0KPgNZlbK78AGoM2pivEL/tfC0tXXhlx3kqsqw
         qFT5cNtZDI8wYoChYrNXF+6D6GunwwbyXdkKerblwtbXZXltS5mJc2bl69fKeCrQYIPs
         TFpe3pQ8CdptIQFTEizQ80sxa7AIXM3d22E/kBTW7RBNSHgT9X7z+xqeYCGeCj+OI7mU
         1Ii4eWM2DTJMP9TYk/FSn2qsfPDU4085T+snoy3swrlEK3Nf2jlTgAu7VUTuLm9dGkyM
         WvyQYjgcKFEfWt0ctvFfO9HoRRCFxj2mB9h6pd8Xy8Es4B3gnk6RwLSYgc+NXBBK4P+6
         Mx3g==
X-Gm-Message-State: APjAAAXLEgYgxSl0WfBI3IfJmkmy97flnr8Fr5L5CFAVA5qXtVTrXmnc
        y54/5qZ8Mwt0vAYgHCil8qq7cltkC/s7gw==
X-Google-Smtp-Source: APXvYqxQbraQWsPFKuxh/T45xHHKCZZNNddrHMcoT7y2wZwmmYVEVj5O/A50ead244CAMZr28SPSyg==
X-Received: by 2002:a63:e54f:: with SMTP id z15mr20750331pgj.453.1574493194750;
        Fri, 22 Nov 2019 23:13:14 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id 67sm798960pjz.27.2019.11.22.23.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 23:13:14 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com, tariqt@mellanox.com,
        saeedm@mellanox.com, maximmi@mellanox.com
Subject: [PATCH bpf-next v2 5/6] net/mlx4_en: start using xdp_call.h
Date:   Sat, 23 Nov 2019 08:12:24 +0100
Message-Id: <20191123071226.6501-6-bjorn.topel@gmail.com>
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
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 7 ++++++-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c     | 5 ++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index d4697beeacc2..f2dea32e5599 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -41,6 +41,7 @@
 #include <net/ip.h>
 #include <net/vxlan.h>
 #include <net/devlink.h>
+#include <linux/xdp_call.h>
 
 #include <linux/mlx4/driver.h>
 #include <linux/mlx4/device.h>
@@ -2759,12 +2760,14 @@ static int mlx4_en_set_tx_maxrate(struct net_device *dev, int queue_index, u32 m
 	return err;
 }
 
+DEFINE_XDP_CALL(mlx4_xdp_call);
+
 static int mlx4_xdp_set(struct net_device *dev, struct bpf_prog *prog)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_dev *mdev = priv->mdev;
 	struct mlx4_en_port_profile new_prof;
-	struct bpf_prog *old_prog;
+	struct bpf_prog *old_prog = NULL;
 	struct mlx4_en_priv *tmp;
 	int tx_changed = 0;
 	int xdp_ring_num;
@@ -2790,6 +2793,7 @@ static int mlx4_xdp_set(struct net_device *dev, struct bpf_prog *prog)
 			if (old_prog)
 				bpf_prog_put(old_prog);
 		}
+		xdp_call_update(mlx4_xdp_call, old_prog, prog);
 		mutex_unlock(&mdev->state_lock);
 		return 0;
 	}
@@ -2839,6 +2843,7 @@ static int mlx4_xdp_set(struct net_device *dev, struct bpf_prog *prog)
 		if (old_prog)
 			bpf_prog_put(old_prog);
 	}
+	xdp_call_update(mlx4_xdp_call, old_prog, prog);
 
 	if (port_up) {
 		err = mlx4_en_start_port(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index db3552f2d087..f2400ea36a11 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -42,6 +42,7 @@
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
 #include <linux/irq.h>
+#include <linux/xdp_call.h>
 
 #include <net/ip.h>
 #if IS_ENABLED(CONFIG_IPV6)
@@ -661,6 +662,8 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
 #define MLX4_CQE_STATUS_IP_ANY (MLX4_CQE_STATUS_IPV4)
 #endif
 
+DECLARE_XDP_CALL(mlx4_xdp_call);
+
 int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
@@ -782,7 +785,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 			xdp.data_end = xdp.data + length;
 			orig_data = xdp.data;
 
-			act = bpf_prog_run_xdp(xdp_prog, &xdp);
+			act = xdp_call_run(mlx4_xdp_call, xdp_prog, &xdp);
 
 			length = xdp.data_end - xdp.data;
 			if (xdp.data != orig_data) {
-- 
2.20.1

