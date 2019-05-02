Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F19E116A0
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfEBJl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:41:29 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:64068 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfEBJl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 05:41:28 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Joergen.Andreasen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="Joergen.Andreasen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Joergen.Andreasen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,421,1549954800"; 
   d="scan'208";a="28787435"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 May 2019 02:41:02 -0700
Received: from localhost (10.10.76.4) by chn-sv-exch04.mchp-main.com
 (10.10.76.105) with Microsoft SMTP Server id 14.3.352.0; Thu, 2 May 2019
 02:41:02 -0700
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     Joergen Andreasen <joergen.andreasen@microchip.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Paul Burton" <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, <linux-mips@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 1/3] net/sched: act_police: move police parameters into separate header file
Date:   Thu, 2 May 2019 11:40:27 +0200
Message-ID: <20190502094029.22526-2-joergen.andreasen@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190502094029.22526-1-joergen.andreasen@microchip.com>
References: <20190502094029.22526-1-joergen.andreasen@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hardware offloading a policer requires access to it's parameters.
This is now possible by including net/tc_act/tc_police.h.

Signed-off-by: Joergen Andreasen <joergen.andreasen@microchip.com>
---
 include/net/tc_act/tc_police.h | 41 ++++++++++++++++++++++++++++++++++
 net/sched/act_police.c         | 27 +---------------------
 2 files changed, 42 insertions(+), 26 deletions(-)
 create mode 100644 include/net/tc_act/tc_police.h

diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
new file mode 100644
index 000000000000..052dc5f37aa9
--- /dev/null
+++ b/include/net/tc_act/tc_police.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_TC_POLICE_H
+#define __NET_TC_POLICE_H
+
+#include <net/act_api.h>
+
+struct tcf_police_params {
+	int			tcfp_result;
+	u32			tcfp_ewma_rate;
+	s64			tcfp_burst;
+	u32			tcfp_mtu;
+	s64			tcfp_mtu_ptoks;
+	struct psched_ratecfg	rate;
+	bool			rate_present;
+	struct psched_ratecfg	peak;
+	bool			peak_present;
+	struct rcu_head rcu;
+};
+
+struct tcf_police {
+	struct tc_action	common;
+	struct tcf_police_params __rcu *params;
+
+	spinlock_t		tcfp_lock ____cacheline_aligned_in_smp;
+	s64			tcfp_toks;
+	s64			tcfp_ptoks;
+	s64			tcfp_t_c;
+};
+
+#define to_police(pc) ((struct tcf_police *)pc)
+
+static inline bool is_tcf_police(const struct tc_action *a)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (a->ops && a->ops->id == TCA_ID_POLICE)
+		return true;
+#endif
+	return false;
+}
+
+#endif /* __NET_TC_POLICE_H */
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 2b8581f6ab51..5cb053f2c7b1 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -19,35 +19,10 @@
 #include <linux/rtnetlink.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <net/act_api.h>
+#include <net/tc_act/tc_police.h>
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
 
-struct tcf_police_params {
-	int			tcfp_result;
-	u32			tcfp_ewma_rate;
-	s64			tcfp_burst;
-	u32			tcfp_mtu;
-	s64			tcfp_mtu_ptoks;
-	struct psched_ratecfg	rate;
-	bool			rate_present;
-	struct psched_ratecfg	peak;
-	bool			peak_present;
-	struct rcu_head rcu;
-};
-
-struct tcf_police {
-	struct tc_action	common;
-	struct tcf_police_params __rcu *params;
-
-	spinlock_t		tcfp_lock ____cacheline_aligned_in_smp;
-	s64			tcfp_toks;
-	s64			tcfp_ptoks;
-	s64			tcfp_t_c;
-};
-
-#define to_police(pc) ((struct tcf_police *)pc)
-
 /* old policer structure from before tc actions */
 struct tc_police_compat {
 	u32			index;
-- 
2.17.1

