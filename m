Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A77A2D2A3
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfE2AAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:00:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42418 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727254AbfE2AAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 20:00:03 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SNxpiY020191
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 17:00:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=m9ZPkoR8litv3qg3yIi9+Ukm2kNHPwe9hc1Qm7GRjyk=;
 b=HdZwG8jmwewAgoTaCaYkcAx6TsLRkLWA/N5wTmP7kugXWo2A4fGpm7a3zk8COQrh8yMA
 I5MtJZOnsBfJgspKCYjUwZUK/HHDNbHhHeKPxld+Xc8sAv8Zjji1/ptaKZ1wJk28IB14
 +h1NrQ28yokrUFJbOGojzoUhF3NHIpdqJ2g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ss9pn9756-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 17:00:02 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 May 2019 16:59:59 -0700
Received: by devbig009.ftw2.facebook.com (Postfix, from userid 10340)
        id ECF5B5AE2482; Tue, 28 May 2019 16:59:57 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   brakmo <brakmo@fb.com>
Smtp-Origin-Hostname: devbig009.ftw2.facebook.com
To:     netdev <netdev@vger.kernel.org>
CC:     Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 6/6] bpf: Add more stats to HBM
Date:   Tue, 28 May 2019 16:59:40 -0700
Message-ID: <20190528235940.1452963-7-brakmo@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528235940.1452963-1-brakmo@fb.com>
References: <20190528235940.1452963-1-brakmo@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds more stats to HBM, including average cwnd and rtt of all TCP
flows, percents of packets that are ecn ce marked and distribution
of return values.

Signed-off-by: Lawrence Brakmo <brakmo@fb.com>
---
 samples/bpf/hbm.c          | 33 +++++++++++++++++++
 samples/bpf/hbm.h          |  6 ++++
 samples/bpf/hbm_kern.h     | 66 ++++++++++++++++++++++++++++++++++++--
 samples/bpf/hbm_out_kern.c | 22 ++++++++-----
 4 files changed, 117 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index c5629bae67ab..480b7ad6a1f2 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -316,6 +316,14 @@ static int run_bpf_prog(char *prog, int cg_id)
 		double percent_pkts, percent_bytes;
 		char fname[100];
 		FILE *fout;
+		int k;
+		static const char *returnValNames[] = {
+			"DROP_PKT",
+			"ALLOW_PKT",
+			"DROP_PKT_CWR",
+			"ALLOW_PKT_CWR"
+		};
+#define RET_VAL_COUNT 4
 
 // Future support of ingress
 //		if (!outFlag)
@@ -350,6 +358,31 @@ static int run_bpf_prog(char *prog, int cg_id)
 			(qstats.bytes_total + 1);
 		fprintf(fout, "pkts_dropped_percent:%6.2f\n", percent_pkts);
 		fprintf(fout, "bytes_dropped_percent:%6.2f\n", percent_bytes);
+
+		// ECN CE markings
+		percent_pkts = (qstats.pkts_ecn_ce * 100.0) /
+			(qstats.pkts_total + 1);
+		fprintf(fout, "pkts_ecn_ce:%6.2f (%d)\n", percent_pkts,
+			(int)qstats.pkts_ecn_ce);
+
+		// Average cwnd
+		fprintf(fout, "avg cwnd:%d\n",
+			(int)(qstats.sum_cwnd / (qstats.sum_cwnd_cnt + 1)));
+		// Average rtt
+		fprintf(fout, "avg rtt:%d\n",
+			(int)(qstats.sum_rtt / (qstats.pkts_total + 1)));
+		// Average credit
+		fprintf(fout, "avg credit:%d\n",
+			(int)(qstats.sum_credit /
+			      (1500 * ((int)qstats.pkts_total) + 1)));
+
+		// Return values stats
+		for (k = 0; k < RET_VAL_COUNT; k++) {
+			percent_pkts = (qstats.returnValCount[k] * 100.0) /
+				(qstats.pkts_total + 1);
+			fprintf(fout, "%s:%6.2f (%d)\n", returnValNames[k],
+				percent_pkts, (int)qstats.returnValCount[k]);
+		}
 		fclose(fout);
 	}
 
