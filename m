Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877702CA88B
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgLAQol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:44:41 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726485AbgLAQol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 11:44:41 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1GLwou024118
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 08:44:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+vg20QsxrHjWRyiB4huPhOw6IpTsigJrXdHgbBxUf9M=;
 b=o+zKoJFPi2NP5qJzoNBsQs4Ne74Y1riZOzXP+zEWbNIERbBGGJDef065U3b+C/H4x9Ue
 moRSFuE1g/YHg0XiVNVBODNHF7neucO5shb0G5oWijT+tmIVQA2iG1KXvlMUARNpOEIO
 nE551CLAxJntKuDbkXaQXOnRYvO8fBg/Iv0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 354hsykek4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 08:44:00 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 08:43:58 -0800
Received: by devvm3178.ftw3.facebook.com (Postfix, from userid 201728)
        id 0EC914757EBAF; Tue,  1 Dec 2020 08:43:58 -0800 (PST)
From:   Prankur gupta <prankgup@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 1/2] bpf: Adds support for setting window clamp
Date:   Tue, 1 Dec 2020 08:43:56 -0800
Message-ID: <20201201164357.2623610-2-prankgup@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201164357.2623610-1-prankgup@fb.com>
References: <20201201164357.2623610-1-prankgup@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=13 mlxlogscore=649
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012010102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a new bpf_setsockopt for TCP sockets, TCP_BPF_WINDOW_CLAMP,
which sets the maximum receiver window size. It will be useful for
limiting receiver window based on RTT.

Signed-off-by: Prankur gupta <prankgup@fb.com>
---
 net/core/filter.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2ca5eecebacf..8c52ffae7b0c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4910,6 +4910,19 @@ static int _bpf_setsockopt(struct sock *sk, int le=
vel, int optname,
 				tp->notsent_lowat =3D val;
 				sk->sk_write_space(sk);
 				break;
+			case TCP_WINDOW_CLAMP:
+				if (!val) {
+					if (sk->sk_state !=3D TCP_CLOSE) {
+						ret =3D -EINVAL;
+						break;
+					}
+					tp->window_clamp =3D 0;
+				} else {
+					tp->window_clamp =3D
+						val < SOCK_MIN_RCVBUF / 2 ?
+						SOCK_MIN_RCVBUF / 2 : val;
+				}
+				break;
 			default:
 				ret =3D -EINVAL;
 			}
--=20
2.24.1

