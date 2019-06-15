Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6556446F28
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 11:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfFOJDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 05:03:55 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36497 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfFOJDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 05:03:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id u8so4456242wmm.1
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 02:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+gXoNNdakWMbzVMSeN/B/6kAzgiKHSKQBmXyfSY9Fqw=;
        b=Bfm/LqIPiqZS5Mo4TDFvvz7fniE6Qom+WAHgvCGZdOtO206nGyq7BzBkIMPuh4m4h7
         w0Sdapqq6ecMYdb93aAqxrZvywKWJKcKCJ9OEdBviA9uANhUosAdFDFKMQSQn6eeesQm
         TQr/ezelp5d9PRliocrgBILotRFsvIE0d1USx1TqVCmuonUmyLDGSu31vXVeuoyXEU0N
         vSFdcksodv2GKlr/7bYxjjBkTgxYR18R6+5P5XxY5vqVYCtZxsXLJGiMKuwDiO5oeUAm
         De2gPYC3K0A9nV+1/ccezQqwN1AyKrZwNIxIqN7sTiNr6fzB7uTEsB5GA6KAP/cZT3ih
         nJ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+gXoNNdakWMbzVMSeN/B/6kAzgiKHSKQBmXyfSY9Fqw=;
        b=KK1zserYNfqZ7a1nau1sPQXB1LNCM4qrqw19bQWG3dE9kGb9rF2MtgTkzxOBL9Y7so
         w1oBq6OaaD3CpK11XJixfERFENaU3qefmPpDxeDQHVzO2JUueRti0GVOfiGyToYbG2to
         cV++ZkgTPjOc5HUj358YE6fgsfOUy6HLRW89vdTO8ayfva7uBbg7QQxp0mKWuV7rAoy6
         fJMvuZ9QoB4RzTYlpV1XWd/hJqbhoDHg4mBqlv9zLqhrNMfAxgzKnzdlKdKk/HG+cFnJ
         GcACgrDqslYrM/16W7qE7MkTqHr7IV9ND44afLGAFVghFT6aQNk3TZPvX3jRroGX8tz7
         4T3Q==
X-Gm-Message-State: APjAAAUT2SxX4QRbWuBRgbUAAtErSbWxviVHs61HMcguaWhIfiVLMO5/
        x7eszmXmswavhY4aeWXO8lc3+R2j43rVYA==
X-Google-Smtp-Source: APXvYqxttvVSoeQcYtyVQFXZpsmYPVReKuTZX1dSLNhwn2bnC+WpWYKCj15l2xcOAPj4qBWRu/VSjA==
X-Received: by 2002:a1c:968c:: with SMTP id y134mr10275243wmd.122.1560589430371;
        Sat, 15 Jun 2019 02:03:50 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id c11sm3499996wrs.97.2019.06.15.02.03.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 02:03:50 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com
Subject: [patch net-next] net: sched: remove NET_CLS_IND config option
Date:   Sat, 15 Jun 2019 11:03:49 +0200
Message-Id: <20190615090349.12036-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

This config option makes only couple of lines optional.
Two small helpers and an int in couple of cls structs.

Remove the config option and always compile this in.
This saves the user from unexpected surprises when he adds
a filter with ingress device match which is silently ignored
in case the config option is not set.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 arch/mips/configs/malta_defconfig           |  1 -
 arch/mips/configs/malta_kvm_defconfig       |  1 -
 arch/mips/configs/malta_kvm_guest_defconfig |  1 -
 arch/mips/configs/malta_qemu_32r6_defconfig |  1 -
 arch/mips/configs/maltaaprp_defconfig       |  1 -
 arch/mips/configs/maltasmvp_defconfig       |  1 -
 arch/mips/configs/maltasmvp_eva_defconfig   |  1 -
 arch/mips/configs/maltaup_defconfig         |  1 -
 arch/mips/configs/maltaup_xpa_defconfig     |  1 -
 arch/mips/configs/rb532_defconfig           |  1 -
 arch/powerpc/configs/ppc6xx_defconfig       |  1 -
 arch/sh/configs/se7712_defconfig            |  1 -
 arch/sh/configs/se7721_defconfig            |  1 -
 arch/sh/configs/titan_defconfig             |  1 -
 include/net/pkt_cls.h                       |  5 +----
 include/uapi/linux/pkt_cls.h                |  2 +-
 net/sched/Kconfig                           |  8 --------
 net/sched/cls_flower.c                      |  3 +--
 net/sched/cls_fw.c                          | 13 -------------
 net/sched/cls_u32.c                         | 15 ---------------
 tools/include/uapi/linux/pkt_cls.h          |  2 +-
 tools/testing/selftests/tc-testing/config   |  1 -
 22 files changed, 4 insertions(+), 59 deletions(-)

diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index 0ee5e677662e..0de92ac1ca64 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -210,7 +210,6 @@ CONFIG_NET_ACT_NAT=m
 CONFIG_NET_ACT_PEDIT=m
 CONFIG_NET_ACT_SIMP=m
 CONFIG_NET_ACT_SKBEDIT=m
-CONFIG_NET_CLS_IND=y
 CONFIG_CFG80211=m
 CONFIG_MAC80211=m
 CONFIG_MAC80211_MESH=y
diff --git a/arch/mips/configs/malta_kvm_defconfig b/arch/mips/configs/malta_kvm_defconfig
index 041bffac043b..efc3abace048 100644
--- a/arch/mips/configs/malta_kvm_defconfig
+++ b/arch/mips/configs/malta_kvm_defconfig
@@ -215,7 +215,6 @@ CONFIG_NET_ACT_NAT=m
 CONFIG_NET_ACT_PEDIT=m
 CONFIG_NET_ACT_SIMP=m
 CONFIG_NET_ACT_SKBEDIT=m
-CONFIG_NET_CLS_IND=y
 CONFIG_CFG80211=m
 CONFIG_MAC80211=m
 CONFIG_MAC80211_MESH=y
diff --git a/arch/mips/configs/malta_kvm_guest_defconfig b/arch/mips/configs/malta_kvm_guest_defconfig
index 511065e62182..c6ceeca4394d 100644
--- a/arch/mips/configs/malta_kvm_guest_defconfig
+++ b/arch/mips/configs/malta_kvm_guest_defconfig
@@ -212,7 +212,6 @@ CONFIG_NET_ACT_NAT=m
 CONFIG_NET_ACT_PEDIT=m
 CONFIG_NET_ACT_SIMP=m
 CONFIG_NET_ACT_SKBEDIT=m
-CONFIG_NET_CLS_IND=y
 CONFIG_CFG80211=m
 CONFIG_MAC80211=m
 CONFIG_MAC80211_MESH=y
diff --git a/arch/mips/configs/malta_qemu_32r6_defconfig b/arch/mips/configs/malta_qemu_32r6_defconfig
index 299088043164..e6c600dc1814 100644
--- a/arch/mips/configs/malta_qemu_32r6_defconfig
+++ b/arch/mips/configs/malta_qemu_32r6_defconfig
@@ -74,7 +74,6 @@ CONFIG_NET_CLS_RSVP=m
 CONFIG_NET_CLS_RSVP6=m
 CONFIG_NET_CLS_ACT=y
 CONFIG_NET_ACT_POLICE=y
-CONFIG_NET_CLS_IND=y
 # CONFIG_WIRELESS is not set
 CONFIG_DEVTMPFS=y
 CONFIG_BLK_DEV_LOOP=y
diff --git a/arch/mips/configs/maltaaprp_defconfig b/arch/mips/configs/maltaaprp_defconfig
index 2b4b3a24f637..82b44b774553 100644
--- a/arch/mips/configs/maltaaprp_defconfig
+++ b/arch/mips/configs/maltaaprp_defconfig
@@ -76,7 +76,6 @@ CONFIG_NET_CLS_RSVP=m
 CONFIG_NET_CLS_RSVP6=m
 CONFIG_NET_CLS_ACT=y
 CONFIG_NET_ACT_POLICE=y
-CONFIG_NET_CLS_IND=y
 # CONFIG_WIRELESS is not set
 CONFIG_DEVTMPFS=y
 CONFIG_BLK_DEV_LOOP=y
