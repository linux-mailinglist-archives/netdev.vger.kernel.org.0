Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A7C280BD4
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387520AbgJBBJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:09:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60518 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387483AbgJBBJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:09:27 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0920oEdO017136
        for <netdev@vger.kernel.org>; Thu, 1 Oct 2020 18:09:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=fERio69ItryMqZrWzLGlcDHS9oRj967rORp22P7IdrU=;
 b=EUY+EnYJb0SWjU5slwpZ+ew/fJD3yj2NCY++fL8l5hPBGz/ZE3AcdFWYXJ4S9avX2R1K
 wVNkZQPMKVm3p85Xh5S1kVdkzGboOwa0T1DZMTIgNaQ2cad1I2DiqovjM9S0+burnYA2
 jZQd8kSs2UapR96twC9fcJZs3j8pQ+xVXIk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33vtgc9ve0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 18:09:26 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 18:09:24 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C565B2EC789D; Thu,  1 Oct 2020 18:09:19 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tony Ambardar <tony.ambardar@gmail.com>
Subject: [PATCH bpf-next 2/3] libbpf: allow specifying both ELF and raw BTF for CO-RE BTF override
Date:   Thu, 1 Oct 2020 18:06:32 -0700
Message-ID: <20201002010633.3706122-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201002010633.3706122-1-andriin@fb.com>
References: <20201002010633.3706122-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_10:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=8 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use generalized BTF parsing logic, making it possible to parse BTF both f=
rom
ELF file, as well as a raw BTF dump. This makes it easier to write custom
tests with manually generated BTFs.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 20a47b729f7c..cb198283fe3d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5817,7 +5817,7 @@ bpf_object__relocate_core(struct bpf_object *obj, c=
onst char *targ_btf_path)
 		return 0;
=20
 	if (targ_btf_path)
-		targ_btf =3D btf__parse_elf(targ_btf_path, NULL);
+		targ_btf =3D btf__parse(targ_btf_path, NULL);
 	else
 		targ_btf =3D obj->btf_vmlinux;
 	if (IS_ERR_OR_NULL(targ_btf)) {
--=20
2.24.1

