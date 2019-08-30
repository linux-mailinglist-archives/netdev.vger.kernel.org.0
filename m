Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A278A3E1F
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 21:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfH3TG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 15:06:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13086 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727891AbfH3TG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 15:06:28 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7UIqHkd073023;
        Fri, 30 Aug 2019 15:06:24 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uq77fcngv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 15:06:24 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7UIqItb073513;
        Fri, 30 Aug 2019 15:06:24 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uq77fcngb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 15:06:24 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7UJ5QXg027763;
        Fri, 30 Aug 2019 19:06:22 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 2un65khbm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 19:06:22 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7UJ6G8p53281270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 19:06:16 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87F8AAE05F;
        Fri, 30 Aug 2019 19:06:16 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4C61AE060;
        Fri, 30 Aug 2019 19:06:15 +0000 (GMT)
Received: from oc5348122405.ibm.com.austin.ibm.com (unknown [9.53.179.215])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 30 Aug 2019 19:06:15 +0000 (GMT)
From:   David Dai <zdai@linux.vnet.ibm.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zdai@us.ibm.com, zdai@linux.vnet.ibm.com
Subject: [v2] net_sched: act_police: add 2 new attributes to support police 64bit rate and peakrate
Date:   Fri, 30 Aug 2019 14:06:14 -0500
Message-Id: <1567191974-11578-1-git-send-email-zdai@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-30_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908300179
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For high speed adapter like Mellanox CX-5 card, it can reach upto
100 Gbits per second bandwidth. Currently htb already supports 64bit rate
in tc utility. However police action rate and peakrate are still limited
to 32bit value (upto 32 Gbits per second). Add 2 new attributes
TCA_POLICE_RATE64 and TCA_POLICE_RATE64 in kernel for 64bit support
so that tc utility can use them for 64bit rate and peakrate value to
break the 32bit limit, and still keep the backward binary compatibility.

Tested-by: David Dai <zdai@linux.vnet.ibm.com>
Signed-off-by: David Dai <zdai@linux.vnet.ibm.com>
---
Changelog:
v1->v2:
 - Move 2 attributes TCA_POLICE_RATE64 TCA_POLICE_PEAKRATE64 after
   TCA_POLICE_PAD in pkt_cls.h header.
---
 include/uapi/linux/pkt_cls.h |    2 ++
 net/sched/act_police.c       |   27 +++++++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

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
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 49cec3e..425f2a3 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -40,6 +40,8 @@ static int tcf_police_walker(struct net *net, struct sk_buff *skb,
 	[TCA_POLICE_PEAKRATE]	= { .len = TC_RTAB_SIZE },
 	[TCA_POLICE_AVRATE]	= { .type = NLA_U32 },
 	[TCA_POLICE_RESULT]	= { .type = NLA_U32 },
+	[TCA_POLICE_RATE64]     = { .type = NLA_U64 },
+	[TCA_POLICE_PEAKRATE64] = { .type = NLA_U64 },
 };
 
 static int tcf_police_init(struct net *net, struct nlattr *nla,
@@ -58,6 +60,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 	struct tcf_police_params *new;
 	bool exists = false;
 	u32 index;
+	u64 rate64, prate64;
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -155,14 +158,18 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 	}
 	if (R_tab) {
 		new->rate_present = true;
-		psched_ratecfg_precompute(&new->rate, &R_tab->rate, 0);
+		rate64 = tb[TCA_POLICE_RATE64] ?
+			 nla_get_u64(tb[TCA_POLICE_RATE64]) : 0;
+		psched_ratecfg_precompute(&new->rate, &R_tab->rate, rate64);
 		qdisc_put_rtab(R_tab);
 	} else {
 		new->rate_present = false;
 	}
 	if (P_tab) {
 		new->peak_present = true;
-		psched_ratecfg_precompute(&new->peak, &P_tab->rate, 0);
+		prate64 = tb[TCA_POLICE_PEAKRATE64] ?
+			  nla_get_u64(tb[TCA_POLICE_PEAKRATE64]) : 0;
+		psched_ratecfg_precompute(&new->peak, &P_tab->rate, prate64);
 		qdisc_put_rtab(P_tab);
 	} else {
 		new->peak_present = false;
@@ -313,10 +320,22 @@ static int tcf_police_dump(struct sk_buff *skb, struct tc_action *a,
 				      lockdep_is_held(&police->tcf_lock));
 	opt.mtu = p->tcfp_mtu;
 	opt.burst = PSCHED_NS2TICKS(p->tcfp_burst);
-	if (p->rate_present)
+	if (p->rate_present) {
 		psched_ratecfg_getrate(&opt.rate, &p->rate);
-	if (p->peak_present)
+		if ((police->params->rate.rate_bytes_ps >= (1ULL << 32)) &&
+		    nla_put_u64_64bit(skb, TCA_POLICE_RATE64,
+				      police->params->rate.rate_bytes_ps,
+				      __TCA_POLICE_MAX))
+			goto nla_put_failure;
+	}
+	if (p->peak_present) {
 		psched_ratecfg_getrate(&opt.peakrate, &p->peak);
+		if ((police->params->peak.rate_bytes_ps >= (1ULL << 32)) &&
+		    nla_put_u64_64bit(skb, TCA_POLICE_PEAKRATE64,
+				      police->params->peak.rate_bytes_ps,
+				      __TCA_POLICE_MAX))
+			goto nla_put_failure;
+	}
 	if (nla_put(skb, TCA_POLICE_TBF, sizeof(opt), &opt))
 		goto nla_put_failure;
 	if (p->tcfp_result &&
-- 
1.7.1

