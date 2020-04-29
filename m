Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6901BD351
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 05:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgD2D6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 23:58:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50318 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726739AbgD2D6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 23:58:52 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03T3tsIN001108
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 20:58:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7R7IsYDhdkU5c5IAf0mtqOlnMrTZmkufYpvln0m5DNA=;
 b=nlX58VoyFwt+zSrfmrWZBziSssplraMbWRl+D2JvcirAfguvmzFjQkDlbamYH+kzxsOq
 L/Xsq2R/70DPZhiqM7/kWdD/bD6aD7PuthdkPsctccA3i2YAkH1IoORxYLCy5o1RWc7Q
 knwpfzOTz7Qs/HktJGc0/Wub+gwEdrtOSkY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 30ntjvxdjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 20:58:50 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 20:58:49 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9215362E4BEF; Tue, 28 Apr 2020 20:58:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v7 bpf-next 2/3] libbpf: add support for command BPF_ENABLE_STATS
Date:   Tue, 28 Apr 2020 20:58:40 -0700
Message-ID: <20200429035841.3959159-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200429035841.3959159-1-songliubraving@fb.com>
References: <20200429035841.3959159-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0
 suspectscore=8 phishscore=0 mlxlogscore=822 lowpriorityscore=0
 adultscore=0 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290028
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
 tools/lib/bpf/libbpf.map |  5 +++++
 3 files changed, 16 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 5cc1b0785d18..17bb4ad06c0e 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -826,3 +826,13 @@ int bpf_task_fd_query(int pid, int fd, __u32 flags, =
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
index 46d47afdd887..5996e64d324c 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -229,6 +229,7 @@ LIBBPF_API int bpf_load_btf(void *btf, __u32 btf_size=
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
index bb8831605b25..ebd946faada5 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -254,3 +254,8 @@ LIBBPF_0.0.8 {
 		bpf_program__set_lsm;
 		bpf_set_link_xdp_fd_opts;
 } LIBBPF_0.0.7;
+
+LIBBPF_0.0.9 {
+	global:
+		bpf_enable_stats;
+} LIBBPF_0.0.8;
\ No newline at end of file
--=20
2.24.1

