Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01D23B499D
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 22:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhFYUHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 16:07:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65294 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229881AbhFYUHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 16:07:32 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PJvg00029177
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:05:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=vdoppFcFAh9nTnqcwp4GpQgR/4yTZArT/1CSGl0BaKo=;
 b=np5cXTGEithZDZt85OAG8nLvb5S4pvvN0NJbJn8urku9tvs1sSM0dIuk2cN4o9Da41rY
 xLBr2WxDYANmzK9r5a7uScjzPY6tjYCOe1s31an6eNvRkqp9QKk9n3pq+C9ds57b3G6y
 A6f1sPPP0D9QCu+2TS648H5IGKgbSoA8b3c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39d23qxpmh-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:05:11 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 13:05:07 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 021FC29422B0; Fri, 25 Jun 2021 13:05:04 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH bpf-next 3/8] bpf: tcp: seq_file: Remove bpf_seq_afinfo from tcp_iter_state
Date:   Fri, 25 Jun 2021 13:05:04 -0700
Message-ID: <20210625200504.725683-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210625200446.723230-1-kafai@fb.com>
References: <20210625200446.723230-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: FqfikFq4HfQdCNk_12aK7rx34lEogcPb
X-Proofpoint-ORIG-GUID: FqfikFq4HfQdCNk_12aK7rx34lEogcPb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_07:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250122
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
index 13a8b6e8d6bc..ca55e87f6cc9 100644
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

