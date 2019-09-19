Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0901BB878D
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 00:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393168AbfISWpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 18:45:54 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37900 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392137AbfISWpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 18:45:54 -0400
Received: by mail-ot1-f66.google.com with SMTP id e11so4580871otl.5;
        Thu, 19 Sep 2019 15:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=IAWauUnAqsTRSrfy63qmEZbpdzHCy9CCjiwO2vbS/QM=;
        b=lCgIPt2b64Dq9Q8n7tz/AJ3m6JY5Y6SsTVjbtXIw3x9djKJAIR0LvvENfbu4ufSy67
         3WuzAkGyDaFRFoCqA+0Vi8C/20KWDlUuq0kaMbYzu+S+POSxZlZQx5JvvbwEgTYA+J9W
         LNdtp8XAq/BeelTbFuJJARUVHWpMT7yEtU7w1QLCuQgNMISdRIigESQLvafmStaHi7t+
         M5eS9+8t/fzpLwCkYbB5hR5afgEPgQLc8rs/mMfvh7UubOAlUS51sIy7+7Sl59BQfC7G
         WPvWzlUB8KMaZkgsYhuPmhnhPLrukQFRkhSajVPjyZIec2fB/o5y6fNFUU6SoVEaCqo8
         0thQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=IAWauUnAqsTRSrfy63qmEZbpdzHCy9CCjiwO2vbS/QM=;
        b=ZgGxHeuQsmjG7b8g5NJhNeXIuzXZfeMsY6qv79NH75MI/oqD/GpNcOH1HZWzLgoS02
         +cYe+ZAivbh9H8RhtYm99JmXdOAG5divNe9oUL1gaMDb/1Bm7lFXOSYruG+KvSczCcOW
         lRRzHTUQmkc6nU1cxlnP61lznyKOi6ijTHl0V/tmmLsUqqD7iVU5QDAsoWMFsrp+1jJn
         A10TqFnDnrzYWmyax4tco1c2KzxmaoS8bcu6UKKm0L64teRmP4lRbATgqN4SxruE6Xhj
         qXAX+/4Dx/O77tmtTW+obTSTRDiZ2zTVDoq9h3Xt6t2XbX2IzGA50fZ1s/3F3GzfHcFT
         DVQg==
X-Gm-Message-State: APjAAAXXKx6rkJSWc148ADfpjGSAV8uYniEsTWf7suFzU/BaWNH+9Oo4
        3Mmdj4AT751yGpv/NaoUlt8=
X-Google-Smtp-Source: APXvYqz9vb0btbVc/NK+VQLC+3CkcFHaI4U8OhgI81icjUC/TSYPjywZOdRyTW4NtS+/lcKR4VRcYA==
X-Received: by 2002:a9d:6190:: with SMTP id g16mr8808973otk.302.1568933152988;
        Thu, 19 Sep 2019 15:45:52 -0700 (PDT)
Received: from localhost.localdomain (ip24-56-44-135.ph.ph.cox.net. [24.56.44.135])
        by smtp.gmail.com with ESMTPSA id r187sm2860oie.17.2019.09.19.15.45.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 15:45:52 -0700 (PDT)
From:   Matthew Cover <werekraken@gmail.com>
X-Google-Original-From: Matthew Cover <matthew.cover@stackpath.com>
To:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        nikolay@cumulusnetworks.com, sd@queasysnail.net,
        sbrivio@redhat.com, vincent@bernat.ch, kda@linux-powerpc.org,
        matthew.cover@stackpath.com, jiri@mellanox.com,
        edumazet@google.com, pabeni@redhat.com, idosch@mellanox.com,
        petrm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, dsahern@gmail.com,
        christian@brauner.io, jakub.kicinski@netronome.com,
        roopa@cumulusnetworks.com, johannes.berg@intel.com,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [RFC net-next 1/2] Introduce an eBPF hookpoint for tx queue selection in the XPS (Transmit Packet Steering) code.
