Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F14AAA79
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 20:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391198AbfIESAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 14:00:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2666 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391194AbfIESAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 14:00:21 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x85I0GmE005786
        for <netdev@vger.kernel.org>; Thu, 5 Sep 2019 11:00:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=7ke73pEVb/kU37IV/XVhV4TkVIqC/yt+sS0yMFGN1Y0=;
 b=f4+b8EtvvVw6Zd1b3NVvDsrHXX9hXWiOndTBw1WCqFGinVXgprBBcsOoBxpXowggBETD
 cznJJMWj0Gpryw0dZe46XXOcTKdyZcBkCX6lyoOlkRKZK71OAbDXchx/ybKG9uUL8uny
 R/o8AhiTUANGjZflqA6MSBMWZP8DKT0878U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2utkkxvvbg-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 11:00:20 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Sep 2019 10:59:53 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 9DD42861892; Thu,  5 Sep 2019 10:59:52 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] kbuild: replace BASH-specific ${@:2} with shift and ${@}
Date:   Thu, 5 Sep 2019 10:59:38 -0700
Message-ID: <20190905175938.599455-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_05:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=500 mlxscore=0 clxscore=1015 adultscore=0 suspectscore=9
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909050170
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

${@:2} is BASH-specific extension, which makes link-vmlinux.sh rely on
BASH. Use shift and ${@} instead to fix this issue.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 341dfcf8d78e ("btf: expose BTF info through sysfs")
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 scripts/link-vmlinux.sh | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 0d8f41db8cd6..8c59970a09dc 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -57,12 +57,16 @@ modpost_link()
 
 # Link of vmlinux
 # ${1} - output file
-# ${@:2} - optional extra .o files
+# ${2}, ${3}, ... - optional extra .o files
 vmlinux_link()
 {
 	local lds="${objtree}/${KBUILD_LDS}"
+	local output=${1}
 	local objects
 
+	# skip output file argument
+	shift
+
 	if [ "${SRCARCH}" != "um" ]; then
 		objects="--whole-archive			\
 			${KBUILD_VMLINUX_OBJS}			\
@@ -70,9 +74,10 @@ vmlinux_link()
 			--start-group				\
 			${KBUILD_VMLINUX_LIBS}			\
 			--end-group				\
-			${@:2}"
+			${@}"
 
-		${LD} ${KBUILD_LDFLAGS} ${LDFLAGS_vmlinux} -o ${1}	\
+		${LD} ${KBUILD_LDFLAGS} ${LDFLAGS_vmlinux}	\
+			-o ${output}				\
 			-T ${lds} ${objects}
 	else
 		objects="-Wl,--whole-archive			\
@@ -81,9 +86,10 @@ vmlinux_link()
 			-Wl,--start-group			\
 			${KBUILD_VMLINUX_LIBS}			\
 			-Wl,--end-group				\
-			${@:2}"
+			${@}"
 
-		${CC} ${CFLAGS_vmlinux} -o ${1}			\
+		${CC} ${CFLAGS_vmlinux}				\
+			-o ${output}				\
 			-Wl,-T,${lds}				\
 			${objects}				\
 			-lutil -lrt -lpthread
-- 
2.21.0

