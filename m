Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEB0487E5E
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 22:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiAGVi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 16:38:27 -0500
Received: from 1.mo548.mail-out.ovh.net ([178.32.121.110]:58367 "EHLO
        1.mo548.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiAGVi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 16:38:27 -0500
X-Greylist: delayed 4509 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jan 2022 16:38:27 EST
Received: from mxplan1.mail.ovh.net (unknown [10.109.138.194])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id 6D8DC20E7B;
        Fri,  7 Jan 2022 20:23:16 +0000 (UTC)
Received: from bracey.fi (37.59.142.96) by DAG4EX1.mxp1.local (172.16.2.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 7 Jan
 2022 21:23:15 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-96R0019ee7a6c2-2ded-4948-8349-43da7af5a9a6,
                    922F2FDBF6210DF4D3554770821CDAEC5C4B95F4) smtp.auth=kevin@bracey.fi
X-OVh-ClientIp: 82.181.225.135
From:   Kevin Bracey <kevin@bracey.fi>
To:     <netdev@vger.kernel.org>
CC:     Kevin Bracey <kevin@bracey.fi>, Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@resnulli.us>, Vimalkumar <j.vimal@gmail.com>
Subject: [PATCH net-next] net_sched: restore "mpu xxx" handling
Date:   Fri, 7 Jan 2022 22:22:50 +0200
Message-ID: <20220107202249.3812322-1-kevin@bracey.fi>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.59.142.96]
X-ClientProxiedBy: DAG10EX2.mxp1.local (172.16.2.20) To DAG4EX1.mxp1.local
 (172.16.2.7)
X-Ovh-Tracer-GUID: 5632b2d4-0807-4753-aad4-3aab8805911c
X-Ovh-Tracer-Id: 11615909339707576483
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvuddrudegvddgudduudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgggfgtihesthekredtredttdenucfhrhhomhepmfgvvhhinhcuuehrrggtvgihuceokhgvvhhinhessghrrggtvgihrdhfiheqnecuggftrfgrthhtvghrnhepueektdeiuefhueevheejudetleehudffheekffdtteegheefueeggfetudejgedunecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrdelieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepmhigphhlrghnuddrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehkvghvihhnsegsrhgrtggvhidrfhhipdhrtghpthhtohepkhgvvhhinhessghrrggtvgihrdhfih
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

