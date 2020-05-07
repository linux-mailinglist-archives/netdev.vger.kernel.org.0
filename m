Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611441C81A2
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 07:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgEGFj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 01:39:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19088 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726026AbgEGFjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 01:39:25 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0475XbSQ008888
        for <netdev@vger.kernel.org>; Wed, 6 May 2020 22:39:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=iOuYplLj40uLSzHCtthHRPo29UubTX2x6FKjOUkfBVA=;
 b=C6iyPlHAYjhk4SHMPJt0kH9ZsBBLcLJe9csga4MsqgD1SFjMsSadpaiK2GlL8X8RQBoj
 RuBWK0ezFgKdtb5FmDL4EghQeny4hq9PmC17dMxnJ//iV1AzAhFyIqgp91GmPK907OEq
 DJHCizV+gpKyl/57StetEqkefdnFqNSvDds= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30ufak86ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 22:39:24 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 22:39:23 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 961E43701B99; Wed,  6 May 2020 22:39:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 05/21] bpf: implement bpf_seq_read() for bpf iterator
Date:   Wed, 6 May 2020 22:39:20 -0700
Message-ID: <20200507053920.1542763-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200507053915.1542140-1-yhs@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_02:2020-05-05,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=636 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070043
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

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/bpf_iter.c | 118 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 0542a243b78c..f198597b0ea4 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -26,6 +26,124 @@ static DEFINE_MUTEX(targets_mutex);
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
+	if (IS_ERR_OR_NULL(p))
+		goto stop;
+
+	err =3D seq->op->show(seq, p);
+	if (err > 0) {
+		seq->count =3D 0;
+	} else if (err < 0 || seq_has_overflowed(seq)) {
+		if (!err)
+			err =3D -E2BIG;
+		seq->count =3D 0;
+		seq->op->stop(seq, p);
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
+		if (IS_ERR_OR_NULL(p)) {
+			err =3D PTR_ERR(p);
+			break;
+		}
+		if (seq->count >=3D size)
+			break;
+
+		err =3D seq->op->show(seq, p);
+		if (err > 0) {
+			seq->count =3D offs;
+		} else if (err < 0 || seq_has_overflowed(seq)) {
+			seq->count =3D offs;
+			if (!err)
+				err =3D -E2BIG;
+			if (offs =3D=3D 0) {
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

