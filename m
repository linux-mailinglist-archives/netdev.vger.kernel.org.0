Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91843B4998
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 22:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFYUHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 16:07:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27796 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229873AbhFYUHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 16:07:18 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 15PK4LAZ001695
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:04:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=BCXA1is2SgfRbBG9IuoIHQcqTpKa0CM3/e/1g+2tH20=;
 b=TuTaZPWPpM9Ey4AEBjZ0j6/1t9cDjawfQdV5ECpbIxlSPoAGbKw12ItDUzcOp3VRXQ49
 U19iCSA6yoK7/K652BApNjBQ+SOCGaGf9aMpOEV5TroBYQy/6abDt4N7olKj+9jvgKh8
 tg5EF0DzUMyKbhiL8fTHX0ZrkmN65xlCXu0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 39d253xpe0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:04:56 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 13:04:55 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 74D1E2942295; Fri, 25 Jun 2021 13:04:52 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH bpf-next 1/8] tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos
Date:   Fri, 25 Jun 2021 13:04:52 -0700
Message-ID: <20210625200452.723506-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210625200446.723230-1-kafai@fb.com>
References: <20210625200446.723230-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 9L_88lny7u7a8RVf2OgASLI8YsoQ8VhT
X-Proofpoint-GUID: 9L_88lny7u7a8RVf2OgASLI8YsoQ8VhT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_07:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=964 mlxscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250123
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
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/tcp_ipv4.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6cb8e269f1ab..7a49427eefbf 100644
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

