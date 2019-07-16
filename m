Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563676B01F
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 21:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388673AbfGPTxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 15:53:18 -0400
Received: from mga07.intel.com ([134.134.136.100]:53334 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbfGPTxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 15:53:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 12:53:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,271,1559545200"; 
   d="scan'208";a="342818270"
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga005.jf.intel.com with ESMTP; 16 Jul 2019 12:53:17 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com, dsahern@gmail.com,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH iproute2 net-next v4 2/6] etf: Add skip_sock_check
Date:   Tue, 16 Jul 2019 12:53:05 -0700
Message-Id: <1563306789-2908-2-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1563306789-2908-1-git-send-email-vedang.patel@intel.com>
References: <1563306789-2908-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ETF Qdisc currently checks for a socket with SO_TXTIME socket option. If
either is not present, the packet is dropped. In the future commits, we
want other Qdiscs to add packet with launchtime to the ETF Qdisc. Also,
there are some packets (e.g. ICMP packets) which may not have a socket
associated with them.  So, add an option to skip this check.

Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 tc/q_etf.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tc/q_etf.c b/tc/q_etf.c
index 76aca476c61d..c2090589bc64 100644
--- a/tc/q_etf.c
+++ b/tc/q_etf.c
@@ -130,6 +130,13 @@ static int etf_parse_opt(struct qdisc_util *qu, int argc,
 				explain_clockid(*argv);
 				return -1;
 			}
+		} else if (strcmp(*argv, "skip_sock_check") == 0) {
+			if (opt.flags & TC_ETF_SKIP_SOCK_CHECK) {
+				fprintf(stderr, "etf: duplicate \"skip_sock_check\" specification\n");
+				return -1;
+			}
+
+			opt.flags |= TC_ETF_SKIP_SOCK_CHECK;
 		} else if (strcmp(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -171,8 +178,10 @@ static int etf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	print_uint(PRINT_ANY, "delta", "delta %d ", qopt->delta);
 	print_string(PRINT_ANY, "offload", "offload %s ",
 				(qopt->flags & TC_ETF_OFFLOAD_ON) ? "on" : "off");
-	print_string(PRINT_ANY, "deadline_mode", "deadline_mode %s",
+	print_string(PRINT_ANY, "deadline_mode", "deadline_mode %s ",
 				(qopt->flags & TC_ETF_DEADLINE_MODE_ON) ? "on" : "off");
+	print_string(PRINT_ANY, "skip_sock_check", "skip_sock_check %s",
+				(qopt->flags & TC_ETF_SKIP_SOCK_CHECK) ? "on" : "off");
 
 	return 0;
 }
-- 
2.7.3

