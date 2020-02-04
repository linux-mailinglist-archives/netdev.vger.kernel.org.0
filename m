Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DC1151900
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 11:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgBDKtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 05:49:35 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44680 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgBDKte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 05:49:34 -0500
Received: by mail-pl1-f196.google.com with SMTP id d9so7113329plo.11
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 02:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xxRpv41GQfzYxEQk/xZSaRwxYZ0w9ARkNlQGnx8MaZs=;
        b=fwj09K68AP4O2+2NBJqG+UoDnq2YZ/rqVHFX4NsoBc467ao/YnqTNxPI2si+uGRFMw
         X0B5nOnUxF9BJ8zLs9M3TJB3FGujVDTMgvKqNv9FO21plARklsey+0Rcrls/aabJTO1p
         u6+V9PRlqW7BRELlFv/XtCyK9hxqme+1xJuC6zkXYJT1Mh0egSzQ3jfrEcbmkazRjCCY
         qCPpUBWwiBBIU2bIVwatDK7I357YHrmjWky4IRQZqzZ3McSsYFvgPEUP96LKDl95Xm+a
         OvSmsxwThhu7u19Y9dCCuwTtmUs0GkNkvu2kC6d9bHSKfsZCHw4o5Fr4ipXojopDerGF
         RF6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xxRpv41GQfzYxEQk/xZSaRwxYZ0w9ARkNlQGnx8MaZs=;
        b=O7T5HZTYCvWThjueyW2JIpCyiFVx6SEGUvYzzSqqiPRK4YE6EHn1O1O0XKP+inWT8w
         2JPmtCrFVPZB2eWzD6ZMs0F+5fH7zEp2gEu6FwNMqV9ohUjConyYcZVOPwpMrsC/HBgB
         xd3RJmGpnP08tyiSD8KOUo+2jixCeSpkTOa+WTPFAF5bd9BFQA5SseWZT1XlT8EoaiTe
         HufcmXhlvPCi7gA+U6GdZqNFFs8KOyCLBzmtqlX9TapBLQtK9TNZFtJlr3QpyU2y3Yh5
         WS83VTbNRLTXcDIavEtvbTprrlLhCkkuNaAKFYdFSEIEcDb8of7Wdh8Yvt+lockCl9If
         y/fA==
X-Gm-Message-State: APjAAAX3FNizNDdME4guVMZn492XaNMLFAGVrDo7rZm59g2LIDMU/8mY
        h/QTQbQWsKxCvIG9r2ACERISsdyehy/+3w==
X-Google-Smtp-Source: APXvYqx5ksoU7uCzzUJEJITxqBsRVLyfaF6uBzKuSs74yz0Xw0uKYKUXppMMd7vahfvBCLx92Fpd/w==
X-Received: by 2002:a17:902:9349:: with SMTP id g9mr28876324plp.110.1580813372835;
        Tue, 04 Feb 2020 02:49:32 -0800 (PST)
Received: from localhost.localdomain ([223.186.244.92])
        by smtp.gmail.com with ESMTPSA id gc1sm2870606pjb.20.2020.02.04.02.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 02:49:31 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH iproute2 v2] tc: add support for FQ-PIE packet scheduler
Date:   Tue,  4 Feb 2020 16:19:19 +0530
Message-Id: <20200204104919.23492-1-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

This patch adds support for the FQ-PIE packet Scheduler

Principles:
  - Packets are classified on flows.
  - This is a Stochastic model (as we use a hash, several flows might
                                be hashed to the same slot)
  - Each flow has a PIE managed queue.
  - Flows are linked onto two (Round Robin) lists,
    so that new flows have priority on old ones.
  - For a given flow, packets are not reordered.
  - Drops during enqueue only.
  - ECN capability is off by default.
  - ECN threshold (if ECN is enabled) is at 10% by default.
  - Uses timestamps to calculate queue delay by default.

Usage:
tc qdisc ... fq_pie [ limit PACKETS ] [ flows NUMBER ]
                    [ target TIME ] [ tupdate TIME ]
                    [ alpha NUMBER ] [ beta NUMBER ]
                    [ quantum BYTES ] [ memory_limit BYTES ]
                    [ ecn_prob PERCENTAGE ] [ [no]ecn ]
                    [ [no]bytemode ] [ [no_]dq_rate_estimator ]

