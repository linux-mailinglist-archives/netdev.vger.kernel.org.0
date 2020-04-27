Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492B91BAEEF
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgD0UMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:12:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14618 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726285AbgD0UMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:12:39 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RK8FdP022602
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=aV4IlLZ1Pn8nevkUO0Q4IsIL0wp9STZRdrqXvAfOdJ8=;
 b=mCiu5d8OaAMBz86FIC9CtSQEiSSc07F4zh93jZRYzssarIdjP6yCXJVAUQ4M5Co9TZV3
 UPfKbgd4OJhzhKNsB7a9g8wxHWswn64piHVIiGEY2tzozbqYLQkO7IcD2a68v0NdtA5L
 XH9wDdTklZ4nM+aaeLH3mN3R4J6Kkncoa7I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n54ea3mv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:39 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:38 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 7144F3700880; Mon, 27 Apr 2020 13:12:35 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 01/19] net: refactor net assignment for seq_net_private structure
Date:   Mon, 27 Apr 2020 13:12:35 -0700
Message-ID: <20200427201235.2994615-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=896 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004270164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor assignment of "net" in seq_net_private structure
in proc_net.c to a helper function. The helper later will
be used by bpfdump.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 fs/proc/proc_net.c           | 5 ++---
 include/linux/seq_file_net.h | 8 ++++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 4888c5224442..aee07c19cf8b 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -75,9 +75,8 @@ static int seq_open_net(struct inode *inode, struct fil=
e *file)
 		put_net(net);
 		return -ENOMEM;
 	}
-#ifdef CONFIG_NET_NS
-	p->net =3D net;
-#endif
+
+	set_seq_net_private(p, net);
 	return 0;
 }
=20
diff --git a/include/linux/seq_file_net.h b/include/linux/seq_file_net.h
index 0fdbe1ddd8d1..0ec4a18b9aca 100644
--- a/include/linux/seq_file_net.h
+++ b/include/linux/seq_file_net.h
@@ -35,4 +35,12 @@ static inline struct net *seq_file_single_net(struct s=
eq_file *seq)
 #endif
 }
=20
+static inline void set_seq_net_private(struct seq_net_private *p,
+				       struct net *net)
+{
+#ifdef CONFIG_NET_NS
+	p->net =3D net;
+#endif
+}
+
 #endif
--=20
2.24.1

