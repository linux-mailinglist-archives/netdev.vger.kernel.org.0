Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412C848C9F1
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241715AbiALRjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:39:02 -0500
Received: from 10.mo548.mail-out.ovh.net ([46.105.77.235]:34623 "EHLO
        10.mo548.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241366AbiALRi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:38:27 -0500
X-Greylist: delayed 38124 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2022 12:38:26 EST
Received: from mxplan1.mail.ovh.net (unknown [10.109.138.7])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id BF871204FD;
        Wed, 12 Jan 2022 17:02:14 +0000 (UTC)
Received: from bracey.fi (37.59.142.99) by DAG4EX1.mxp1.local (172.16.2.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 12 Jan
 2022 18:02:13 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-99G003cb9ac296-aba9-4fcf-b6c9-8400c344c0e1,
                    9C4ECD095E6EB6DE56D124D498B9B7C748136B87) smtp.auth=kevin@bracey.fi
X-OVh-ClientIp: 82.181.225.135
From:   Kevin Bracey <kevin@bracey.fi>
To:     <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, Kevin Bracey <kevin@bracey.fi>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@resnulli.us>, Vimalkumar <j.vimal@gmail.com>
Subject: [PATCH net-next v2] net_sched: restore "mpu xxx" handling
Date:   Wed, 12 Jan 2022 19:02:10 +0200
Message-ID: <20220112170210.1014351-1-kevin@bracey.fi>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.59.142.99]
X-ClientProxiedBy: DAG9EX2.mxp1.local (172.16.2.18) To DAG4EX1.mxp1.local
 (172.16.2.7)
X-Ovh-Tracer-GUID: 6c64fa6f-ace9-478b-909a-096c1e4c5b7b
X-Ovh-Tracer-Id: 690739593305493542
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrtddugdejudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgggfgtihesthekredtredttdenucfhrhhomhepmfgvvhhinhcuuehrrggtvgihuceokhgvvhhinhessghrrggtvgihrdhfiheqnecuggftrfgrthhtvghrnhepueektdeiuefhueevheejudetleehudffheekffdtteegheefueeggfetudejgedunecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrdelleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepmhigphhlrghnuddrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehkvghvihhnsegsrhgrtggvhidrfhhipdhnsggprhgtphhtthhopedupdhrtghpthhtohepkhgvvhhinhessghrrggtvgihrdhfih
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 56b765b79e9a ("htb: improved accuracy at high rates") broke
"overhead X", "linklayer atm" and "mpu X" attributes.

"overhead X" and "linklayer atm" have already been fixed. This restores
the "mpu X" handling, as might be used by DOCSIS or Ethernet shaping:

    tc class add ... htb rate X overhead 4 mpu 64

The code being fixed is used by htb, tbf and act_police. Cake has its
own mpu handling. qdisc_calculate_pkt_len still uses the size table
containing values adjusted for mpu by user space.

iproute2 tc has always passed mpu into the kernel via a tc_ratespec
structure, but the kernel never directly acted on it, merely stored it
so that it could be read back by `tc class show`.

Rather, tc would generate length-to-time tables that included the mpu
(and linklayer) in their construction, and the kernel used those tables.

Since v3.7, the tables were no longer used. Along with "mpu", this also
broke "overhead" and "linklayer" which were fixed in 01cb71d2d47b
("net_sched: restore "overhead xxx" handling", v3.10) and 8a8e3d84b171
("net_sched: restore "linklayer atm" handling", v3.11).

"overhead" was fixed by simply restoring use of tc_ratespec::overhead -
this had originally been used by the kernel but was initially omitted
from the new non-table-based calculations.

"linklayer" had been handled in the table like "mpu", but the mode was
not originally passed in tc_ratespec. The new implementation was made to
handle it by getting new versions of tc to pass the mode in an extended
tc_ratespec, and for older versions of tc the table contents were analysed
at load time to deduce linklayer.

As "mpu" has always been given to the kernel in tc_ratespec,
accompanying the mpu-based table, we can restore system functionality
with no userspace change by making the kernel act on the tc_ratespec
value.

Fixes: 56b765b79e9a ("htb: improved accuracy at high rates")
Signed-off-by: Kevin Bracey <kevin@bracey.fi>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Vimalkumar <j.vimal@gmail.com>
---
 include/net/sch_generic.h | 5 +++++
 net/sched/sch_generic.c   | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index c70e6d2b2fdd..fddca0aa73ef 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1244,6 +1244,7 @@ struct psched_ratecfg {
 	u64	rate_bytes_ps; /* bytes per second */
 	u32	mult;
 	u16	overhead;
+	u16	mpu;
 	u8	linklayer;
 	u8	shift;
 };
@@ -1253,6 +1254,9 @@ static inline u64 psched_l2t_ns(const struct psched_ratecfg *r,
 {
 	len += r->overhead;
 
+	if (len < r->mpu)
+		len = r->mpu;
+
 	if (unlikely(r->linklayer == TC_LINKLAYER_ATM))
 		return ((u64)(DIV_ROUND_UP(len,48)*53) * r->mult) >> r->shift;
 
@@ -1275,6 +1279,7 @@ static inline void psched_ratecfg_getrate(struct tc_ratespec *res,
 	res->rate = min_t(u64, r->rate_bytes_ps, ~0U);
 
 	res->overhead = r->overhead;
+	res->mpu = r->mpu;
 	res->linklayer = (r->linklayer & TC_LINKLAYER_MASK);
 }
 
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 3b0f62095803..5d391fe3137d 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1474,6 +1474,7 @@ void psched_ratecfg_precompute(struct psched_ratecfg *r,
 {
 	memset(r, 0, sizeof(*r));
 	r->overhead = conf->overhead;
+	r->mpu = conf->mpu;
 	r->rate_bytes_ps = max_t(u64, conf->rate, rate64);
 	r->linklayer = (conf->linklayer & TC_LINKLAYER_MASK);
 	psched_ratecfg_precompute__(r->rate_bytes_ps, &r->mult, &r->shift);
-- 
2.25.1

