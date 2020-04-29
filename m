Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62DB1BD4F5
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgD2Gp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:45:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54798 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbgD2Gp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:45:57 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T6cVpY008402
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 23:45:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=oZEpp5dTUNXoDUGJqwDCPbgZ4r4OQQTpbp66PAlL5BY=;
 b=fUK290+zP3scJVWYKmza7jEFK/8fCTPc8L/b/Sr5Pks0Q86b2+jNPE0g1xsXi5c2YsBd
 X57eg3aOfblKBkjZfpW5UKIPHfwLWTUESZXZ68Elz/js5FWH+izmMZOeCixYE4sXy4Uy
 PzqsMiE9Qr7KHPwtl3wIGA1u1rcTf1GS4rs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n54en55x-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 23:45:56 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 23:45:55 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 8B4FF62E4C2D; Tue, 28 Apr 2020 23:45:49 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v8 bpf-next 2/3] libbpf: add support for command BPF_ENABLE_STATS
Date:   Tue, 28 Apr 2020 23:45:42 -0700
Message-ID: <20200429064543.634465-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200429064543.634465-1-songliubraving@fb.com>
References: <20200429064543.634465-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_02:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 suspectscore=8 spamscore=0 impostorscore=0
 mlxlogscore=884 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_enable_stats() is added to enable given stats.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/lib/bpf/bpf.c      | 10 ++++++++++
 tools/lib/bpf/bpf.h      |  1 +
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 12 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 8f2f0958d446..43322f0d6c7f 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -841,3 +841,13 @@ int bpf_task_fd_query(int pid, int fd, __u32 flags, =
char *buf, __u32 *buf_len,
=20
 	return err;
 }
+
+int bpf_enable_stats(enum bpf_stats_type type)
+{
+	union bpf_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.enable_stats.type =3D type;
+
+	return sys_bpf(BPF_ENABLE_STATS, &attr, sizeof(attr));
+}
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 335b457b3a25..1901b2777854 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -231,6 +231,7 @@ LIBBPF_API int bpf_load_btf(void *btf, __u32 btf_size=
, char *log_buf,
 LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf=
,
 				 __u32 *buf_len, __u32 *prog_id, __u32 *fd_type,
 				 __u64 *probe_offset, __u64 *probe_addr);
+LIBBPF_API int bpf_enable_stats(enum bpf_stats_type type);
=20
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 7cd49aa38005..e03bd4db827e 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -257,6 +257,7 @@ LIBBPF_0.0.8 {
=20
 LIBBPF_0.0.9 {
 	global:
+		bpf_enable_stats;
 		bpf_link_get_fd_by_id;
 		bpf_link_get_next_id;
 } LIBBPF_0.0.8;
--=20
2.24.1