defaults:
  limit: 10240 packets, flows: 1024
  target: 15 ms, tupdate: 15 ms (in jiffies)
  alpha: 1/8, beta : 5/4
  quantum: device MTU, memory_limit: 32 Mb
  ecnprob: 10%, ecn: off
  bytemode: off, dq_rate_estimator: off

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Sachin D. Patil <sdp.sachin@gmail.com>
Signed-off-by: V. Saicharan <vsaicharan1998@gmail.com>
Signed-off-by: Mohit Bhasi <mohitbhasi1998@gmail.com>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---

Changes from v1 to v2:
 - Changed the lisence header to the SPDX for GPLv2

 bash-completion/tc   |  12 +-
 man/man8/tc-fq_pie.8 | 166 ++++++++++++++++++++++
 man/man8/tc.8        |   8 ++
 tc/Makefile          |   1 +
 tc/q_fq_pie.c        | 318 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 503 insertions(+), 2 deletions(-)
 create mode 100644 man/man8/tc-fq_pie.8
 create mode 100644 tc/q_fq_pie.c

diff --git a/bash-completion/tc b/bash-completion/tc
index fe0d51ec..086cb7f6 100644
--- a/bash-completion/tc
+++ b/bash-completion/tc
@@ -3,8 +3,8 @@
 # Copyright 2016 Quentin Monnet <quentin.monnet@6wind.com>
 
 QDISC_KIND=' choke codel bfifo pfifo pfifo_head_drop fq fq_codel gred hhf \
-            mqprio multiq netem pfifo_fast pie red rr sfb sfq tbf atm cbq drr \
-            dsmark hfsc htb prio qfq '
+            mqprio multiq netem pfifo_fast pie fq_pie red rr sfb sfq tbf atm \
+            cbq drr dsmark hfsc htb prio qfq '
 FILTER_KIND=' basic bpf cgroup flow flower fw route rsvp tcindex u32 matchall '
 ACTION_KIND=' gact mirred bpf sample '
 
@@ -326,6 +326,14 @@ _tc_qdisc_options()
             _tc_one_of_list 'dq_rate_estimator no_dq_rate_estimator'
             return 0
             ;;
+        fq_pie)
+            _tc_once_attr 'limit flows target tupdate \
+                alpha beta quantum memory_limit ecn_prob'
+            _tc_one_of_list 'ecn noecn'
+            _tc_one_of_list 'bytemode nobytemode'
+            _tc_one_of_list 'dq_rate_estimator no_dq_rate_estimator'
+            return 0
+            ;;
         red)
             _tc_once_attr 'limit min max avpkt burst adaptive probability \
                 bandwidth ecn harddrop'
