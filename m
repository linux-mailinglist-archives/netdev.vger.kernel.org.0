Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A672618C1
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731548AbgIHSBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:01:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29206 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbgIHSBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 14:01:40 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088I1Xww026329
        for <netdev@vger.kernel.org>; Tue, 8 Sep 2020 11:01:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=QcZNytBp4an3COkPG96D0v1/8brsO2t1w7s3YhRQU10=;
 b=EOcbAo98BXA8LhDMedyDPSy02HpF+yGxiPASAbqoakKdkmaD5ZRF7eB4sd7jn8IefMEH
 rkXrcXqbgWuSdINMTtwVkDk4gkkaKedCeOilWhA6WM67YNT+r/Pe9WXnzFXr0rXAA4QE
 D7RBRrh8Fi7X35qcBAOkiVRHoNYlhTP9nOg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33ct69jssx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 11:01:38 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Sep 2020 11:01:33 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1FA902EC6B09; Tue,  8 Sep 2020 11:01:31 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <acme@kernel.org>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next] perf: stop using deprecated bpf_program__title()
Date:   Tue, 8 Sep 2020 11:01:27 -0700
Message-ID: <20200908180127.1249-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_09:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 phishscore=0 clxscore=1015
 mlxlogscore=976 impostorscore=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch from deprecated bpf_program__title() API to
bpf_program__section_name(). Also drop unnecessary error checks because
neither bpf_program__title() nor bpf_program__section_name() can fail or
return NULL.

Fixes: 521095842027 ("libbpf: Deprecate notion of BPF program "title" in =
favor of "section name"")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/perf/util/bpf-loader.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
index 2feb751516ab..0374adcb223c 100644
--- a/tools/perf/util/bpf-loader.c
+++ b/tools/perf/util/bpf-loader.c
@@ -328,12 +328,6 @@ config_bpf_program(struct bpf_program *prog)
 	probe_conf.no_inlines =3D false;
 	probe_conf.force_add =3D false;
=20
-	config_str =3D bpf_program__title(prog, false);
-	if (IS_ERR(config_str)) {
-		pr_debug("bpf: unable to get title for program\n");
-		return PTR_ERR(config_str);
-	}
-
 	priv =3D calloc(sizeof(*priv), 1);
 	if (!priv) {
 		pr_debug("bpf: failed to alloc priv\n");
@@ -341,6 +335,7 @@ config_bpf_program(struct bpf_program *prog)
 	}
 	pev =3D &priv->pev;
=20
+	config_str =3D bpf_program__section_name(prog);
 	pr_debug("bpf: config program '%s'\n", config_str);
 	err =3D parse_prog_config(config_str, &main_str, &is_tp, pev);
 	if (err)
@@ -454,10 +449,7 @@ preproc_gen_prologue(struct bpf_program *prog, int n=
,
 	if (err) {
 		const char *title;
=20
-		title =3D bpf_program__title(prog, false);
-		if (!title)
-			title =3D "[unknown]";
-
+		title =3D bpf_program__section_name(prog);
 		pr_debug("Failed to generate prologue for program %s\n",
 			 title);
 		return err;
--=20
2.24.1

