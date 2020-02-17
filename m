Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D343B161C63
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 21:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgBQUlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 15:41:00 -0500
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:56110 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727332AbgBQUk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 15:40:59 -0500
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HKWGuW027247;
        Mon, 17 Feb 2020 20:40:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to; s=jan2016.eng;
 bh=8XJ7OuLWZ0V1Mlp4n4ryROk3raofF+rl5vPWIxb9Wfg=;
 b=j1dwjqbKs4o2bbnOhHZkcnx5bQw9YzWrgT5NVgRyLalDdKy9AODwGyboismhT5hB8BZf
 Z0ScxRiTZGHb03XrCCyEWFFZ0kcIcTOnEIDyC6fehqaA+ZvMY4mF6WMgt2icwIvpUfGw
 IMKyPb79IradX+cEpMfQ4cYrBRKlw4WzM2LptwOHBNVpp16+tSHWms/UkzmdfVYE/PE7
 AOXenIWIv3FXYUNaya46TuCKwULM5ZQss+BvZhHqg9q12e9kX41T5tJ6eIfUw7nKUZtZ
 XHTrPPoCGrixu3gPFIxCgEZPOZ94uEadLwgwRz4TX1+kueT6EGVX7fgs1iDiFSmljQqv Fw== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2y68sf1eqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Feb 2020 20:40:53 +0000
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 01HKZjHX005439;
        Mon, 17 Feb 2020 15:40:52 -0500
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint6.akamai.com with ESMTP id 2y6cuy1np2-1;
        Mon, 17 Feb 2020 15:40:52 -0500
Received: from bos-lpjec.145bw.corp.akamai.com (bos-lpjec.145bw.corp.akamai.com [172.28.3.71])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 46EE621A4A;
        Mon, 17 Feb 2020 20:40:52 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com
Cc:     netdev@vger.kernel.org, soukjin.bae@samsung.com,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH v3 net] net: sched: correct flower port blocking
Date:   Mon, 17 Feb 2020 15:38:09 -0500
Message-Id: <1581971889-5862-1-git-send-email-jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20200216.191837.828352407289487240.davem@davemloft.net>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-02-17_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=960
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002050000 definitions=main-2002170169
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_12:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 spamscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 adultscore=0
 bulkscore=0 mlxlogscore=960 malwarescore=0 mlxscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002170168
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
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---

v3:
-add include of string.h for memset() (David Miller)

v2:
-move rename to flow_dissector_init_keys() amd move to
 flow_dissector.h (Cong Wang)


 include/net/flow_dissector.h | 9 +++++++++
 net/sched/cls_flower.c       | 1 +
 2 files changed, 10 insertions(+)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index d93017a..e03827f 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/in6.h>
 #include <linux/siphash.h>
+#include <linux/string.h>
 #include <uapi/linux/if_ether.h>
 
 struct sk_buff;
@@ -349,4 +350,12 @@ struct bpf_flow_dissector {
 	void			*data_end;
 };
 
+static inline void
+flow_dissector_init_keys(struct flow_dissector_key_control *key_control,
+			 struct flow_dissector_key_basic *key_basic)
+{
+	memset(key_control, 0, sizeof(*key_control));
+	memset(key_basic, 0, sizeof(*key_basic));
+}
+
 #endif
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f9c0d1e..b783254 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -305,6 +305,7 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 	struct cls_fl_filter *f;
 
 	list_for_each_entry_rcu(mask, &head->masks, list) {
+		flow_dissector_init_keys(&skb_key.control, &skb_key.basic);
 		fl_clear_masked_range(&skb_key, mask);
 
 		skb_flow_dissect_meta(skb, &mask->dissector, &skb_key);
-- 
2.7.4