diff --git a/man/man8/tc-fq_pie.8 b/man/man8/tc-fq_pie.8
new file mode 100644
index 00000000..457a56bb
--- /dev/null
+++ b/man/man8/tc-fq_pie.8
@@ -0,0 +1,166 @@
+.TH FQ-PIE 8 "23 January 2020" "iproute2" "Linux"
+
+.SH NAME
+
+FQ-PIE - Flow Queue Proportional Integral controller Enhanced
+
+.SH SYNOPSIS
+
+.B tc qdisc ... fq_pie
+[ \fBlimit\fR PACKETS ] [ \fBflows\fR NUMBER ]
+.br
+                    \
+[ \fBtarget\fR TIME ] [ \fBtupdate\fR TIME ]
+.br
+                    \
+[ \fBalpha\fR NUMBER ] [ \fBbeta\fR NUMBER ]
+.br
+                    \
+[ \fBquantum\fR BYTES ] [ \fBmemory_limit\fR BYTES ]
+.br
+                    \
+[ \fBecn_prob\fR PERENTAGE ] [ [\fBno\fR]\fBecn\fR ]
+.br
+                    \
+[ [\fBno\fR]\fBbytemode\fR ] [ [\fBno_\fR]\fBdq_rate_estimator\fR ]
+
+.SH DESCRIPTION
+FQ-PIE (Flow Queuing with Proportional Integral controller Enhanced) is a
+queuing discipline that combines Flow Queuing with the PIE AQM scheme. FQ-PIE
+uses a Jenkins hash function to classify incoming packets into different flows
+and is used to provide a fair share of the bandwidth to all the flows using the
+qdisc. Each such flow is managed by the PIE algorithm.
+
+.SH ALGORITHM
+The FQ-PIE algorithm consists of two logical parts: the scheduler which selects
+which queue to dequeue a packet from, and the PIE AQM which works on each of the
+queues. The major work of FQ-PIE is mostly in the scheduling part. The
+interaction between the scheduler and the PIE algorithm is straight forward.
+
+During the enqueue stage, a hashing-based scheme is used, where flows are hashed
+into a number of buckets with each bucket having its own queue. The number of
+buckets is configurable, and presently defaults to 1024 in the implementation.
+The flow hashing is performed on the 5-tuple of source and destination IP
+addresses, port numbers and IP protocol number. Once the packet has been
+successfully classified into a queue, it is handed over to the PIE algorithm
+for enqueuing. It is then added to the tail of the selected queue, and the
+queue's byte count is updated by the packet size. If the queue is not currently
+active (i.e., if it is not in either the list of new or the list of old queues)
+, it is added to the end of the list of new queues, and its number of credits
+is initiated to the configured quantum. Otherwise, the queue is left in its
+current queue list.
+
+During the dequeue stage, the scheduler first looks at the list of new queues;
+for the queue at the head of that list, if that queue has a negative number of
+credits (i.e., it has already dequeued at least a quantum of bytes), it is given
+an additional quantum of credits, the queue is put onto the end of the list of
+old queues, and the routine selects the next queue and starts again. Otherwise,
+that queue is selected for dequeue again. If the list of new queues is empty,
+the scheduler proceeds down the list of old queues in the same fashion
+(checking the credits, and either selecting the queue for dequeuing, or adding
+credits and putting the queue back at the end of the list). After having
+selected a queue from which to dequeue a packet, the PIE algorithm is invoked
+on that queue.
+
+Finally, if the PIE algorithm does not return a packet, then the queue must be
+empty and the scheduler does one of two things:
+
+If the queue selected for dequeue came from the list of new queues, it is moved
+to the end of the list of old queues. If instead it came from the list of old
+queues, that queue is removed from the list, to be added back (as a new queue)
+the next time a packet arrives that hashes to that queue. Then (since no packet
+was available for dequeue), the whole dequeue process is restarted from the
+beginning.
+
+If, instead, the scheduler did get a packet back from the PIE algorithm, it
+subtracts the size of the packet from the byte credits for the selected queue
+and returns the packet as the result of the dequeue operation.
+
+.SH PARAMETERS
+.SS limit
+It is the limit on the queue size in packets. Incoming packets are dropped when
+the limit is reached. The default value is 10240 packets.
+
+.SS flows
+It is the number of flows into which the incoming packets are classified. Due
+to the stochastic nature of hashing, multiple flows may end up being hashed
+into the same slot. Newer flows have priority over older ones. This
+parameter can be set only at load time since memory has to be allocated for
+the hash table. The default value is 1024.
+
+.SS target
+It is the queue delay which the PIE algorithm tries to maintain. The default
+target delay is 15ms.
+
+.SS tupdate
+It is the time interval at which the system drop probability is calculated.
+The default is 15ms.
+
+.SS alpha
+.SS beta
+alpha and beta are parameters chosen to control the drop probability. These
+should be in the range between 0 and 32.
+
+.SS quantum
+quantum signifies the number of bytes that may be dequeued from a queue before
+switching to the next queue in the deficit round robin scheme.
+
+.SS memory_limit
+It is the maximum total memory allowed for packets of all flows. The default is
+32Mb.
+
+.SS ecn_prob
+It is the drop probability threshold below which packets will be ECN marked
+instead of getting dropped. The default is 10%. Setting this parameter requires
+\fBecn\fR to be enabled.
+
+.SS \fR[\fBno\fR]\fBecn\fR
+It has the same semantics as \fBpie\fR and can be used to mark packets
+instead of dropping them. If \fBecn\fR has been enabled, \fBnoecn\fR can
+be used to turn it off and vice-a-versa.
+
+.SS \fR[\fBno\fR]\fBbytemode\fR
+It is used to scale drop probability proportional to packet size
+\fBbytemode\fR to turn on bytemode, \fBnobytemode\fR to turn off
+bytemode. By default, \fBbytemode\fR is turned off.
+
+.SS \fR[\fBno_\fR]\fBdq_rate_estimator\fR
+\fBdq_rate_estimator\fR can be used to calculate queue delay using Little's
+Law, \fBno_dq_rate_estimator\fR can be used to calculate queue delay
+using timestamp. By default, \fBdq_rate_estimator\fR is turned off.
+
+.SH EXAMPLES
+# tc qdisc add dev eth0 root fq_pie
+.br
+# tc -s qdisc show dev eth0
+.br
+qdisc fq_pie 8001: root refcnt 2 limit 10240p flows 1024 target 15.0ms tupdate
+16.0ms alpha 2 beta 20 quantum 1514b memory_limit 32Mb ecn_prob 10
+ Sent 159173586 bytes 105261 pkt (dropped 24, overlimits 0 requeues 0)
+ backlog 75700b 50p requeues 0
+  pkts_in 105311 overlimit 0 overmemory 0 dropped 24 ecn_mark 0
+  new_flow_count 7332 new_flows_len 0 old_flows_len 4 memory_used 108800
+
+# tc qdisc add dev eth0 root fq_pie dq_rate_estimator
+.br
+# tc -s qdisc show dev eth0
+.br
+qdisc fq_pie 8001: root refcnt 2 limit 10240p flows 1024 target 15.0ms tupdate
+16.0ms alpha 2 beta 20 quantum 1514b memory_limit 32Mb ecn_prob 10
+dq_rate_estimator
+ Sent 8263620 bytes 5550 pkt (dropped 4, overlimits 0 requeues 0)
+ backlog 805448b 532p requeues 0
+  pkts_in 6082 overlimit 0 overmemory 0 dropped 4 ecn_mark 0
+  new_flow_count 94 new_flows_len 0 old_flows_len 8 memory_used 1157632
+
+.SH SEE ALSO
+.BR tc (8),
+.BR tc-pie (8),
+.BR tc-fq_codel (8)
+
+.SH SOURCES
+RFC 8033: https://tools.ietf.org/html/rfc8033
+
+.SH AUTHORS
+FQ-PIE was implemented by Mohit P. Tahiliani. Please report corrections to the
+Linux Networking mailing list <netdev@vger.kernel.org>.
diff --git a/man/man8/tc.8 b/man/man8/tc.8
index 39976ad7..e8e0cd0f 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -284,6 +284,13 @@ bandwidth to all the flows using the queue. Each such flow is managed by the
 CoDel queuing discipline. Reordering within a flow is avoided since Codel
 internally uses a FIFO queue.
 .TP
