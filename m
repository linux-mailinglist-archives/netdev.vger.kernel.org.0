Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339D1486D03
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 23:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244734AbiAFWDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 17:03:09 -0500
Received: from 6.mo552.mail-out.ovh.net ([188.165.49.222]:52115 "EHLO
        6.mo552.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244436AbiAFWDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 17:03:08 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2022 17:03:08 EST
Received: from mxplan1.mail.ovh.net (unknown [10.108.20.173])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 527EC228C3;
        Thu,  6 Jan 2022 21:56:53 +0000 (UTC)
Received: from bracey.fi (37.59.142.103) by DAG4EX1.mxp1.local (172.16.2.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 6 Jan
 2022 22:56:52 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-103G00522a957d2-4b13-4f49-8364-fac989962f22,
                    983A4165C0DE8D18A60C99794E4AA4D91BE67B4B) smtp.auth=kevin@bracey.fi
X-OVh-ClientIp: 82.181.225.135
From:   Kevin Bracey <kevin@bracey.fi>
To:     <toke@toke.dk>
CC:     <netdev@vger.kernel.org>, Kevin Bracey <kevin@bracey.fi>
Subject: [PATCH net-next v2] sch_cake: revise Diffserv docs
Date:   Thu, 6 Jan 2022 23:56:37 +0200
Message-ID: <20220106215637.3132391-1-kevin@bracey.fi>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <87h7aga8es.fsf@toke.dk>
References: <87h7aga8es.fsf@toke.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.59.142.103]
X-ClientProxiedBy: DAG8EX1.mxp1.local (172.16.2.15) To DAG4EX1.mxp1.local
 (172.16.2.7)
X-Ovh-Tracer-GUID: 12f03016-9bd3-4f67-b326-5fdd470f5372
X-Ovh-Tracer-Id: 7324260372134138077
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvuddrudefledgudehfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpefmvghvihhnuceurhgrtggvhicuoehkvghvihhnsegsrhgrtggvhidrfhhiqeenucggtffrrghtthgvrhhnpeduvdehleffueeluefgkeeggeffveduheekfeektedtkeffkeejvdejffekveejgeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddtfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepmhigphhlrghnuddrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehkvghvihhnsegsrhgrtggvhidrfhhipdhrtghpthhtohepkhgvvhhinhessghrrggtvgihrdhfih
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation incorrectly stated that CS1 is equivalent to LE for
diffserv8. But when LE was added to the table, CS1 was pushed into tin
1, leaving only LE in tin 0.

Also "TOS1" no longer exists, as that is the same codepoint as LE.

Make other tweaks properly distinguishing codepoints from classes and
putting current Diffserve codepoints ahead of legacy ones.

Signed-off-by: Kevin Bracey <kevin@bracey.fi>
---
 net/sched/sch_cake.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 857aaebd49f4..a43a58a73d09 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2342,9 +2342,7 @@ static int cake_config_precedence(struct Qdisc *sch)
 
 /*	List of known Diffserv codepoints:
  *
- *	Least Effort (CS1, LE)
- *	Best Effort (CS0)
- *	Max Reliability & LLT "Lo" (TOS1)
+ *	Default Forwarding (DF/CS0) - Best Effort
  *	Max Throughput (TOS2)
  *	Min Delay (TOS4)
  *	LLT "La" (TOS5)
@@ -2352,6 +2350,7 @@ static int cake_config_precedence(struct Qdisc *sch)
  *	Assured Forwarding 2 (AF2x) - x3
  *	Assured Forwarding 3 (AF3x) - x3
  *	Assured Forwarding 4 (AF4x) - x3
+ *	Precedence Class 1 (CS1)
  *	Precedence Class 2 (CS2)
  *	Precedence Class 3 (CS3)
  *	Precedence Class 4 (CS4)
@@ -2360,8 +2359,9 @@ static int cake_config_precedence(struct Qdisc *sch)
  *	Precedence Class 7 (CS7)
  *	Voice Admit (VA)
  *	Expedited Forwarding (EF)
-
- *	Total 25 codepoints.
+ *	Lower Effort (LE)
+ *
+ *	Total 26 codepoints.
  */
 
 /*	List of traffic classes in RFC 4594, updated by RFC 8622:
@@ -2375,12 +2375,12 @@ static int cake_config_precedence(struct Qdisc *sch)
  *	Realtime Interactive (CS4)     - eg. games
  *	Multimedia Streaming (AF3x)    - eg. YouTube, NetFlix, Twitch
  *	Broadcast Video (CS3)
- *	Low Latency Data (AF2x,TOS4)      - eg. database
- *	Ops, Admin, Management (CS2,TOS1) - eg. ssh
- *	Standard Service (CS0 & unrecognised codepoints)
- *	High Throughput Data (AF1x,TOS2)  - eg. web traffic
- *	Low Priority Data (CS1,LE)        - eg. BitTorrent
-
+ *	Low-Latency Data (AF2x,TOS4)      - eg. database
+ *	Ops, Admin, Management (CS2)      - eg. ssh
+ *	Standard Service (DF & unrecognised codepoints)
+ *	High-Throughput Data (AF1x,TOS2)  - eg. web traffic
+ *	Low-Priority Data (LE,CS1)        - eg. BitTorrent
+ *
  *	Total 12 traffic classes.
  */
 
@@ -2390,12 +2390,12 @@ static int cake_config_diffserv8(struct Qdisc *sch)
  *
  *		Network Control          (CS6, CS7)
  *		Minimum Latency          (EF, VA, CS5, CS4)
- *		Interactive Shell        (CS2, TOS1)
+ *		Interactive Shell        (CS2)
  *		Low Latency Transactions (AF2x, TOS4)
  *		Video Streaming          (AF4x, AF3x, CS3)
- *		Bog Standard             (CS0 etc.)
- *		High Throughput          (AF1x, TOS2)
- *		Background Traffic       (CS1, LE)
+ *		Bog Standard             (DF etc.)
+ *		High Throughput          (AF1x, TOS2, CS1)
+ *		Background Traffic       (LE)
  *
  *		Total 8 traffic classes.
  */
@@ -2437,9 +2437,9 @@ static int cake_config_diffserv4(struct Qdisc *sch)
 /*  Further pruned list of traffic classes for four-class system:
  *
  *	    Latency Sensitive  (CS7, CS6, EF, VA, CS5, CS4)
- *	    Streaming Media    (AF4x, AF3x, CS3, AF2x, TOS4, CS2, TOS1)
- *	    Best Effort        (CS0, AF1x, TOS2, and those not specified)
- *	    Background Traffic (CS1, LE)
+ *	    Streaming Media    (AF4x, AF3x, CS3, AF2x, TOS4, CS2)
+ *	    Best Effort        (DF, AF1x, TOS2, and those not specified)
+ *	    Background Traffic (LE, CS1)
  *
  *		Total 4 traffic classes.
  */
@@ -2477,9 +2477,9 @@ static int cake_config_diffserv4(struct Qdisc *sch)
 static int cake_config_diffserv3(struct Qdisc *sch)
 {
 /*  Simplified Diffserv structure with 3 tins.
- *		Low Priority		(CS1, LE)
+ *		Latency Sensitive	(CS7, CS6, EF, VA, TOS4)
  *		Best Effort
- *		Latency Sensitive	(TOS4, VA, EF, CS6, CS7)
+ *		Low Priority		(LE, CS1)
  */
 	struct cake_sched_data *q = qdisc_priv(sch);
 	u32 mtu = psched_mtu(qdisc_dev(sch));
-- 
2.25.1