Date:   Thu, 19 Sep 2019 15:45:42 -0700
Message-Id: <20190919224542.91488-1-matthew.cover@stackpath.com>
X-Mailer: git-send-email 2.15.2 (Apple Git-101.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WORK IN PROGRESS:
  * bpf program loading works!
  * txq steering via bpf program return code works!
  * bpf program unloading not working.
  * bpf program attached query not working.
---
 include/linux/netdevice.h    |  3 +++
 include/uapi/linux/if_link.h | 12 +++++++++
 net/core/dev.c               | 61 ++++++++++++++++++++++++++++++++++++-------
 net/core/rtnetlink.c         | 62 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 129 insertions(+), 9 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9eda1c3..88e37d5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1966,6 +1966,7 @@ struct net_device {
 #ifdef CONFIG_XPS
 	struct xps_dev_maps __rcu *xps_cpus_map;
 	struct xps_dev_maps __rcu *xps_rxqs_map;
+	struct bpf_prog __rcu     *xps_prog;
 #endif
 #ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc __rcu	*miniq_egress;
@@ -2147,6 +2148,8 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
 					 struct sk_buff *skb,
 					 struct net_device *sb_dev);
 
+int dev_change_xps_fd(struct net_device *dev, int fd);
+
 /* returns the headroom that the master device needs to take in account
  * when forwarding to this dev
  */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 4a8c02c..a23d241 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -167,6 +167,7 @@ enum {
 	IFLA_NEW_IFINDEX,
 	IFLA_MIN_MTU,
 	IFLA_MAX_MTU,
+	IFLA_XPS,
 	__IFLA_MAX
 };
 
@@ -979,6 +980,17 @@ enum {
 
 #define IFLA_XDP_MAX (__IFLA_XDP_MAX - 1)
 
+/* XPS section */
+
+enum {
+	IFLA_XPS_UNSPEC,
+	IFLA_XPS_FD,
+	IFLA_XPS_ATTACHED,
+	__IFLA_XPS_MAX,
+};
+
+#define IFLA_XPS_MAX (__IFLA_XPS_MAX - 1)
+
 enum {
 	IFLA_EVENT_NONE,
 	IFLA_EVENT_REBOOT,		/* internal reset / reboot */
diff --git a/net/core/dev.c b/net/core/dev.c
index 71b18e8..a46d42b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3663,26 +3663,34 @@ static int get_xps_queue(struct net_device *dev, struct net_device *sb_dev,
 {
 #ifdef CONFIG_XPS
 	struct xps_dev_maps *dev_maps;
+	struct bpf_prog *prog;
 	struct sock *sk = skb->sk;
+	int bpf_ret = -1;
 	int queue_index = -1;
 
 	if (!static_key_false(&xps_needed))
 		return -1;
 
 	rcu_read_lock();
-	if (!static_key_false(&xps_rxqs_needed))
-		goto get_cpus_map;
 
-	dev_maps = rcu_dereference(sb_dev->xps_rxqs_map);
-	if (dev_maps) {
-		int tci = sk_rx_queue_get(sk);
+	prog = rcu_dereference(dev->xps_prog);
+	if (prog) {
+		bpf_ret = bpf_prog_run_clear_cb(prog, skb);
+		if (bpf_ret >= 0)
+			queue_index = bpf_ret % dev->num_tx_queues;
+	}
 
-		if (tci >= 0 && tci < dev->num_rx_queues)
-			queue_index = __get_xps_queue_idx(dev, skb, dev_maps,
-							  tci);
+	if (queue_index < 0 && static_key_false(&xps_rxqs_needed)) {
+		dev_maps = rcu_dereference(sb_dev->xps_rxqs_map);
+		if (dev_maps) {
+			int tci = sk_rx_queue_get(sk);
+
+			if (tci >= 0 && tci < dev->num_rx_queues)
+				queue_index = __get_xps_queue_idx(dev, skb,
+								dev_maps, tci);
+		}
 	}
 
-get_cpus_map:
 	if (queue_index < 0) {
 		dev_maps = rcu_dereference(sb_dev->xps_cpus_map);
 		if (dev_maps) {
@@ -8170,6 +8178,41 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	return err;
 }
 
+static void dev_xps_install(struct net_device *dev, struct bpf_prog *prog)
+{
+#ifdef CONFIG_XPS
+	struct bpf_prog *old = rtnl_dereference(dev->xps_prog);
+	struct bpf_prog *new = prog;
+
+	rcu_assign_pointer(dev->xps_prog, new);
+	if (old)
+		bpf_prog_put(old);
+#endif
+}
+
+/**
+ *	dev_change_xps_fd - set or clear a bpf program for tx queue selection for a device
+ *	@dev: device
+ *	@fd: new program fd or negative value to clear
+ *
+ *	Set or clear a bpf program for a device
+ */
+int dev_change_xps_fd(struct net_device *dev, int fd)
+{
+	struct bpf_prog *prog = NULL;
+
+	ASSERT_RTNL();
+
+	prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER);
+
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	dev_xps_install(dev, prog);
+
+	return 0;
+}
+
 /**
  *	dev_new_index	-	allocate an ifindex
  *	@net: the applicable net namespace
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1ee6460..202b59a 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -980,6 +980,15 @@ static size_t rtnl_xdp_size(void)
 	return xdp_size;
 }
 
+static size_t rtnl_xps_size(void)
+{
+	size_t xps_size = nla_total_size(0) +	/* nest IFLA_XPS */
+			  nla_total_size(1) +	/* XPS_ATTACHED */
+			  nla_total_size(4);	/* XPS_PROG_ID */
+
+	return xps_size;
+}
+
 static noinline size_t if_nlmsg_size(const struct net_device *dev,
 				     u32 ext_filter_mask)
 {
@@ -1018,6 +1027,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(MAX_PHYS_ITEM_ID_LEN) /* IFLA_PHYS_SWITCH_ID */
 	       + nla_total_size(IFNAMSIZ) /* IFLA_PHYS_PORT_NAME */
 	       + rtnl_xdp_size() /* IFLA_XDP */
+	       + rtnl_xps_size() /* IFLA_XPS */
 	       + nla_total_size(4)  /* IFLA_EVENT */
 	       + nla_total_size(4)  /* IFLA_NEW_NETNSID */
 	       + nla_total_size(4)  /* IFLA_NEW_IFINDEX */
@@ -1455,6 +1465,31 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
 	return err;
 }
 
+static int rtnl_xps_fill(struct sk_buff *skb, struct net_device *dev)
+{
+	struct nlattr *xps;
+	struct bpf_prog *xps_prog;
+	int err;
+
+	ASSERT_RTNL();
+
+	xps = nla_nest_start(skb, IFLA_XPS);
+	if (!xps)
+		return -EMSGSIZE;
+
+	xps_prog = rtnl_dereference(dev->xps_prog);
+	if (xps_prog) {
+		err = nla_put_u8(skb, IFLA_XPS_ATTACHED, xps_prog->aux->id);
+		if (err) {
+			nla_nest_cancel(skb, xps);
+			return err;
+		}
+	}
+
+	nla_nest_end(skb, xps);
+	return 0;
+}
+
 static u32 rtnl_get_event(unsigned long event)
 {
 	u32 rtnl_event_type = IFLA_EVENT_NONE;
@@ -1697,6 +1732,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 		goto nla_put_failure_rcu;
 	rcu_read_unlock();
 
+	if (rtnl_xps_fill(skb, dev))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
@@ -1750,6 +1788,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	[IFLA_CARRIER_DOWN_COUNT] = { .type = NLA_U32 },
 	[IFLA_MIN_MTU]		= { .type = NLA_U32 },
 	[IFLA_MAX_MTU]		= { .type = NLA_U32 },
+	[IFLA_XPS]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -1801,6 +1840,11 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	[IFLA_XDP_PROG_ID]	= { .type = NLA_U32 },
 };
 
+static const struct nla_policy ifla_xps_policy[IFLA_XPS_MAX + 1] = {
+	[IFLA_XPS_FD]		= { .type = NLA_S32 },
+	[IFLA_XPS_ATTACHED]	= { .type = NLA_U8 },
+};
+
 static const struct rtnl_link_ops *linkinfo_to_kind_ops(const struct nlattr *nla)
 {
 	const struct rtnl_link_ops *ops = NULL;
@@ -2709,6 +2753,24 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 	}
 
+	if (tb[IFLA_XPS]) {
+		struct nlattr  *xps[IFLA_XPS_MAX + 1];
+
+		err = nla_parse_nested_deprecated(xps, IFLA_XPS_MAX,
+						  tb[IFLA_XPS],
+						  ifla_xps_policy, NULL);
+		if (err < 0)
+			goto errout;
+
+		if (xps[IFLA_XPS_FD]) {
+			err = dev_change_xps_fd(dev,
+						nla_get_s32(xps[IFLA_XPS_FD]));
+			if (err)
+				goto errout;
+			status |= DO_SETLINK_NOTIFY;
+		}
+	}
+
 errout:
 	if (status & DO_SETLINK_MODIFIED) {
 		if ((status & DO_SETLINK_NOTIFY) == DO_SETLINK_NOTIFY)
-- 
1.8.3.1

