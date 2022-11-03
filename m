Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB87561766D
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 06:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiKCFyc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Nov 2022 01:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiKCFxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 01:53:34 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C2B1789D
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 22:53:30 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVscF010769
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 22:53:29 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkhkvttgt-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 22:53:29 -0700
Received: from twshared17038.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 22:53:25 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id 045452102ECEF; Wed,  2 Nov 2022 22:53:15 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 05/10] selftests/bpf: allow to define asc/desc ordering for sort specs in veristat
Date:   Wed, 2 Nov 2022 22:52:59 -0700
Message-ID: <20221103055304.2904589-6-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221103055304.2904589-1-andrii@kernel.org>
References: <20221103055304.2904589-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 1pEUN42OwDKEhJO0p0c2kew56EhGxHUv
X-Proofpoint-ORIG-GUID: 1pEUN42OwDKEhJO0p0c2kew56EhGxHUv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to specify '^' at the end of stat name to designate that it should
be sorted in ascending order. Similarly, allow any of 'v', 'V', '.',
'!', or '_' suffix "symbols" to designate descending order. It's such
a zoo for descending order because there is no single intuitive symbol
that could be used (using 'v' looks pretty weird in practice), so few
symbols that are "downwards leaning or pointing" were chosen. Either
way, it shouldn't cause any troubles in practice.

This new feature allows to customize sortering order to match user's
needs.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 63 ++++++++++++++++++++------
 1 file changed, 48 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index 0da3ecf6ed52..56ba55156abb 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -419,32 +419,65 @@ static struct stat_def {
 	[MARK_READ_MAX_LEN] = { "Max mark read length", {"max_mark_read_len", "mark_read"}, },
 };
 
+static bool parse_stat_id(const char *name, size_t len, int *id)
+{
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(stat_defs); i++) {
+		struct stat_def *def = &stat_defs[i];
+
+		for (j = 0; j < ARRAY_SIZE(stat_defs[i].names); j++) {
+
+			if (!def->names[j] ||
+			    strlen(def->names[j]) != len ||
+			    strncmp(def->names[j], name, len) != 0)
+				continue;
+
+			*id = i;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool is_asc_sym(char c)
+{
+	return c == '^';
+}
+
+static bool is_desc_sym(char c)
+{
+	return c == 'v' || c == 'V' || c == '.' || c == '!' || c == '_';
+}
+
 static int parse_stat(const char *stat_name, struct stat_specs *specs)
 {
-	int id, i;
+	int id;
+	bool has_order = false, is_asc = false;
+	size_t len = strlen(stat_name);
 
 	if (specs->spec_cnt >= ARRAY_SIZE(specs->ids)) {
 		fprintf(stderr, "Can't specify more than %zd stats\n", ARRAY_SIZE(specs->ids));
 		return -E2BIG;
 	}
 
-	for (id = 0; id < ARRAY_SIZE(stat_defs); id++) {
-		struct stat_def *def = &stat_defs[id];
-
-		for (i = 0; i < ARRAY_SIZE(stat_defs[id].names); i++) {
-			if (!def->names[i] || strcmp(def->names[i], stat_name) != 0)
-				continue;
-
-			specs->ids[specs->spec_cnt] = id;
-			specs->asc[specs->spec_cnt] = def->asc_by_default;
-			specs->spec_cnt++;
+	if (len > 1 && (is_asc_sym(stat_name[len - 1]) || is_desc_sym(stat_name[len - 1]))) {
+		has_order = true;
+		is_asc = is_asc_sym(stat_name[len - 1]);
+		len -= 1;
+	}
 
-			return 0;
-		}
+	if (!parse_stat_id(stat_name, len, &id)) {
+		fprintf(stderr, "Unrecognized stat name '%s'\n", stat_name);
+		return -ESRCH;
 	}
 
-	fprintf(stderr, "Unrecognized stat name '%s'\n", stat_name);
-	return -ESRCH;
+	specs->ids[specs->spec_cnt] = id;
+	specs->asc[specs->spec_cnt] = has_order ? is_asc : stat_defs[id].asc_by_default;
+	specs->spec_cnt++;
+
+	return 0;
 }
 
 static int parse_stats(const char *stats_str, struct stat_specs *specs)
-- 
2.30.2

