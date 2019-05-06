Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4EC14324
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 02:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfEFAKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 20:10:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38636 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727373AbfEFAKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 20:10:47 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4604n0F009676
        for <netdev@vger.kernel.org>; Sun, 5 May 2019 17:10:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=HQNR+ajknOMARZWsVADyoDmTPiSw0EYyP9Bz1Nn55sw=;
 b=ECqe4XlZz2Lf4sTWgBmQ0GdLuXw++Xg24UjTTmf+6mXMvn6FmDOp33YOSii33fdW0UJf
 TunMtIBP4ZE/7CGbo1xR3BdFXYMdqcvtKnYD+Ebefg60cLPg8qLu02azdvRxYoHGBrzO
 DZjd5yfyg6d9s8+YVTndaOQD6gyRv728Avc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2s96s0unje-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 17:10:46 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 5 May 2019 17:10:44 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 84882862582; Sun,  5 May 2019 17:10:42 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <yhs@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf] kbuild: tolerate missing pahole when generating BTF
Date:   Sun, 5 May 2019 17:10:33 -0700
Message-ID: <20190506001033.2765060-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-05_20:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=738 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905050216
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When BTF generation is enabled through CONFIG_DEBUG_INFO_BTF,
scripts/link-vmlinux.sh detects if pahole version is too old and
gracefully continues build process, skipping BTF generation build step.
But if pahole is not available, build will still fail. This patch adds
check for whether pahole exists at all and bails out gracefully, if not.

Cc: Alexei Starovoitov <ast@fb.com>
Reported-by: Yonghong Song <yhs@fb.com>
Fixes: e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 scripts/link-vmlinux.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 6a148d0d51bf..e3c06b9482a2 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -96,6 +96,11 @@ gen_btf()
 {
 	local pahole_ver;
 
+	if ! [ -x "$(command -v ${PAHOLE})" ]; then
+		info "BTF" "${1}: pahole (${PAHOLE}) is not available"
+		return 0
+	fi
+
 	pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
 	if [ "${pahole_ver}" -lt "113" ]; then
 		info "BTF" "${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.13"
-- 
2.17.1

