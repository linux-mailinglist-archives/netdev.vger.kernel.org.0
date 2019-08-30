Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3853A3E22
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 21:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbfH3TH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 15:07:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60392 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727888AbfH3TH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 15:07:27 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7UIqP2n025859;
        Fri, 30 Aug 2019 15:07:22 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uq0tst9h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 15:07:22 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7UIqoe6027185;
        Fri, 30 Aug 2019 15:07:21 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uq0tst9gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 15:07:21 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7UJ1Tlh023243;
        Fri, 30 Aug 2019 19:07:21 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 2un65khbu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 19:07:21 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7UJ7KGb53870938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 19:07:20 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76340AC05B;
        Fri, 30 Aug 2019 19:07:20 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4C7FAC059;
        Fri, 30 Aug 2019 19:07:19 +0000 (GMT)
Received: from oc5348122405.ibm.com.austin.ibm.com (unknown [9.53.179.215])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 30 Aug 2019 19:07:19 +0000 (GMT)
From:   David Dai <zdai@linux.vnet.ibm.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     zdai@us.ibm.com, zdai@linux.vnet.ibm.com
Subject: [v2] iproute2-next: police: support 64bit rate and peakrate in tc utility
Date:   Fri, 30 Aug 2019 14:07:17 -0500
Message-Id: <1567192037-11684-1-git-send-email-zdai@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-30_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1031 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908300179
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For high speed adapter like Mellanox CX-5 card, it can reach upto
100 Gbits per second bandwidth. Currently htb already supports 64bit rate
in tc utility. However police action rate and peakrate are still limited
to 32bit value (upto 32 Gbits per second). Taking advantage of the 2 new
attributes TCA_POLICE_RATE64 and TCA_POLICE_PEAKRATE64 from kernel,
tc can use them to break the 32bit limit, and still keep the backward
binary compatibility.

Tested-by: David Dai <zdai@linux.vnet.ibm.com>
Signed-off-by: David Dai <zdai@linux.vnet.ibm.com>
---
Changelog:
v1->v2:
 - Change patch submit component from iproute2 to iproute2-next
 - Move 2 attributes TCA_POLICE_RATE64 TCA_POLICE_PEAKRATE64 after 
   TCA_POLICE_PAD in pkt_cls.h header to be consistent with kernel's 
   pkt_cls.h header.
