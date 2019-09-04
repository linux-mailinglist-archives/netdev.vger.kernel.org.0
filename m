Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50049A892D
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731192AbfIDPEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:04:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730604AbfIDPEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 11:04:04 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x84Ev7JB059495;
        Wed, 4 Sep 2019 11:03:50 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2utdmwwb89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 11:03:50 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x84EwGKg064747;
        Wed, 4 Sep 2019 11:03:50 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2utdmwwb7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 11:03:50 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x84Exfgd030870;
        Wed, 4 Sep 2019 15:03:49 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma05wdc.us.ibm.com with ESMTP id 2usa0mbcku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 15:03:49 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x84F3nCV13435646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Sep 2019 15:03:49 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBCD2112062;
        Wed,  4 Sep 2019 15:03:48 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB9AF112061;
        Wed,  4 Sep 2019 15:03:47 +0000 (GMT)
Received: from oc5348122405.ibm.com.austin.ibm.com (unknown [9.53.179.215])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  4 Sep 2019 15:03:47 +0000 (GMT)
From:   David Dai <zdai@linux.vnet.ibm.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zdai@us.ibm.com, zdai@linux.vnet.ibm.com
Subject: [v3] net_sched: act_police: add 2 new attributes to support police 64bit rate and peakrate
Date:   Wed,  4 Sep 2019 10:03:43 -0500
Message-Id: <1567609423-26826-1-git-send-email-zdai@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-04_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909040147
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
v2->v3:
 - Use TCA_POLICE_PAD instead of __TCA_POLICE_MAX as padding attr
   in last parameter in nla_put_u64_64bit() routine.
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
+				      TCA_POLICE_PAD))
+			goto nla_put_failure;
+	}
+	if (p->peak_present) {
 		psched_ratecfg_getrate(&opt.peakrate, &p->peak);
+		if ((police->params->peak.rate_bytes_ps >= (1ULL << 32)) &&
+		    nla_put_u64_64bit(skb, TCA_POLICE_PEAKRATE64,
+				      police->params->peak.rate_bytes_ps,
+				      TCA_POLICE_PAD))
+			goto nla_put_failure;
+	}
 	if (nla_put(skb, TCA_POLICE_TBF, sizeof(opt), &opt))
 		goto nla_put_failure;
 	if (p->tcfp_result &&
-- 
1.7.1

