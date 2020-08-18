Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650C6248BDE
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 18:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgHRQpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 12:45:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26490 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728230AbgHRQpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 12:45:03 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IGhufk021143
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 09:45:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=uCbEw0zMIkaLhgMxiOrg1zEwe6M/85iawE/FGmZDTrI=;
 b=amaQgC07o1/+ZcoIppiqr5OYJkuA4BpfFY4rmOjUj4WKjrt+X4HiilgvyrvdhWO4JsdV
 EjIne4+lxIZ5kdA1lwXkt15X+NI8YtSZUV6nivvHxXqBMZaFKxKI4Z6L49q1vmq7dn8A
 zrb++9+UZ2+KUmMKALA8maUISsd40GUuDyI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304nxknk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 09:45:01 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 09:45:01 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 615692EC5DE0; Tue, 18 Aug 2020 09:44:58 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] libbpf: fix build on ppc64le architecture
Date:   Tue, 18 Aug 2020 09:44:56 -0700
Message-ID: <20200818164456.1181661-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_11:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180119
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ppc64le we get the following warning:

  In file included from btf_dump.c:16:0:
  btf_dump.c: In function =E2=80=98btf_dump_emit_struct_def=E2=80=99:
  ../include/linux/kernel.h:20:17: error: comparison of distinct pointer =
types lacks a cast [-Werror]
    (void) (&_max1 =3D=3D &_max2);  \
                   ^
  btf_dump.c:882:11: note: in expansion of macro =E2=80=98max=E2=80=99
      m_sz =3D max(0LL, btf__resolve_size(d->btf, m->type));
             ^~~

Fix by explicitly casting to __s64, which is a return type from
btf__resolve_size().

Fixes: 702eddc77a90 ("libbpf: Handle GCC built-in types for Arm NEON")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index fe39bd774697..57c00fa63932 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -879,7 +879,7 @@ static void btf_dump_emit_struct_def(struct btf_dump =
*d,
 			btf_dump_printf(d, ": %d", m_sz);
 			off =3D m_off + m_sz;
 		} else {
-			m_sz =3D max(0LL, btf__resolve_size(d->btf, m->type));
+			m_sz =3D max((__s64)0, btf__resolve_size(d->btf, m->type));
 			off =3D m_off + m_sz * 8;
 		}
 		btf_dump_printf(d, ";");
--=20
2.24.1

