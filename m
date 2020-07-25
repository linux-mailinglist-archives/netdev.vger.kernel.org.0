Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7675222D2B8
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgGYAFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:05:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12668 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727887AbgGYAEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:46 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06ONnh88027939
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=oEnmyUCkDbp6GsiBTaBZObGYGFPu+HplQnEkNgp2CuY=;
 b=Uto0v55FZzOqaYlQG+DX1vJCW+Gc1rj90AVujKQMzsrV7W1ErsHz9Khx704IiAWQn3EK
 M3+nwwbV3jfEU0jz5lQyxOX1+f+MxMmajJKH5AELOzWEgs/7MzMY9aiT59lbcz97mDRp
 Ql14qUHNgNNr99HAH4Sj93MU7P0BZd//mxM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 32esdjvm7f-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:44 -0700
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 17:04:43 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 436091B35AA6; Fri, 24 Jul 2020 17:04:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next 29/35] bpf: libbpf: cleanup RLIMIT_MEMLOCK usage
Date:   Fri, 24 Jul 2020 17:04:04 -0700
Message-ID: <20200725000410.3566700-30-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200725000410.3566700-1-guro@fb.com>
References: <20200725000410.3566700-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_10:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 malwarescore=0 spamscore=0 adultscore=0 impostorscore=0 phishscore=0
 suspectscore=13 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As bpf is not using memlock rlimit for memory accounting anymore,
let's remove the related code from libbpf.

Bpf operations can't fail because of exceeding the limit anymore.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 tools/lib/bpf/libbpf.c | 31 +------------------------------
 tools/lib/bpf/libbpf.h |  5 -----
 2 files changed, 1 insertion(+), 35 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e51479d60285..841060f5cee3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -112,32 +112,6 @@ void libbpf_print(enum libbpf_print_level level, con=
st char *format, ...)
 	va_end(args);
 }
=20
-static void pr_perm_msg(int err)
-{
-	struct rlimit limit;
-	char buf[100];
-
-	if (err !=3D -EPERM || geteuid() !=3D 0)
-		return;
-
-	err =3D getrlimit(RLIMIT_MEMLOCK, &limit);
-	if (err)
-		return;
-
-	if (limit.rlim_cur =3D=3D RLIM_INFINITY)
-		return;
-
-	if (limit.rlim_cur < 1024)
-		snprintf(buf, sizeof(buf), "%zu bytes", (size_t)limit.rlim_cur);
-	else if (limit.rlim_cur < 1024*1024)
-		snprintf(buf, sizeof(buf), "%.1f KiB", (double)limit.rlim_cur / 1024);
-	else
-		snprintf(buf, sizeof(buf), "%.1f MiB", (double)limit.rlim_cur / (1024*=
1024));
-
-	pr_warn("permission error while running as root; try raising 'ulimit -l=
'? current value: %s\n",
-		buf);
-}
-
 #define STRERR_BUFSIZE  128
=20
 /* Copied from tools/perf/util/util.h */
@@ -3420,8 +3394,7 @@ bpf_object__probe_loading(struct bpf_object *obj)
 		cp =3D libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
 		pr_warn("Error in %s():%s(%d). Couldn't load trivial BPF "
 			"program. Make sure your kernel supports BPF "
-			"(CONFIG_BPF_SYSCALL=3Dy) and/or that RLIMIT_MEMLOCK is "
-			"set to big enough value.\n", __func__, cp, ret);
+			"(CONFIG_BPF_SYSCALL=3Dy)", __func__, cp, ret);
 		return -ret;
 	}
 	close(ret);
@@ -3918,7 +3891,6 @@ bpf_object__create_maps(struct bpf_object *obj)
 err_out:
 	cp =3D libbpf_strerror_r(err, errmsg, sizeof(errmsg));
 	pr_warn("map '%s': failed to create: %s(%d)\n", map->name, cp, err);
-	pr_perm_msg(err);
 	for (j =3D 0; j < i; j++)
 		zclose(obj->maps[j].fd);
 	return err;
@@ -5419,7 +5391,6 @@ load_program(struct bpf_program *prog, struct bpf_i=
nsn *insns, int insns_cnt,
 	ret =3D -errno;
 	cp =3D libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
 	pr_warn("load bpf program failed: %s\n", cp);
-	pr_perm_msg(ret);
=20
 	if (log_buf && log_buf[0] !=3D '\0') {
 		ret =3D -LIBBPF_ERRNO__VERIFY;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c6813791fa7e..8d2f1194cb02 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -610,11 +610,6 @@ bpf_prog_linfo__lfind(const struct bpf_prog_linfo *p=
rog_linfo,
=20
 /*
  * Probe for supported system features
- *
- * Note that running many of these probes in a short amount of time can =
cause
- * the kernel to reach the maximal size of lockable memory allowed for t=
he
- * user, causing subsequent probes to fail. In this case, the caller may=
 want
- * to adjust that limit with setrlimit().
  */
 LIBBPF_API bool bpf_probe_prog_type(enum bpf_prog_type prog_type,
 				    __u32 ifindex);
--=20
2.26.2

