Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1A61C1D6F
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 20:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbgEAS43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 14:56:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23596 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730074AbgEAS42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 14:56:28 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041IeUwo011940
        for <netdev@vger.kernel.org>; Fri, 1 May 2020 11:56:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=1UibhM8/Ws+BT/moLSKnrq0pQFjfgiKjje2D7orwhR8=;
 b=ZjyIHWLWKXO2DqwGEEyyR9SKWnNXipQOSx20DHe45aJgILwMs9C7QglCS4hLYMyw0gvi
 KXPaJuRN9eDzIg6jxng2VZLeGOReWjJ6hxv0Li75PZKrvfq+ntLJ8U3ebMV8UcAYIxJt
 alanCgjClXOJNFCJAQB+2d3ekUH1dOFYTd4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30r7dyw5fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 11:56:28 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 1 May 2020 11:56:26 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9BC592EC2F4C; Fri,  1 May 2020 11:56:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        <syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next] bpf: fix use-after-free of bpf_link when priming half-fails
Date:   Fri, 1 May 2020 11:56:22 -0700
Message-ID: <20200501185622.3088964-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_11:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 suspectscore=25 clxscore=1015 phishscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 bulkscore=0 mlxlogscore=632 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005010141
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

Fix this by first allocating ID and only then allocating file. Adding ID =
to
link_idr is ok, because link at that point still doesn't have its ID set,=
 so
no user-space process can create a new FD for it.

Suggested-by: Martin KaFai Lau <kafai@fb.com>
Fixes: a3b80e107894 ("bpf: Allocate ID for bpf_link")
Reported-by: syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/syscall.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c75b2dd2459c..108c8051dff2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2348,19 +2348,20 @@ int bpf_link_prime(struct bpf_link *link, struct =
bpf_link_primer *primer)
 	if (fd < 0)
 		return fd;
=20
-	file =3D anon_inode_getfile("bpf_link", &bpf_link_fops, link, O_CLOEXEC=
);
-	if (IS_ERR(file)) {
-		put_unused_fd(fd);
-		return PTR_ERR(file);
-	}
=20
 	id =3D bpf_link_alloc_id(link);
 	if (id < 0) {
 		put_unused_fd(fd);
-		fput(file);
 		return id;
 	}
=20
+	file =3D anon_inode_getfile("bpf_link", &bpf_link_fops, link, O_CLOEXEC=
);
+	if (IS_ERR(file)) {
+		bpf_link_free_id(id);
+		put_unused_fd(fd);
+		return PTR_ERR(file);
+	}
+
 	primer->link =3D link;
 	primer->file =3D file;
 	primer->fd =3D fd;
--=20
2.24.1

