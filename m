Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3A71CF9D5
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbgELPxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:53:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55972 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727795AbgELPxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:53:15 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CFpMr7016651
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:53:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=B0la6kbxVl951yfPwl0NKZpbJioGf0wtnobq3n9O/bY=;
 b=LH4keD8QGtFs8lJlFn2npsBLdCfBNiLZ0KGYeO9Mckzq2l+Kk96WAVde66juZISVuPbr
 TCYNT3I5AwIYDu8kYe6tGXu8nyY9sIG/2bZ6NeH07Qlsin14q3wC1Gv0BShdDZwjftab
 IgKSuv4Pygm/vym+aacqobu+o8IP7Ep9cA8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30xcc3w243-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:53:14 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 08:52:44 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 0EB973700839; Tue, 12 May 2020 08:52:36 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/8] bpf: add WARN_ONCE if bpf_seq_read show() return a positive number
Date:   Tue, 12 May 2020 08:52:36 -0700
Message-ID: <20200512155236.1080458-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200512155232.1080167-1-yhs@fb.com>
References: <20200512155232.1080167-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_05:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In seq_read() implementation, a positive integer return value
of seq_ops->show() indicates that the current object seq_file
buffer is discarded and next object should be checked.
bpf_seq_read() implemented in a similar way if show()
returns a positive integer value.

But for bpf_seq_read(), show() didn't return positive integer for
all currently supported targets. Let us add a WARN_ONCE for
such cases so we can get an alert when things are changed.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/bpf_iter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 0a45a6cdfabd..b0c8b3bdf3b0 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -120,6 +120,7 @@ static ssize_t bpf_seq_read(struct file *file, char _=
_user *buf, size_t size,
=20
 	err =3D seq->op->show(seq, p);
 	if (err > 0) {
+		WARN_ONCE(1, "seq_ops->show() returns %d\n", err);
 		/* object is skipped, decrease seq_num, so next
 		 * valid object can reuse the same seq_num.
 		 */
@@ -156,6 +157,7 @@ static ssize_t bpf_seq_read(struct file *file, char _=
_user *buf, size_t size,
=20
 		err =3D seq->op->show(seq, p);
 		if (err > 0) {
+			WARN_ONCE(1, "seq_ops->show() returns %d\n", err);
 			bpf_iter_dec_seq_num(seq);
 			seq->count =3D offs;
 		} else if (err < 0 || seq_has_overflowed(seq)) {
--=20
2.24.1

