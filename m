Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3340815CC67
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 21:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgBMUbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 15:31:50 -0500
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:53372 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726968AbgBMUbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 15:31:50 -0500
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01DKHSCt030561;
        Thu, 13 Feb 2020 20:31:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=OEX4zwbqE3xoQAhkgvhyXtPR6N85NAb64kKQkSRBvj4=;
 b=ehaYrr0D5U3hwWbJEXyf12HOR8r72ZFL7xihCsx4qaG1QMUgipoHarNa35nCxRxqjiSu
 ltkHsc2Zhl8XhFTBuAMc2Ngh4O6HXWM0AmZUjLOHFAPCI+H8dVASQmwdO1YJ1EpAkn20
 iQYAgdxSJ5+rcv6wJOMs0JfsqzRM9YL6EvMN2/ma86c+Ub5kEeQHAHqE1ZDUA8rQN/bx
 O3WZEpvJWbnwYIGpyUzMU2zMDEXAuduI2dxI2BBTt/kO6Y+QKKf/zBAP88MX6TmNRH8S
 MoxI/4464le1TkUYbj4PhuJeKi2TJaonsewHy8X3BC+wVaBwcQAOgsL/0duvl0ZOfCIi Lw== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2y457y8p5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Feb 2020 20:31:43 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 01DKIVBe005532;
        Thu, 13 Feb 2020 15:31:42 -0500
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2y5bd68cuw-1;
        Thu, 13 Feb 2020 15:31:42 -0500
Received: from bos-lpjec.145bw.corp.akamai.com (bos-lpjec.145bw.corp.akamai.com [172.28.3.71])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 1E3C621A55;
        Thu, 13 Feb 2020 20:31:42 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com
Cc:     netdev@vger.kernel.org, soukjin.bae@samsung.com,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] net: sched: correct flower port blocking
Date:   Thu, 13 Feb 2020 15:28:19 -0500
Message-Id: <1581625699-24457-1-git-send-email-jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-02-13_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002050000 definitions=main-2002130143
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-13_08:2020-02-12,2020-02-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 phishscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tc flower rules that are based on src or dst port blocking are sometimes
ineffective due to uninitialized stack data. __skb_flow_dissect() extracts
ports from the skb for tc flower to match against. However, the port
dissection is not done when when the FLOW_DIS_IS_FRAGMENT bit is set in
key_control->flags. All callers of __skb_flow_dissect(), zero-out the
key_control field except for fl_classify() as used by the flower
classifier. Thus, the FLOW_DIS_IS_FRAGMENT may be set on entry to
__skb_flow_dissect(), since key_control is allocated on the stack
and may not be initialized.

Since key_basic and key_control are present for all flow keys, let's
make sure they are initialized.

Fixes: 62230715fd24 ("flow_dissector: do not dissect l4 ports for fragments")
Co-developed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 include/linux/skbuff.h | 8 ++++++++
 net/sched/cls_flower.c | 1 +
 2 files changed, 9 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ca8806b..f953bfa 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1288,6 +1288,14 @@ bool __skb_flow_dissect(const struct net *net,
 			void *data, __be16 proto, int nhoff, int hlen,
 			unsigned int flags);
 
+static inline void
+skb_flow_dissect_init_key(struct flow_dissector_key_control *key_control,
+			  struct flow_dissector_key_basic *key_basic)
+{
+	memset(key_control, 0, sizeof(*key_control));
+	memset(key_basic, 0, sizeof(*key_basic));
+}
+
 static inline bool skb_flow_dissect(const struct sk_buff *skb,
 				    struct flow_dissector *flow_dissector,
 				    void *target_container, unsigned int flags)
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f9c0d1e..b0a534b 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -305,6 +305,7 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 	struct cls_fl_filter *f;
 
 	list_for_each_entry_rcu(mask, &head->masks, list) {
+		skb_flow_dissect_init_key(&skb_key.control, &skb_key.basic);
 		fl_clear_masked_range(&skb_key, mask);
 
 		skb_flow_dissect_meta(skb, &mask->dissector, &skb_key);
-- 
2.7.4

