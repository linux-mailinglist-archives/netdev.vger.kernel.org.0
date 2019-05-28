Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD62E2D2A0
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbfE1X75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 19:59:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38206 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727254AbfE1X74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 19:59:56 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SNrOEU029794
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 16:59:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=QTTyHz2kfTw7yeZZoJjI61N0iKgHznxZuxYZ+P76WgU=;
 b=djYzaMhY+FNMATesv+zdMmIN7zD9ycoHp1XhTPg6gWplCPp8biosoE1OtDv7aORUf+yw
 UicLeCG55l/52q7VfbM3WXbwCy4tIJ4FQnPxS5VYv81wmLbK7wQcD06bePqGmf08o2Kd
 B16YW05ujJBKKPF5OGtdnyHGnZZnY3LyHuM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ss8221ksd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 16:59:55 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 28 May 2019 16:59:53 -0700
Received: by devbig009.ftw2.facebook.com (Postfix, from userid 10340)
        id C38535AE2482; Tue, 28 May 2019 16:59:50 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   brakmo <brakmo@fb.com>
Smtp-Origin-Hostname: devbig009.ftw2.facebook.com
To:     netdev <netdev@vger.kernel.org>
CC:     Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 3/6] bpf: Update __cgroup_bpf_run_filter_skb with cn
Date:   Tue, 28 May 2019 16:59:37 -0700
Message-ID: <20190528235940.1452963-4-brakmo@fb.com>
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
 mlxlogscore=783 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For egress packets, __cgroup_bpf_fun_filter_skb() will now call
BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY() instead of PROG_CGROUP_RUN_ARRAY()
in order to propagate congestion notifications (cn) requests to TCP
callers.

For egress packets, this function can return:
   NET_XMIT_SUCCESS    (0)    - continue with packet output
   NET_XMIT_DROP       (1)    - drop packet and notify TCP to call cwr
   NET_XMIT_CN         (2)    - continue with packet output and notify TCP
                                to call cwr
   -EPERM                     - drop packet

For ingress packets, this function will return -EPERM if any attached
program was found and if it returned != 1 during execution. Otherwise 0
is returned.

Signed-off-by: Lawrence Brakmo <brakmo@fb.com>
---
 kernel/bpf/cgroup.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index fcde0f7b2585..5db8eb8481cb 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -548,8 +548,16 @@ int cgroup_bpf_prog_query(const union bpf_attr *attr,
  * The program type passed in via @type must be suitable for network
  * filtering. No further check is performed to assert that.
  *
- * This function will return %-EPERM if any if an attached program was found
- * and if it returned != 1 during execution. In all other cases, 0 is returned.
+ * For egress packets, this function can return:
+ *   NET_XMIT_SUCCESS    (0)	- continue with packet output
+ *   NET_XMIT_DROP       (1)	- drop packet and notify TCP to call cwr
+ *   NET_XMIT_CN         (2)	- continue with packet output and notify TCP
+ *				  to call cwr
+ *   -EPERM			- drop packet
+ *
+ * For ingress packets, this function will return -EPERM if any
+ * attached program was found and if it returned != 1 during execution.
+ * Otherwise 0 is returned.
  */
 int __cgroup_bpf_run_filter_skb(struct sock *sk,
 				struct sk_buff *skb,
@@ -575,12 +583,19 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 	/* compute pointers for the bpf prog */
 	bpf_compute_and_save_data_end(skb, &saved_data_end);
 
-	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], skb,
-				 __bpf_prog_run_save_cb);
+	if (type == BPF_CGROUP_INET_EGRESS) {
+		ret = BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY(
+			cgrp->bpf.effective[type], skb, __bpf_prog_run_save_cb);
+	} else {
+		ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], skb,
+					  __bpf_prog_run_save_cb);
+		ret = (ret == 1 ? 0 : -EPERM);
+	}
 	bpf_restore_data_end(skb, saved_data_end);
 	__skb_pull(skb, offset);
 	skb->sk = save_sk;
-	return ret == 1 ? 0 : -EPERM;
+
+	return ret;
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_skb);
 
-- 
2.17.1

