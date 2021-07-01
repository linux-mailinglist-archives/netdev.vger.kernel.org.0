Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F3C3B96E2
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhGAUIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:08:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51044 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233478AbhGAUIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 16:08:17 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 161Jwjv4001206
        for <netdev@vger.kernel.org>; Thu, 1 Jul 2021 13:05:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=4JzmU94JfPnQkwQ4bDUq+83XjyG3dTzA3zR1RCB4Jbw=;
 b=gtPkXTJCNkbTcpgKTZn5NfUGJly2QljUUcqF7bz7p0PBf0388mi7KXWALEBsJbPA0nFw
 1xdVqmkeGIUPDKhTA9oGpMx0o8e1vcmAoMXwaZoYMuUzH+Tsv/WmGDAxX56HYPsRX8hL
 0f40URaAhOwOoeGuKFqCmPXb6qJgYYQkBu0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39h1wyxbr6-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 13:05:46 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 13:05:44 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id DAC172940BB9; Thu,  1 Jul 2021 13:05:41 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH v2 bpf-next 1/8] tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos
Date:   Thu, 1 Jul 2021 13:05:41 -0700
Message-ID: <20210701200541.1033917-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210701200535.1033513-1-kafai@fb.com>
References: <20210701200535.1033513-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: c8A7o1XOoGfqlE_f7ROz5F7xu4UMNcd9
X-Proofpoint-GUID: c8A7o1XOoGfqlE_f7ROz5F7xu4UMNcd9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-01_12:2021-07-01,2021-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 mlxlogscore=958
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107010117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

st->bucket stores the current bucket number.
st->offset stores the offset within this bucket that is the sk to be
seq_show().  Thus, st->offset only makes sense within the same
st->bucket.

These two variables are an optimization for the common no-lseek case.
When resuming the seq_file iteration (i.e. seq_start()),
tcp_seek_last_pos() tries to continue from the st->offset
at bucket st->bucket.

However, it is possible that the bucket pointed by st->bucket
has changed and st->offset may end up skipping the whole st->bucket
without finding a sk.  In this case, tcp_seek_last_pos() currently
continues to satisfy the offset condition in the next (and incorrect)
bucket.  Instead, regardless of the offset value, the first sk of the
next bucket should be returned.  Thus, "bucket =3D=3D st->bucket" check i=
s
added to tcp_seek_last_pos().

The chance of hitting this is small and the issue is a decade old,
so targeting for the next tree.

Fixes: a8b690f98baf ("tcp: Fix slowness in read /proc/net/tcp")
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/tcp_ipv4.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e66ad6bfe808..26b7b2056585 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2451,6 +2451,7 @@ static void *tcp_get_idx(struct seq_file *seq, loff=
_t pos)
 static void *tcp_seek_last_pos(struct seq_file *seq)
 {
 	struct tcp_iter_state *st =3D seq->private;
+	int bucket =3D st->bucket;
 	int offset =3D st->offset;
 	int orig_num =3D st->num;
 	void *rc =3D NULL;
@@ -2461,7 +2462,7 @@ static void *tcp_seek_last_pos(struct seq_file *seq=
)
 			break;
 		st->state =3D TCP_SEQ_STATE_LISTENING;
 		rc =3D listening_get_next(seq, NULL);
-		while (offset-- && rc)
+		while (offset-- && rc && bucket =3D=3D st->bucket)
 			rc =3D listening_get_next(seq, rc);
 		if (rc)
 			break;
@@ -2472,7 +2473,7 @@ static void *tcp_seek_last_pos(struct seq_file *seq=
)
 		if (st->bucket > tcp_hashinfo.ehash_mask)
 			break;
 		rc =3D established_get_first(seq);
-		while (offset-- && rc)
+		while (offset-- && rc && bucket =3D=3D st->bucket)
 			rc =3D established_get_next(seq, rc);
 	}
=20
--=20
2.30.2

