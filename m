Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D2A1E77D5
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 10:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgE2IF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 04:05:58 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:22632 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgE2IFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 04:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590739554; x=1622275554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1RJrbxytZP/GSdAuMopE53ThjRMpa9akASPS4XmBsKY=;
  b=wxkxppcmqOdiX/xdIz4cChgSdCdMGBTrxZa1ymJNHmpUlBjyqMAlNJR1
   mXr9c1uszTBHdHgd5fy8pgrhn2x2+RxG99R7MIUKqifKjlQ1yleIALCLK
   bE004QLvxeemONxicTg3xt+ocQmIMU3eXkP7qCjjHNT+kHKAF3SIHeTsc
   c3ER8pYh85RIoinOw6Q3t7eRMFOnIdpWvVPjVs7uwnrbFi68WSGhJWGSf
   v/Fo3kC8ed/bCjlTOybiZ95A6AhT7rh2vQp9Mj/RtN2OQfPyNXR7/jKBO
   gJ1AoFkN7Zeav/CleJnDrPHGEK2FMp98ZykCuN5YJRSnnPyfeHsAGwMrI
   w==;
IronPort-SDR: yY09J9q+rxzIPAh/ZznsRh9G7+JxVQrXVysozRyWz2T+vrLxtdtmccu7Nbh/CP8skeFwDqpESw
 SvobRnR3MOwZBWxxxnUpQZ0ZzQcFyMQc3QIBhVK3e52gsebfk2zQcQq75LdhEd46SKbA3F8xRp
 umaaFDoimLQsfbIfeP17/Fyxntzmq0XscAbcjk5LHWCQuffUQRit1c7msCNLenq1q4jAtxuEXO
 peABraHvJvvrSoiuH189b4G+mJQDVu6m6vOpfUz+sgb550GaNxv/RRTzq16xyRlEdAQJjaL3KB
 dgA=
X-IronPort-AV: E=Sophos;i="5.73,447,1583218800"; 
   d="scan'208";a="76726270"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 May 2020 01:05:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 29 May 2020 01:05:53 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 29 May 2020 01:05:51 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/2] bridge: mrp: Add support for role MRA
Date:   Fri, 29 May 2020 10:05:14 +0000
Message-ID: <20200529100514.920537-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529100514.920537-1-horatiu.vultur@microchip.com>
References: <20200529100514.920537-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A node that has the MRA role, it can behave as MRM or MRC.

Initially it starts as MRM and sends MRP_Test frames on both ring ports.
If it detects that there are MRP_Test send by another MRM, then it
checks if these frames have a lower priority than itself. In this case
it would send MRP_Nack frames to notify the other node that it needs to
stop sending MRP_Test frames.
If it receives a MRP_Nack frame then it stops sending MRP_Test frames
and starts to behave as a MRC but it would continue to monitor the
MRP_Test frames send by MRM. If at a point the MRM stops to send
MRP_Test frames it would get the MRM role and start to send MRP_Test
frames.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/net/switchdev.h         |   1 +
 include/uapi/linux/if_bridge.h  |   2 +
 include/uapi/linux/mrp_bridge.h |  38 ++++++++++
 net/bridge/br_mrp.c             | 125 +++++++++++++++++++++++++++-----
 net/bridge/br_mrp_netlink.c     |   6 ++
 net/bridge/br_mrp_switchdev.c   |   4 +-
 net/bridge/br_private_mrp.h     |   4 +-
 7 files changed, 159 insertions(+), 21 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index f82ef4c45f5ed..b8c059b4e06d9 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -130,6 +130,7 @@ struct switchdev_obj_ring_test_mrp {
 	u8 max_miss;
 	u32 ring_id;
 	u32 period;
+	bool monitor;
 };
 
 #define SWITCHDEV_OBJ_RING_TEST_MRP(OBJ) \
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 0162c1370ecb6..caa6914a3e53a 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -222,6 +222,7 @@ enum {
 	IFLA_BRIDGE_MRP_START_TEST_INTERVAL,
 	IFLA_BRIDGE_MRP_START_TEST_MAX_MISS,
 	IFLA_BRIDGE_MRP_START_TEST_PERIOD,
+	IFLA_BRIDGE_MRP_START_TEST_MONITOR,
 	__IFLA_BRIDGE_MRP_START_TEST_MAX,
 };
 
