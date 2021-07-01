Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CACC3B96E5
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhGAUIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:08:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39926 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232628AbhGAUIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 16:08:37 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 161K0cIb026353
        for <netdev@vger.kernel.org>; Thu, 1 Jul 2021 13:06:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=3zB4O/E1HZBoqzPN3o5ZOih5nXst9ZcjSSoDaT6Qfo0=;
 b=owIaRdIYEJ/D9IUUWpEuwCqAjLJRgikpKSw1r8GrTH3Ak75c9MvNb/NzH0/lIkE0TmgX
 pbiW/wR962BbGzcek2ExbZ0v3ppg08+PJX0m3qcvbj9R36IrE4hEDV+0AFFUKTBYj2Gx
 GhDRGfO2muupfFZ/mn3ecLceem2OPZxY6qY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39gagnpgcw-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 13:06:06 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 13:06:00 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 5DB092940BB9; Thu,  1 Jul 2021 13:05:54 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH v2 bpf-next 3/8] bpf: tcp: seq_file: Remove bpf_seq_afinfo from tcp_iter_state
Date:   Thu, 1 Jul 2021 13:05:54 -0700
Message-ID: <20210701200554.1034982-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210701200535.1033513-1-kafai@fb.com>
References: <20210701200535.1033513-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4usb8DsFO1Q-I_izlTq9mkseR2P2Ljza
X-Proofpoint-GUID: 4usb8DsFO1Q-I_izlTq9mkseR2P2Ljza
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-01_12:2021-07-01,2021-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107010117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A following patch will create a separate struct to store extra
bpf_iter state and it will embed the existing tcp_iter_state like this:
struct bpf_tcp_iter_state {
	struct tcp_iter_state state;
	/* More bpf_iter specific states here ... */
}

As a prep work, this patch removes the
"struct tcp_seq_afinfo *bpf_seq_afinfo" where its purpose is
to tell if it is iterating from bpf_iter instead of proc fs.
Currently, if "*bpf_seq_afinfo" is not NULL, it is iterating from
bpf_iter.  The kernel should not filter by the addr family and
leave this filtering decision to the bpf prog.

Instead of adding a "*bpf_seq_afinfo" pointer, this patch uses the
"seq->op =3D=3D &bpf_iter_tcp_seq_ops" test to tell if it is iterating
from the bpf iter.

The bpf_iter_(init|fini)_tcp() is left here to prepare for
the change of a following patch.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/tcp.h   |  1 -
 net/ipv4/tcp_ipv4.c | 25 +++++--------------------
 2 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e668f1bf780d..06ce38967890 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1955,7 +1955,6 @@ struct tcp_iter_state {
 	struct seq_net_private	p;
 	enum tcp_seq_states	state;
 	struct sock		*syn_wait_sk;
-	struct tcp_seq_afinfo	*bpf_seq_afinfo;
 	int			bucket, offset, sbucket, num;
 	loff_t			last_pos;
 };
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e4e9f73a19a6..6071391b9c0f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2735,12 +2735,13 @@ static const struct seq_operations bpf_iter_tcp_s=
eq_ops =3D {
 #endif
 static unsigned short seq_file_family(const struct seq_file *seq)
 {
-	const struct tcp_iter_state *st =3D seq->private;
-	const struct tcp_seq_afinfo *afinfo =3D st->bpf_seq_afinfo;
+	const struct tcp_seq_afinfo *afinfo;
=20
+#ifdef CONFIG_BPF_SYSCALL
 	/* Iterated from bpf_iter.  Let the bpf prog to filter instead. */
-	if (afinfo)
+	if (seq->op =3D=3D &bpf_iter_tcp_seq_ops)
 		return AF_UNSPEC;
+#endif
=20
 	/* Iterated from proc fs */
 	afinfo =3D PDE_DATA(file_inode(seq->file));
@@ -2998,27 +2999,11 @@ DEFINE_BPF_ITER_FUNC(tcp, struct bpf_iter_meta *m=
eta,
=20
 static int bpf_iter_init_tcp(void *priv_data, struct bpf_iter_aux_info *=
aux)
 {
-	struct tcp_iter_state *st =3D priv_data;
-	struct tcp_seq_afinfo *afinfo;
-	int ret;
-
-	afinfo =3D kmalloc(sizeof(*afinfo), GFP_USER | __GFP_NOWARN);
-	if (!afinfo)
-		return -ENOMEM;
-
-	afinfo->family =3D AF_UNSPEC;
-	st->bpf_seq_afinfo =3D afinfo;
-	ret =3D bpf_iter_init_seq_net(priv_data, aux);
-	if (ret)
-		kfree(afinfo);
-	return ret;
+	return bpf_iter_init_seq_net(priv_data, aux);
 }
=20
 static void bpf_iter_fini_tcp(void *priv_data)
 {
-	struct tcp_iter_state *st =3D priv_data;
-
-	kfree(st->bpf_seq_afinfo);
 	bpf_iter_fini_seq_net(priv_data);
 }
=20
--=20
2.30.2

