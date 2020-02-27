Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1563170EF6
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgB0DUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:20:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728352AbgB0DU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 22:20:29 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14AB324687;
        Thu, 27 Feb 2020 03:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582773628;
        bh=WBS6TILPwmpt1uslfWFLaf7jr+kbYILGd0NoC+AwvIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXk96rmgtU7ALIxzGzQfo4hJZx4s9tL8vwa9G4nsQQyZ8JTegWH3hHjfvA12Ueu0Z
         68jYt3Y0BXabNggcbOwrXjBoEGIq/hgoljm+D4JXsvHOPAXTQVe8TTKgyH9MPo3L/9
         w/1vvEePtk0fLugSr06yjihAGuBkTkENs4QWyT5E=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH RFC v4 bpf-next 07/11] tun: set egress XDP program
Date:   Wed, 26 Feb 2020 20:20:09 -0700
Message-Id: <20200227032013.12385-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200227032013.12385-1-dsahern@kernel.org>
References: <20200227032013.12385-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

This patch adds a way to set tx path XDP program in tun driver
by handling XDP_SETUP_PROG_EGRESS and XDP_QUERY_PROG_EGRESS in
ndo_bpf handler.

Signed-off-by: David Ahern <dahern@digitalocean.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tun.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7cc5a1acaef2..6aae398b904b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -239,6 +239,7 @@ struct tun_struct {
 	u32 rx_batched;
 	struct tun_pcpu_stats __percpu *pcpu_stats;
 	struct bpf_prog __rcu *xdp_prog;
+	struct bpf_prog __rcu *xdp_egress_prog;
 	struct tun_prog __rcu *steering_prog;
 	struct tun_prog __rcu *filter_prog;
 	struct ethtool_link_ksettings link_ksettings;
@@ -1189,15 +1190,21 @@ tun_net_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 }
 
 static int tun_xdp_set(struct net_device *dev, struct bpf_prog *prog,
-		       struct netlink_ext_ack *extack)
+		       bool egress, struct netlink_ext_ack *extack)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 	struct tun_file *tfile;
 	struct bpf_prog *old_prog;
 	int i;
 
-	old_prog = rtnl_dereference(tun->xdp_prog);
-	rcu_assign_pointer(tun->xdp_prog, prog);
+	if (egress) {
+		old_prog = rtnl_dereference(tun->xdp_egress_prog);
+		rcu_assign_pointer(tun->xdp_egress_prog, prog);
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
+static u32 tun_xdp_query(struct net_device *dev, bool egress)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 	const struct bpf_prog *xdp_prog;
 
-	xdp_prog = rtnl_dereference(tun->xdp_prog);
+	if (egress)
+		xdp_prog = rtnl_dereference(tun->xdp_egress_prog);
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
+	case XDP_SETUP_PROG_EGRESS:
+		return tun_xdp_set(dev, xdp->prog, true, xdp->extack);
 	case XDP_QUERY_PROG:
-		xdp->prog_id = tun_xdp_query(dev);
-		return 0;
+		xdp->prog_id = tun_xdp_query(dev, false);
+		break;
+	case XDP_QUERY_PROG_EGRESS:
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
2.21.1 (Apple Git-122.3)

