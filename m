Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22811E4FDA
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgE0VJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgE0VJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:09:39 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689EAC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:09:39 -0700 (PDT)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 04RKTZoK005754;
        Wed, 27 May 2020 21:30:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=jan2016.eng;
 bh=6c+i4kI1TjzvXbF6atuB8qx9iZWTBJ0JXpTjlL8tgms=;
 b=dVn/MFat6B4UjZULcvwQQWH2XMkX8XS6GaI6bpY0mxcC91g79UzXn/ehxf0fBKwVW5ry
 B9jIEdrLbB68BI/N4Dmmeo12v0wDNnEEY80+JikGHrdEbos33E+57RzvD1PBUU+kLWfp
 w9aZaIqdmtxH3Lna2SCGfXHCABRO/trD/KlF3sx58/kfxdiTPs5ssqJJEVDzRD8wuR/6
 NzgUAzMmmN0TWXlEL1A7Hr3podutR+x7lv5xWdYyiMymPVTFxZjXQv4VcOR/bjOrqzQ/
 wLRBXW0mOxH3eag7pD4R3x7J1qVCpG6CCpLyUceLbBckicCxCtmV3wTgVjva/aZtogUr gw== 
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 316v8gf0y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 May 2020 21:30:31 +0100
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
        by prod-mail-ppoint7.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 04RK2GGo008876;
        Wed, 27 May 2020 16:30:30 -0400
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint7.akamai.com with ESMTP id 319vrrh1h2-1;
        Wed, 27 May 2020 16:30:30 -0400
Received: from bos-lpjec.145bw.corp.akamai.com (bos-lpjec.145bw.corp.akamai.com [172.28.3.71])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id 191D96017F;
        Wed, 27 May 2020 20:30:30 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: [net-next 1/2] net: sched: cls-flower: include ports in 1rst fragment
Date:   Wed, 27 May 2020 16:25:29 -0400
Message-Id: <1590611130-19146-2-git-send-email-jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590611130-19146-1-git-send-email-jbaron@akamai.com>
References: <1590611130-19146-1-git-send-email-jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-27_03:2020-05-27,2020-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=998
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2004280000 definitions=main-2005270153
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-27_03:2020-05-27,2020-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 suspectscore=1
 malwarescore=0 clxscore=1015 impostorscore=0 phishscore=0 mlxlogscore=935
 mlxscore=0 lowpriorityscore=0 adultscore=0 cotscore=-2147483648
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005270157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cls-flower does not include the ports in the 1rst ipv4/6
fragments. Thus, if fragments are to be allowed, then port based
rules have no choice but to allow all fragments destined to all
ports. Let's include ports in the 1rst fragment. Thus, fragmented
packets can be allowed/blocked by adding a rule which
allows/blocks specific ports and allows all non-first ip fragments
(via setting ip_flags to frag/nofirstfrag).


Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 net/core/flow_dissector.c | 4 +++-
 net/sched/cls_flower.c    | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 0aeb335..bfd554e 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1446,7 +1446,9 @@ bool __skb_flow_dissect(const struct net *net,
 		break;
 	}
 
-	if (!(key_control->flags & FLOW_DIS_IS_FRAGMENT))
+	if (!(key_control->flags & FLOW_DIS_IS_FRAGMENT) ||
+	    ((key_control->flags & FLOW_DIS_FIRST_FRAG) &&
+	     (FLOW_DISSECTOR_F_PARSE_1ST_FRAG & flags)))
 		__skb_flow_dissect_ports(skb, flow_dissector, target_container,
 					 data, nhoff, ip_proto, hlen);
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 96f5999..e16227a 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -317,7 +317,8 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		skb_flow_dissect_ct(skb, &mask->dissector, &skb_key,
 				    fl_ct_info_to_flower_map,
 				    ARRAY_SIZE(fl_ct_info_to_flower_map));
-		skb_flow_dissect(skb, &mask->dissector, &skb_key, 0);
+		skb_flow_dissect(skb, &mask->dissector, &skb_key,
+				 FLOW_DISSECTOR_F_PARSE_1ST_FRAG);
 
 		fl_set_masked_key(&skb_mkey, &skb_key, mask);
 
-- 
2.7.4