+fq_pie
+FQ-PIE (Flow Queuing with Proportional Integral controller Enhanced) is a
+queuing discipline that combines Flow Queuing with the PIE AQM scheme. FQ-PIE
+uses a Jenkins hash function to classify incoming packets into different flows
+and is used to provide a fair share of the bandwidth to all the flows using the
+qdisc. Each such flow is managed by the PIE algorithm.
+.TP
 gred
 Generalized Random Early Detection combines multiple RED queues in order to
 achieve multiple drop priorities. This is required to realize Assured
@@ -855,6 +862,7 @@ was written by Alexey N. Kuznetsov and added in Linux 2.2.
 .BR tc-flower (8),
 .BR tc-fq (8),
 .BR tc-fq_codel (8),
+.BR tc-fq_pie (8),
 .BR tc-fw (8),
 .BR tc-hfsc (7),
 .BR tc-hfsc (8),
diff --git a/tc/Makefile b/tc/Makefile
index f06ba14b..e31cbc12 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -70,6 +70,7 @@ TCMODULES += q_codel.o
 TCMODULES += q_fq_codel.o
 TCMODULES += q_fq.o
 TCMODULES += q_pie.o
+TCMODULES += q_fq_pie.o
 TCMODULES += q_cake.o
 TCMODULES += q_hhf.o
 TCMODULES += q_clsact.o
