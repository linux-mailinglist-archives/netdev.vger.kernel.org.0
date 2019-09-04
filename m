Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25DC9A893E
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbfIDPHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:07:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729944AbfIDPHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 11:07:01 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x84EvE8K016255;
        Wed, 4 Sep 2019 11:06:56 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2utf321m9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 11:06:56 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x84EvVE6017580;
        Wed, 4 Sep 2019 11:06:56 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2utf321m9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 11:06:56 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x84F5J53009566;
        Wed, 4 Sep 2019 15:06:55 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 2uqgh6sn0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 15:06:55 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x84F6s1c34603346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Sep 2019 15:06:54 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68CF0BE053;
        Wed,  4 Sep 2019 15:06:54 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9883BE04F;
        Wed,  4 Sep 2019 15:06:53 +0000 (GMT)
Received: from oc5348122405.ibm.com.austin.ibm.com (unknown [9.53.179.215])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  4 Sep 2019 15:06:53 +0000 (GMT)
From:   David Dai <zdai@linux.vnet.ibm.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     zdai@us.ibm.com, zdai@linux.vnet.ibm.com
Subject: [v3] iproute2-next: police: support 64bit rate and peakrate in tc utility
Date:   Wed,  4 Sep 2019 10:06:51 -0500
Message-Id: <1567609611-27051-1-git-send-email-zdai@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-04_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1031 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909040147
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
v2->v3:
  - Use common functions of duparg and invarg in police filter.
---
 include/uapi/linux/pkt_cls.h |    2 +
 tc/m_police.c                |  149 +++++++++++++++++++-----------------------
 tc/tc_core.c                 |   29 ++++++++
 tc/tc_core.h                 |    3 +
 4 files changed, 102 insertions(+), 81 deletions(-)

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
index 862a39f..a5bc20c 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -49,11 +49,6 @@ static void usage(void)
 	exit(-1);
 }
 
