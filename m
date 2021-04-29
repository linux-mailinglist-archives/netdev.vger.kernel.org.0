Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A5136EE1F
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 18:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbhD2QaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 12:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbhD2QaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 12:30:20 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4565FC06138B;
        Thu, 29 Apr 2021 09:29:31 -0700 (PDT)
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13TGJgPG010488;
        Thu, 29 Apr 2021 17:29:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=q1qlMUPUsRC6h1GU/B7aEimtmIRSDfg00PYdYuWupl0=;
 b=T5MVIIuLx8mWbQf7intABVl3jZpmlWIDDvV2vkap2UZ4d24aLSqjemT7i8je5d4dWNa8
 MI/4GHPNcay0Qb/9GSLH/kT1e+S9RFCocZRjCBGXnj374p/aIfcA0QWrpjn68WA1iv2y
 x8rZ2cvDyZ0JPIUlCBpBHoU+QoAb8RY9ci3PIrnJeTH+n3KTH6or4RIC9OHfAv+oqLbO
 pPAAxz7usddP99Ohd0NFvbEu0BR3SirEW7UJgZxc6C63a2cSnrkuccQTpVBuot1A9q8I
 h5NPpSfGZHHFXyNWa3Py1CgXjBXn1l2PJuxmvmT6xvJBHWGHM6FM3b1yGiVJXuLcUd12 Zg== 
Received: from prod-mail-ppoint3 (a72-247-45-31.deploy.static.akamaitechnologies.com [72.247.45.31] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 387r9gf070-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Apr 2021 17:29:19 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.1.2/8.16.1.2) with SMTP id 13TGKHkG025364;
        Thu, 29 Apr 2021 12:29:07 -0400
Received: from prod-mail-relay18.dfw02.corp.akamai.com ([172.27.165.172])
        by prod-mail-ppoint3.akamai.com with ESMTP id 3877g6a8e6-1;
        Thu, 29 Apr 2021 12:29:07 -0400
Received: from bos-lpjec.145bw.corp.akamai.com (unknown [172.28.3.71])
        by prod-mail-relay18.dfw02.corp.akamai.com (Postfix) with ESMTP id 98E92494;
        Thu, 29 Apr 2021 16:29:06 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] netfilter: x_tables: improve limit_mt scalability
Date:   Thu, 29 Apr 2021 12:26:13 -0400
Message-Id: <1619713573-32073-1-git-send-email-jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-29_08:2021-04-28,2021-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104290102
X-Proofpoint-ORIG-GUID: b47GY1V4ZYRDkep61DicW24inoLgTuTO
X-Proofpoint-GUID: b47GY1V4ZYRDkep61DicW24inoLgTuTO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-29_08:2021-04-28,2021-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 spamscore=0 clxscore=1011 mlxscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290102
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.31)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We've seen this spin_lock show up high in profiles. Let's introduce a
lockless version. I've tested this using pktgen_sample01_simple.sh.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 net/netfilter/xt_limit.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 24d4afb9988d..8b4fd27857f2 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -8,16 +8,14 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
-#include <linux/spinlock.h>
 #include <linux/interrupt.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_limit.h>
 
 struct xt_limit_priv {
-	spinlock_t lock;
 	unsigned long prev;
-	uint32_t credit;
+	u32 credit;
 };
 
 MODULE_LICENSE("GPL");
@@ -66,22 +64,31 @@ limit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rateinfo *r = par->matchinfo;
 	struct xt_limit_priv *priv = r->master;
-	unsigned long now = jiffies;
-
-	spin_lock_bh(&priv->lock);
-	priv->credit += (now - xchg(&priv->prev, now)) * CREDITS_PER_JIFFY;
-	if (priv->credit > r->credit_cap)
-		priv->credit = r->credit_cap;
-
-	if (priv->credit >= r->cost) {
-		/* We're not limited. */
-		priv->credit -= r->cost;
-		spin_unlock_bh(&priv->lock);
-		return true;
-	}
-
-	spin_unlock_bh(&priv->lock);
-	return false;
+	unsigned long now;
+	u32 old_credit, new_credit, credit_increase = 0;
+	bool ret;
+
+	/* fastpath if there is nothing to update */
+	if ((READ_ONCE(priv->credit) < r->cost) && (READ_ONCE(priv->prev) == jiffies))
+		return false;
+
+	do {
+		now = jiffies;
+		credit_increase += (now - xchg(&priv->prev, now)) * CREDITS_PER_JIFFY;
+		old_credit = READ_ONCE(priv->credit);
+		new_credit = old_credit;
+		new_credit += credit_increase;
+		if (new_credit > r->credit_cap)
+			new_credit = r->credit_cap;
+		if (new_credit >= r->cost) {
+			ret = true;
+			new_credit -= r->cost;
+		} else {
+			ret = false;
+		}
+	} while (cmpxchg(&priv->credit, old_credit, new_credit) != old_credit);
+
+	return ret;
 }
 
 /* Precision saver. */
@@ -122,7 +129,6 @@ static int limit_mt_check(const struct xt_mtchk_param *par)
 		r->credit_cap = priv->credit; /* Credits full. */
 		r->cost = user2credits(r->avg);
 	}
-	spin_lock_init(&priv->lock);
 
 	return 0;
 }
-- 
2.7.4

