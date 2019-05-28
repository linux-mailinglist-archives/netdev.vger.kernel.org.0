Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C0F2D29F
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbfE1X7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 19:59:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54530 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727254AbfE1X7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 19:59:53 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SNxRaW030471
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 16:59:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=AGbLlmyS4rBQmvwrhfGrvf9B1RVz43Z78y0ltXwIW/Y=;
 b=diNux3ykoZz876N2iDLf3iWJjrIzvGAf+FKHvFelu2fww+jIul+O7kXrXcG2q4RaJTXw
 tAyYAGcPbV58j2OWIvGimqYPm01ZVnrs6+c2VhaNcne7TW+eES7BYE24/1C/LQBB7KPm
 p/z7GnFFqHL8uWw/GhuJy17QerNCQRqaCFU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ss90y1c7v-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 16:59:52 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 May 2019 16:59:51 -0700
Received: by devbig009.ftw2.facebook.com (Postfix, from userid 10340)
        id BC9DB5AE2482; Tue, 28 May 2019 16:59:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   brakmo <brakmo@fb.com>
Smtp-Origin-Hostname: devbig009.ftw2.facebook.com
To:     netdev <netdev@vger.kernel.org>
CC:     Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 2/6] bpf: cgroup inet skb programs can return 0 to 3
Date:   Tue, 28 May 2019 16:59:36 -0700
Message-ID: <20190528235940.1452963-3-brakmo@fb.com>
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
 mlxlogscore=829 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allows cgroup inet skb programs to return values in the range [0, 3].
The second bit is used to deterine if congestion occurred and higher
level protocol should decrease rate. E.g. TCP would call tcp_enter_cwr()

The bpf_prog must set expected_attach_type to BPF_CGROUP_INET_EGRESS
at load time if it uses the new return values (i.e. 2 or 3).

The expected_attach_type is currently not enforced for
BPF_PROG_TYPE_CGROUP_SKB.  e.g Meaning the current bpf_prog with
expected_attach_type setting to BPF_CGROUP_INET_EGRESS can attach to
BPF_CGROUP_INET_INGRESS.  Blindly enforcing expected_attach_type will
break backward compatibility.

This patch adds a enforce_expected_attach_type bit to only
enforce the expected_attach_type when it uses the new
return value.

Signed-off-by: Lawrence Brakmo <brakmo@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/filter.h |  3 ++-
 kernel/bpf/syscall.c   | 12 ++++++++++++
 kernel/bpf/verifier.c  | 16 +++++++++++++---
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index ba8b65270e0d..43b45d6db36d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -526,7 +526,8 @@ struct bpf_prog {
 				blinded:1,	/* Was blinded */
 				is_func:1,	/* program is a bpf function */
 				kprobe_override:1, /* Do we override a kprobe? */
-				has_callchain_buf:1; /* callchain buffer allocated? */
+				has_callchain_buf:1, /* callchain buffer allocated? */
+				enforce_expected_attach_type:1; /* Enforce expected_attach_type checking at attach time */
 	enum bpf_prog_type	type;		/* Type of BPF program */
 	enum bpf_attach_type	expected_attach_type; /* For some prog types */
 	u32			len;		/* Number of filter blocks */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 3d546b6f4646..1539774d78c7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1585,6 +1585,14 @@ bpf_prog_load_check_attach_type(enum bpf_prog_type prog_type,
 		default:
 			return -EINVAL;
 		}
+	case BPF_PROG_TYPE_CGROUP_SKB:
+		switch (expected_attach_type) {
+		case BPF_CGROUP_INET_INGRESS:
+		case BPF_CGROUP_INET_EGRESS:
+			return 0;
+		default:
+			return -EINVAL;
+		}
 	default:
 		return 0;
 	}
@@ -1836,6 +1844,10 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 	case BPF_PROG_TYPE_CGROUP_SOCK:
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 		return attach_type == prog->expected_attach_type ? 0 : -EINVAL;
+	case BPF_PROG_TYPE_CGROUP_SKB:
+		return prog->enforce_expected_attach_type &&
+			prog->expected_attach_type != attach_type ?
+			-EINVAL : 0;
 	default:
 		return 0;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2778417e6e0c..5c2cb5bd84ce 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5508,11 +5508,16 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 
 static int check_return_code(struct bpf_verifier_env *env)
 {
+	struct tnum enforce_attach_type_range = tnum_unknown;
 	struct bpf_reg_state *reg;
 	struct tnum range = tnum_range(0, 1);
 
 	switch (env->prog->type) {
 	case BPF_PROG_TYPE_CGROUP_SKB:
+		if (env->prog->expected_attach_type == BPF_CGROUP_INET_EGRESS) {
+			range = tnum_range(0, 3);
+			enforce_attach_type_range = tnum_range(2, 3);
+		}
 	case BPF_PROG_TYPE_CGROUP_SOCK:
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 	case BPF_PROG_TYPE_SOCK_OPS:
@@ -5531,18 +5536,23 @@ static int check_return_code(struct bpf_verifier_env *env)
 	}
 
 	if (!tnum_in(range, reg->var_off)) {
+		char tn_buf[48];
+
 		verbose(env, "At program exit the register R0 ");
 		if (!tnum_is_unknown(reg->var_off)) {
-			char tn_buf[48];
-
 			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
 			verbose(env, "has value %s", tn_buf);
 		} else {
 			verbose(env, "has unknown scalar value");
 		}
-		verbose(env, " should have been 0 or 1\n");
+		tnum_strn(tn_buf, sizeof(tn_buf), range);
+		verbose(env, " should have been %s\n", tn_buf);
 		return -EINVAL;
 	}
+
+	if (!tnum_is_unknown(enforce_attach_type_range) &&
+	    tnum_in(enforce_attach_type_range, reg->var_off))
+		env->prog->enforce_expected_attach_type = 1;
 	return 0;
 }
 
-- 
2.17.1

