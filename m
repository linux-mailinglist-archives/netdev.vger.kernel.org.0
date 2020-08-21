Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBE724D8BA
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 17:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgHUPgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 11:36:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22796 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728358AbgHUPgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 11:36:36 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LFYUWk024756
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:36:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8ZtHLbWQmLHyspFQ6lS5xxV6lHpJpOFj5s3PJW+mjSA=;
 b=apgbBSMr123gkiRGZR4jhb/0vaPUjyT4ERBzB3sJEdYJsNnquKyX2OhScifJGtwp04LG
 vMe9HwZHvxsVUHKuVeX5TzKrMbpVPoMyPCgl3Bb5B/3DFHWdyapMJi2MVsJ8AcjMCj5u
 WmMbJKjT+FryeeqEDLi8j1F6syQCi/BEqZc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 332ehfruyb-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:36:32 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 08:35:55 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id DF57B3702D3F; Fri, 21 Aug 2020 08:35:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 3/3] bpftool: implement link_query for bpf iterators
Date:   Fri, 21 Aug 2020 08:35:48 -0700
Message-ID: <20200821153548.4056381-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200821153546.4056166-1-yhs@fb.com>
References: <20200821153546.4056166-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 suspectscore=8 mlxlogscore=999
 phishscore=0 malwarescore=0 impostorscore=0 clxscore=1015 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The link query for bpf iterators is implemented.
Besides being shown to the user what bpf iterator
the link represents, the target_name is also used
to filter out what additional information should be
printed out, e.g., whether map_id should be shown or not.
The following is an example of bpf_iter link dump,
plain output or pretty output.

  $ bpftool link show
  11: iter  prog 59  target_name task
          pids test_progs(1749)
  34: iter  prog 173  target_name bpf_map_elem  map_id 127
          pids test_progs_1(1753)
  $ bpftool -p link show
  [{
          "id": 11,
          "type": "iter",
          "prog_id": 59,
          "target_name": "task",
          "pids": [{
                  "pid": 1749,
                  "comm": "test_progs"
              }
          ]
      },{
          "id": 34,
          "type": "iter",
          "prog_id": 173,
          "target_name": "bpf_map_elem",
          "map_id": 127,
          "pids": [{
                  "pid": 1753,
                  "comm": "test_progs_1"
              }
          ]
      }
  ]

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/bpf/bpftool/link.c | 44 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index a89f09e3c848..e77e1525d20a 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -77,6 +77,22 @@ static void show_link_attach_type_json(__u32 attach_ty=
pe, json_writer_t *wtr)
 		jsonw_uint_field(wtr, "attach_type", attach_type);
 }
=20
+static bool is_iter_map_target(const char *target_name)
+{
+	return strcmp(target_name, "bpf_map_elem") =3D=3D 0 ||
+	       strcmp(target_name, "bpf_sk_storage_map") =3D=3D 0;
+}
+
+static void show_iter_json(struct bpf_link_info *info, json_writer_t *wt=
r)
+{
+	const char *target_name =3D u64_to_ptr(info->iter.target_name);
+
+	jsonw_string_field(wtr, "target_name", target_name);
+
+	if (is_iter_map_target(target_name))
+		jsonw_uint_field(wtr, "map_id", info->iter.map.map_id);
+}
+
 static int get_prog_info(int prog_id, struct bpf_prog_info *info)
 {
 	__u32 len =3D sizeof(*info);
@@ -128,6 +144,9 @@ static int show_link_close_json(int fd, struct bpf_li=
nk_info *info)
 				   info->cgroup.cgroup_id);
 		show_link_attach_type_json(info->cgroup.attach_type, json_wtr);
 		break;
+	case BPF_LINK_TYPE_ITER:
+		show_iter_json(info, json_wtr);
+		break;
 	case BPF_LINK_TYPE_NETNS:
 		jsonw_uint_field(json_wtr, "netns_ino",
 				 info->netns.netns_ino);
@@ -175,6 +194,16 @@ static void show_link_attach_type_plain(__u32 attach=
_type)
 		printf("attach_type %u  ", attach_type);
 }
=20
+static void show_iter_plain(struct bpf_link_info *info)
+{
+	const char *target_name =3D u64_to_ptr(info->iter.target_name);
+
+	printf("target_name %s  ", target_name);
+
+	if (is_iter_map_target(target_name))
+		printf("map_id %u  ", info->iter.map.map_id);
+}
+
 static int show_link_close_plain(int fd, struct bpf_link_info *info)
 {
 	struct bpf_prog_info prog_info;
@@ -204,6 +233,9 @@ static int show_link_close_plain(int fd, struct bpf_l=
ink_info *info)
 		printf("\n\tcgroup_id %zu  ", (size_t)info->cgroup.cgroup_id);
 		show_link_attach_type_plain(info->cgroup.attach_type);
 		break;
+	case BPF_LINK_TYPE_ITER:
+		show_iter_plain(info);
+		break;
 	case BPF_LINK_TYPE_NETNS:
 		printf("\n\tnetns_ino %u  ", info->netns.netns_ino);
 		show_link_attach_type_plain(info->netns.attach_type);
@@ -231,7 +263,7 @@ static int do_show_link(int fd)
 {
 	struct bpf_link_info info;
 	__u32 len =3D sizeof(info);
-	char raw_tp_name[256];
+	char buf[256];
 	int err;
=20
 	memset(&info, 0, sizeof(info));
@@ -245,8 +277,14 @@ static int do_show_link(int fd)
 	}
 	if (info.type =3D=3D BPF_LINK_TYPE_RAW_TRACEPOINT &&
 	    !info.raw_tracepoint.tp_name) {
-		info.raw_tracepoint.tp_name =3D (unsigned long)&raw_tp_name;
-		info.raw_tracepoint.tp_name_len =3D sizeof(raw_tp_name);
+		info.raw_tracepoint.tp_name =3D (unsigned long)&buf;
+		info.raw_tracepoint.tp_name_len =3D sizeof(buf);
+		goto again;
+	}
+	if (info.type =3D=3D BPF_LINK_TYPE_ITER &&
+	    !info.iter.target_name) {
+		info.iter.target_name =3D (unsigned long)&buf;
+		info.iter.target_name_len =3D sizeof(buf);
 		goto again;
 	}
=20
--=20
2.24.1

