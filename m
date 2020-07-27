Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C07D22FE0A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgG0Xe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:34:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17558 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgG0Xe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 19:34:26 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RNX4Wi009335
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 16:34:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=JDfgqHEGv/LvNvNKPVciWSLBRPWixDLg/YTu4wwbIk8=;
 b=qAVFcsf+xYdHPTe/lrLLKUtLQHaFwJw7Pi5XBHNGsyVbcv7sFu52gTlukF8SS1B+xKvm
 ulXrnVdN1DRXJRicWcT+RVlbrR69CKX3/fQQ3f4k+gE08nT+poPcfPWUKfqzvM/Ur4vV
 lH1FEwegZe/aXybKPmgGAqA2hX5eCVDYZOg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4q9f104-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 16:34:26 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 16:33:52 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C506F2EC4BAB; Mon, 27 Jul 2020 16:33:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: add new bpf_iter context structs to fix build on old kernels
Date:   Mon, 27 Jul 2020 16:33:45 -0700
Message-ID: <20200727233345.1686358-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=797
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_iter__bpf_map_elem and bpf_iter__bpf_sk_storage_map to bpf_iter.h

Cc: Yonghong Song <yhs@fb.com>
Fixes: 3b1c420bd882 ("selftests/bpf: Add a test for bpf sk_storage_map it=
erator")
Fixes: 2a7c2fff7dd6 ("selftests/bpf: Add test for bpf hash map iterators"=
)
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/progs/bpf_iter.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing=
/selftests/bpf/progs/bpf_iter.h
index 17db3bac518b..c196280df90d 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter.h
+++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
@@ -11,6 +11,8 @@
 #define tcp6_sock tcp6_sock___not_used
 #define bpf_iter__udp bpf_iter__udp___not_used
 #define udp6_sock udp6_sock___not_used
+#define bpf_iter__bpf_map_elem bpf_iter__bpf_map_elem___not_used
+#define bpf_iter__bpf_sk_storage_map bpf_iter__bpf_sk_storage_map___not_=
used
 #include "vmlinux.h"
 #undef bpf_iter_meta
 #undef bpf_iter__bpf_map
@@ -22,6 +24,8 @@
 #undef tcp6_sock
 #undef bpf_iter__udp
 #undef udp6_sock
+#undef bpf_iter__bpf_map_elem
+#undef bpf_iter__bpf_sk_storage_map
=20
 struct bpf_iter_meta {
 	struct seq_file *seq;
@@ -78,3 +82,17 @@ struct udp6_sock {
 	struct udp_sock	udp;
 	struct ipv6_pinfo inet6;
 } __attribute__((preserve_access_index));
+
+struct bpf_iter__bpf_map_elem {
+	struct bpf_iter_meta *meta;
+	struct bpf_map *map;
+	void *key;
+	void *value;
+};
+
+struct bpf_iter__bpf_sk_storage_map {
+	struct bpf_iter_meta *meta;
+	struct bpf_map *map;
+	struct sock *sk;
+	void *value;
+};
--=20
2.24.1