@@ -249,6 +250,7 @@ struct br_mrp_start_test {
 	__u32 interval;
 	__u32 max_miss;
 	__u32 period;
+	__u32 monitor;
 };
 
 struct bridge_stp_xstats {
diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
index 2600cdf5a2848..ba248cbbc751e 100644
--- a/include/uapi/linux/mrp_bridge.h
+++ b/include/uapi/linux/mrp_bridge.h
@@ -11,11 +11,14 @@
 #define MRP_DOMAIN_UUID_LENGTH		16
 #define MRP_VERSION			1
 #define MRP_FRAME_PRIO			7
+#define MRP_OUI_LENGTH			3
+#define MRP_MANUFACTURE_DATA_LENGTH	2
 
 enum br_mrp_ring_role_type {
 	BR_MRP_RING_ROLE_DISABLED,
 	BR_MRP_RING_ROLE_MRC,
 	BR_MRP_RING_ROLE_MRM,
+	BR_MRP_RING_ROLE_MRA,
 };
 
 enum br_mrp_ring_state_type {
@@ -43,6 +46,13 @@ enum br_mrp_tlv_header_type {
 	BR_MRP_TLV_HEADER_RING_TOPO = 0x3,
 	BR_MRP_TLV_HEADER_RING_LINK_DOWN = 0x4,
 	BR_MRP_TLV_HEADER_RING_LINK_UP = 0x5,
+	BR_MRP_TLV_HEADER_OPTION = 0x7f,
+};
+
+enum br_mrp_sub_tlv_header_type {
+	BR_MRP_SUB_TLV_HEADER_TEST_MGR_NACK = 0x1,
+	BR_MRP_SUB_TLV_HEADER_TEST_PROPAGATE = 0x2,
+	BR_MRP_SUB_TLV_HEADER_TEST_AUTO_MGR = 0x3,
 };
 
 struct br_mrp_tlv_hdr {
@@ -50,6 +60,11 @@ struct br_mrp_tlv_hdr {
 	__u8 length;
 };
 
+struct br_mrp_sub_tlv_hdr {
+	__u8 type;
+	__u8 length;
+};
+
 struct br_mrp_end_hdr {
 	struct br_mrp_tlv_hdr hdr;
 };
@@ -81,4 +96,27 @@ struct br_mrp_ring_link_hdr {
 	__u16 blocked;
 };
 
+struct br_mrp_sub_opt_hdr {
+	__u8 type;
+	__u8 manufacture_data[MRP_MANUFACTURE_DATA_LENGTH];
+};
+
+struct br_mrp_test_mgr_nack_hdr {
+	__u16 prio;
+	__u8 sa[ETH_ALEN];
+	__u16 other_prio;
+	__u8 other_sa[ETH_ALEN];
+};
+
+struct br_mrp_test_prop_hdr {
+	__u16 prio;
+	__u8 sa[ETH_ALEN];
+	__u16 other_prio;
+	__u8 other_sa[ETH_ALEN];
+};
+
+struct br_mrp_oui_hdr {
+	__u8 oui[MRP_OUI_LENGTH];
+};
+
 #endif
diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index f8fd037219fe9..24986ec7d38cc 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -160,6 +160,16 @@ static struct sk_buff *br_mrp_alloc_test_skb(struct br_mrp *mrp,
 	return skb;
 }
 
+/* This function is continuously called in the following cases:
+ * - when node role is MRM, in this case test_monitor is always set to false
+ *   because it needs to notify the userspace that the ring is open and needs to
+ *   send MRP_Test frames
+ * - when node role is MRA, there are 2 subcases:
+ *     - when MRA behaves as MRM, in this case is similar with MRM role
+ *     - when MRA behaves as MRC, in this case test_monitor is set to true,
+ *       because it needs to detect when it stops seeing MRP_Test frames
+ *       from MRM node but it doesn't need to send MRP_Test frames.
+ */
 static void br_mrp_test_work_expired(struct work_struct *work)
 {
 	struct delayed_work *del_work = to_delayed_work(work);
@@ -177,8 +187,14 @@ static void br_mrp_test_work_expired(struct work_struct *work)
 		/* Notify that the ring is open only if the ring state is
 		 * closed, otherwise it would continue to notify at every
 		 * interval.
+		 * Also notify that the ring is open when the node has the
+		 * role MRA and behaves as MRC. The reason is that the
+		 * userspace needs to know when the MRM stopped sending
+		 * MRP_Test frames so that the current node to try to take
+		 * the role of a MRM.
 		 */
-		if (mrp->ring_state == BR_MRP_RING_STATE_CLOSED)
+		if (mrp->ring_state == BR_MRP_RING_STATE_CLOSED ||
+		    mrp->test_monitor)
 			notify_open = true;
 	}
 
@@ -186,12 +202,15 @@ static void br_mrp_test_work_expired(struct work_struct *work)
 
 	p = rcu_dereference(mrp->p_port);
 	if (p) {
-		skb = br_mrp_alloc_test_skb(mrp, p, BR_MRP_PORT_ROLE_PRIMARY);
-		if (!skb)
-			goto out;
-
-		skb_reset_network_header(skb);
-		dev_queue_xmit(skb);
+		if (!mrp->test_monitor) {
+			skb = br_mrp_alloc_test_skb(mrp, p,
+						    BR_MRP_PORT_ROLE_PRIMARY);
+			if (!skb)
+				goto out;
+
+			skb_reset_network_header(skb);
+			dev_queue_xmit(skb);
+		}
 
 		if (notify_open && !mrp->ring_role_offloaded)
 			br_mrp_port_open(p->dev, true);
@@ -199,12 +218,15 @@ static void br_mrp_test_work_expired(struct work_struct *work)
 
 	p = rcu_dereference(mrp->s_port);
 	if (p) {
-		skb = br_mrp_alloc_test_skb(mrp, p, BR_MRP_PORT_ROLE_SECONDARY);
-		if (!skb)
-			goto out;
-
-		skb_reset_network_header(skb);
-		dev_queue_xmit(skb);
+		if (!mrp->test_monitor) {
+			skb = br_mrp_alloc_test_skb(mrp, p,
+						    BR_MRP_PORT_ROLE_SECONDARY);
+			if (!skb)
+				goto out;
+
+			skb_reset_network_header(skb);
+			dev_queue_xmit(skb);
+		}
 
 		if (notify_open && !mrp->ring_role_offloaded)
 			br_mrp_port_open(p->dev, true);
@@ -227,7 +249,7 @@ static void br_mrp_del_impl(struct net_bridge *br, struct br_mrp *mrp)
 
 	/* Stop sending MRP_Test frames */
 	cancel_delayed_work_sync(&mrp->test_work);
-	br_mrp_switchdev_send_ring_test(br, mrp, 0, 0, 0);
+	br_mrp_switchdev_send_ring_test(br, mrp, 0, 0, 0, 0);
 
 	br_mrp_switchdev_del(br, mrp);
 
@@ -452,8 +474,8 @@ int br_mrp_set_ring_role(struct net_bridge *br,
 	return 0;
 }
 
-/* Start to generate MRP test frames, the frames are generated by HW and if it
- * fails, they are generated by the SW.
+/* Start to generate or monitor MRP test frames, the frames are generated by
+ * HW and if it fails, they are generated by the SW.
  * note: already called with rtnl_lock
  */
 int br_mrp_start_test(struct net_bridge *br,
@@ -464,16 +486,18 @@ int br_mrp_start_test(struct net_bridge *br,
 	if (!mrp)
 		return -EINVAL;
 
-	/* Try to push it to the HW and if it fails then continue to generate in
-	 * SW and if that also fails then return error
+	/* Try to push it to the HW and if it fails then continue with SW
+	 * implementation and if that also fails then return error.
 	 */
 	if (!br_mrp_switchdev_send_ring_test(br, mrp, test->interval,
-					     test->max_miss, test->period))
+					     test->max_miss, test->period,
+					     test->monitor))
 		return 0;
 
 	mrp->test_interval = test->interval;
 	mrp->test_end = jiffies + usecs_to_jiffies(test->period);
 	mrp->test_max_miss = test->max_miss;
+	mrp->test_monitor = test->monitor;
 	mrp->test_count_miss = 0;
 	queue_delayed_work(system_wq, &mrp->test_work,
 			   usecs_to_jiffies(test->interval));
@@ -510,6 +534,57 @@ static void br_mrp_mrm_process(struct br_mrp *mrp, struct net_bridge_port *port,
 		br_mrp_port_open(port->dev, false);
 }
 
+/* Determin if the test hdr has a better priority than the node */
+static bool br_mrp_test_better_than_own(struct br_mrp *mrp,
+					struct net_bridge *br,
+					const struct br_mrp_ring_test_hdr *hdr)
+{
+	u16 prio = be16_to_cpu(hdr->prio);
+
+	if (prio < mrp->prio ||
+	    (prio == mrp->prio &&
+	    ether_addr_to_u64(hdr->sa) < ether_addr_to_u64(br->dev->dev_addr)))
+		return true;
+
+	return false;
+}
+
+/* Process only MRP Test frame. All the other MRP frames are processed by
+ * userspace application
+ * note: already called with rcu_read_lock
+ */
+static void br_mrp_mra_process(struct br_mrp *mrp, struct net_bridge *br,
+			       struct net_bridge_port *port,
+			       struct sk_buff *skb)
+{
+	const struct br_mrp_ring_test_hdr *test_hdr;
+	struct br_mrp_ring_test_hdr _test_hdr;
+	const struct br_mrp_tlv_hdr *hdr;
+	struct br_mrp_tlv_hdr _hdr;
+
+	/* Each MRP header starts with a version field which is 16 bits.
+	 * Therefore skip the version and get directly the TLV header.
+	 */
+	hdr = skb_header_pointer(skb, sizeof(uint16_t), sizeof(_hdr), &_hdr);
+	if (!hdr)
+		return;
+
+	if (hdr->type != BR_MRP_TLV_HEADER_RING_TEST)
+		return;
+
+	test_hdr = skb_header_pointer(skb, sizeof(uint16_t) + sizeof(_hdr),
+				      sizeof(_test_hdr), &_test_hdr);
+	if (!test_hdr)
+		return;
+
+	/* Only frames that have a better priority than the node will
+	 * clear the miss counter because otherwise the node will need to behave
+	 * as MRM.
+	 */
+	if (br_mrp_test_better_than_own(mrp, br, test_hdr))
+		mrp->test_count_miss = 0;
+}
+
 /* This will just forward the frame to the other mrp ring port(MRC role) or will
  * not do anything.
  * note: already called with rcu_read_lock
@@ -546,6 +621,18 @@ static int br_mrp_rcv(struct net_bridge_port *p,
 		return 1;
 	}
 
+	/* If the role is MRA then don't forward the frames if it behaves as
+	 * MRM node
+	 */
+	if (mrp->ring_role == BR_MRP_RING_ROLE_MRA) {
+		if (!mrp->test_monitor) {
+			br_mrp_mrm_process(mrp, p, skb);
+			return 1;
+		}
+
+		br_mrp_mra_process(mrp, br, p, skb);
+	}
+
 	/* Clone the frame and forward it on the other MRP port */
 	nskb = skb_clone(skb, GFP_ATOMIC);
 	if (!nskb)
diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
index 332d9894a9485..32acf8a738f9e 100644
--- a/net/bridge/br_mrp_netlink.c
+++ b/net/bridge/br_mrp_netlink.c
@@ -196,6 +196,7 @@ br_mrp_start_test_policy[IFLA_BRIDGE_MRP_START_TEST_MAX + 1] = {
 	[IFLA_BRIDGE_MRP_START_TEST_INTERVAL]	= { .type = NLA_U32 },
 	[IFLA_BRIDGE_MRP_START_TEST_MAX_MISS]	= { .type = NLA_U32 },
 	[IFLA_BRIDGE_MRP_START_TEST_PERIOD]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_START_TEST_MONITOR]	= { .type = NLA_U32 },
 };
 
 static int br_mrp_start_test_parse(struct net_bridge *br, struct nlattr *attr,
@@ -225,6 +226,11 @@ static int br_mrp_start_test_parse(struct net_bridge *br, struct nlattr *attr,
 	test.interval = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_TEST_INTERVAL]);
 	test.max_miss = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_TEST_MAX_MISS]);
 	test.period = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_TEST_PERIOD]);
