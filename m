Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5636D583
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391544AbfGRTzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:55:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:40934 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391485AbfGRTzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 15:55:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 12:55:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,279,1559545200"; 
   d="scan'208";a="158881616"
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga007.jf.intel.com with ESMTP; 18 Jul 2019 12:55:49 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com, dsahern@gmail.com,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH iproute2 net-next v5 5/5] tc: taprio: Update documentation
Date:   Thu, 18 Jul 2019 12:55:43 -0700
Message-Id: <1563479743-8371-5-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
In-Reply-To: <1563479743-8371-1-git-send-email-vedang.patel@intel.com>
References: <1563479743-8371-1-git-send-email-vedang.patel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for the latest options, flags and txtime-delay, to the
taprio manpage.

This also adds an example to run tc in txtime offload mode.

Signed-off-by: Vedang Patel <vedang.patel@intel.com>
---
 man/man8/tc-taprio.8 | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/man/man8/tc-taprio.8 b/man/man8/tc-taprio.8
index 850be9b03649..e1d19ba19089 100644
--- a/man/man8/tc-taprio.8
+++ b/man/man8/tc-taprio.8
@@ -112,6 +112,26 @@ means that traffic class 0 is "active" for that schedule entry.
 long that state defined by <command> and <gate mask> should be held
 before moving to the next entry.
 
+.TP
+flags
+.br
+Specifies different modes for taprio. Currently, only txtime-assist is
+supported which can be enabled by setting it to 0x1. In this mode, taprio will
+set the transmit timestamp depending on the interval in which the packet needs
+to be transmitted. It will then utililize the
+.BR etf(8)
+qdisc to sort and transmit the packets at the right time. The second example
+can be used as a reference to configure this mode.
+
+.TP
+txtime-delay
+.br
+This parameter is specific to the txtime offload mode. It specifies the maximum
+time a packet might take to reach the network card from the taprio qdisc. The
+value should always be greater than the delta specified in the
+.BR etf(8)
+qdisc.
+
 .SH EXAMPLES
 
 The following example shows how an traffic schedule with three traffic
@@ -137,6 +157,26 @@ reference CLOCK_TAI. The schedule is composed of three entries each of
               clockid CLOCK_TAI
 .EE
 
+Following is an example to enable the txtime offload mode in taprio. See
+.BR etf(8)
+for more information about configuring the ETF qdisc.
+
+.EX
+# tc qdisc replace dev eth0 parent root handle 100 taprio \\
+              num_tc 3 \\
+              map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \\
+              queues 1@0 1@0 1@0 \\
+              base-time 1528743495910289987 \\
+              sched-entry S 01 300000 \\
+              sched-entry S 02 300000 \\
+              sched-entry S 04 400000 \\
+              flags 0x1 \\
+              txtime-delay 200000 \\
+              clockid CLOCK_TAI
+
+# tc qdisc replace dev $IFACE parent 100:1 etf skip_skb_check \\
+              offload delta 200000 clockid CLOCK_TAI
+.EE
 
 .SH AUTHORS
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
-- 
2.7.3