diff --git a/arch/mips/configs/maltasmvp_defconfig b/arch/mips/configs/maltasmvp_defconfig
index 425ddfd7cd78..4190fc6189a0 100644
--- a/arch/mips/configs/maltasmvp_defconfig
+++ b/arch/mips/configs/maltasmvp_defconfig
@@ -77,7 +77,6 @@ CONFIG_NET_CLS_RSVP=m
 CONFIG_NET_CLS_RSVP6=m
 CONFIG_NET_CLS_ACT=y
 CONFIG_NET_ACT_POLICE=y
-CONFIG_NET_CLS_IND=y
 # CONFIG_WIRELESS is not set
 CONFIG_DEVTMPFS=y
 CONFIG_BLK_DEV_LOOP=y
diff --git a/arch/mips/configs/maltasmvp_eva_defconfig b/arch/mips/configs/maltasmvp_eva_defconfig
index 8beaa7ba1e52..a13c10e910ec 100644
--- a/arch/mips/configs/maltasmvp_eva_defconfig
+++ b/arch/mips/configs/maltasmvp_eva_defconfig
@@ -78,7 +78,6 @@ CONFIG_NET_CLS_RSVP=m
 CONFIG_NET_CLS_RSVP6=m
 CONFIG_NET_CLS_ACT=y
 CONFIG_NET_ACT_POLICE=y
-CONFIG_NET_CLS_IND=y
 # CONFIG_WIRELESS is not set
 CONFIG_DEVTMPFS=y
 CONFIG_BLK_DEV_LOOP=y
diff --git a/arch/mips/configs/maltaup_defconfig b/arch/mips/configs/maltaup_defconfig
index 6e8b95ceb54a..b35f1fc690fb 100644
--- a/arch/mips/configs/maltaup_defconfig
+++ b/arch/mips/configs/maltaup_defconfig
@@ -75,7 +75,6 @@ CONFIG_NET_CLS_RSVP=m
 CONFIG_NET_CLS_RSVP6=m
 CONFIG_NET_CLS_ACT=y
 CONFIG_NET_ACT_POLICE=y
-CONFIG_NET_CLS_IND=y
 # CONFIG_WIRELESS is not set
 CONFIG_DEVTMPFS=y
 CONFIG_BLK_DEV_LOOP=y
diff --git a/arch/mips/configs/maltaup_xpa_defconfig b/arch/mips/configs/maltaup_xpa_defconfig
index 6c026db96ff9..56861aef2756 100644
--- a/arch/mips/configs/maltaup_xpa_defconfig
+++ b/arch/mips/configs/maltaup_xpa_defconfig
@@ -212,7 +212,6 @@ CONFIG_NET_ACT_NAT=m
 CONFIG_NET_ACT_PEDIT=m
 CONFIG_NET_ACT_SIMP=m
 CONFIG_NET_ACT_SKBEDIT=m
-CONFIG_NET_CLS_IND=y
 CONFIG_CFG80211=m
 CONFIG_MAC80211=m
 CONFIG_MAC80211_MESH=y
diff --git a/arch/mips/configs/rb532_defconfig b/arch/mips/configs/rb532_defconfig
index 50632a3103dd..864c70fbe668 100644
--- a/arch/mips/configs/rb532_defconfig
+++ b/arch/mips/configs/rb532_defconfig
@@ -103,7 +103,6 @@ CONFIG_GACT_PROB=y
 CONFIG_NET_ACT_MIRRED=m
 CONFIG_NET_ACT_IPT=m
 CONFIG_NET_ACT_PEDIT=m
-CONFIG_NET_CLS_IND=y
 CONFIG_HAMRADIO=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 7c6baf6df139..aa51b9b66fa2 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -301,7 +301,6 @@ CONFIG_NET_ACT_NAT=m
 CONFIG_NET_ACT_PEDIT=m
 CONFIG_NET_ACT_SIMP=m
 CONFIG_NET_ACT_SKBEDIT=m
-CONFIG_NET_CLS_IND=y
 CONFIG_IRDA=m
 CONFIG_IRLAN=m
 CONFIG_IRNET=m
