Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33ADC1CC37C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 19:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgEIR7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:59:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62520 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728469AbgEIR7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:59:10 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049HrtMm016343
        for <netdev@vger.kernel.org>; Sat, 9 May 2020 10:59:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wuGOVWNZN+b7BwsJWWJzocwxX0Kb1JsXdXMhgR12GxQ=;
 b=QkZqisOdmKG4R6scZEzTqXz7zwUZ02oB74ka9u5XMoviP5TRkZCEwB4RfpSqNSectZZt
 vgWY2IcoWwJ/29Gb/KhSgwPlloipk2YUVKNqmhKg7Px2+jXp6+nN9Oc45XyD88uDOokk
 igN8JrUl56NwL028+ToIU8ebrVl5q0Ri5qY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30wtbfscc2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 10:59:09 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 10:59:08 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 045D937008E2; Sat,  9 May 2020 10:59:02 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 04/21] bpf: support bpf tracing/iter programs for BPF_LINK_UPDATE
Date:   Sat, 9 May 2020 10:59:02 -0700
Message-ID: <20200509175902.2475262-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200509175859.2474608-1-yhs@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_06:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 adultscore=0
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005090155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added BPF_LINK_UPDATE support for tracing/iter programs.
This way, a file based bpf iterator, which holds a reference
to the link, can have its bpf program updated without
creating new files.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/bpf_iter.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 03f5832909db..0542a243b78c 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -23,6 +23,9 @@ struct bpf_iter_link {
 static struct list_head targets =3D LIST_HEAD_INIT(targets);
 static DEFINE_MUTEX(targets_mutex);
=20
+/* protect bpf_iter_link changes */
+static DEFINE_MUTEX(link_mutex);
+
 int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
 {
 	struct bpf_iter_target_info *tinfo;
@@ -111,9 +114,37 @@ static void bpf_iter_link_dealloc(struct bpf_link *l=
ink)
 	kfree(iter_link);
 }
=20
+static int bpf_iter_link_replace(struct bpf_link *link,
+				 struct bpf_prog *new_prog,
+				 struct bpf_prog *old_prog)
+{
+	int ret =3D 0;
+
+	mutex_lock(&link_mutex);
+	if (old_prog && link->prog !=3D old_prog) {
+		ret =3D -EPERM;
+		goto out_unlock;
+	}
+
+	if (link->prog->type !=3D new_prog->type ||
+	    link->prog->expected_attach_type !=3D new_prog->expected_attach_typ=
e ||
+	    link->prog->aux->attach_btf_id !=3D new_prog->aux->attach_btf_id) {
+		ret =3D -EINVAL;
+		goto out_unlock;
+	}
+
+	old_prog =3D xchg(&link->prog, new_prog);
+	bpf_prog_put(old_prog);
+
+out_unlock:
+	mutex_unlock(&link_mutex);
+	return ret;
+}
+
 static const struct bpf_link_ops bpf_iter_link_lops =3D {
 	.release =3D bpf_iter_link_release,
 	.dealloc =3D bpf_iter_link_dealloc,
+	.update_prog =3D bpf_iter_link_replace,
 };
=20
 int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og)
--=20
2.24.1

