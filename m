Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6804613D07A
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 00:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgAOXBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 18:01:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36388 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726513AbgAOXBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 18:01:36 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00FN1Nx4025713
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 15:01:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Z5K3DcIdVMWH7XVB+Us9quz2oSbjKlzmJ+j6qmMN4nY=;
 b=apj2qvmXp9rN+eo9faYUkNG27dOZBnZUl9IcFfjlJmXVoe2fnKd8hW0eilZU0yZ70+XT
 yDbif83dlEaeOBRbT80bJlC81Eh4p93ET9X0IqLjDcVRIMe/9f/8RdTJnmxEb+m2frYg
 XWmOYLQ6qGhnl+W3S261f02jfXfAr0dODy4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhahps7s5-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 15:01:36 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 Jan 2020 15:00:47 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 3AA6F2941680; Wed, 15 Jan 2020 15:00:44 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 5/5] bpftool: Support dumping a map with btf_vmlinux_value_type_id
Date:   Wed, 15 Jan 2020 15:00:44 -0800
Message-ID: <20200115230044.1103008-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200115230012.1100525-1-kafai@fb.com>
References: <20200115230012.1100525-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_03:2020-01-15,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=758 malwarescore=0 suspectscore=38 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001150173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes bpftool support dumping a map's value properly
when the map's value type is a type of the running kernel's btf.
(i.e. map_info.btf_vmlinux_value_type_id is set instead of
map_info.btf_value_type_id).  The first usecase is for the
BPF_MAP_TYPE_STRUCT_OPS.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/bpf/bpftool/map.c | 61 +++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 11 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 4c5b15d736b6..86f8ab0b7e63 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -252,6 +252,7 @@ static int do_dump_btf(const struct btf_dumper *d,
 		       struct bpf_map_info *map_info, void *key,
 		       void *value)
 {
+	__u32 value_id;
 	int ret;
 
 	/* start of key-value pair */
@@ -265,9 +266,12 @@ static int do_dump_btf(const struct btf_dumper *d,
 			goto err_end_obj;
 	}
 
+	value_id = map_info->btf_vmlinux_value_type_id ?
+		: map_info->btf_value_type_id;
+
 	if (!map_is_per_cpu(map_info->type)) {
 		jsonw_name(d->jw, "value");
-		ret = btf_dumper_type(d, map_info->btf_value_type_id, value);
+		ret = btf_dumper_type(d, value_id, value);
 	} else {
 		unsigned int i, n, step;
 
@@ -279,8 +283,7 @@ static int do_dump_btf(const struct btf_dumper *d,
 			jsonw_start_object(d->jw);
 			jsonw_int_field(d->jw, "cpu", i);
 			jsonw_name(d->jw, "value");
-			ret = btf_dumper_type(d, map_info->btf_value_type_id,
-					      value + i * step);
+			ret = btf_dumper_type(d, value_id, value + i * step);
 			jsonw_end_object(d->jw);
 			if (ret)
 				break;
@@ -932,6 +935,44 @@ static int maps_have_btf(int *fds, int nb_fds)
 	return 1;
 }
 
+static struct btf *btf_vmlinux;
+
+static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
+{
+	struct btf *btf = NULL;
+
+	if (info->btf_vmlinux_value_type_id) {
+		if (!btf_vmlinux) {
+			btf_vmlinux = libbpf_find_kernel_btf();
+			if (IS_ERR(btf_vmlinux))
+				p_err("failed to get kernel btf");
+		}
+		return btf_vmlinux;
+	} else if (info->btf_value_type_id) {
+		int err;
+
+		err = btf__get_from_id(info->btf_id, &btf);
+		if (err || !btf) {
+			p_err("failed to get btf");
+			btf = err ? ERR_PTR(err) : ERR_PTR(-ESRCH);
+		}
+	}
+
+	return btf;
+}
+
+static void free_map_kv_btf(struct btf *btf)
+{
+	if (!IS_ERR(btf) && btf != btf_vmlinux)
+		btf__free(btf);
+}
+
+static void free_btf_vmlinux(void)
+{
+	if (!IS_ERR(btf_vmlinux))
+		btf__free(btf_vmlinux);
+}
+
 static int
 map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 	 bool show_header)
@@ -952,13 +993,10 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 	prev_key = NULL;
 
 	if (wtr) {
-		if (info->btf_id) {
-			err = btf__get_from_id(info->btf_id, &btf);
-			if (err || !btf) {
-				err = err ? : -ESRCH;
-				p_err("failed to get btf");
-				goto exit_free;
-			}
+		btf = get_map_kv_btf(info);
+		if (IS_ERR(btf)) {
+			err = PTR_ERR(btf);
+			goto exit_free;
 		}
 
 		if (show_header) {
@@ -999,7 +1037,7 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 	free(key);
 	free(value);
 	close(fd);
-	btf__free(btf);
+	free_map_kv_btf(btf);
 
 	return err;
 }
@@ -1067,6 +1105,7 @@ static int do_dump(int argc, char **argv)
 		close(fds[i]);
 exit_free:
 	free(fds);
+	free_btf_vmlinux();
 	return err;
 }
 
-- 
2.17.1