diff --git a/arch/sh/configs/se7712_defconfig b/arch/sh/configs/se7712_defconfig
index 5a1097641247..1e116529735f 100644
--- a/arch/sh/configs/se7712_defconfig
+++ b/arch/sh/configs/se7712_defconfig
@@ -63,7 +63,6 @@ CONFIG_NET_SCH_NETEM=y
 CONFIG_NET_CLS_TCINDEX=y
 CONFIG_NET_CLS_ROUTE4=y
 CONFIG_NET_CLS_FW=y
-CONFIG_NET_CLS_IND=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/sh/configs/se7721_defconfig b/arch/sh/configs/se7721_defconfig
index 9c0ef13bee10..c66e512719ab 100644
--- a/arch/sh/configs/se7721_defconfig
+++ b/arch/sh/configs/se7721_defconfig
@@ -62,7 +62,6 @@ CONFIG_NET_SCH_NETEM=y
 CONFIG_NET_CLS_TCINDEX=y
 CONFIG_NET_CLS_ROUTE4=y
 CONFIG_NET_CLS_FW=y
-CONFIG_NET_CLS_IND=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/sh/configs/titan_defconfig b/arch/sh/configs/titan_defconfig
index 822fa9e96f74..171ab05ce4fc 100644
--- a/arch/sh/configs/titan_defconfig
+++ b/arch/sh/configs/titan_defconfig
@@ -142,7 +142,6 @@ CONFIG_GACT_PROB=y
 CONFIG_NET_ACT_MIRRED=m
 CONFIG_NET_ACT_IPT=m
 CONFIG_NET_ACT_PEDIT=m
-CONFIG_NET_CLS_IND=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_FW_LOADER=m
 CONFIG_CONNECTOR=m
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 514e3c80ecc1..720f2b32fc2f 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -7,6 +7,7 @@
 #include <net/sch_generic.h>
 #include <net/act_api.h>
 #include <net/flow_offload.h>
+#include <net/net_namespace.h>
 
 /* TC action not accessible from user space */
 #define TC_ACT_REINSERT		(TC_ACT_VALUE_MAX + 1)
@@ -576,9 +577,6 @@ static inline int tcf_valid_offset(const struct sk_buff *skb,
 		      (ptr <= (ptr + len)));
 }
 
-#ifdef CONFIG_NET_CLS_IND
-#include <net/net_namespace.h>
-
 static inline int
 tcf_change_indev(struct net *net, struct nlattr *indev_tlv,
 		 struct netlink_ext_ack *extack)
@@ -605,7 +603,6 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 		return false;
 	return ifindex == skb->skb_iif;
 }
