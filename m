Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD6F1B7DDF
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 20:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgDXS3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 14:29:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7832 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727108AbgDXS3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 14:29:30 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03OITThI014831
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 11:29:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=0D9XB2cxNQjJgg0xp0kt9fyv3Vd91/eGjXDHde3VadE=;
 b=Wr/pGzd4p3WvwtDz5ZoYfDSiDFH7DGyeOs9XNax00O8A3PFmOrpgavmxRN+JcUfoMTFb
 QbJeodGjAQi8slU58vMSpfHywrfhJ75WTl7VhUzGnvlykqzQff1lmJ9zLSxQzroUEY5L
 WdTBCMOKe3cTkF3HdZWiYJPjMFmm/MR6nyA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30kknkx9rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 11:29:29 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 24 Apr 2020 11:29:15 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id F17AE29417B0; Fri, 24 Apr 2020 11:29:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpftool: Respect the -d option in struct_ops cmd
Date:   Fri, 24 Apr 2020 11:29:11 -0700
Message-ID: <20200424182911.1259355-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_09:2020-04-24,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 suspectscore=1 adultscore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the prog cmd, the "-d" option turns on the verifier log.
This is missed in the "struct_ops" cmd and this patch fixes it.

Fixes: 65c93628599d ("bpftool: Add struct_ops support")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/bpf/bpftool/struct_ops.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_op=
s.c
index 0fe0d584c57e..e17738479edc 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -479,6 +479,7 @@ static int do_unregister(int argc, char **argv)
=20
 static int do_register(int argc, char **argv)
 {
+	struct bpf_object_load_attr load_attr =3D {};
 	const struct bpf_map_def *def;
 	struct bpf_map_info info =3D {};
 	__u32 info_len =3D sizeof(info);
@@ -499,7 +500,12 @@ static int do_register(int argc, char **argv)
=20
 	set_max_rlimit();
=20
-	if (bpf_object__load(obj)) {
+	load_attr.obj =3D obj;
+	if (verifier_logs)
+		/* log_level1 + log_level2 + stats, but not stable UAPI */
+		load_attr.log_level =3D 1 + 2 + 4;
+
+	if (bpf_object__load_xattr(&load_attr)) {
 		bpf_object__close(obj);
 		return -1;
 	}
--=20
2.24.1

