Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D53FB326
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 16:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfKMPFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 10:05:05 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43655 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfKMPFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 10:05:04 -0500
Received: by mail-pg1-f194.google.com with SMTP id l24so1534789pgh.10
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 07:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=345VlEGBSnYxFd4H+raHSbsJ/hlkhlhfLot28bYiH/k=;
        b=ig3n+wLCVSQ+Non9VsE7Aw7W/rWEx9CnMlcni15k8GQGmumWI4n8B7oGevSqzqoPf3
         ltEsr9jofgP18dYw6cbqPhonGi40yHcpbKh3MKY9Vgtc+OLnqFRgb3sjFyfnKWXolxu9
         jqZlex/HIRWXkmMdBGp9sUkCR2dMQa+1qsac9gW4iD9sybuJSO1brvjaGDxFGGNK99d9
         lTdXM4+XOR5qA5+eDM1kt/nsYK18hWg241mq44pz2p/MHpDOw/Upt+rHQxXc/j9ooI9v
         9AeH+QFKKrzA83F8sCHW3IN4ekKAIo/tae+f+oXj1bbfWET45fVkcug5hfE+HWKngqCI
         3C0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=345VlEGBSnYxFd4H+raHSbsJ/hlkhlhfLot28bYiH/k=;
        b=sknsUvxtAcnb4o3irqPHkUG+TKyOcYo9FiLNa6CeJAFKdy0pwyM2KlmtQl/Nm9NPir
         cFCOIpjtjzuWIPZ2MDAlXSk3vdg2ZQKdXOESYyOgY599cJQoIDyogmi47MwHy7Q1lzyB
         yHhGBQ9X8P4Pftv9bfJzBCpEHc0bJh3ojMQpyqP4RmtNIh97n1xywRMmunKP7+JKOyiK
         HwprluPF8zDmwhyRWmrVB+NJuANtCXwCg+5b2VzOMjrGiM3T6vQy0QJvavyLUJv8Jlat
         46ikFB/LHOEqiQu+cJX3ZFTGhwH3x2RuK3xkW8sHTgZEjVVSjhLyV7OlL98V+zn9woSz
         NfKg==
X-Gm-Message-State: APjAAAV4FHAtbu0bv7JpVhitQ9kquBpdf9wrQJ+NjcwFnLxGfACrgD08
        IK0+gXjeNWvoKVOemzHlpF8=
X-Google-Smtp-Source: APXvYqy5gy6aEQwTDxRJc1JBjVMtCiI6xKQJS3VpN1NInCtEmFmm8e2YeHaoyXZjrjdB1GFTV9uABQ==
X-Received: by 2002:a63:1242:: with SMTP id 2mr4155535pgs.288.1573657503716;
        Wed, 13 Nov 2019 07:05:03 -0800 (PST)
Received: from local.opencloud.tech.localdomain ([115.171.60.86])
        by smtp.gmail.com with ESMTPSA id i5sm2863212pfo.52.2019.11.13.07.05.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Nov 2019 07:05:02 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, gvrose8192@gmail.com
Cc:     blp@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4] net: openvswitch: add hash info to upcall
Date:   Wed, 13 Nov 2019 23:04:49 +0800
Message-Id: <1573657489-16067-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

When using the kernel datapath, the upcall don't
include skb hash info relatived. That will introduce
some problem, because the hash of skb is important
in kernel stack. For example, VXLAN module uses
it to select UDP src port. The tx queue selection
may also use the hash in stack.

Hash is computed in different ways. Hash is random
for a TCP socket, and hash may be computed in hardware,
or software stack. Recalculation hash is not easy.

Hash of TCP socket is computed:
tcp_v4_connect
    -> sk_set_txhash (is random)

__tcp_transmit_skb
    -> skb_set_hash_from_sk

There will be one upcall, without information of skb
hash, to ovs-vswitchd, for the first packet of a TCP
session. The rest packets will be processed in Open vSwitch
modules, hash kept. If this tcp session is forward to
VXLAN module, then the UDP src port of first tcp packet
is different from rest packets.

TCP packets may come from the host or dockers, to Open vSwitch.
To fix it, we store the hash info to upcall, and restore hash
when packets sent back.

+---------------+          +-------------------------+
|   Docker/VMs  |          |     ovs-vswitchd        |
+----+----------+          +-+--------------------+--+
     |                       ^                    |
     |                       |                    |
     |                       |  upcall            v restore packet hash (not recalculate)
     |                     +-+--------------------+--+
     |  tap netdev         |                         |   vxlan module
     +--------------->     +-->  Open vSwitch ko     +-->
       or internal type    |                         |
                           +-------------------------+

