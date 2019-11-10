Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E15AEF68D1
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 12:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfKJLyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 06:54:17 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37868 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfKJLyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 06:54:17 -0500
Received: by mail-pl1-f193.google.com with SMTP id g8so2215942plt.4
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 03:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=slcDd6mBj/FzNCchVLX/2U16a5BQK+C9W1oPutDB+FY=;
        b=PHaDAg33GM4aB6ox69KX5q3AuIdibjsDyzh2esCrlPQodgb6Q8IQxYgn3SAza/vU/g
         +FSA4T64rCu0uGqSuSH9Y8egJ5YbgFzp0a45mZzRVBh0RF6Vg3UuG02gzcxowxXFNEwO
         hrKfTVuvfBWXVT+DyrQAGLzCWif9ujkXuHutJDJnrKKI2EZBBD69Vq9XWouqTa29BFbu
         wfm+0GsUjkpB8TS86I1GDziOR2Mr7iNnLRUZ69+wz9kMIAbK/WQG7Q2hOiZru1pJ602D
         Rkey7wdIEeAlXxS4In5cQtHsPHz/AucAHdEDPYeBC58XO8n43KXcbCSWVFoX3Z7tuwhR
         ZsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=slcDd6mBj/FzNCchVLX/2U16a5BQK+C9W1oPutDB+FY=;
        b=HMYzuJuq22qX0U71ssOyau9+KYNGNJbnZ9HOMXcaulP/VfcJfBi8dYhMoBFfIrhFds
         rCfxlb8gbTsdeTn48JUAVTkjxSY+juPjfOENTSjKmrIMVErzo1TDIUnuShmtIIkCMM6X
         htmES1b5SByu5d79V8VtLnuPZtxbxJSgASiM7D7Sc3CQSGiZbEeMY9lfsNntxtCRzLyO
         nDlpQahN8YYPzWe1ABfLjL9RvHlLKhicxd1IghTcJndOMLUro46B57aoAjAZ7MrOTtYN
         dvO/3748EknAnVLOy8j/U10bZy41QDy/e+8Ui+6Te2k2Ygvg2f5h0hwH8wQzOIyhL5SR
         gycQ==
X-Gm-Message-State: APjAAAVkIt7ybZx593fcyRDi1VUhJtbAeMToxjbZu9ZJDrmqyaRM88F9
        ERRAVRmZnFuEmTs8ne+Pd6o=
X-Google-Smtp-Source: APXvYqwX7zddhuOFckIKbKkb8Cp4IAz3Yj6GoM3R23UzjwFqXTB2d7H1IbNw0gPOyKuV/lbFNBwOSA==
X-Received: by 2002:a17:902:6b4b:: with SMTP id g11mr20599949plt.196.1573386856077;
        Sun, 10 Nov 2019 03:54:16 -0800 (PST)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id l62sm11587886pgl.24.2019.11.10.03.54.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Nov 2019 03:54:15 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, blp@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, ychen103103@163.com,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2] net: openvswitch: add hash info to upcall
Date:   Sun, 10 Nov 2019 19:54:04 +0800
Message-Id: <1573386844-35344-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

When using the kernel datapath, the upcall don't
add skb hash info relatived. That will introduce
some problem, because the hash of skb is very
important (e.g. vxlan module uses it for udp src port,
tx queue selection on tx path.).

For example, there will be one upcall, without information
skb hash, to ovs-vswitchd, for the first packet of one tcp
session. When kernel sents the tcp packets, the hash is
random for a tcp socket:

tcp_v4_connect
  -> sk_set_txhash (is random)

__tcp_transmit_skb
  -> skb_set_hash_from_sk

Then the udp src port of first tcp packet is different
from rest packets. The topo is shown.

$ ovs-vsctl add-br br-int
$ ovs-vsctl add-port br-int vxl0 -- \
                set Interface vxl0 type=vxlan options:key=100 options:remote_ip=1.1.1.200

$ __tap is internal type on host
$ or tap net device for VM/Dockers
$ ovs-vsctl add-port br-int __tap

+---------------+          +-------------------------+
|   Docker/VMs  |          |     ovs-vswitchd        |
+----+----------+          +-------------------------+
     |                       ^                    |
     |                       |                    |
     |                       |  upcall            v recalculate packet hash
     |                     +-+--------------------+--+
     |  tap netdev         |                         |   vxlan modules
     +--------------->     +-->  Open vSwitch ko   --+--->
       internal type       |                         |
                           +-------------------------+

