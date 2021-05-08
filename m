Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44237376DF2
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhEHAvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:51:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58654 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229488AbhEHAvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:51:15 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1480btCP012794
        for <netdev@vger.kernel.org>; Fri, 7 May 2021 17:50:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=/6dBoZ4Ptb1cVlTcUL9MBk10I9K2L40jILV4exYzOfg=;
 b=E5H2du6x3ktQSar0F9/zgdfl2n6u1zqQfBE3qTuSg1zakFtDILI9srVGjZyNMDO1m5Bk
 VozYJalnnzQAJD78QB4jQq1XWuV89lLn5JBs4OgixnuDCMS+fy/bFbGdqVYCM1F2RZoU
 kTn15iS+Oh7evvnytsogr5RYOmI3FMdmAGY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38css568yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 17:50:15 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 7 May 2021 17:50:13 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 484AA29428F7; Fri,  7 May 2021 17:50:11 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>,
        =?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
        Jiri Slaby <jslaby@suse.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH bpf] bpf: Limit static tcp-cc functions in the .BTF_ids list to x86
Date:   Fri, 7 May 2021 17:50:11 -0700
Message-ID: <20210508005011.3863757-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset="UTF-8"
X-FB-Internal: Safe
X-Proofpoint-GUID: QdmpJ4pVLILrkJAWhn9JVG-7j4s265Ye
X-Proofpoint-ORIG-GUID: QdmpJ4pVLILrkJAWhn9JVG-7j4s265Ye
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_10:2021-05-06,2021-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=632 phishscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105080001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the discussion in [0].  It was pointed out that static functions
in ppc64 is prefixed with ".".  For example, the 'readelf -s vmlinux.ppc':

89326: c000000001383280    24 NOTYPE  LOCAL  DEFAULT   31 cubictcp_init
89327: c000000000c97c50   168 FUNC    LOCAL  DEFAULT    2 .cubictcp_init

The one with FUNC type is ".cubictcp_init" instead of "cubictcp_init".
The "." seems to be done by arch/powerpc/include/asm/ppc_asm.h.

This caused the pahole cannot generate the BTF for these tcp-cc kernel
functions because pahole only captures the FUNC type and "cubictcp_init"
is not.  It then failed the kernel compilation in ppc64.

This behavior is only reported in ppc64 so far.  I tried arm64, s390,
and sparc64 and did not observe this "." prefix and NOTYPE behavior.

Since the kfunc call is only supported in the x86_64 and x86_32 jit,
this patch limits those tcp-cc functions to x86 only to avoid unnecessary
compilation issue in other ARCHs.  In the future, we can examine
if it is better to change all those functions from static to
extern.

[0]: https://lore.kernel.org/bpf/4e051459-8532-7b61-c815-f3435767f8a0@kerne=
l.org/

Fixes: e78aea8b2170 ("bpf: tcp: Put some tcp cong functions in allowlist fo=
r bpf-tcp-cc")
Cc: Michal Such=C3=A1nek <msuchanek@suse.de>
Cc: Jiri Slaby <jslaby@suse.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/bpf_tcp_ca.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index dff4f0eb96b0..9e41eff4a685 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -185,6 +185,7 @@ BTF_ID(func, tcp_reno_cong_avoid)
 BTF_ID(func, tcp_reno_undo_cwnd)
 BTF_ID(func, tcp_slow_start)
 BTF_ID(func, tcp_cong_avoid_ai)
+#ifdef CONFIG_X86
 #ifdef CONFIG_DYNAMIC_FTRACE
 #if IS_BUILTIN(CONFIG_TCP_CONG_CUBIC)
 BTF_ID(func, cubictcp_init)
@@ -213,6 +214,7 @@ BTF_ID(func, bbr_min_tso_segs)
 BTF_ID(func, bbr_set_state)
 #endif
 #endif  /* CONFIG_DYNAMIC_FTRACE */
+#endif	/* CONFIG_X86 */
 BTF_SET_END(bpf_tcp_ca_kfunc_ids)
=20
 static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id)
--=20
2.30.2

