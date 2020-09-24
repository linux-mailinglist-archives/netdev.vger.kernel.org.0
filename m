Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129ED27778E
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 19:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgIXRRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 13:17:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28920 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728461AbgIXRRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 13:17:12 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08OH9LZB020032
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 10:17:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=3XZQVNprvX2hF0kPb0NKXH2kLMm90+GQ1ikQK+K5Pq0=;
 b=EGUj2hy4n8oagkWycYRD2rTVKNonNatgRejoUSB8qRA19pOWaHNzONtkcvLbKeE4eb3h
 yz8xNfxaEvOAdvoCJtUUn0P/1AzY7DB+Qlzb7gRMGkUr6eIDmcnB1XK5HBOOLuTuLfjr
 zymOo1JRbozeRTv302J9UbV1G18szqfE0rQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp52uth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 10:17:11 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 10:17:10 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 247992EC74F2; Thu, 24 Sep 2020 10:17:06 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Nikita Shirokov <tehnerd@tehnerd.com>,
        Udip Pant <udippant@fb.com>
Subject: [PATCH bpf] libbpf: fix XDP program load regression for old kernels
Date:   Thu, 24 Sep 2020 10:17:05 -0700
Message-ID: <20200924171705.3803628-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_10:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix regression in libbpf, introduced by XDP link change, which causes XDP
programs to fail to be loaded into kernel due to specified BPF_XDP
expected_attach_type. While kernel doesn't enforce expected_attach_type f=
or
BPF_PROG_TYPE_XDP, some old kernels already support XDP program, but they
don't yet recognize expected_attach_type field in bpf_attr, so setting it=
 to
non-zero value causes program load to fail.

Luckily, libbpf already has a mechanism to deal with such cases, so just =
make
expected_attach_type optional for XDP programs.

Reported-by: Nikita Shirokov <tehnerd@tehnerd.com>
Reported-by: Udip Pant <udippant@fb.com>
Fixes: dc8698cac7aa ("libbpf: Add support for BPF XDP link")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7253b833576c..e493d6048143 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6925,7 +6925,7 @@ static const struct bpf_sec_def section_defs[] =3D =
{
 						BPF_XDP_DEVMAP),
 	BPF_EAPROG_SEC("xdp_cpumap/",		BPF_PROG_TYPE_XDP,
 						BPF_XDP_CPUMAP),
-	BPF_EAPROG_SEC("xdp",			BPF_PROG_TYPE_XDP,
+	BPF_APROG_SEC("xdp",			BPF_PROG_TYPE_XDP,
 						BPF_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
--=20
2.24.1

