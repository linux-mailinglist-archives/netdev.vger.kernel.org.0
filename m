Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC18E1A2C35
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgDHXZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:25:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43278 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726504AbgDHXZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:25:34 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038NODYC025755
        for <netdev@vger.kernel.org>; Wed, 8 Apr 2020 16:25:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=bMHph6GvtAI2lVXYP7KfFodEFgqg55TiGWyhtZe5jOE=;
 b=FfACUAxloiUjYyqqM9zx9WOuPi9RrP2+twj1fjzPBw3F8nFam3bXD60YbrytoihtL24F
 ExX5i4JZBLvjaq7eu39AcL5SbOaTHtc1gEHdLGkPzgLc15j5GXJHI0IyGEnXHnNuCa2+
 VbDrzUjEip0zwacFIJFwYZiOrlSoo2i7yQQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3091r0e35n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 16:25:33 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 8 Apr 2020 16:25:33 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id B19073700D98; Wed,  8 Apr 2020 16:25:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 07/16] bpf: add bpf_map target
Date:   Wed, 8 Apr 2020 16:25:28 -0700
Message-ID: <20200408232528.2675856-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200408232520.2675265-1-yhs@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-08_09:2020-04-07,2020-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 mlxlogscore=932 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080164
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
 kernel/bpf/syscall.c | 104 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b5e4f18cc633..62a872a406ca 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3797,3 +3797,107 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __u=
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
+static void bpf_map_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpfdump_seq_map_info *info =3D seq->private;
+
+	if (info->map) {
+		__bpf_map_put(info->map, true);
+		info->map =3D NULL;
+	}
+}
+
+static int bpf_map_seq_show(struct seq_file *seq, void *v)
+{
+	struct {
+		struct bpf_map *map;
+		struct seq_file *seq;
+		u64 seq_num;
+	} ctx =3D {
+		.map =3D v,
+		.seq =3D seq,
+	};
+	struct bpf_prog *prog;
+	int ret;
+
+	prog =3D bpf_dump_get_prog(seq, sizeof(struct bpfdump_seq_map_info),
+				 &ctx.seq_num);
+	ret =3D bpf_dump_run_prog(prog, &ctx);
+
+	return ret =3D=3D 0 ? 0 : -EINVAL;
+}
+
+static const struct seq_operations bpf_map_seq_ops =3D {
+	.start	=3D bpf_map_seq_start,
+	.next	=3D bpf_map_seq_next,
+	.stop	=3D bpf_map_seq_stop,
+	.show	=3D bpf_map_seq_show,
+};
+
+int __init bpfdump__bpf_map(struct bpf_map *map, struct seq_file *seq,
+			    u64 seq_num)
+{
+	return 0;
+}
+
+static int __init bpf_map_dump_init(void)
+{
+	return bpf_dump_reg_target("bpf_map",
+				   "bpfdump__bpf_map",
+				   &bpf_map_seq_ops,
+				   sizeof(struct bpfdump_seq_map_info), 0);
+}
+
+late_initcall(bpf_map_dump_init);
--=20
2.24.1

