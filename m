Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950CFA0C12
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfH1VEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:04:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4526 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727087AbfH1VEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:04:20 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7SL47FH028834
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=txtomiOXWxacCT7/7yJQhGvyYNbKMak5FyK2wGSFu24=;
 b=RziBnKbxYXl1+9k+245zzDaUjmyZGviE3ijst19LV7va8hJvIeSOX8nw8nOC4lmuPXqT
 vhxXW4siVbVVGeaDgJzqjDujWbd3nevsNQEmmROe/Fh/CIfAOJjGZlJgfKoQattopgis
 sPN9w8hC3U+iapEEmgoRxMHnDGhgH8tqL38= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2unvfyhhpy-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:18 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 14:04:17 -0700
Received: by devvm2868.prn3.facebook.com (Postfix, from userid 125878)
        id A6CA6A25D668; Wed, 28 Aug 2019 14:04:16 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Julia Kartseva <hex@fb.com>
Smtp-Origin-Hostname: devvm2868.prn3.facebook.com
To:     <rdna@fb.com>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: prn3c11
Subject: [PATCH bpf-next 07/10] selftests/bpf: extend test_section_names with type_(from|to)_str
Date:   Wed, 28 Aug 2019 14:03:10 -0700
Message-ID: <e0b334db9b0a494a879a248b8b3275e99550257b.1567024943.git.hex@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1567024943.git.hex@fb.com>
References: <cover.1567024943.git.hex@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-28_11:2019-08-28,2019-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908280206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test bpf enum stringification helpers:
libbpf_(prog|map|attach)_type_(from|to)_str

Signed-off-by: Julia Kartseva <hex@fb.com>
---
 .../selftests/bpf/test_section_names.c        | 149 +++++++++++++++++-
 1 file changed, 147 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_section_names.c b/tools/testing/selftests/bpf/test_section_names.c
index 29833aeaf0de..564585a07592 100644
--- a/tools/testing/selftests/bpf/test_section_names.c
+++ b/tools/testing/selftests/bpf/test_section_names.c
@@ -202,7 +202,137 @@ static int test_attach_type_by_name(const struct sec_name_test *test)
 	return 0;
 }
 
-static int run_test_case(const struct sec_name_test *test)
+static int test_prog_type_from_to_str(void)
+{
+	enum bpf_prog_type type, actual_type;
+	const char *str;
+	int rc;
+
+	for (type = BPF_PROG_TYPE_UNSPEC; type < __MAX_BPF_PROG_TYPE; type++) {
+		rc = libbpf_prog_type_to_str(type, &str);
+		if (rc) {
+			warnx("prog_type_to_str: unexpected rc=%d for type %d",
+			      rc, type);
+			return rc;
+		}
+
+		rc = libbpf_prog_type_from_str(str, &actual_type);
+		if (rc) {
+			warnx("prog_type_from_str: unexpected rc=%d for str %s",
+			      rc, str);
+			return rc;
+		}
+
+		if (actual_type != type) {
+			warnx("prog: unexpected prog_type for str %s, %d != %d",
+			      str, actual_type, type);
+			return -EINVAL;
+		}
+	}
+
+	rc = libbpf_prog_type_to_str(__MAX_BPF_PROG_TYPE, &str);
+	if (!rc) {
+		warnx("prog: unexpected result for __MAX_BPF_PROG_TYPE");
+		return -EINVAL;
+	}
+
+	rc = libbpf_prog_type_from_str("NonExistent", &type);
+	if (!rc) {
+		warnx("prog: unexpected result for non existent key");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int test_map_type_from_to_str(void)
+{
+	enum bpf_map_type type, actual_type;
+	const char *str;
+	int rc;
+
+	for (type = BPF_MAP_TYPE_UNSPEC; type < __MAX_BPF_MAP_TYPE; type++) {
+		rc = libbpf_map_type_to_str(type, &str);
+		if (rc) {
+			warnx("map_type_to_str: unexpected rc=%d for type %d",
+			      rc, type);
+			return rc;
+		}
+
+		rc = libbpf_map_type_from_str(str, &actual_type);
+		if (rc) {
+			warnx("map_type_from_str: unexpected rc=%d for str %s",
+			      rc, str);
+			return rc;
+		}
+
+		if (actual_type != type) {
+			warnx("map: unexpected map_type for str %s, %d != %d",
+			      str, actual_type, type);
+			return -EINVAL;
+		}
+	}
+
+	rc = libbpf_map_type_to_str(__MAX_BPF_MAP_TYPE, &str);
+	if (!rc) {
+		warnx("map: unexpected result for __MAX_BPF_MAP_TYPE");
+		return -EINVAL;
+	}
+
+	rc = libbpf_map_type_from_str("NonExistent", &type);
+	if (!rc) {
+		warnx("map: unexpected result for non existent key");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int test_attach_type_from_to_str(void)
+{
+	enum bpf_attach_type type, actual_type;
+	const char *str;
+	int rc;
+
+	for (type = BPF_CGROUP_INET_INGRESS; type < __MAX_BPF_ATTACH_TYPE;
+	     type++) {
+		rc = libbpf_attach_type_to_str(type, &str);
+		if (rc) {
+			warnx("attach: unexpected rc=%d for type %d",
+			      rc, type);
+			return rc;
+		}
+
+		rc = libbpf_attach_type_from_str(str, &actual_type);
+		if (rc) {
+			warnx("attach: unexpected rc=%d for str %s",
+			      rc, str);
+			return rc;
+		}
+
+		if (actual_type != type) {
+			warnx("attach: unexpected type for str %s, %d != %d",
+			      str, actual_type, type);
+			return -EINVAL;
+		}
+	}
+
+	rc = libbpf_attach_type_to_str(__MAX_BPF_ATTACH_TYPE, &str);
+	if (!rc) {
+		warnx("attach: unexpected result for __MAX_BPF_ATTACH_TYPE");
+		return -EINVAL;
+	}
+
+	rc = libbpf_attach_type_from_str("NonExistent", &type);
+	if (!rc) {
+		warnx("attach: unexpected result for non existent key");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int run_sec_name_test_case(const struct sec_name_test *test)
 {
 	if (test_prog_type_by_name(test))
 		return -1;
@@ -218,11 +348,26 @@ static int run_tests(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(tests); ++i) {
-		if (run_test_case(&tests[i]))
+		if (run_sec_name_test_case(&tests[i]))
 			++fails;
 		else
 			++passes;
 	}
+
+	if (test_prog_type_from_to_str())
+		++fails;
+	else
+		++passes;
+
+	if (test_map_type_from_to_str())
+		++fails;
+	else
+		++passes;
+
+	if (test_attach_type_from_to_str())
+		++fails;
+	else
+		++passes;
 	printf("Summary: %d PASSED, %d FAILED\n", passes, fails);
 	return fails ? -1 : 0;
 }
-- 
2.17.1

