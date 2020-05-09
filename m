Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6571CC36E
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 19:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgEIR7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:59:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33310 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728620AbgEIR7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:59:15 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049HuSmN026231
        for <netdev@vger.kernel.org>; Sat, 9 May 2020 10:59:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=MIHue5K3OZMd7Kk+fCOsQScZEYeHoH21Ya1hUHGApy0=;
 b=U+uvJP8cmEMWiS35hWFeBInqbQRP1YQIea6cfsQnqmGUY9PfetklXX43QvM4FVSsi5iP
 i8vKR4XeYo7PmYGHbzrLSSWEkc4WetX3Oaha5A169BaUHUaWyunFVlJ24iwyAEW+XWIS
 2pVnG+JQCq/RP2ft25f6ADVTnS2DQfatZd0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30wsbq1hb3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 10:59:14 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 10:59:11 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 3E97937008E2; Sat,  9 May 2020 10:59:04 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 05/21] bpf: implement bpf_seq_read() for bpf iterator
Date:   Sat, 9 May 2020 10:59:04 -0700
Message-ID: <20200509175904.2475468-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200509175859.2474608-1-yhs@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_06:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0
 phishscore=0 clxscore=1015 mlxscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=650 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf iterator uses seq_file to provide a lossless
way to transfer data to user space. But we want to call
bpf program after all objects have been traversed, and
bpf program may write additional data to the
seq_file buffer. The current seq_read() does not work
for this use case.

Besides allowing stop() function to write to the buffer,
the bpf_seq_read() also fixed the buffer size to one page.
If any single call of show() or stop() will emit data
more than one page to cause overflow, -E2BIG error code
will be returned to user space.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/bpf_iter.c | 123 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 0542a243b78c..832973ee80fa 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -26,6 +26,129 @@ static DEFINE_MUTEX(targets_mutex);
 /* protect bpf_iter_link changes */
 static DEFINE_MUTEX(link_mutex);
=20
+/* bpf_seq_read, a customized and simpler version for bpf iterator.
+ * no_llseek is assumed for this file.
+ * The following are differences from seq_read():
+ *  . fixed buffer size (PAGE_SIZE)
+ *  . assuming no_llseek
+ *  . stop() may call bpf program, handling potential overflow there
+ */
+static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t =
size,
+			    loff_t *ppos)
+{
+	struct seq_file *seq =3D file->private_data;
+	size_t n, offs, copied =3D 0;
+	int err =3D 0;
+	void *p;
+
+	mutex_lock(&seq->lock);
+
+	if (!seq->buf) {
+		seq->size =3D PAGE_SIZE;
+		seq->buf =3D kmalloc(seq->size, GFP_KERNEL);
+		if (!seq->buf) {
+			err =3D -ENOMEM;
+			goto done;
+		}
+	}
+
+	if (seq->count) {
+		n =3D min(seq->count, size);
+		err =3D copy_to_user(buf, seq->buf + seq->from, n);
+		if (err) {
+			err =3D -EFAULT;
+			goto done;
+		}
+		seq->count -=3D n;
+		seq->from +=3D n;
+		copied =3D n;
+		goto done;
+	}
+
+	seq->from =3D 0;
+	p =3D seq->op->start(seq, &seq->index);
+	if (!p)
+		goto stop;
+	if (IS_ERR(p)) {
+		err =3D PTR_ERR(p);
+		seq->op->stop(seq, p);
+		seq->count =3D 0;
+		goto done;
+	}
+
+	err =3D seq->op->show(seq, p);
+	if (err > 0) {
+		seq->count =3D 0;
+	} else if (err < 0 || seq_has_overflowed(seq)) {
+		if (!err)
+			err =3D -E2BIG;
+		seq->op->stop(seq, p);
+		seq->count =3D 0;
+		goto done;
+	}
+
+	while (1) {
+		loff_t pos =3D seq->index;
+
+		offs =3D seq->count;
+		p =3D seq->op->next(seq, p, &seq->index);
+		if (pos =3D=3D seq->index) {
+			pr_info_ratelimited("buggy seq_file .next function %ps "
+				"did not updated position index\n",
+				seq->op->next);
+			seq->index++;
+		}
+
+		if (IS_ERR_OR_NULL(p))
+			break;
+
+		if (seq->count >=3D size)
+			break;
+
+		err =3D seq->op->show(seq, p);
+		if (err > 0) {
+			seq->count =3D offs;
+		} else if (err < 0 || seq_has_overflowed(seq)) {
+			seq->count =3D offs;
+			if (offs =3D=3D 0) {
+				if (!err)
+					err =3D -E2BIG;
+				seq->op->stop(seq, p);
+				goto done;
+			}
+			break;
+		}
+	}
+stop:
+	offs =3D seq->count;
+	/* bpf program called if !p */
+	seq->op->stop(seq, p);
+	if (!p && seq_has_overflowed(seq)) {
+		seq->count =3D offs;
+		if (offs =3D=3D 0) {
+			err =3D -E2BIG;
+			goto done;
+		}
+	}
+
+	n =3D min(seq->count, size);
+	err =3D copy_to_user(buf, seq->buf, n);
+	if (err) {
+		err =3D -EFAULT;
+		goto done;
+	}
+	copied =3D n;
+	seq->count -=3D n;
+	seq->from =3D n;
+done:
+	if (!copied)
+		copied =3D err;
+	else
+		*ppos +=3D copied;
+	mutex_unlock(&seq->lock);
+	return copied;
+}
+
 int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
 {
 	struct bpf_iter_target_info *tinfo;
--=20
2.24.1

