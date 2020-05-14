Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1791D312D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 15:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgENNXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 09:23:16 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51125 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726098AbgENNXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 09:23:16 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 May 2020 16:23:13 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04EDNCBk013405;
        Thu, 14 May 2020 16:23:12 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     dsahern@gmail.com, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, dcaratti@redhat.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH iproute2-next 2/2] tc: implement support for terse dump
Date:   Thu, 14 May 2020 16:23:06 +0300
Message-Id: <20200514132306.29961-3-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200514132306.29961-1-vladbu@mellanox.com>
References: <20200514114026.27047-1-vladbu@mellanox.com>
 <20200514132306.29961-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for classifier/action terse dump using new TCA_DUMP_FLAGS
tlv with only available flag value TCA_DUMP_FLAGS_TERSE. Set the flag when
user requested it with following example CLI:

> tc -s filter show terse dev ens1f0 ingress

In terse mode dump only outputs essential data needed to identify the
filter and action (handle, cookie, etc.) and stats, if requested by the
user. The intention is to significantly improve rule dump rate by omitting
all static data that do not change after rule is created.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 include/uapi/linux/rtnetlink.h |  6 ++++++
 tc/tc_filter.c                 | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 9d802cd7f695..bcb1ba4d0146 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -609,11 +609,17 @@ enum {
 	TCA_HW_OFFLOAD,
 	TCA_INGRESS_BLOCK,
 	TCA_EGRESS_BLOCK,
+	TCA_DUMP_FLAGS,
 	__TCA_MAX
 };
 
 #define TCA_MAX (__TCA_MAX - 1)
 
+#define TCA_DUMP_FLAGS_TERSE (1 << 0) /* Means that in dump user gets only basic
+				       * data necessary to identify the objects
+				       * (handle, cookie, etc.) and stats.
+				       */
+
 #define TCA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct tcmsg))))
 #define TCA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct tcmsg))
 
diff --git a/tc/tc_filter.c b/tc/tc_filter.c
index c591a19f3123..6a82f9bb42fb 100644
--- a/tc/tc_filter.c
+++ b/tc/tc_filter.c
@@ -595,6 +595,7 @@ static int tc_filter_list(int cmd, int argc, char **argv)
 		.t.tcm_parent = TC_H_UNSPEC,
 		.t.tcm_family = AF_UNSPEC,
 	};
+	bool terse_dump = false;
 	char d[IFNAMSIZ] = {};
 	__u32 prio = 0;
 	__u32 protocol = 0;
@@ -687,6 +688,8 @@ static int tc_filter_list(int cmd, int argc, char **argv)
 				invarg("invalid chain index value", *argv);
 			filter_chain_index_set = 1;
 			filter_chain_index = chain_index;
+		} else if (matches(*argv, "terse") == 0) {
+			terse_dump = true;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
 		} else {
@@ -721,6 +724,15 @@ static int tc_filter_list(int cmd, int argc, char **argv)
 	if (filter_chain_index_set)
 		addattr32(&req.n, sizeof(req), TCA_CHAIN, chain_index);
 
+	if (terse_dump) {
+		struct nla_bitfield32 flags = {
+			.value = TCA_DUMP_FLAGS_TERSE,
+			.selector = TCA_DUMP_FLAGS_TERSE
+		};
+
+		addattr_l(&req.n, MAX_MSG, TCA_DUMP_FLAGS, &flags, sizeof(flags));
+	}
+
 	if (rtnl_dump_request_n(&rth, &req.n) < 0) {
 		perror("Cannot send dump request");
 		return 1;
-- 
2.21.0

