Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA84A0DC4
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 00:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfH1Wvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 18:51:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5870 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726828AbfH1Wvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 18:51:38 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7SMlXMX108629;
        Wed, 28 Aug 2019 18:51:34 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2up1m3hwb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Aug 2019 18:51:33 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7SMn8s5112837;
        Wed, 28 Aug 2019 18:51:33 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2up1m3hwap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Aug 2019 18:51:33 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7SMj48P018800;
        Wed, 28 Aug 2019 22:51:32 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 2ujvv78pdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Aug 2019 22:51:32 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7SMpVPD49021352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:51:31 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DFEEC6070;
        Wed, 28 Aug 2019 22:51:31 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 735CBC6062;
        Wed, 28 Aug 2019 22:51:30 +0000 (GMT)
Received: from oc5348122405.ibm.com.austin.ibm.com (unknown [9.53.179.215])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 28 Aug 2019 22:51:30 +0000 (GMT)
From:   David Dai <zdai@linux.vnet.ibm.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zdai@us.ibm.com, zdai@linux.vnet.ibm.com
Subject: [v1] net_sched: act_police: add 2 new attributes to support police 64bit rate and peakrate
Date:   Wed, 28 Aug 2019 17:51:27 -0500
Message-Id: <1567032687-973-1-git-send-email-zdai@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-28_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908280218
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
 include/uapi/linux/pkt_cls.h |    2 ++
 net/sched/act_police.c       |   27 +++++++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index b057aee..eb4ea4d 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -159,6 +159,8 @@ enum {
 	TCA_POLICE_AVRATE,
 	TCA_POLICE_RESULT,
 	TCA_POLICE_TM,
+	TCA_POLICE_RATE64,
+	TCA_POLICE_PEAKRATE64,
 	TCA_POLICE_PAD,
 	__TCA_POLICE_MAX
 #define TCA_POLICE_RESULT TCA_POLICE_RESULT
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 49cec3e..ed5372e 100644
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

