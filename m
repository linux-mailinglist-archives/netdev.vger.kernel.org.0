Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441661BB583
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 06:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgD1EvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 00:51:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50316 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726366AbgD1EvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 00:51:18 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03S4m1io015123
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 21:51:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=MFUNWFXTDtKydgExxdShP51rLeiWG+IvQkJdWM9J5wA=;
 b=CbqHlMVj3jAb4BQQ5ef6zy76SI0qU3oXK+JDdXDdQa10UhoiKfdbbk9/hWTHmLdAOvHj
 1W7e2QfdqvwzQVgq5KZskaxXjIfncgmW9Uk1E5oyzasZKE8Ec1vMnxCEgMSPYv7JQ5Fd
 fm57W44/Ht8xugZegyX7IBBmrjV7JO+E3o4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30mgvngtwa-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 21:51:17 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 21:51:15 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BFE692EC2B14; Mon, 27 Apr 2020 21:51:09 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 6/6] selftests/bpf: fix memory leak in extract_build_id()
Date:   Mon, 27 Apr 2020 21:46:28 -0700
Message-ID: <20200428044628.3772114-7-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200428044628.3772114-1-andriin@fb.com>
References: <20200428044628.3772114-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_02:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=926 clxscore=1015
 suspectscore=25 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004280039
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

getline() allocates string, which has to be freed.

Cc: Song Liu <songliubraving@fb.com>
Fixes: 81f77fd0deeb ("bpf: add selftest for stackmap with BPF_F_STACK_BUI=
LD_ID")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_progs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/sel=
ftests/bpf/test_progs.c
index 86d0020c9eec..93970ec1c9e9 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -351,6 +351,7 @@ int extract_build_id(char *build_id, size_t size)
 		len =3D size;
 	memcpy(build_id, line, len);
 	build_id[len] =3D '\0';
+	free(line);
 	return 0;
 err:
 	fclose(fp);
--=20
2.24.1