Reported-at: https://mail.openvswitch.org/pipermail/ovs-dev/2019-October/364062.html
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v4:
* all hash of skb to upcall
* remove the pad_packet, nla_put makes sure len is align
* add OVS_PACKET_ATTR_HASH at the end of ovs_packet_attr.
v3:
* add enum ovs_pkt_hash_types
* avoid duplicate call the skb_get_hash_raw.
* explain why we should fix this problem.
---
 include/uapi/linux/openvswitch.h |  4 +++-
 net/openvswitch/datapath.c       | 26 +++++++++++++++++++++++++-
 net/openvswitch/datapath.h       | 12 ++++++++++++
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 1887a451c388..a87b44cd5590 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -173,6 +173,7 @@ enum ovs_packet_cmd {
  * @OVS_PACKET_ATTR_LEN: Packet size before truncation.
  * %OVS_PACKET_ATTR_USERSPACE action specify the Maximum received fragment
  * size.
+ * @OVS_PACKET_ATTR_HASH: Packet hash info (e.g. hash, sw_hash and l4_hash in skb).
  *
  * These attributes follow the &struct ovs_header within the Generic Netlink
  * payload for %OVS_PACKET_* commands.
@@ -190,7 +191,8 @@ enum ovs_packet_attr {
 	OVS_PACKET_ATTR_PROBE,      /* Packet operation is a feature probe,
 				       error logging should be suppressed. */
 	OVS_PACKET_ATTR_MRU,	    /* Maximum received IP fragment size. */
-	OVS_PACKET_ATTR_LEN,		/* Packet size before truncation. */
+	OVS_PACKET_ATTR_LEN,	    /* Packet size before truncation. */
+	OVS_PACKET_ATTR_HASH,	    /* Packet hash. */
 	__OVS_PACKET_ATTR_MAX
 };
 
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 2088619c03f0..8ce1f773378d 100644
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
@@ -504,6 +506,19 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 		pad_packet(dp, user_skb);
 	}
 
+	/* Add OVS_PACKET_ATTR_HASH */
+	hash = skb_get_hash_raw(skb);
+	if (skb->sw_hash)
+		hash |= OVS_PACKET_HASH_SW_BIT;
+
+	if (skb->l4_hash)
+		hash |= OVS_PACKET_HASH_L4_BIT;
+
+	if (nla_put(user_skb, OVS_PACKET_ATTR_HASH, sizeof (u64), &hash)) {
+		err = -ENOBUFS;
+		goto out;
+	}
+
 	/* Only reserve room for attribute header, packet data is added
 	 * in skb_zerocopy() */
 	if (!(nla = nla_reserve(user_skb, OVS_PACKET_ATTR_PACKET, 0))) {
@@ -543,6 +558,7 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
 	struct datapath *dp;
 	struct vport *input_vport;
 	u16 mru = 0;
+	u64 hash;
 	int len;
 	int err;
 	bool log = !a[OVS_PACKET_ATTR_PROBE];
@@ -568,6 +584,14 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
 	}
 	OVS_CB(packet)->mru = mru;
 
+	if (a[OVS_PACKET_ATTR_HASH]) {
+		hash = nla_get_u64(a[OVS_PACKET_ATTR_HASH]);
+
+		__skb_set_hash(packet, hash & 0xFFFFFFFFULL,
+			       !!(hash & OVS_PACKET_HASH_SW_BIT),
+			       !!(hash & OVS_PACKET_HASH_L4_BIT));
+	}
+
 	/* Build an sw_flow for sending this packet. */
 	flow = ovs_flow_alloc();
 	err = PTR_ERR(flow);
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 81e85dde8217..e239a46c2f94 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -139,6 +139,18 @@ struct ovs_net {
 	bool xt_label;
 };
 
+/**
+ * enum ovs_pkt_hash_types - hash info to include with a packet
+ * to send to userspace.
+ * @OVS_PACKET_HASH_SW_BIT: indicates hash was computed in software stack.
+ * @OVS_PACKET_HASH_L4_BIT: indicates hash is a canonical 4-tuple hash
+ * over transport ports.
+ */
+enum ovs_pkt_hash_types {
+	OVS_PACKET_HASH_SW_BIT = (1ULL << 32),
+	OVS_PACKET_HASH_L4_BIT = (1ULL << 33),
+};
+
 extern unsigned int ovs_net_id;
 void ovs_lock(void);
 void ovs_unlock(void);
-- 
2.23.0