+	test.monitor = false;
+
+	if (tb[IFLA_BRIDGE_MRP_START_TEST_MONITOR])
+		test.monitor =
+			nla_get_u32(tb[IFLA_BRIDGE_MRP_START_TEST_MONITOR]);
 
 	return br_mrp_start_test(br, &test);
 }
diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
index 3a776043bf80d..0da68a0da4b5a 100644
--- a/net/bridge/br_mrp_switchdev.c
+++ b/net/bridge/br_mrp_switchdev.c
@@ -65,7 +65,8 @@ int br_mrp_switchdev_set_ring_role(struct net_bridge *br,
 
 int br_mrp_switchdev_send_ring_test(struct net_bridge *br,
 				    struct br_mrp *mrp, u32 interval,
-				    u8 max_miss, u32 period)
+				    u8 max_miss, u32 period,
+				    bool monitor)
 {
 	struct switchdev_obj_ring_test_mrp test = {
 		.obj.orig_dev = br->dev,
@@ -74,6 +75,7 @@ int br_mrp_switchdev_send_ring_test(struct net_bridge *br,
 		.max_miss = max_miss,
 		.ring_id = mrp->ring_id,
 		.period = period,
+		.monitor = monitor,
 	};
 	int err;
 
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 558941ce23669..33b255e38ffec 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -26,6 +26,7 @@ struct br_mrp {
 	unsigned long			test_end;
 	u32				test_count_miss;
 	u32				test_max_miss;
+	bool				test_monitor;
 
 	u32				seq_id;
 
@@ -52,7 +53,8 @@ int br_mrp_switchdev_set_ring_role(struct net_bridge *br, struct br_mrp *mrp,
 int br_mrp_switchdev_set_ring_state(struct net_bridge *br, struct br_mrp *mrp,
 				    enum br_mrp_ring_state_type state);
 int br_mrp_switchdev_send_ring_test(struct net_bridge *br, struct br_mrp *mrp,
-				    u32 interval, u8 max_miss, u32 period);
+				    u32 interval, u8 max_miss, u32 period,
+				    bool monitor);
 int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
 				    enum br_mrp_port_state_type state);
 int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
-- 
2.26.2

