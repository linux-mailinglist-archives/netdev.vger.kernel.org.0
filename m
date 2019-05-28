Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE122BDF2
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 05:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfE1DtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 23:49:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53646 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727320AbfE1DtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 23:49:23 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4S3iO5g024825
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 20:49:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=zX7L0T/Q5QNRDOwBnrEbqvMND6nXBJs99NpWQEH04vg=;
 b=fy/U7ErGKYCR/rBd8Lx5wW9YGM+UCXw61NUyyRREDT2n12+rQaf4sZ5voImWZxhDB/wi
 ge8yKpyjJqbn7BubQNA404XZZhsGvU28s3mIWKtZSFrzBOjDg0RAZCHDsZW32WuolmpN
 Jld2enNAq48fg/LO496wFanPW/aXO3/oZF0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2srh8u9msm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 20:49:21 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 27 May 2019 20:49:20 -0700
Received: by devbig009.ftw2.facebook.com (Postfix, from userid 10340)
        id B70755AE25F0; Mon, 27 May 2019 20:49:19 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   brakmo <brakmo@fb.com>
Smtp-Origin-Hostname: devbig009.ftw2.facebook.com
To:     netdev <netdev@vger.kernel.org>
CC:     Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/6] bpf: Create BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY
Date:   Mon, 27 May 2019 20:49:02 -0700
Message-ID: <20190528034907.1957536-2-brakmo@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528034907.1957536-1-brakmo@fb.com>
References: <20190528034907.1957536-1-brakmo@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=767 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280025
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create new macro BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY() to be used by
__cgroup_bpf_run_filter_skb for EGRESS BPF progs so BPF programs can
request cwr for TCP packets.

Current cgroup skb programs can only return 0 or 1 (0 to drop the
packet. This macro changes the behavior so the low order bit
indicates whether the packet should be dropped (0) or not (1)
and the next bit is used for congestion notification (cn).

Hence, new allowed return values of CGROUP EGRESS BPF programs are:
  0: drop packet
  1: keep packet
  2: drop packet and call cwr
  3: keep packet and call cwr

This macro then converts it to one of NET_XMIT values or -EPERM
that has the effect of dropping the packet with no cn.
  0: NET_XMIT_SUCCESS  skb should be transmitted (no cn)
  1: NET_XMIT_DROP     skb should be dropped and cwr called
  2: NET_XMIT_CN       skb should be transmitted and cwr called
  3: -EPERM            skb should be dropped (no cn)

Note that when more than one BPF program is called, the packet is
dropped if at least one of programs requests it be dropped, and
there is cn if at least one program returns cn.

Signed-off-by: Lawrence Brakmo <brakmo@fb.com>
---
 include/linux/bpf.h | 50 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d98141edb74b..49be4f88454c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -552,6 +552,56 @@ _out:							\
 		_ret;					\
 	 })
 
+/* To be used by __cgroup_bpf_run_filter_skb for EGRESS BPF progs
+ * so BPF programs can request cwr for TCP packets.
+ *
+ * Current cgroup skb programs can only return 0 or 1 (0 to drop the
+ * packet. This macro changes the behavior so the low order bit
+ * indicates whether the packet should be dropped (0) or not (1)
+ * and the next bit is a congestion notification bit. This could be
+ * used by TCP to call tcp_enter_cwr()
+ *
+ * Hence, new allowed return values of CGROUP EGRESS BPF programs are:
+ *   0: drop packet
+ *   1: keep packet
+ *   2: drop packet and cn
+ *   3: keep packet and cn
+ *
+ * This macro then converts it to one of the NET_XMIT or an error
+ * code that is then interpreted as drop packet (and no cn):
+ *   0: NET_XMIT_SUCCESS  skb should be transmitted
+ *   1: NET_XMIT_DROP     skb should be dropped and cn
+ *   2: NET_XMIT_CN       skb should be transmitted and cn
+ *   3: -EPERM            skb should be dropped
+ */
+#define BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY(array, ctx, func)		\
+	({						\
+		struct bpf_prog_array_item *_item;	\
+		struct bpf_prog *_prog;			\
+		struct bpf_prog_array *_array;		\
+		u32 ret;				\
+		u32 _ret = 1;				\
+		u32 _cn = 0;				\
+		preempt_disable();			\
+		rcu_read_lock();			\
+		_array = rcu_dereference(array);	\
+		_item = &_array->items[0];		\
+		while ((_prog = READ_ONCE(_item->prog))) {		\
+			bpf_cgroup_storage_set(_item->cgroup_storage);	\
+			ret = func(_prog, ctx);		\
+			_ret &= (ret & 1);		\
+			_cn |= (ret & 2);		\
+			_item++;			\
+		}					\
+		rcu_read_unlock();			\
+		preempt_enable_no_resched();		\
+		if (_ret)				\
+			_ret = (_cn ? NET_XMIT_CN : NET_XMIT_SUCCESS);	\
+		else					\
+			_ret = (_cn ? NET_XMIT_DROP : -EPERM);		\
+		_ret;					\
+	})
+
 #define BPF_PROG_RUN_ARRAY(array, ctx, func)		\
 	__BPF_PROG_RUN_ARRAY(array, ctx, func, false)
 
-- 
2.17.1

