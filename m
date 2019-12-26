Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B7412A9D3
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfLZCdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:33:55 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39117 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfLZCdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:33:54 -0500
Received: by mail-pg1-f196.google.com with SMTP id b137so12202475pga.6
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 18:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ls5EHKn8kII01baUywOQuMp/ygUs9YYWxCQoq0YmxvE=;
        b=uN3oOvAjR2ST8OmDHMag0mUQ++SgvSyP6VLEiOjDmmswVA+raAXnMsexsnsM66j5A8
         jhURHAzZgWOTVTLGy9gGqsl+OQa8DjC94Db7obhza0cmStg55/akhq/gFy9NOI61x/cY
         we0Bm5ZeYT7OvY+ukHdk1gK7X+UBL+g94LKIBc2NqTSlhnzUa+6VoS5xXyVCJiczobu8
         nUYZB4pGeBb/GYZ//l2c0zhJHfMe33WKmCvxNLU4opikptOt3VHGjG0H59ga4ygMe/Lj
         kHVfUDEaK9syHkdRBN35YOK8aV6KqW68dP8TyuyeaJEsIhNQ2pvRsRyEz5uR11GUWNjI
         ICZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ls5EHKn8kII01baUywOQuMp/ygUs9YYWxCQoq0YmxvE=;
        b=lJWprf5hN1e1wL8PvlHs8zWsKvqmXST6ahvH3i3sINuoALw99XgHD90MAwY5bNd11J
         Ry+746NLBJ+UBgyBJFUI186sMbTBTto9m+L0utziNB4g+OmEZFs2CWA7YIUUMfqwueB6
         d1TAv7VqdP9C7PWMA6U87f40poH2cjZg1siV/HNy6aR0Mb49LBNM/Sn5PwRqR8EvFsyt
         Nt1YVwl3X8x3ibdLEgx7DWNnXEvov085Y4Cm3zrpZd4B7//I8K0I7/XOznX7Lzqbs9tD
         Idje4mYN36bkNdQd99oW6gIQFFGeNafxnnPGc9JMCzfzmEnpBKi9lncKB3gNQW447Bpy
         cEwg==
X-Gm-Message-State: APjAAAVeLAntB9q3iMqGRZoXPw4ck+covw8UuDzOd8IOvSMEVVc1wHPW
        zIiuvlGwwjfVBPJ+pGDPSeE=
X-Google-Smtp-Source: APXvYqzXprrV59MGpJtksGndiYsVU5MV9YCcF8Nf7JN1Qs5WBcgtXYU55Ju2Irxw6BvQd6xzzF3pvA==
X-Received: by 2002:a63:fc01:: with SMTP id j1mr47871676pgi.220.1577327634053;
        Wed, 25 Dec 2019 18:33:54 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id e6sm33865222pfh.32.2019.12.25.18.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:33:53 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     David Ahern <dahern@digitalocean.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Subject: [RFC v2 net-next 11/12] tun: set tx path XDP program
Date:   Thu, 26 Dec 2019 11:31:59 +0900
Message-Id: <20191226023200.21389-12-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

This patch adds a way to set tx path XDP program in tun driver
by handling XDP_SETUP_PROG_TX and XDP_QUERY_PROG_TX in ndo_bpf
handler.

Signed-off-by: David Ahern <dahern@digitalocean.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tun.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index d078b4659897..8aee7abd53a2 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -239,6 +239,7 @@ struct tun_struct {
 	u32 rx_batched;
 	struct tun_pcpu_stats __percpu *pcpu_stats;
 	struct bpf_prog __rcu *xdp_prog;
+	struct bpf_prog __rcu *xdp_tx_prog;
 	struct tun_prog __rcu *steering_prog;
 	struct tun_prog __rcu *filter_prog;
 	struct ethtool_link_ksettings link_ksettings;
@@ -1189,15 +1190,21 @@ tun_net_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 }
 
 static int tun_xdp_set(struct net_device *dev, struct bpf_prog *prog,
-		       struct netlink_ext_ack *extack)
+		       bool tx, struct netlink_ext_ack *extack)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 	struct tun_file *tfile;
 	struct bpf_prog *old_prog;
 	int i;
 
-	old_prog = rtnl_dereference(tun->xdp_prog);
-	rcu_assign_pointer(tun->xdp_prog, prog);
+	if (tx) {
+		old_prog = rtnl_dereference(tun->xdp_tx_prog);
+		rcu_assign_pointer(tun->xdp_tx_prog, prog);
+	} else {
+		old_prog = rtnl_dereference(tun->xdp_prog);
+		rcu_assign_pointer(tun->xdp_prog, prog);
+	}
+
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
@@ -1218,12 +1225,16 @@ static int tun_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	return 0;
 }
 
-static u32 tun_xdp_query(struct net_device *dev)
+static u32 tun_xdp_query(struct net_device *dev, bool tx)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 	const struct bpf_prog *xdp_prog;
 
-	xdp_prog = rtnl_dereference(tun->xdp_prog);
+	if (tx)
+		xdp_prog = rtnl_dereference(tun->xdp_tx_prog);
+	else
+		xdp_prog = rtnl_dereference(tun->xdp_prog);
+
 	if (xdp_prog)
 		return xdp_prog->aux->id;
 
@@ -1234,13 +1245,20 @@ static int tun_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
-		return tun_xdp_set(dev, xdp->prog, xdp->extack);
+		return tun_xdp_set(dev, xdp->prog, false, xdp->extack);
+	case XDP_SETUP_PROG_TX:
+		return tun_xdp_set(dev, xdp->prog, true, xdp->extack);
 	case XDP_QUERY_PROG:
-		xdp->prog_id = tun_xdp_query(dev);
-		return 0;
+		xdp->prog_id = tun_xdp_query(dev, false);
+		break;
+	case XDP_QUERY_PROG_TX:
+		xdp->prog_id = tun_xdp_query(dev, true);
+		break;
 	default:
 		return -EINVAL;
 	}
+
+	return 0;
 }
 
 static int tun_net_change_carrier(struct net_device *dev, bool new_carrier)
-- 
2.21.0

