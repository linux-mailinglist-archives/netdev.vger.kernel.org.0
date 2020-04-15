Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A33E1AB1C2
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411893AbgDOTae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:30:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59590 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2411819AbgDOT2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:24 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03FJSBiM007577
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=oO988a3vrBzAlJAo3ewjADin46X5JyPGhd7kzF/2yc4=;
 b=jEHLHiotVYuTDg7RoiyVC22Dh04VHDziWxy5108aCsIkgUtsSZ2q+WLymxR4LEB7bodG
 PoM2KwEw5CDp93kjhlQiI5H850BJL0AX6T2W1HiAzHveiMXK0AGFuCBZ1OPCPZFaXYaG
 yQf7qqISw0d4mh3cwtPw5crF/aDNnKleyvw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30dn7fymmp-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:23 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:27:51 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 6D9C53700AF5; Wed, 15 Apr 2020 12:27:49 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 08/17] bpf: add bpf_map target
Date:   Wed, 15 Apr 2020 12:27:49 -0700
Message-ID: <20200415192749.4083310-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added bpf_map target. Traversing all bpf_maps
through map_idr. A reference is held for the map during
the show() to ensure safety and correctness for field accesses.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/syscall.c | 116 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4a3c9fceebb8..e6a4514435c4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3800,3 +3800,119 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __u=
ser *, uattr, unsigned int, siz
=20
 	return err;
 }
+
+struct bpfdump_seq_map_info {
+	struct bpf_map *map;
+	u32 id;
+};
+
+static struct bpf_map *bpf_map_seq_get_next(u32 *id)
+{
+	struct bpf_map *map;
+
+	spin_lock_bh(&map_idr_lock);
+	map =3D idr_get_next(&map_idr, id);
+	if (map)
+		map =3D __bpf_map_inc_not_zero(map, false);
+	spin_unlock_bh(&map_idr_lock);
+
+	return map;
+}
+
+static void *bpf_map_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpfdump_seq_map_info *info =3D seq->private;
+	struct bpf_map *map;
+	u32 id =3D info->id + 1;
+
+	map =3D bpf_map_seq_get_next(&id);
+	if (!map)
+		return NULL;
+
+	++*pos;
+	info->map =3D map;
+	info->id =3D id;
+	return map;
+}
+
+static void *bpf_map_seq_next(struct seq_file *seq, void *v, loff_t *pos=
)
+{
+	struct bpfdump_seq_map_info *info =3D seq->private;
+	struct bpf_map *map;
+	u32 id =3D info->id + 1;
+
+	++*pos;
+	map =3D bpf_map_seq_get_next(&id);
+	if (!map)
+		return NULL;
+
+	__bpf_map_put(info->map, true);
+	info->map =3D map;
+	info->id =3D id;
+	return map;
+}
+
+struct bpfdump__bpf_map {
+	struct bpf_dump_meta *meta;
+	struct bpf_map *map;
+};
+
+int __init __bpfdump__bpf_map(struct bpf_dump_meta *meta, struct bpf_map=
 *map)
+{
+	return 0;
+}
+
+static int bpf_map_seq_show(struct seq_file *seq, void *v)
+{
+	struct bpf_dump_meta meta;
+	struct bpfdump__bpf_map ctx;
+	struct bpf_prog *prog;
+	int ret =3D 0;
+
+	ctx.meta =3D &meta;
+	ctx.map =3D v;
+	meta.seq =3D seq;
+	prog =3D bpf_dump_get_prog(seq, sizeof(struct bpfdump_seq_map_info),
+				 &meta.session_id, &meta.seq_num,
+				 v =3D=3D (void *)0);
+	if (prog)
+		ret =3D bpf_dump_run_prog(prog, &ctx);
+
+	return ret =3D=3D 0 ? 0 : -EINVAL;
+}
+
+static void bpf_map_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpfdump_seq_map_info *info =3D seq->private;
+
+	if (!v)
+		bpf_map_seq_show(seq, v);
+
+	if (info->map) {
+		__bpf_map_put(info->map, true);
+		info->map =3D NULL;
+	}
+}
+
+static const struct seq_operations bpf_map_seq_ops =3D {
+	.start	=3D bpf_map_seq_start,
+	.next	=3D bpf_map_seq_next,
+	.stop	=3D bpf_map_seq_stop,
+	.show	=3D bpf_map_seq_show,
+};
+
+static int __init bpf_map_dump_init(void)
+{
+	struct bpf_dump_reg reg_info =3D {
+		.target			=3D "bpf_map",
+		.target_proto 		=3D "__bpfdump__bpf_map",
+		.prog_ctx_type_name	=3D "bpfdump__bpf_map",
+		.seq_ops		=3D &bpf_map_seq_ops,
+		.seq_priv_size		=3D sizeof(struct bpfdump_seq_map_info),
+		.target_feature		=3D 0,
+	};
+
+	return bpf_dump_reg_target(&reg_info);
+}
+
+late_initcall(bpf_map_dump_init);
--=20
2.24.1

