Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC99F93AB
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 16:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfKLPJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 10:09:33 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36724 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfKLPJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 10:09:32 -0500
Received: by mail-pf1-f195.google.com with SMTP id b19so1264249pfd.3
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 07:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2DzezMOdIfO5arl9C8ik9PsJNSPPcBuBmup2DMQUr1s=;
        b=Z5ag0/Ls4NVsFcNSAyZnz8aPip7beFbZmHDaznRRWsEdp61lHPMsaYQ9cUOpj6oslT
         jCQm8AugCKVNvuwvuAlZjzIWleafs3z5ADNMr34K71Iq8iKA/f2bzbFZ1nmJ4Wx5vUgf
         Nm4eGGj39xdOqM9cAA6DbCt+j6iTP9lp3Ls40CbH+Ss9E0YE9kdmemhKFefArjeCy4a0
         Epsbjs90PTej3+dmUUqxFibZP+wanhiiIAUOeplijXJ7jEuXLyBxmVbM2E0rRkEJGE7Q
         OISFQZnHQ1aD3Rr/REeO0dX9DRdJDFIRgsnCKz7lLpGDEgAjaFeTikqsHEWFX0Q8Qq64
         WnAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2DzezMOdIfO5arl9C8ik9PsJNSPPcBuBmup2DMQUr1s=;
        b=Ugb2+1kuv9mW60s19iMh9Se6HPmEIz4fzf4LiZw9feDM4EbwrCiMU1KaPPibbm2Ebw
         e19PSGuAfRc+UYueK2+kpFzrvg0A5jfoHVKXNXxaNoOXBiayMmMXiwV//uRCnZao1rrF
         iXrzy53OJj3Znyk+2D35WOWLbN+QZWHx5XUGRFYTRz7uaA1qhUHH1tcolzCQ6iiuRneS
         v/8KLhavrLEAlTcjD+9KlZUv4QHNmkl5rTALjNM3WAnqRS4n1kK3AuByGrRtt9QRvQG4
         qiUEMnUdiNFeC6+YpLfP2FixRTiVzSWBr4omUafotAf42y6Lt3Gdc/ibKOPeYMlLcc8x
         6aQg==
X-Gm-Message-State: APjAAAX7O8Mq9Dn1IsuSdLYf84943NFPHQvLGQXVvErmZHCCXi2l2PTe
        7lL2P+Ygo4NzhmgHPIA+ILs=
X-Google-Smtp-Source: APXvYqzsWE9iwRj/u6mVcCR9NEndwE+ULFFmrfaIt0v+UAUxL0Mv0CPCmC51UieWGcicwEUGVBjESA==
X-Received: by 2002:aa7:80d2:: with SMTP id a18mr13418590pfn.29.1573571372017;
        Tue, 12 Nov 2019 07:09:32 -0800 (PST)
Received: from local.opencloud.tech.localdomain ([115.171.60.86])
        by smtp.gmail.com with ESMTPSA id k32sm2874689pje.10.2019.11.12.07.09.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 07:09:31 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, blp@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, ychen103103@163.com,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3] net: openvswitch: add hash info to upcall
Date:   Tue, 12 Nov 2019 23:08:47 +0800
Message-Id: <1573571327-6906-1-git-send-email-xiangxia.m.yue@gmail.com>
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
v3:
* add enum ovs_pkt_hash_types
* avoid duplicate call the skb_get_hash_raw.
* explain why we should fix this problem.
---
 include/uapi/linux/openvswitch.h |  2 ++
 net/openvswitch/datapath.c       | 30 +++++++++++++++++++++++++++++-
 net/openvswitch/datapath.h       | 12 ++++++++++++
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 1887a451c388..e65407c1f366 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -170,6 +170,7 @@ enum ovs_packet_cmd {
  * output port is actually a tunnel port. Contains the output tunnel key
  * extracted from the packet as nested %OVS_TUNNEL_KEY_ATTR_* attributes.
  * @OVS_PACKET_ATTR_MRU: Present for an %OVS_PACKET_CMD_ACTION and
+ * @OVS_PACKET_ATTR_HASH: Packet hash info (e.g. hash, sw_hash and l4_hash in skb).
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
index 2088619c03f0..b556cf62b77c 100644
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
@@ -504,6 +506,23 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 		pad_packet(dp, user_skb);
 	}
 
+	hash = skb_get_hash_raw(skb);
+	if (hash) {
+		if (skb->sw_hash)
+			hash |= OVS_PACKET_HASH_SW_BIT;
+
+		if (skb->l4_hash)
+			hash |= OVS_PACKET_HASH_L4_BIT;
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
@@ -543,6 +562,7 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
 	struct datapath *dp;
 	struct vport *input_vport;
 	u16 mru = 0;
+	u64 hash;
 	int len;
 	int err;
 	bool log = !a[OVS_PACKET_ATTR_PROBE];
@@ -568,6 +588,14 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
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

