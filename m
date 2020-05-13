Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FF81D1FA6
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403805AbgEMTuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:50:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:59369 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403801AbgEMTuj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 15:50:39 -0400
IronPort-SDR: 4z9yPNB5201x4gxAxNTq/U2Yp79u2zn8WPTmy1+A1tqYA00SbcC8qE7gyi43Tr6Ta0wwVp7zvg
 jljAS0PjocuQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 12:50:37 -0700
IronPort-SDR: NYKz+sjD2jfN6VNoiiPY4uYScT9xEHKCpGKokPe/w56hcpZ7XyorCBI2Gg45UcSxKrckk5h1Ds
 t+gW1FbHt/zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,388,1583222400"; 
   d="scan'208";a="341363960"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga001.jf.intel.com with ESMTP; 13 May 2020 12:50:36 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     dsahern@gmail.com, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, kiran.patil@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH iproute2-next] tc: mqprio: reject queues count/offset pair count higher than num_tc
Date:   Wed, 13 May 2020 21:47:17 +0200
Message-Id: <20200513194717.15363-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a sanity check that will make sure whether queues count/offset
pair count will not exceed the actual number of TCs being created.

Example command that is invalid because there are 4 count/offset pairs
whereas num_tc is only 2.

 # tc qdisc add dev enp96s0f0 root mqprio num_tc 2 map 0 0 0 0 1 1 1 1
queues 4@0 4@4 4@8 4@12 hw 1 mode channel

Store the parsed count/offset pair count onto a dedicated variable that
will be compared against opt.num_tc after all of the command line
arguments were parsed. Bail out if this count is higher than opt.num_tc
and let user know about it.

Drivers were swallowing such commands as they were iterating over
count/offset pairs where num_tc was used as a delimiter, so this is not
a big deal, but better catch such misconfiguration at the command line
argument parsing level.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tc/q_mqprio.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tc/q_mqprio.c b/tc/q_mqprio.c
index 0eb41308..f26ba8d7 100644
--- a/tc/q_mqprio.c
+++ b/tc/q_mqprio.c
@@ -48,6 +48,7 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
 	__u64 max_rate64[TC_QOPT_MAX_QUEUE] = {0};
 	__u16 shaper = TC_MQPRIO_SHAPER_DCB;
 	__u16 mode = TC_MQPRIO_MODE_DCB;
+	int cnt_off_pairs = 0;
 	struct rtattr *tail;
 	__u32 flags = 0;
 
@@ -94,6 +95,7 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
 				}
 				free(tmp);
 				idx++;
+				cnt_off_pairs++;
 			}
 		} else if (strcmp(*argv, "hw") == 0) {
 			NEXT_ARG();
@@ -173,6 +175,12 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
 		argc--; argv++;
 	}
 
+	if (cnt_off_pairs > opt.num_tc) {
+		fprintf(stderr, "queues count/offset pair count %d can not be higher than given num_tc %d\n",
+			cnt_off_pairs, opt.num_tc);
+		return -1;
+	}
+
 	tail = NLMSG_TAIL(n);
 	addattr_l(n, 1024, TCA_OPTIONS, &opt, sizeof(opt));
 
-- 
2.20.1

