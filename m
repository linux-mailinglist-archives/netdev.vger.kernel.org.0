Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CE5146082
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgAWBm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:42:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729050AbgAWBm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 20:42:26 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C467B2467A;
        Thu, 23 Jan 2020 01:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579743745;
        bh=QgrEd6GU72F/ha1GBmPS6IcybxVSPY/6Gdkn9iPrFVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CG7OhSctvsi78D8HPxK4GSh4NeN1lwzTU5ikoZYXztevPvtBuJR5aTC14jOAdVIuR
         /3C8N5SniqvwhxLqpvO4uAOqzXuGW2hZsTglTIbh2tAniFjFajH7EJFwbLlgHueTz9
         B9ERwXiISoZNvil2Dgd7tV4y2t9qMR5jWj6ygk7c=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH bpf-next 09/12] tun: set egress XDP program
Date:   Wed, 22 Jan 2020 18:42:07 -0700
Message-Id: <20200123014210.38412-10-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200123014210.38412-1-dsahern@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org>
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
index d4a0e59fcf5c..b6bac773f2a0 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -238,6 +238,7 @@ struct tun_struct {
 	u32 rx_batched;
 	struct tun_pcpu_stats __percpu *pcpu_stats;
 	struct bpf_prog __rcu *xdp_prog;
+	struct bpf_prog __rcu *xdp_egress_prog;
 	struct tun_prog __rcu *steering_prog;
 	struct tun_prog __rcu *filter_prog;
 	struct ethtool_link_ksettings link_ksettings;
@@ -1156,15 +1157,21 @@ tun_net_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
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
 
@@ -1185,12 +1192,16 @@ static int tun_xdp_set(struct net_device *dev, struct bpf_prog *prog,
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
 
@@ -1201,13 +1212,20 @@ static int tun_xdp(struct net_device *dev, struct netdev_bpf *xdp)
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

