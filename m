Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4D725D040
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 06:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgIDEQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 00:16:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38524 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726194AbgIDEQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 00:16:25 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0844B1rC006803
        for <netdev@vger.kernel.org>; Thu, 3 Sep 2020 21:16:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=n3DyQ6hup2hgi3k95ilMSadcTvm3ef7F/g6ukHpZaoU=;
 b=ECHunJtm1CeHT+LMklmv+sEnQgdrgu9Zw3kemuKxe6w6yJaOUjk0+TmTHSncfHbMI+Gh
 OePuHjOSSgupJZKhiQhBa7eSmZPmirJOjJQ/8a0aEWHZTTv8WvHRujfv9S+fobDpXWI+
 WZllFIxaUusO25CKQUXiJyR4OGPljcOfxsI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33a4cnms61-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 21:16:24 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Sep 2020 21:16:23 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0FFE82EC6841; Thu,  3 Sep 2020 21:16:17 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 2/2] libbpf: fix potential multiplication overflow
Date:   Thu, 3 Sep 2020 21:16:11 -0700
Message-ID: <20200904041611.1695163-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200904041611.1695163-1-andriin@fb.com>
References: <20200904041611.1695163-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_02:2020-09-03,2020-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=851 adultscore=0 suspectscore=8 lowpriorityscore=0 spamscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040038
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Detected by LGTM static analyze in Github repo, fix potential multiplicat=
ion
overflow before result is casted to size_t.

Fixes: 8505e8709b5e ("libbpf: Implement generalized .BTF.ext func/line in=
fo adjustment")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 53be32a2b9fc..550950eb1860 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5802,7 +5802,7 @@ static int adjust_prog_btf_ext_info(const struct bp=
f_object *obj,
 		/* append func/line info of a given (sub-)program to the main
 		 * program func/line info
 		 */
-		old_sz =3D (*prog_rec_cnt) * ext_info->rec_size;
+		old_sz =3D (size_t)(*prog_rec_cnt) * ext_info->rec_size;
 		new_sz =3D old_sz + (copy_end - copy_start);
 		new_prog_info =3D realloc(*prog_info, new_sz);
 		if (!new_prog_info)
--=20
2.24.1

