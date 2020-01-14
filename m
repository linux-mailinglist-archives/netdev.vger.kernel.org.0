Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D8F13B566
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 23:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgANWoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 17:44:15 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18456 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727102AbgANWoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 17:44:15 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00EMf4tR024545
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 14:44:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=BKq4fULxnaKvlUNX2Q6RKD/xvGg6aBHy/8ql8LzX5CA=;
 b=eH2Vxmse0jkGIqvFDMpmdREDLacZEneVBpqie92RkFA0+kD90T1VUx2Wh4AUnbfSuAps
 1dOceIGoUzvPFLm9knz0Ppb9PCDNJekV1i1XjAzX4+XHNCk932goffqIeyrTKBwmvMhZ
 YX40tFBgV8pqF/RbjIUBNLqh03JXoZ9YCGg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhftutcpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 14:44:14 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Jan 2020 14:44:13 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 7FF8229438DC; Tue, 14 Jan 2020 14:44:06 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Paul Chaignon <paul.chaignon@orange.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/5] bpftool: Fix missing BTF output for json during map dump
Date:   Tue, 14 Jan 2020 14:44:06 -0800
Message-ID: <20200114224406.3027562-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200114224358.3027079-1-kafai@fb.com>
References: <20200114224358.3027079-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_06:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 suspectscore=38 lowpriorityscore=0 mlxlogscore=766
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001140174
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The btf availability check is only done for plain text output.
It causes the whole BTF output went missing when json_output
is used.

This patch simplifies the logic a little by avoiding passing "int btf" to
map_dump().

For plain text output, the btf_wtr is only created when the map has
BTF (i.e. info->btf_id != 0).  The nullness of "json_writer_t *wtr"
in map_dump() alone can decide if dumping BTF output is needed.
As long as wtr is not NULL, map_dump() will print out the BTF-described
data whenever a map has BTF available (i.e. info->btf_id != 0)
regardless of json or plain-text output.

In do_dump(), the "int btf" is also renamed to "int do_plain_btf".

Fixes: 99f9863a0c45 ("bpftool: Match maps by name")
Cc: Paul Chaignon <paul.chaignon@orange.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/bpf/bpftool/map.c | 42 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index e00e9e19d6b7..45c1eda6512c 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -933,7 +933,7 @@ static int maps_have_btf(int *fds, int nb_fds)
 
 static int
 map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
-	 bool enable_btf, bool show_header)
+	 bool show_header)
 {
 	void *key, *value, *prev_key;
 	unsigned int num_elems = 0;
@@ -950,18 +950,16 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 
 	prev_key = NULL;
 
-	if (enable_btf) {
-		err = btf__get_from_id(info->btf_id, &btf);
-		if (err || !btf) {
-			/* enable_btf is true only if we've already checked
-			 * that all maps have BTF information.
-			 */
-			p_err("failed to get btf");
-			goto exit_free;
+	if (wtr) {
+		if (info->btf_id) {
+			err = btf__get_from_id(info->btf_id, &btf);
+			if (err || !btf) {
+				err = err ? : -ESRCH;
+				p_err("failed to get btf");
+				goto exit_free;
+			}
 		}
-	}
 
-	if (wtr) {
 		if (show_header) {
 			jsonw_start_object(wtr);	/* map object */
 			show_map_header_json(info, wtr);
@@ -1009,7 +1007,7 @@ static int do_dump(int argc, char **argv)
 {
 	json_writer_t *wtr = NULL, *btf_wtr = NULL;
 	struct bpf_map_info info = {};
-	int nb_fds, i = 0, btf = 0;
+	int nb_fds, i = 0;
 	__u32 len = sizeof(info);
 	int *fds = NULL;
 	int err = -1;
@@ -1029,17 +1027,17 @@ static int do_dump(int argc, char **argv)
 	if (json_output) {
 		wtr = json_wtr;
 	} else {
-		btf = maps_have_btf(fds, nb_fds);
-		if (btf < 0)
+		int do_plain_btf;
+
+		do_plain_btf = maps_have_btf(fds, nb_fds);
+		if (do_plain_btf < 0)
 			goto exit_close;
-		if (btf) {
+
+		if (do_plain_btf) {
 			btf_wtr = get_btf_writer();
-			if (btf_wtr) {
-				wtr = btf_wtr;
-			} else {
+			wtr = btf_wtr;
+			if (!btf_wtr)
 				p_info("failed to create json writer for btf. falling back to plain output");
-				btf = 0;
-			}
 		}
 	}
 
@@ -1050,7 +1048,7 @@ static int do_dump(int argc, char **argv)
 			p_err("can't get map info: %s", strerror(errno));
 			break;
 		}
-		err = map_dump(fds[i], &info, wtr, btf, nb_fds > 1);
+		err = map_dump(fds[i], &info, wtr, nb_fds > 1);
 		if (!wtr && i != nb_fds - 1)
 			printf("\n");
 
@@ -1061,7 +1059,7 @@ static int do_dump(int argc, char **argv)
 	if (wtr && nb_fds > 1)
 		jsonw_end_array(wtr);	/* root array */
 
-	if (btf)
+	if (btf_wtr)
 		jsonw_destroy(&btf_wtr);
 exit_close:
 	for (; i < nb_fds; i++)
-- 
2.17.1

