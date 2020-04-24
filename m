Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF36D1B6DFB
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 08:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgDXGSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 02:18:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32810 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbgDXGSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 02:18:07 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O6GMmH008198
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 23:18:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=TUKBWJf/jG9LPRV1hQjqfOa4hgECIEQI5aegDKaPdu4=;
 b=LH8lp5U6kZZGXH9ENuJg5tTswA7/zhdG57ix2a+PczMX5u9x7hCr+gNfojuSqYKxSsk6
 37+TDJnbLVh6Hw/Vx/6V7rtQ34GCHWcT1rQvKeKVcxsc8/L2dqJUeuNa2YHLdWt380/c
 h1AWhPUsB3nWEQKM3peQHfLuH0yIvPP67xc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30jwey1sa1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 23:18:07 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 23 Apr 2020 23:18:06 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id A6E0A62E4C20; Thu, 23 Apr 2020 23:18:02 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 2/3] libbpf: add support for command BPF_ENABLE_STATS
Date:   Thu, 23 Apr 2020 23:17:54 -0700
Message-ID: <20200424061755.436559-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200424061755.436559-1-songliubraving@fb.com>
References: <20200424061755.436559-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_01:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 priorityscore=1501 mlxlogscore=838 mlxscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 spamscore=0 adultscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_enable_stats() is added to enable given stats.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/lib/bpf/bpf.c      | 9 +++++++++
 tools/lib/bpf/bpf.h      | 1 +
 tools/lib/bpf/libbpf.map | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 5cc1b0785d18..c06c25293ab7 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -826,3 +826,12 @@ int bpf_task_fd_query(int pid, int fd, __u32 flags, =
char *buf, __u32 *buf_len,
=20
 	return err;
 }
+
+int bpf_enable_stats(enum bpf_stats_type type)
+{
+	union bpf_attr attr =3D {};
+
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