diff --git a/tc/q_fq_pie.c b/tc/q_fq_pie.c
new file mode 100644
index 00000000..c136cd1a
--- /dev/null
+++ b/tc/q_fq_pie.c
@@ -0,0 +1,318 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Flow Queue PIE
+ *
+ * Copyright (C) 2019 Mohit P. Tahiliani <tahiliani@nitk.edu.in>
+ * Copyright (C) 2019 Sachin D. Patil <sdp.sachin@gmail.com>
+ * Copyright (C) 2019 V. Saicharan <vsaicharan1998@gmail.com>
+ * Copyright (C) 2019 Mohit Bhasi <mohitbhasi1998@gmail.com>
+ * Copyright (C) 2019 Leslie Monis <lesliemonis@gmail.com>
+ * Copyright (C) 2019 Gautam Ramakrishnan <gautamramk@gmail.com>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <string.h>
+
+#include "utils.h"
+#include "tc_util.h"
+
+static void explain(void)
+{
+	fprintf(stderr,
+		"Usage: ... fq_pie [ limit PACKETS ] [ flows NUMBER ]\n"
+		"                  [ target TIME ] [ tupdate TIME ]\n"
+		"                  [ alpha NUMBER ] [ beta NUMBER ]\n"
+		"                  [ quantum BYTES ] [ memory_limit BYTES ]\n"
+		"                  [ ecn_prob PERCENTAGE ] [ [no]ecn ]\n"
+		"                  [ [no]bytemode ] [ [no_]dq_rate_estimator ]\n");
+}
+
+#define ALPHA_MAX 32
+#define BETA_MAX 32
+
+static int fq_pie_parse_opt(struct qdisc_util *qu, int argc, char **argv,
+			    struct nlmsghdr *n, const char *dev)
+{
+	unsigned int limit = 0;
+	unsigned int flows = 0;
+	unsigned int target = 0;
+	unsigned int tupdate = 0;
+	unsigned int alpha = 0;
+	unsigned int beta = 0;
+	unsigned int quantum = 0;
+	unsigned int memory_limit = 0;
+	unsigned int ecn_prob = 0;
+	int ecn = -1;
+	int bytemode = -1;
+	int dq_rate_estimator = -1;
+	struct rtattr *tail;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "limit") == 0) {
+			NEXT_ARG();
+			if (get_unsigned(&limit, *argv, 0)) {
+				fprintf(stderr, "Illegal \"limit\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "flows") == 0) {
+			NEXT_ARG();
+			if (get_unsigned(&flows, *argv, 0)) {
+				fprintf(stderr, "Illegal \"flows\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "target") == 0) {
+			NEXT_ARG();
+			if (get_time(&target, *argv)) {
+				fprintf(stderr, "Illegal \"target\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "tupdate") == 0) {
+			NEXT_ARG();
+			if (get_time(&tupdate, *argv)) {
+				fprintf(stderr, "Illegal \"tupdate\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "alpha") == 0) {
+			NEXT_ARG();
+			if (get_unsigned(&alpha, *argv, 0) ||
+			    alpha > ALPHA_MAX) {
+				fprintf(stderr, "Illegal \"alpha\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "beta") == 0) {
+			NEXT_ARG();
+			if (get_unsigned(&beta, *argv, 0) ||
+			    beta > BETA_MAX) {
+				fprintf(stderr, "Illegal \"beta\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "quantum") == 0) {
+			NEXT_ARG();
+			if (get_size(&quantum, *argv)) {
+				fprintf(stderr, "Illegal \"quantum\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "memory_limit") == 0) {
+			NEXT_ARG();
+			if (get_size(&memory_limit, *argv)) {
+				fprintf(stderr, "Illegal \"memory_limit\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "ecn_prob") == 0) {
+			NEXT_ARG();
+			if (get_unsigned(&ecn_prob, *argv, 0) ||
+			    ecn_prob >= 100) {
+				fprintf(stderr, "Illegal \"ecn_prob\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "ecn") == 0) {
+			ecn = 1;
+		} else if (strcmp(*argv, "noecn") == 0) {
+			ecn = 0;
+		} else if (strcmp(*argv, "bytemode") == 0) {
+			bytemode = 1;
+		} else if (strcmp(*argv, "nobytemode") == 0) {
+			bytemode = 0;
+		} else if (strcmp(*argv, "dq_rate_estimator") == 0) {
+			dq_rate_estimator = 1;
+		} else if (strcmp(*argv, "no_dq_rate_estimator") == 0) {
+			dq_rate_estimator = 0;
+		} else if (strcmp(*argv, "help") == 0) {
+			explain();
+			return -1;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			explain();
+			return -1;
+		}
+
+		argc--;
+		argv++;
+	}
+
+	tail = addattr_nest(n, 1024, TCA_OPTIONS | NLA_F_NESTED);
+	if (limit)
+		addattr_l(n, 1024, TCA_FQ_PIE_LIMIT, &limit, sizeof(limit));
+	if (flows)
+		addattr_l(n, 1024, TCA_FQ_PIE_FLOWS, &flows, sizeof(flows));
+	if (target)
+		addattr_l(n, 1024, TCA_FQ_PIE_TARGET, &target, sizeof(target));
+	if (tupdate)
+		addattr_l(n, 1024, TCA_FQ_PIE_TUPDATE, &tupdate,
+			  sizeof(tupdate));
+	if (alpha)
+		addattr_l(n, 1024, TCA_FQ_PIE_ALPHA, &alpha, sizeof(alpha));
+	if (beta)
+		addattr_l(n, 1024, TCA_FQ_PIE_BETA, &beta, sizeof(beta));
+	if (quantum)
+		addattr_l(n, 1024, TCA_FQ_PIE_QUANTUM, &quantum,
+			  sizeof(quantum));
+	if (memory_limit)
+		addattr_l(n, 1024, TCA_FQ_PIE_MEMORY_LIMIT, &memory_limit,
+			  sizeof(memory_limit));
+	if (ecn_prob)
+		addattr_l(n, 1024, TCA_FQ_PIE_ECN_PROB, &ecn_prob,
+			  sizeof(ecn_prob));
+	if (ecn != -1)
+		addattr_l(n, 1024, TCA_FQ_PIE_ECN, &ecn, sizeof(ecn));
+	if (bytemode != -1)
+		addattr_l(n, 1024, TCA_FQ_PIE_BYTEMODE, &bytemode,
+			  sizeof(bytemode));
+	if (dq_rate_estimator != -1)
+		addattr_l(n, 1024, TCA_FQ_PIE_DQ_RATE_ESTIMATOR,
+			  &dq_rate_estimator, sizeof(dq_rate_estimator));
+	addattr_nest_end(n, tail);
+
+	return 0;
+}
+
+static int fq_pie_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
+{
+	struct rtattr *tb[TCA_FQ_PIE_MAX + 1];
+	unsigned int limit = 0;
+	unsigned int flows = 0;
+	unsigned int target = 0;
+	unsigned int tupdate = 0;
+	unsigned int alpha = 0;
+	unsigned int beta = 0;
+	unsigned int quantum = 0;
+	unsigned int memory_limit = 0;
+	unsigned int ecn_prob = 0;
+	int ecn = -1;
+	int bytemode = -1;
+	int dq_rate_estimator = -1;
+
+	SPRINT_BUF(b1);
+
+	if (opt == NULL)
+		return 0;
+
+	parse_rtattr_nested(tb, TCA_FQ_PIE_MAX, opt);
+
+	if (tb[TCA_FQ_PIE_LIMIT] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_PIE_LIMIT]) >= sizeof(__u32)) {
+		limit = rta_getattr_u32(tb[TCA_FQ_PIE_LIMIT]);
+		print_uint(PRINT_ANY, "limit", "limit %up ", limit);
+	}
+	if (tb[TCA_FQ_PIE_FLOWS] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_PIE_FLOWS]) >= sizeof(__u32)) {
+		flows = rta_getattr_u32(tb[TCA_FQ_PIE_FLOWS]);
+		print_uint(PRINT_ANY, "flows", "flows %u ", flows);
+	}
+	if (tb[TCA_FQ_PIE_TARGET] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_PIE_TARGET]) >= sizeof(__u32)) {
+		target = rta_getattr_u32(tb[TCA_FQ_PIE_TARGET]);
+		print_uint(PRINT_JSON, "target", NULL, target);
+		print_string(PRINT_FP, NULL, "target %s ",
+			     sprint_time(target, b1));
+	}
+	if (tb[TCA_FQ_PIE_TUPDATE] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_PIE_TUPDATE]) >= sizeof(__u32)) {
+		tupdate = rta_getattr_u32(tb[TCA_FQ_PIE_TUPDATE]);
+		print_uint(PRINT_JSON, "tupdate", NULL, tupdate);
+		print_string(PRINT_FP, NULL, "tupdate %s ",
+			     sprint_time(tupdate, b1));
+	}
+	if (tb[TCA_FQ_PIE_ALPHA] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_PIE_ALPHA]) >= sizeof(__u32)) {
+		alpha = rta_getattr_u32(tb[TCA_FQ_PIE_ALPHA]);
+		print_uint(PRINT_ANY, "alpha", "alpha %u ", alpha);
+	}
+	if (tb[TCA_FQ_PIE_BETA] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_PIE_BETA]) >= sizeof(__u32)) {
+		beta = rta_getattr_u32(tb[TCA_FQ_PIE_BETA]);
+		print_uint(PRINT_ANY, "beta", "beta %u ", beta);
+	}
+	if (tb[TCA_FQ_PIE_QUANTUM] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_PIE_QUANTUM]) >= sizeof(__u32)) {
+		quantum = rta_getattr_u32(tb[TCA_FQ_PIE_QUANTUM]);
+		print_uint(PRINT_JSON, "quantum", NULL, quantum);
+		print_string(PRINT_FP, NULL, "quantum %s ",
+			     sprint_size(quantum, b1));
+	}
+	if (tb[TCA_FQ_PIE_MEMORY_LIMIT] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_PIE_MEMORY_LIMIT]) >= sizeof(__u32)) {
+		memory_limit = rta_getattr_u32(tb[TCA_FQ_PIE_MEMORY_LIMIT]);
+		print_uint(PRINT_JSON, "memory_limit", NULL, memory_limit);
+		print_string(PRINT_FP, NULL, "memory_limit %s ",
+			     sprint_size(memory_limit, b1));
+	}
+	if (tb[TCA_FQ_PIE_ECN_PROB] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_PIE_ECN_PROB]) >= sizeof(__u32)) {
+		ecn_prob = rta_getattr_u32(tb[TCA_FQ_PIE_ECN_PROB]);
+		print_uint(PRINT_ANY, "ecn_prob", "ecn_prob %u ", ecn_prob);
+	}
+	if (tb[TCA_FQ_PIE_ECN] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_PIE_ECN]) >= sizeof(__u32)) {
+		ecn = rta_getattr_u32(tb[TCA_FQ_PIE_ECN]);
+		if (ecn)
+			print_bool(PRINT_ANY, "ecn", "ecn ", true);
+	}
+	if (tb[TCA_FQ_PIE_BYTEMODE] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_PIE_BYTEMODE]) >= sizeof(__u32)) {
+		bytemode = rta_getattr_u32(tb[TCA_FQ_PIE_BYTEMODE]);
+		if (bytemode)
+			print_bool(PRINT_ANY, "bytemode", "bytemode ", true);
+	}
+	if (tb[TCA_FQ_PIE_DQ_RATE_ESTIMATOR] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_PIE_DQ_RATE_ESTIMATOR]) >= sizeof(__u32)) {
+		dq_rate_estimator =
+			rta_getattr_u32(tb[TCA_FQ_PIE_DQ_RATE_ESTIMATOR]);
+		if (dq_rate_estimator)
+			print_bool(PRINT_ANY, "dq_rate_estimator",
+				   "dq_rate_estimator ", true);
+	}
+
+	return 0;
+}
+
+static int fq_pie_print_xstats(struct qdisc_util *qu, FILE *f,
+			       struct rtattr *xstats)
+{
+	struct tc_fq_pie_xstats _st = {}, *st;
+
+	if (xstats == NULL)
+		return 0;
+
+	st = RTA_DATA(xstats);
+	if (RTA_PAYLOAD(xstats) < sizeof(*st)) {
+		memcpy(&_st, st, RTA_PAYLOAD(xstats));
+		st = &_st;
+	}
+
+	print_uint(PRINT_ANY, "pkts_in", "  pkts_in %u",
+		   st->packets_in);
+	print_uint(PRINT_ANY, "overlimit", " overlimit %u",
+		   st->overlimit);
+	print_uint(PRINT_ANY, "overmemory", " overmemory %u",
+		   st->overmemory);
+	print_uint(PRINT_ANY, "dropped", " dropped %u",
+		   st->dropped);
+	print_uint(PRINT_ANY, "ecn_mark", " ecn_mark %u",
+		   st->ecn_mark);
+	print_nl();
+	print_uint(PRINT_ANY, "new_flow_count", "  new_flow_count %u",
+		   st->new_flow_count);
+	print_uint(PRINT_ANY, "new_flows_len", " new_flows_len %u",
+		   st->new_flows_len);
+	print_uint(PRINT_ANY, "old_flows_len", " old_flows_len %u",
+		   st->old_flows_len);
+	print_uint(PRINT_ANY, "memory_used", " memory_used %u",
+		   st->memory_usage);
+
+	return 0;
+
+}
+
+struct qdisc_util fq_pie_qdisc_util = {
+	.id		= "fq_pie",
+	.parse_qopt	= fq_pie_parse_opt,
+	.print_qopt	= fq_pie_print_opt,
+	.print_xstats	= fq_pie_print_xstats,
+};
-- 
2.17.1