diff --git a/samples/bpf/hbm.h b/samples/bpf/hbm.h
index c08247cec2a7..f0963ed6a562 100644
--- a/samples/bpf/hbm.h
+++ b/samples/bpf/hbm.h
@@ -29,4 +29,10 @@ struct hbm_queue_stats {
 	unsigned long long bytes_total;
 	unsigned long long firstPacketTime;
 	unsigned long long lastPacketTime;
+	unsigned long long pkts_ecn_ce;
+	unsigned long long returnValCount[4];
+	unsigned long long sum_cwnd;
+	unsigned long long sum_rtt;
+	unsigned long long sum_cwnd_cnt;
+	long long sum_credit;
 };
diff --git a/samples/bpf/hbm_kern.h b/samples/bpf/hbm_kern.h
index 41384be233b9..be19cf1d5cd5 100644
--- a/samples/bpf/hbm_kern.h
+++ b/samples/bpf/hbm_kern.h
@@ -65,17 +65,43 @@ struct bpf_map_def SEC("maps") queue_stats = {
 BPF_ANNOTATE_KV_PAIR(queue_stats, int, struct hbm_queue_stats);
 
 struct hbm_pkt_info {
+	int	cwnd;
+	int	rtt;
 	bool	is_ip;
 	bool	is_tcp;
 	short	ecn;
 };
 
+static int get_tcp_info(struct __sk_buff *skb, struct hbm_pkt_info *pkti)
+{
+	struct bpf_sock *sk;
+	struct bpf_tcp_sock *tp;
+
+	sk = skb->sk;
+	if (sk) {
+		sk = bpf_sk_fullsock(sk);
+		if (sk) {
+			if (sk->protocol == IPPROTO_TCP) {
+				tp = bpf_tcp_sock(sk);
+				if (tp) {
+					pkti->cwnd = tp->snd_cwnd;
+					pkti->rtt = tp->srtt_us >> 3;
+					return 0;
+				}
+			}
+		}
+	}
+	return 1;
+}
+
 static __always_inline void hbm_get_pkt_info(struct __sk_buff *skb,
 					     struct hbm_pkt_info *pkti)
 {
 	struct iphdr iph;
 	struct ipv6hdr *ip6h;
 
+	pkti->cwnd = 0;
+	pkti->rtt = 0;
 	bpf_skb_load_bytes(skb, 0, &iph, 12);
 	if (iph.version == 6) {
 		ip6h = (struct ipv6hdr *)&iph;
@@ -91,6 +117,8 @@ static __always_inline void hbm_get_pkt_info(struct __sk_buff *skb,
 		pkti->is_tcp = false;
 		pkti->ecn = 0;
 	}
+	if (pkti->is_tcp)
+		get_tcp_info(skb, pkti);
 }
 
 static __always_inline void hbm_init_vqueue(struct hbm_vqueue *qdp, int rate)
@@ -105,8 +133,14 @@ static __always_inline void hbm_update_stats(struct hbm_queue_stats *qsp,
 					     int len,
 					     unsigned long long curtime,
 					     bool congestion_flag,
-					     bool drop_flag)
+					     bool drop_flag,
+					     bool cwr_flag,
+					     bool ecn_ce_flag,
+					     struct hbm_pkt_info *pkti,
+					     int credit)
 {
+	int rv = ALLOW_PKT;
+
 	if (qsp != NULL) {
 		// Following is needed for work conserving
 		__sync_add_and_fetch(&(qsp->bytes_total), len);
@@ -116,7 +150,7 @@ static __always_inline void hbm_update_stats(struct hbm_queue_stats *qsp,
 				qsp->firstPacketTime = curtime;
 			qsp->lastPacketTime = curtime;
 			__sync_add_and_fetch(&(qsp->pkts_total), 1);
-			if (congestion_flag || drop_flag) {
+			if (congestion_flag) {
 				__sync_add_and_fetch(&(qsp->pkts_marked), 1);
 				__sync_add_and_fetch(&(qsp->bytes_marked), len);
 			}
@@ -125,6 +159,34 @@ static __always_inline void hbm_update_stats(struct hbm_queue_stats *qsp,
 				__sync_add_and_fetch(&(qsp->bytes_dropped),
 						     len);
 			}
+			if (ecn_ce_flag)
+				__sync_add_and_fetch(&(qsp->pkts_ecn_ce), 1);
+			if (pkti->cwnd) {
+				__sync_add_and_fetch(&(qsp->sum_cwnd),
+						     pkti->cwnd);
+				__sync_add_and_fetch(&(qsp->sum_cwnd_cnt), 1);
+			}
+			if (pkti->rtt)
+				__sync_add_and_fetch(&(qsp->sum_rtt),
+						     pkti->rtt);
+			__sync_add_and_fetch(&(qsp->sum_credit), credit);
+
+			if (drop_flag)
+				rv = DROP_PKT;
+			if (cwr_flag)
+				rv |= 2;
+			if (rv == DROP_PKT)
+				__sync_add_and_fetch(&(qsp->returnValCount[0]),
+						     1);
+			else if (rv == ALLOW_PKT)
+				__sync_add_and_fetch(&(qsp->returnValCount[1]),
+						     1);
+			else if (rv == 2)
+				__sync_add_and_fetch(&(qsp->returnValCount[2]),
+						     1);
+			else if (rv == 3)
+				__sync_add_and_fetch(&(qsp->returnValCount[3]),
+						     1);
 		}
 	}
 }
diff --git a/samples/bpf/hbm_out_kern.c b/samples/bpf/hbm_out_kern.c
index fa3ea92e1564..829934bd43cb 100644
--- a/samples/bpf/hbm_out_kern.c
+++ b/samples/bpf/hbm_out_kern.c
@@ -62,11 +62,12 @@ int _hbm_out_cg(struct __sk_buff *skb)
 	unsigned int queue_index = 0;
 	unsigned long long curtime;
 	int credit;
-	signed long long delta = 0, zero = 0;
+	signed long long delta = 0, new_credit;
 	int max_credit = MAX_CREDIT;
 	bool congestion_flag = false;
 	bool drop_flag = false;
 	bool cwr_flag = false;
+	bool ecn_ce_flag = false;
 	struct hbm_vqueue *qdp;
 	struct hbm_queue_stats *qsp = NULL;
 	int rv = ALLOW_PKT;
@@ -99,9 +100,11 @@ int _hbm_out_cg(struct __sk_buff *skb)
 	 */
 	if (delta > 0) {
 		qdp->lasttime = curtime;
-		credit += CREDIT_PER_NS(delta, qdp->rate);
-		if (credit > MAX_CREDIT)
+		new_credit = credit + CREDIT_PER_NS(delta, qdp->rate);
+		if (new_credit > MAX_CREDIT)
 			credit = MAX_CREDIT;
+		else
+			credit = new_credit;
 	}
 	credit -= len;
 	qdp->credit = credit;
@@ -139,7 +142,9 @@ int _hbm_out_cg(struct __sk_buff *skb)
 	}
 
 	if (congestion_flag) {
-		if (!bpf_skb_ecn_set_ce(skb)) {
+		if (bpf_skb_ecn_set_ce(skb)) {
+			ecn_ce_flag = true;
+		} else {
 			if (pkti.is_tcp) {
 				unsigned int rand = bpf_get_prandom_u32();
 
@@ -155,16 +160,17 @@ int _hbm_out_cg(struct __sk_buff *skb)
 		}
 	}
 
-	if (drop_flag)
-		rv = DROP_PKT;
 	if (qsp != NULL)
 		if (qsp->no_cn)
 			cwr_flag = false;
 
-	hbm_update_stats(qsp, len, curtime, congestion_flag, drop_flag);
+	hbm_update_stats(qsp, len, curtime, congestion_flag, drop_flag,
+			 cwr_flag, ecn_ce_flag, &pkti, credit);
 
-	if (rv == DROP_PKT)
+	if (drop_flag) {
 		__sync_add_and_fetch(&(qdp->credit), len);
+		rv = DROP_PKT;
+	}
 
 	if (cwr_flag)
 		rv |= 2;
-- 
2.17.1

