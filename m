Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E831634D9FD
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhC2WOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:14:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60528 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231674AbhC2WOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 18:14:01 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TM9A0F015372
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 15:14:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Y1A/572GcKHxQ0/5BBQbsG7UF53ZoP+0WZoMTCsdQiQ=;
 b=C7RxWNST7+mVW/vp0ijXGx8DJNoymSO4OSqYwnBe3UmrJ26inqcs6hbK1fRN9u+zFv86
 EExYO1xhKh7iBeXM6QACQevI9NBsFc+EfqoELOXSF6LmJArPgm95g0Efu90mg+ABw6BX
 WkD8+TM5Nx2iTv11tjuF6Eb7ZeIyTjYl50E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37kdyt3kb7-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 15:14:00 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 15:13:59 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 20FC12942AEF; Mon, 29 Mar 2021 15:13:57 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next] bpf: tcp: Limit calling some tcp cc functions to CONFIG_DYNAMIC_FTRACE
Date:   Mon, 29 Mar 2021 15:13:57 -0700
Message-ID: <20210329221357.834438-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: bohP1fooEyVmOcH-ZUCG6BOuysev0ZTk
X-Proofpoint-ORIG-GUID: bohP1fooEyVmOcH-ZUCG6BOuysev0ZTk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_13:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 bulkscore=0 clxscore=1015 phishscore=0
 mlxlogscore=650 impostorscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103250000 definitions=main-2103290163
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pahole currently only generates the btf_id for external function and
ftrace-able function.  Some functions in the bpf_tcp_ca_kfunc_ids
are static (e.g. cubictcp_init).  Thus, unless CONFIG_DYNAMIC_FTRACE
is set, btf_ids for those functions will not be generated and the
compilation fails during resolve_btfids.

This patch limits those functions to CONFIG_DYNAMIC_FTRACE.  I will
address the pahole generation in a followup and then remove the
CONFIG_DYNAMIC_FTRACE limitation.

Fixes: e78aea8b2170 ("bpf: tcp: Put some tcp cong functions in allowlist =
for bpf-tcp-cc")
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/bpf_tcp_ca.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 6bb7b335ff9f..dff4f0eb96b0 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -185,6 +185,7 @@ BTF_ID(func, tcp_reno_cong_avoid)
 BTF_ID(func, tcp_reno_undo_cwnd)
 BTF_ID(func, tcp_slow_start)
 BTF_ID(func, tcp_cong_avoid_ai)
+#ifdef CONFIG_DYNAMIC_FTRACE
 #if IS_BUILTIN(CONFIG_TCP_CONG_CUBIC)
 BTF_ID(func, cubictcp_init)
 BTF_ID(func, cubictcp_recalc_ssthresh)
@@ -211,6 +212,7 @@ BTF_ID(func, bbr_ssthresh)
 BTF_ID(func, bbr_min_tso_segs)
 BTF_ID(func, bbr_set_state)
 #endif
+#endif  /* CONFIG_DYNAMIC_FTRACE */
 BTF_SET_END(bpf_tcp_ca_kfunc_ids)
=20
 static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id)
--=20
2.30.2

