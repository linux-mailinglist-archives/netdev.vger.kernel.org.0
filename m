Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507E72C9397
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730994AbgLAAE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:04:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57986 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730967AbgLAAE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:04:28 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUNxUZW004332
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:03:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=neH6M7uZ6eS3cWKZFuRjyvXlhnKfm8cM5Ms6tJv5RkI=;
 b=n57QBKrJSEWyJX1Rjkm/02e7MVfDF2LIQYl5zwI6Ddg3RX5EYSbxPto99/maHAFq9Rp6
 IM1N96LnbzWPh2HXIe6zk8mYnWPkHjTK82bFwpwsW2vihpYRzojuQUHKwgzaJKN5dTol
 eirjmGZ0WBSDosFRmW7cVmwu5GqzaAY2PPM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 355agsg4w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:03:47 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 16:03:46 -0800
Received: by devvm3178.ftw3.facebook.com (Postfix, from userid 201728)
        id 151D34752A007; Mon, 30 Nov 2020 16:03:40 -0800 (PST)
From:   Prankur gupta <prankgup@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 1/2] bpf: Adds support for setting window clamp
Date:   Mon, 30 Nov 2020 16:03:38 -0800
Message-ID: <20201201000339.3310760-2-prankgup@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201000339.3310760-1-prankgup@fb.com>
References: <20201201000339.3310760-1-prankgup@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 phishscore=0 impostorscore=0 mlxlogscore=665 spamscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 suspectscore=13 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300150
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a new bpf_setsockopt for TCP sockets, TCP_BPF_WINDOW_CLAMP,
which sets the maximum receiver window size. It will be useful for
limiting receiver window based on RTT.

Signed-off-by: Prankur gupta <prankgup@fb.com>
---
 net/core/filter.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2ca5eecebacf..cb006962b677 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4910,6 +4910,14 @@ static int _bpf_setsockopt(struct sock *sk, int le=
vel, int optname,
 				tp->notsent_lowat =3D val;
 				sk->sk_write_space(sk);
 				break;
+			case TCP_WINDOW_CLAMP:
+				if (val <=3D 0)
+					ret =3D -EINVAL;
+				else
+					tp->window_clamp =3D
+						max_t(int, val,
+						      SOCK_MIN_RCVBUF / 2);
+				break;
 			default:
 				ret =3D -EINVAL;
 			}
--=20
2.24.1

