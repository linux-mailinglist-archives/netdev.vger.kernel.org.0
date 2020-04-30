Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7351C06B5
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgD3TqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:46:18 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5164 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbgD3TqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:46:18 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UJSCF8021030
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 12:46:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=sE55d1pAoLMzj91gtB1sdCjP8AgbIwGaTfF3rQ76s64=;
 b=UBGd/sN31Nu+nEk7Z28W6F7LyNM67NtaZQ84KFmiWr+ZdSZhwazl+MuiCeH541wFkNha
 EJi0Go5SkdQISohp2CVWCXlYmTtzJMY0E+IYN0Ym7GlI41GU6dOl3sQLbNuOabq/h1aO
 XOjXHjKmSf1qcyrbc08ClJT0OMfOiTZufDA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30qd20r3fy-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 12:46:17 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 30 Apr 2020 12:46:16 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CD9812EC2F29; Thu, 30 Apr 2020 12:46:09 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        <syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: fix use-after-free of bpf_link when priming half-fails
Date:   Thu, 30 Apr 2020 12:46:08 -0700
Message-ID: <20200430194609.1216836-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_12:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 suspectscore=25 priorityscore=1501
 mlxlogscore=465 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bpf_link_prime() succeeds to allocate new anon file, but then fails to
allocate ID for it, link priming is considered to be failed and user is
supposed ot be able to directly kfree() bpf_link, because it was never ex=
posed
to user-space.

But at that point file already keeps a pointer to bpf_link and will event=
ually
call bpf_link_release(), so if bpf_link was kfree()'d by caller, that wou=
ld
lead to use-after-free.

Fix this by creating file with NULL private_data until ID allocation succ=
eeds.
Only then set private_data to bpf_link. Teach bpf_link_release() to recog=
nize
such situation and do nothing.

Fixes: a3b80e107894 ("bpf: Allocate ID for bpf_link")
Reported-by: syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/syscall.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c75b2dd2459c..ce00df64a4d4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2267,7 +2267,12 @@ static int bpf_link_release(struct inode *inode, s=
truct file *filp)
 {
 	struct bpf_link *link =3D filp->private_data;
=20
-	bpf_link_put(link);
+	/* if bpf_link_prime() allocated file, but failed to allocate ID,
+	 * file->private_data will be null and by now link itself is kfree()'d
+	 * directly, so just do nothing in such case.
+	 */
+	if (link)
+		bpf_link_put(link);
 	return 0;
 }
=20
@@ -2348,7 +2353,7 @@ int bpf_link_prime(struct bpf_link *link, struct bp=
f_link_primer *primer)
 	if (fd < 0)
 		return fd;
=20
-	file =3D anon_inode_getfile("bpf_link", &bpf_link_fops, link, O_CLOEXEC=
);
+	file =3D anon_inode_getfile("bpf_link", &bpf_link_fops, NULL, O_CLOEXEC=
);
 	if (IS_ERR(file)) {
 		put_unused_fd(fd);
 		return PTR_ERR(file);
@@ -2357,10 +2362,15 @@ int bpf_link_prime(struct bpf_link *link, struct =
bpf_link_primer *primer)
 	id =3D bpf_link_alloc_id(link);
 	if (id < 0) {
 		put_unused_fd(fd);
-		fput(file);
+		fput(file); /* won't put link, so user can kfree() it */
 		return id;
 	}
=20
+	/* Link priming succeeded, point file's private data to link now.
+	 * After this caller has to call bpf_link_cleanup() to free link.
+	 */
+	file->private_data =3D link;
+
 	primer->link =3D link;
 	primer->file =3D file;
 	primer->fd =3D fd;
--=20
2.24.1

