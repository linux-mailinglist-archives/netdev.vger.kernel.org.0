Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC3D12412E
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfLRIMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:12:51 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36257 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfLRIMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:12:50 -0500
Received: by mail-pl1-f194.google.com with SMTP id d15so637015pll.3
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ls5EHKn8kII01baUywOQuMp/ygUs9YYWxCQoq0YmxvE=;
        b=bKVHG8yQR9tCbyBX3GIX1jJ+jVsh/1n6Kc1aU3ruVu75661bD/8MUiGcz+bhp4x6C2
         9La867ponEiLIP0AHTIAcpzHEh7C53m1Ps/JMqxlya4Owg9Cc9c7MXozWfIg5NloZmwh
         qzjhUh2Iamu12tpCWZ6YxU4PMph1KMRzF0MyBDNyMNrcxMHLVFEHXjY8ec2piYy+A3Zu
         EbIny1W2NyKoh+5Q8QzBkcINEIb9t/TqWYrK7U9RN6JR3dAi8job23E/lZe6IJzUZLwh
         F8i7zWt8IpFgvaJDYhIMFbTAgHweNfD02ww94tCN2OyB8NO4QE8/hVxkW6G0D4IXZ6Wp
         iAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ls5EHKn8kII01baUywOQuMp/ygUs9YYWxCQoq0YmxvE=;
        b=RkZOzYD/3gLK8Q98js+ktJhoCpkbrdlsL0w+eDF+9xggJxDVOnX+1NwaCsJx4/S3Lb
         9vU/ie8N0hUmck6FLZ9gZRwAWx/4hV27I9vq11unlYfW9e87/41IiH2kIIAvdq4/Dh2a
         KCHnzHYU3eQaK40ndpb4RydCH3mmdUQYfBOAVqBXBXVlDlTPUe82KgXNW64/un2ONo7R
         kFaIYQ4fnRxHq2K5Ru0gNQm1BwM18+Rr74IBcZKwYCpRc8V57blsDf5C/54OjmXlqZkM
         bbAQ4k1dn6CJO+0JrxJ2VJrE+HNH1U0cinIE3jD+IMt7/VjoGJiI4l/oE1+FiFEY7lM9
         DUgA==
X-Gm-Message-State: APjAAAUup7h7sXvP1pQB7KVrO7UEE9yJjIzbyISl38Wqp7hiX6Fi7LYi
        0fB1PCmJv6iJYZQpQT5FEiU=
X-Google-Smtp-Source: APXvYqwMU0QkyIRXDgns3WCeQWckLZ2OSq7RgS4oI6+VtdVPhXQFJpLhaXOFpLpeJjPBtaexYE16gg==
X-Received: by 2002:a17:902:b68c:: with SMTP id c12mr1366035pls.126.1576656770209;
        Wed, 18 Dec 2019 00:12:50 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:12:49 -0800 (PST)
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
Subject: [RFC net-next 10/14] tun: set tx path XDP program
Date:   Wed, 18 Dec 2019 17:10:46 +0900
Message-Id: <20191218081050.10170-11-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
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

