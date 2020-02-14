Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B093F15E617
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406055AbgBNQpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:45:43 -0500
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:45886 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394109AbgBNQpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:45:30 -0500
X-Greylist: delayed 1338 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Feb 2020 11:45:30 EST
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 01EGFb99024897;
        Fri, 14 Feb 2020 16:23:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to; s=jan2016.eng;
 bh=wdJCZyrCHZVZ5tmxb+wu9xsVA9jypBpXLz8qqp4pFIg=;
 b=E0SJ4WwJ5TAuiKJ0Z3k4xUy47Yc5RphIbxRo85A46eATfsZDg7eqpIlSgV9gMeKAMjUh
 NwhHWvJTOz9X93Vkie7WNqB2kesXp9ZvCiGk5bnx/a6SLsPSsPKPIOFuJqxzb8BV38mU
 nArDSRrXLWygBNacrYxD3rWrccvTK6daN7QniZpM3pG6GeBDhTtwi9u5PrI1haegjAtM
 0d26VVhzsmEvLDHeIL/OO47RwgKS2OtUmQZGpzG9FL+Oq2bFI1szO5CALGDfEvTGgftg
 F4YOIg9scDK19RXE0t7ictT7PNIn08RRqChaqeXt6z/wJ5fMF+iCrXgU852a82aANW+h Ig== 
Received: from prod-mail-ppoint3 (prod-mail-ppoint3.akamai.com [96.6.114.86] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 2y4580vtft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 16:23:07 +0000
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 01EGIOc2000484;
        Fri, 14 Feb 2020 11:23:06 -0500
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint3.akamai.com with ESMTP id 2y5bdcvg6u-1;
        Fri, 14 Feb 2020 11:23:05 -0500
Received: from bos-lpjec.145bw.corp.akamai.com (bos-lpjec.145bw.corp.akamai.com [172.28.3.71])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id 72E0221F89;
        Fri, 14 Feb 2020 16:23:05 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com
Cc:     netdev@vger.kernel.org, soukjin.bae@samsung.com,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH v2 net] net: sched: correct flower port blocking
Date:   Fri, 14 Feb 2020 11:20:24 -0500
Message-Id: <1581697224-20041-1-git-send-email-jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <CAM_iQpU_dbze9u2U+QjasAw6Rg3UPkax-rs=W1kwi3z4d5pwwg@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-02-14_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002050000 definitions=main-2002140126
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_05:2020-02-12,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0 bulkscore=0
 phishscore=0 clxscore=1015 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002140125
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
v2:

-move rename to flow_dissector_init_keys() amd move to
 flow_dissector.h (Cong Wang)

 include/net/flow_dissector.h | 8 ++++++++
 net/sched/cls_flower.c       | 1 +
 2 files changed, 9 insertions(+)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index d93017a..4bd4931 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -349,4 +349,12 @@ struct bpf_flow_dissector {
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