Reported-at: https://mail.openvswitch.org/pipermail/ovs-dev/2019-October/364062.html
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v2: add define before #endif
---
 include/uapi/linux/openvswitch.h |  2 ++
 net/openvswitch/datapath.c       | 31 ++++++++++++++++++++++++++++++-
 net/openvswitch/datapath.h       |  4 ++++
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 1887a451c388..1c58e019438e 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -170,6 +170,7 @@ enum ovs_packet_cmd {
  * output port is actually a tunnel port. Contains the output tunnel key
  * extracted from the packet as nested %OVS_TUNNEL_KEY_ATTR_* attributes.
  * @OVS_PACKET_ATTR_MRU: Present for an %OVS_PACKET_CMD_ACTION and
+ * @OVS_PACKET_ATTR_HASH: Packet hash info (e.g. hash, sw_hash and l4_hash in skb)
  * @OVS_PACKET_ATTR_LEN: Packet size before truncation.
  * %OVS_PACKET_ATTR_USERSPACE action specify the Maximum received fragment
  * size.
@@ -190,6 +191,7 @@ enum ovs_packet_attr {
 	OVS_PACKET_ATTR_PROBE,      /* Packet operation is a feature probe,
 				       error logging should be suppressed. */
 	OVS_PACKET_ATTR_MRU,	    /* Maximum received IP fragment size. */
+	OVS_PACKET_ATTR_HASH,	    /* Packet hash. */
 	OVS_PACKET_ATTR_LEN,		/* Packet size before truncation. */
 	__OVS_PACKET_ATTR_MAX
 };
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 2088619c03f0..f938c43e3085 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -350,7 +350,8 @@ static size_t upcall_msg_size(const struct dp_upcall_info *upcall_info,
 	size_t size = NLMSG_ALIGN(sizeof(struct ovs_header))
 		+ nla_total_size(hdrlen) /* OVS_PACKET_ATTR_PACKET */
 		+ nla_total_size(ovs_key_attr_size()) /* OVS_PACKET_ATTR_KEY */
-		+ nla_total_size(sizeof(unsigned int)); /* OVS_PACKET_ATTR_LEN */
+		+ nla_total_size(sizeof(unsigned int)) /* OVS_PACKET_ATTR_LEN */
+		+ nla_total_size(sizeof(u64)); /* OVS_PACKET_ATTR_HASH */
 
 	/* OVS_PACKET_ATTR_USERDATA */
 	if (upcall_info->userdata)
@@ -393,6 +394,7 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 	size_t len;
 	unsigned int hlen;
 	int err, dp_ifindex;
+	u64 hash;
 
 	dp_ifindex = get_dpifindex(dp);
 	if (!dp_ifindex)
@@ -504,6 +506,24 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 		pad_packet(dp, user_skb);
 	}
 
+	if (skb_get_hash_raw(skb)) {
+		hash = skb_get_hash_raw(skb);
+
+		if (skb->sw_hash)
+			hash |= OVS_PACKET_HASH_SW;
+
+		if (skb->l4_hash)
+			hash |= OVS_PACKET_HASH_L4;
+
+		if (nla_put(user_skb, OVS_PACKET_ATTR_HASH,
+			    sizeof (u64), &hash)) {
+			err = -ENOBUFS;
+			goto out;
+		}
+
+		pad_packet(dp, user_skb);
+	}
+
 	/* Only reserve room for attribute header, packet data is added
 	 * in skb_zerocopy() */
 	if (!(nla = nla_reserve(user_skb, OVS_PACKET_ATTR_PACKET, 0))) {
@@ -543,6 +563,7 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
 	struct datapath *dp;
 	struct vport *input_vport;
 	u16 mru = 0;
+	u64 hash;
 	int len;
 	int err;
 	bool log = !a[OVS_PACKET_ATTR_PROBE];
@@ -568,6 +589,14 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
 	}
 	OVS_CB(packet)->mru = mru;
 
+	if (a[OVS_PACKET_ATTR_HASH]) {
+		hash = nla_get_u64(a[OVS_PACKET_ATTR_HASH]);
+
+		__skb_set_hash(packet, hash & 0xFFFFFFFFUL,
+			       !!(hash & OVS_PACKET_HASH_SW),
+			       !!(hash & OVS_PACKET_HASH_L4));
+	}
+
 	/* Build an sw_flow for sending this packet. */
 	flow = ovs_flow_alloc();
 	err = PTR_ERR(flow);
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 81e85dde8217..b95f322fc752 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -247,4 +247,8 @@ do {								\
 	if (logging_allowed && net_ratelimit())			\
 		pr_info("netlink: " fmt "\n", ##__VA_ARGS__);	\
 } while (0)
+
+#define OVS_PACKET_HASH_SW	(1ULL << 32)
+#define OVS_PACKET_HASH_L4	(1ULL << 33)
+
 #endif /* datapath.h */
-- 
2.23.0

