Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16AB27F8F1
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 07:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgJAFNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 01:13:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11066 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725878AbgJAFNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 01:13:45 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0915D4aH017312
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 22:13:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=jjPipX/edsJshYt0rDHCloyS5NvudY4fKYKmXHlVFQs=;
 b=lWrXCT4C3ZqkMxyxqXqS6fzibdOT8fs2PPphPQmpmpfUKFGM74HtoUJyAcuFdqTrnQvg
 UsLcSOeIABn0vfySkcyKBJv7u2pFrejXN3gp8sScILYfaP3quan5uguS0xvgYfVXviPE
 Gvk3CblMEoLhalbs31XbHh6JSQbn762ku8M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33v6jxjbdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 22:13:45 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 22:13:43 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id EC7463705C56; Wed, 30 Sep 2020 22:13:39 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH bpf v3] bpf: fix "unresolved symbol" build error with resolve_btfids
Date:   Wed, 30 Sep 2020 22:13:39 -0700
Message-ID: <20201001051339.2549085-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_02:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 suspectscore=8 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010047
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michal reported a build failure likes below:
   BTFIDS  vmlinux
   FAILED unresolved symbol tcp_timewait_sock
   make[1]: *** [/.../linux-5.9-rc7/Makefile:1176: vmlinux] Error 255

This error can be triggered when config has CONFIG_NET enabled
but CONFIG_INET disabled. In this case, there is no user of
structs inet_timewait_sock and tcp_timewait_sock and hence vmlinux BTF
types are not generated for these two structures.

To fix the problem, let us force BTF generation for these two
structures with BTF_TYPE_EMIT.

Fixes: fce557bcef11 ("bpf: Make btf_sock_ids global")
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 net/core/filter.c | 6 ++++++
 1 file changed, 6 insertions(+)

Changelog:
  v2 -> v3:
    . instead of avoiding generating BTF types which is more
      complex, just always generating these BTF types (under CONFIG_NET).
  v1 -> v2:
    . For unsupported socket times, using BTF_ID_UNUSED to
      keep the id as 0. (Martin)

diff --git a/net/core/filter.c b/net/core/filter.c
index 21eaf3b182f2..b5f3faac5e3b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9558,6 +9558,12 @@ const struct bpf_func_proto bpf_skc_to_tcp_sock_pr=
oto =3D {
=20
 BPF_CALL_1(bpf_skc_to_tcp_timewait_sock, struct sock *, sk)
 {
+	/* BTF types for tcp_timewait_sock and inet_timewait_sock are not
+	 * generated if CONFIG_INET=3Dn. Trigger an explicit generation here.
+	 */
+	BTF_TYPE_EMIT(struct inet_timewait_sock);
+	BTF_TYPE_EMIT(struct tcp_timewait_sock);
+
 #ifdef CONFIG_INET
 	if (sk && sk->sk_prot =3D=3D &tcp_prot && sk->sk_state =3D=3D TCP_TIME_=
WAIT)
 		return (unsigned long)sk;
--=20
2.24.1