-static void explain1(char *arg)
-{
-	fprintf(stderr, "Illegal \"%s\"\n", arg);
-}
-
 static int act_parse_police(struct action_util *a, int *argc_p, char ***argv_p,
 			    int tca_id, struct nlmsghdr *n)
 {
@@ -71,6 +66,7 @@ static int act_parse_police(struct action_util *a, int *argc_p, char ***argv_p,
 	unsigned int linklayer = LINKLAYER_ETHERNET; /* Assume ethernet */
 	int Rcell_log =  -1, Pcell_log = -1;
 	struct rtattr *tail;
+	__u64 rate64 = 0, prate64 = 0;
 
 	if (a) /* new way of doing things */
 		NEXT_ARG();
@@ -82,73 +78,47 @@ static int act_parse_police(struct action_util *a, int *argc_p, char ***argv_p,
 
 		if (matches(*argv, "index") == 0) {
 			NEXT_ARG();
-			if (get_u32(&p.index, *argv, 10)) {
-				fprintf(stderr, "Illegal \"index\"\n");
-				return -1;
-			}
+			if (get_u32(&p.index, *argv, 10))
+				invarg("index", *argv);
 		} else if (matches(*argv, "burst") == 0 ||
 			strcmp(*argv, "buffer") == 0 ||
 			strcmp(*argv, "maxburst") == 0) {
 			NEXT_ARG();
-			if (buffer) {
-				fprintf(stderr, "Double \"buffer/burst\" spec\n");
-				return -1;
-			}
-			if (get_size_and_cell(&buffer, &Rcell_log, *argv) < 0) {
-				explain1("buffer");
-				return -1;
-			}
+			if (buffer)
+				duparg("buffer/burst", *argv);
+			if (get_size_and_cell(&buffer, &Rcell_log, *argv) < 0)
+				invarg("buffer", *argv);
 		} else if (strcmp(*argv, "mtu") == 0 ||
 			   strcmp(*argv, "minburst") == 0) {
 			NEXT_ARG();
-			if (mtu) {
-				fprintf(stderr, "Double \"mtu/minburst\" spec\n");
-				return -1;
-			}
-			if (get_size_and_cell(&mtu, &Pcell_log, *argv) < 0) {
-				explain1("mtu");
-				return -1;
-			}
+			if (mtu)
+				duparg("mtu/minburst", *argv);
+			if (get_size_and_cell(&mtu, &Pcell_log, *argv) < 0)
+				invarg("mtu", *argv);
 		} else if (strcmp(*argv, "mpu") == 0) {
 			NEXT_ARG();
-			if (mpu) {
-				fprintf(stderr, "Double \"mpu\" spec\n");
-				return -1;
-			}
-			if (get_size(&mpu, *argv)) {
-				explain1("mpu");
-				return -1;
-			}
+			if (mpu)
+				duparg("mpu", *argv);
+			if (get_size(&mpu, *argv))
+				invarg("mpu", *argv);
 		} else if (strcmp(*argv, "rate") == 0) {
 			NEXT_ARG();
-			if (p.rate.rate) {
-				fprintf(stderr, "Double \"rate\" spec\n");
-				return -1;
-			}
-			if (get_rate(&p.rate.rate, *argv)) {
-				explain1("rate");
-				return -1;
-			}
+			if (rate64)
+				duparg("rate", *argv);
+			if (get_rate64(&rate64, *argv))
+				invarg("rate", *argv);
 		} else if (strcmp(*argv, "avrate") == 0) {
 			NEXT_ARG();
-			if (avrate) {
-				fprintf(stderr, "Double \"avrate\" spec\n");
-				return -1;
-			}
-			if (get_rate(&avrate, *argv)) {
-				explain1("avrate");
-				return -1;
-			}
+			if (avrate)
+				duparg("avrate", *argv);
+			if (get_rate(&avrate, *argv))
+				invarg("avrate", *argv);
 		} else if (matches(*argv, "peakrate") == 0) {
 			NEXT_ARG();
-			if (p.peakrate.rate) {
-				fprintf(stderr, "Double \"peakrate\" spec\n");
-				return -1;
-			}
-			if (get_rate(&p.peakrate.rate, *argv)) {
-				explain1("peakrate");
-				return -1;
-			}
+			if (prate64)
+				duparg("peakrate", *argv);
+			if (get_rate64(&prate64, *argv))
+				invarg("peakrate", *argv);
 		} else if (matches(*argv, "reclassify") == 0 ||
 			   matches(*argv, "drop") == 0 ||
 			   matches(*argv, "shot") == 0 ||
@@ -168,14 +138,12 @@ static int act_parse_police(struct action_util *a, int *argc_p, char ***argv_p,
 			return -1;
 		} else if (matches(*argv, "overhead") == 0) {
 			NEXT_ARG();
-			if (get_u16(&overhead, *argv, 10)) {
-				explain1("overhead"); return -1;
-			}
+			if (get_u16(&overhead, *argv, 10))
+				invarg("overhead", *argv);
 		} else if (matches(*argv, "linklayer") == 0) {
 			NEXT_ARG();
-			if (get_linklayer(&linklayer, *argv)) {
-				explain1("linklayer"); return -1;
-			}
+			if (get_linklayer(&linklayer, *argv))
+				invarg("linklayer", *argv);
 		} else if (strcmp(*argv, "help") == 0) {
 			usage();
 		} else {
@@ -189,23 +157,23 @@ action_ctrl_ok:
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
@@ -215,22 +183,24 @@ action_ctrl_ok:
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
@@ -238,10 +208,16 @@ action_ctrl_ok:
 
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
@@ -268,6 +244,7 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 	struct rtattr *tb[TCA_POLICE_MAX+1];
 	unsigned int buffer;
 	unsigned int linklayer;
+	__u64 rate64, prate64;
 
 	if (arg == NULL)
 		return 0;
@@ -286,16 +263,26 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
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

