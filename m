Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7D36EC29
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 23:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbfGSVkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 17:40:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:41514 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728391AbfGSVkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 17:40:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 14:40:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="173619384"
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga006.jf.intel.com with ESMTP; 19 Jul 2019 14:40:48 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, dsahern@gmail.com,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH iproute2] etf: make printing of variable JSON friendly
Date:   Fri, 19 Jul 2019 14:40:43 -0700
Message-Id: <1563572443-10879-1-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In iproute2 txtime-assist series, it was pointed out that print_bool()
should be used to print binary values. This is to make it JSON friendly.

So, make the corresponding changes in ETF.

Fixes: 8ccd49383cdc ("etf: Add skip_sock_check")
Reported-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 tc/q_etf.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tc/q_etf.c b/tc/q_etf.c
index c2090589bc64..307c50eed48b 100644
--- a/tc/q_etf.c
+++ b/tc/q_etf.c
@@ -176,12 +176,12 @@ static int etf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		     get_clock_name(qopt->clockid));
 
 	print_uint(PRINT_ANY, "delta", "delta %d ", qopt->delta);
-	print_string(PRINT_ANY, "offload", "offload %s ",
-				(qopt->flags & TC_ETF_OFFLOAD_ON) ? "on" : "off");
-	print_string(PRINT_ANY, "deadline_mode", "deadline_mode %s ",
-				(qopt->flags & TC_ETF_DEADLINE_MODE_ON) ? "on" : "off");
-	print_string(PRINT_ANY, "skip_sock_check", "skip_sock_check %s",
-				(qopt->flags & TC_ETF_SKIP_SOCK_CHECK) ? "on" : "off");
+	if (qopt->flags & TC_ETF_OFFLOAD_ON)
+		print_bool(PRINT_ANY, "offload", "offload ", true);
+	if (qopt->flags & TC_ETF_DEADLINE_MODE_ON)
+		print_bool(PRINT_ANY, "deadline_mode", "deadline_mode ", true);
+	if (qopt->flags & TC_ETF_SKIP_SOCK_CHECK)
+		print_bool(PRINT_ANY, "skip_sock_check", "skip_sock_check", true);
 
 	return 0;
 }
-- 
2.7.3