---
 include/uapi/linux/pkt_cls.h |    2 +
 tc/m_police.c                |   64 +++++++++++++++++++++++++++--------------
 tc/tc_core.c                 |   29 +++++++++++++++++++
 tc/tc_core.h                 |    3 ++
 4 files changed, 76 insertions(+), 22 deletions(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index b057aee..a6aa466 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -160,6 +160,8 @@ enum {
 	TCA_POLICE_RESULT,
 	TCA_POLICE_TM,
 	TCA_POLICE_PAD,
+	TCA_POLICE_RATE64,
+	TCA_POLICE_PEAKRATE64,
 	__TCA_POLICE_MAX
 #define TCA_POLICE_RESULT TCA_POLICE_RESULT
 };
diff --git a/tc/m_police.c b/tc/m_police.c
index 862a39f..db913f4 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -71,6 +71,7 @@ static int act_parse_police(struct action_util *a, int *argc_p, char ***argv_p,
 	unsigned int linklayer = LINKLAYER_ETHERNET; /* Assume ethernet */
 	int Rcell_log =  -1, Pcell_log = -1;
 	struct rtattr *tail;
+	__u64 rate64 = 0, prate64 = 0;
 
 	if (a) /* new way of doing things */
 		NEXT_ARG();
@@ -121,11 +122,11 @@ static int act_parse_police(struct action_util *a, int *argc_p, char ***argv_p,
 			}
 		} else if (strcmp(*argv, "rate") == 0) {
 			NEXT_ARG();
-			if (p.rate.rate) {
+			if (rate64) {
 				fprintf(stderr, "Double \"rate\" spec\n");
 				return -1;
 			}
-			if (get_rate(&p.rate.rate, *argv)) {
+			if (get_rate64(&rate64, *argv)) {
 				explain1("rate");
 				return -1;
 			}
@@ -141,11 +142,11 @@ static int act_parse_police(struct action_util *a, int *argc_p, char ***argv_p,
 			}
 		} else if (matches(*argv, "peakrate") == 0) {
 			NEXT_ARG();
-			if (p.peakrate.rate) {
+			if (prate64) {
 				fprintf(stderr, "Double \"peakrate\" spec\n");
 				return -1;
 			}
-			if (get_rate(&p.peakrate.rate, *argv)) {
+			if (get_rate64(&prate64, *argv)) {
 				explain1("peakrate");
 				return -1;
 			}
@@ -189,23 +190,23 @@ action_ctrl_ok:
 	if (!ok)
 		return -1;
 
-	if (p.rate.rate && avrate)
+	if (rate64 && avrate)
 		return -1;
 
 	/* Must at least do late binding, use TB or ewma policing */
-	if (!p.rate.rate && !avrate && !p.index) {
+	if (!rate64 && !avrate && !p.index) {
 		fprintf(stderr, "\"rate\" or \"avrate\" MUST be specified.\n");
 		return -1;
 	}
 
 	/* When the TB policer is used, burst is required */
-	if (p.rate.rate && !buffer && !avrate) {
+	if (rate64 && !buffer && !avrate) {
 		fprintf(stderr, "\"burst\" requires \"rate\".\n");
 		return -1;
 	}
 
-	if (p.peakrate.rate) {
-		if (!p.rate.rate) {
+	if (prate64) {
+		if (!rate64) {
 			fprintf(stderr, "\"peakrate\" requires \"rate\".\n");
 			return -1;
 		}
@@ -215,22 +216,24 @@ action_ctrl_ok:
 		}
 	}
 
-	if (p.rate.rate) {
+	if (rate64) {
+		p.rate.rate = (rate64 >= (1ULL << 32)) ? ~0U : rate64;
 		p.rate.mpu = mpu;
 		p.rate.overhead = overhead;
-		if (tc_calc_rtable(&p.rate, rtab, Rcell_log, mtu,
-				   linklayer) < 0) {
+		if (tc_calc_rtable_64(&p.rate, rtab, Rcell_log, mtu,
+				   linklayer, rate64) < 0) {
 			fprintf(stderr, "POLICE: failed to calculate rate table.\n");
 			return -1;
 		}
-		p.burst = tc_calc_xmittime(p.rate.rate, buffer);
+		p.burst = tc_calc_xmittime(rate64, buffer);
 	}
 	p.mtu = mtu;
-	if (p.peakrate.rate) {
+	if (prate64) {
+		p.peakrate.rate = (prate64 >= (1ULL << 32)) ? ~0U : prate64;
 		p.peakrate.mpu = mpu;
 		p.peakrate.overhead = overhead;
-		if (tc_calc_rtable(&p.peakrate, ptab, Pcell_log, mtu,
-				   linklayer) < 0) {
+		if (tc_calc_rtable_64(&p.peakrate, ptab, Pcell_log, mtu,
+				   linklayer, prate64) < 0) {
 			fprintf(stderr, "POLICE: failed to calculate peak rate table.\n");
 			return -1;
 		}
@@ -238,10 +241,16 @@ action_ctrl_ok:
 
 	tail = addattr_nest(n, MAX_MSG, tca_id);
 	addattr_l(n, MAX_MSG, TCA_POLICE_TBF, &p, sizeof(p));
-	if (p.rate.rate)
+	if (rate64) {
 		addattr_l(n, MAX_MSG, TCA_POLICE_RATE, rtab, 1024);
-	if (p.peakrate.rate)
+		if (rate64 >= (1ULL << 32))
+			addattr64(n, MAX_MSG, TCA_POLICE_RATE64, rate64);
+	}
+	if (prate64) {
 		addattr_l(n, MAX_MSG, TCA_POLICE_PEAKRATE, ptab, 1024);
+		if (prate64 >= (1ULL << 32))
+			addattr64(n, MAX_MSG, TCA_POLICE_PEAKRATE64, prate64);
+	}
 	if (avrate)
 		addattr32(n, MAX_MSG, TCA_POLICE_AVRATE, avrate);
 	if (presult)
@@ -268,6 +277,7 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 	struct rtattr *tb[TCA_POLICE_MAX+1];
 	unsigned int buffer;
 	unsigned int linklayer;
+	__u64 rate64, prate64;
 
 	if (arg == NULL)
 		return 0;
@@ -286,16 +296,26 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 #endif
 	p = RTA_DATA(tb[TCA_POLICE_TBF]);
 
+	rate64 = p->rate.rate;
+	if (tb[TCA_POLICE_RATE64] &&
+	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
+		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
+
 	fprintf(f, " police 0x%x ", p->index);
-	fprintf(f, "rate %s ", sprint_rate(p->rate.rate, b1));
-	buffer = tc_calc_xmitsize(p->rate.rate, p->burst);
+	fprintf(f, "rate %s ", sprint_rate(rate64, b1));
+	buffer = tc_calc_xmitsize(rate64, p->burst);
 	fprintf(f, "burst %s ", sprint_size(buffer, b1));
 	fprintf(f, "mtu %s ", sprint_size(p->mtu, b1));
 	if (show_raw)
 		fprintf(f, "[%08x] ", p->burst);
 
-	if (p->peakrate.rate)
-		fprintf(f, "peakrate %s ", sprint_rate(p->peakrate.rate, b1));
+	prate64 = p->peakrate.rate;
+	if (tb[TCA_POLICE_PEAKRATE64] &&
+	    RTA_PAYLOAD(tb[TCA_POLICE_PEAKRATE64]) >= sizeof(prate64))
+		prate64 = rta_getattr_u64(tb[TCA_POLICE_PEAKRATE64]);
+
+	if (prate64)
+		fprintf(f, "peakrate %s ", sprint_rate(prate64, b1));
 
 	if (tb[TCA_POLICE_AVRATE])
 		fprintf(f, "avrate %s ",
diff --git a/tc/tc_core.c b/tc/tc_core.c
index 8eb1122..498d35d 100644
--- a/tc/tc_core.c
+++ b/tc/tc_core.c
@@ -152,6 +152,35 @@ int tc_calc_rtable(struct tc_ratespec *r, __u32 *rtab,
 	return cell_log;
 }
 
+int tc_calc_rtable_64(struct tc_ratespec *r, __u32 *rtab,
+		   int cell_log, unsigned int mtu,
+		   enum link_layer linklayer, __u64 rate)
+{
+	int i;
+	unsigned int sz;
+	__u64 bps = rate;
+	unsigned int mpu = r->mpu;
+
+	if (mtu == 0)
+		mtu = 2047;
+
+	if (cell_log < 0) {
+		cell_log = 0;
+		while ((mtu >> cell_log) > 255)
+			cell_log++;
+	}
+
+	for (i = 0; i < 256; i++) {
+		sz = tc_adjust_size((i + 1) << cell_log, mpu, linklayer);
+		rtab[i] = tc_calc_xmittime(bps, sz);
+	}
+
+	r->cell_align =  -1;
+	r->cell_log = cell_log;
+	r->linklayer = (linklayer & TC_LINKLAYER_MASK);
+	return cell_log;
+}
+
 /*
    stab[pkt_len>>cell_log] = pkt_xmit_size>>size_log
  */
diff --git a/tc/tc_core.h b/tc/tc_core.h
index bd4a99f..6dab272 100644
--- a/tc/tc_core.h
+++ b/tc/tc_core.h
@@ -21,6 +21,9 @@ unsigned tc_calc_xmittime(__u64 rate, unsigned size);
 unsigned tc_calc_xmitsize(__u64 rate, unsigned ticks);
 int tc_calc_rtable(struct tc_ratespec *r, __u32 *rtab,
 		   int cell_log, unsigned mtu, enum link_layer link_layer);
+int tc_calc_rtable_64(struct tc_ratespec *r, __u32 *rtab,
+			int cell_log, unsigned mtu, enum link_layer link_layer,
+			__u64 rate);
 int tc_calc_size_table(struct tc_sizespec *s, __u16 **stab);
 
 int tc_setup_estimator(unsigned A, unsigned time_const, struct tc_estimator *est);
-- 
1.7.1

