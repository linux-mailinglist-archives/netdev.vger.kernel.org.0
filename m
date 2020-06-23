Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440CC204A84
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbgFWHIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:08:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62746 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731143AbgFWHI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 03:08:28 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N74aJ3024010
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 00:08:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=G8U8wLrivL4Bm9XBrSH1qxyAz1VKRcKWF+DdWmgC89Y=;
 b=LPJ22L+FI8aKXka1ibGAObYe4nxbwiVZzzHwFNj9Jrrc2xgKBaVjzFmAYR3G3AIS/D8M
 JCyq3zjepc48YpFDZJOnb2cXvCYfkbySe1ttTrqEJWLQyrFQsVPmAKyrt7Hy0BntvFSd
 PeF/7EcffmmyRDPppgzZw1C1B/abZ+yoWc0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31sg6scax3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 00:08:26 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 00:08:25 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id BD84362E50B5; Tue, 23 Jun 2020 00:08:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/3] bpf: allow %pB in bpf_seq_printf()
Date:   Tue, 23 Jun 2020 00:08:01 -0700
Message-ID: <20200623070802.2310018-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623070802.2310018-1-songliubraving@fb.com>
References: <20200623070802.2310018-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_04:2020-06-22,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=803 lowpriorityscore=0
 phishscore=0 spamscore=0 clxscore=1015 priorityscore=1501 suspectscore=8
 impostorscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes it easy to dump stack trace with bpf_seq_printf().

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/trace/bpf_trace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 2c13bcb5c2bce..ced3176801ae8 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -636,7 +636,8 @@ BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char=
 *, fmt, u32, fmt_size,
 		if (fmt[i] =3D=3D 'p') {
 			if (fmt[i + 1] =3D=3D 0 ||
 			    fmt[i + 1] =3D=3D 'K' ||
-			    fmt[i + 1] =3D=3D 'x') {
+			    fmt[i + 1] =3D=3D 'x' ||
+			    fmt[i + 1] =3D=3D 'B') {
 				/* just kernel pointers */
 				params[fmt_cnt] =3D args[fmt_cnt];
 				fmt_cnt++;
--=20
2.24.1