-#endif /* CONFIG_NET_CLS_IND */
 
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts);
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index a93680fc4bfa..8cc6b6777b3c 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -295,7 +295,7 @@ enum {
 	TCA_FW_UNSPEC,
 	TCA_FW_CLASSID,
 	TCA_FW_POLICE,
-	TCA_FW_INDEV, /*  used by CONFIG_NET_CLS_IND */
+	TCA_FW_INDEV,
 	TCA_FW_ACT, /* used by CONFIG_NET_CLS_ACT */
 	TCA_FW_MASK,
 	__TCA_FW_MAX
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index d104f7ee26c7..360fdd3eaa77 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -941,14 +941,6 @@ config NET_IFE_SKBTCINDEX
         tristate "Support to encoding decoding skb tcindex on IFE action"
         depends on NET_ACT_IFE
 
-config NET_CLS_IND
-	bool "Incoming device classification"
-	depends on NET_CLS_U32 || NET_CLS_FW
-	---help---
-	  Say Y here to extend the u32 and fw classifier to support
-	  classification based on the incoming device. This option is
-	  likely to disappear in favour of the metadata ematch.
-
 endif # NET_SCHED
 
 config NET_SCH_FIFO
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index c388372df0e2..84c7f279855b 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1010,7 +1010,7 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 {
 	__be16 ethertype;
 	int ret = 0;
-#ifdef CONFIG_NET_CLS_IND
+
 	if (tb[TCA_FLOWER_INDEV]) {
 		int err = tcf_change_indev(net, tb[TCA_FLOWER_INDEV], extack);
 		if (err < 0)
@@ -1018,7 +1018,6 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 		key->indev_ifindex = err;
 		mask->indev_ifindex = 0xffffffff;
 	}
-#endif
 
 	fl_set_key_val(tb, key->eth.dst, TCA_FLOWER_KEY_ETH_DST,
 		       mask->eth.dst, TCA_FLOWER_KEY_ETH_DST_MASK,
diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index 4dab833f66cb..c9496c920d6f 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -8,9 +8,6 @@
  * Karlis Peisenieks <karlis@mt.lv> : 990415 : fw_walk off by one
  * Karlis Peisenieks <karlis@mt.lv> : 990415 : fw_delete killed all the filter (and kernel).
  * Alex <alex@pilotsoft.com> : 2004xxyy: Added Action extension
- *
- * JHS: We should remove the CONFIG_NET_CLS_IND from here
- * eventually when the meta match extension is made available
  */
 
 #include <linux/module.h>
@@ -37,9 +34,7 @@ struct fw_filter {
 	struct fw_filter __rcu	*next;
 	u32			id;
 	struct tcf_result	res;
-#ifdef CONFIG_NET_CLS_IND
 	int			ifindex;
-#endif /* CONFIG_NET_CLS_IND */
 	struct tcf_exts		exts;
 	struct tcf_proto	*tp;
 	struct rcu_work		rwork;
@@ -67,10 +62,8 @@ static int fw_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		     f = rcu_dereference_bh(f->next)) {
 			if (f->id == id) {
 				*res = f->res;
-#ifdef CONFIG_NET_CLS_IND
 				if (!tcf_match_indev(skb, f->ifindex))
 					continue;
-#endif /* CONFIG_NET_CLS_IND */
 				r = tcf_exts_exec(skb, &f->exts, res);
 				if (r < 0)
 					continue;
@@ -222,7 +215,6 @@ static int fw_set_parms(struct net *net, struct tcf_proto *tp,
 		tcf_bind_filter(tp, &f->res, base);
 	}
 
-#ifdef CONFIG_NET_CLS_IND
 	if (tb[TCA_FW_INDEV]) {
 		int ret;
 		ret = tcf_change_indev(net, tb[TCA_FW_INDEV], extack);
@@ -230,7 +222,6 @@ static int fw_set_parms(struct net *net, struct tcf_proto *tp,
 			return ret;
 		f->ifindex = ret;
 	}
-#endif /* CONFIG_NET_CLS_IND */
 
 	err = -EINVAL;
 	if (tb[TCA_FW_MASK]) {
@@ -276,9 +267,7 @@ static int fw_change(struct net *net, struct sk_buff *in_skb,
 
 		fnew->id = f->id;
 		fnew->res = f->res;
-#ifdef CONFIG_NET_CLS_IND
 		fnew->ifindex = f->ifindex;
-#endif /* CONFIG_NET_CLS_IND */
 		fnew->tp = f->tp;
 
 		err = tcf_exts_init(&fnew->exts, net, TCA_FW_ACT,
@@ -405,14 +394,12 @@ static int fw_dump(struct net *net, struct tcf_proto *tp, void *fh,
 	if (f->res.classid &&
 	    nla_put_u32(skb, TCA_FW_CLASSID, f->res.classid))
 		goto nla_put_failure;
-#ifdef CONFIG_NET_CLS_IND
 	if (f->ifindex) {
 		struct net_device *dev;
 		dev = __dev_get_by_index(net, f->ifindex);
 		if (dev && nla_put_string(skb, TCA_FW_INDEV, dev->name))
 			goto nla_put_failure;
 	}
-#endif /* CONFIG_NET_CLS_IND */
 	if (head->mask != 0xFFFFFFFF &&
 	    nla_put_u32(skb, TCA_FW_MASK, head->mask))
 		goto nla_put_failure;
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index c7727de5e073..be9e46c77e8b 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -20,9 +20,6 @@
  *	pure RSVP doesn't need such a general approach and can use
  *	much simpler (and faster) schemes, sort of cls_rsvp.c.
  *
- *	JHS: We should remove the CONFIG_NET_CLS_IND from here
- *	eventually when the meta match extension is made available
- *
  *	nfmark match added by Catalin(ux aka Dino) BOIE <catab at umbrella.ro>
  */
 
@@ -48,9 +45,7 @@ struct tc_u_knode {
 	u32			handle;
 	struct tc_u_hnode __rcu	*ht_up;
 	struct tcf_exts		exts;
-#ifdef CONFIG_NET_CLS_IND
 	int			ifindex;
-#endif
 	u8			fshift;
 	struct tcf_result	res;
 	struct tc_u_hnode __rcu	*ht_down;
@@ -176,12 +171,10 @@ static int u32_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 			if (n->sel.flags & TC_U32_TERMINAL) {
 
 				*res = n->res;
-#ifdef CONFIG_NET_CLS_IND
 				if (!tcf_match_indev(skb, n->ifindex)) {
 					n = rcu_dereference_bh(n->next);
 					goto next_knode;
 				}
-#endif
 #ifdef CONFIG_CLS_U32_PERF
 				__this_cpu_inc(n->pf->rhit);
 #endif
@@ -761,7 +754,6 @@ static int u32_set_parms(struct net *net, struct tcf_proto *tp,
 		tcf_bind_filter(tp, &n->res, base);
 	}
 
-#ifdef CONFIG_NET_CLS_IND
 	if (tb[TCA_U32_INDEV]) {
 		int ret;
 		ret = tcf_change_indev(net, tb[TCA_U32_INDEV], extack);
@@ -769,7 +761,6 @@ static int u32_set_parms(struct net *net, struct tcf_proto *tp,
 			return -EINVAL;
 		n->ifindex = ret;
 	}
-#endif
 	return 0;
 }
 
@@ -817,9 +808,7 @@ static struct tc_u_knode *u32_init_knode(struct net *net, struct tcf_proto *tp,
 	new->handle = n->handle;
 	RCU_INIT_POINTER(new->ht_up, n->ht_up);
 
-#ifdef CONFIG_NET_CLS_IND
 	new->ifindex = n->ifindex;
-#endif
 	new->fshift = n->fshift;
 	new->res = n->res;
 	new->flags = n->flags;
@@ -1351,14 +1340,12 @@ static int u32_dump(struct net *net, struct tcf_proto *tp, void *fh,
 		if (tcf_exts_dump(skb, &n->exts) < 0)
 			goto nla_put_failure;
 
-#ifdef CONFIG_NET_CLS_IND
 		if (n->ifindex) {
 			struct net_device *dev;
 			dev = __dev_get_by_index(net, n->ifindex);
 			if (dev && nla_put_string(skb, TCA_U32_INDEV, dev->name))
 				goto nla_put_failure;
 		}
-#endif
 #ifdef CONFIG_CLS_U32_PERF
 		gpf = kzalloc(sizeof(struct tc_u32_pcnt) +
 			      n->sel.nkeys * sizeof(u64),
@@ -1422,9 +1409,7 @@ static int __init init_u32(void)
 #ifdef CONFIG_CLS_U32_PERF
 	pr_info("    Performance counters on\n");
 #endif
-#ifdef CONFIG_NET_CLS_IND
 	pr_info("    input device check on\n");
-#endif
 #ifdef CONFIG_NET_CLS_ACT
 	pr_info("    Actions configured\n");
 #endif
diff --git a/tools/include/uapi/linux/pkt_cls.h b/tools/include/uapi/linux/pkt_cls.h
index 401d0c1e612d..12153771396a 100644
--- a/tools/include/uapi/linux/pkt_cls.h
+++ b/tools/include/uapi/linux/pkt_cls.h
@@ -257,7 +257,7 @@ enum {
 	TCA_FW_UNSPEC,
 	TCA_FW_CLASSID,
 	TCA_FW_POLICE,
-	TCA_FW_INDEV, /*  used by CONFIG_NET_CLS_IND */
+	TCA_FW_INDEV,
 	TCA_FW_ACT, /* used by CONFIG_NET_CLS_ACT */
 	TCA_FW_MASK,
 	__TCA_FW_MAX
diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index b235efd55367..1adc4f9bb795 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -45,5 +45,4 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
 CONFIG_NET_IFE_SKBMARK=m
 CONFIG_NET_IFE_SKBPRIO=m
 CONFIG_NET_IFE_SKBTCINDEX=m
-CONFIG_NET_CLS_IND=y
 CONFIG_NET_SCH_FIFO=y
-- 
2.21.0

