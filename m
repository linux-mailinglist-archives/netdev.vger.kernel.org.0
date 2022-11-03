Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0D7617667
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 06:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiKCFxn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Nov 2022 01:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiKCFxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 01:53:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377AA65B0
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 22:53:27 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVquj020776
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 22:53:27 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3kkhd9jypv-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 22:53:27 -0700
Received: from twshared17038.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 22:53:25 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id 4FEC42102ED26; Wed,  2 Nov 2022 22:53:20 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 07/10] selftests/bpf: make veristat emit all stats in CSV mode by default
Date:   Wed, 2 Nov 2022 22:53:01 -0700
Message-ID: <20221103055304.2904589-8-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221103055304.2904589-1-andrii@kernel.org>
References: <20221103055304.2904589-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: KzYkCLkaL67XoFlRh09ldXL3cHCdNeZ2
X-Proofpoint-ORIG-GUID: KzYkCLkaL67XoFlRh09ldXL3cHCdNeZ2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make veristat distinguish between table and CSV output formats and use
different default set of stats (columns) that are emitted. While for
human-readable table output it doesn't make sense to output all known
stats, it is very useful for CSV mode to record all possible data, so
that it can later be queried and filtered in replay or comparison mode.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index 37e512d233a7..ec1a8ba7791c 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -501,6 +501,15 @@ static const struct stat_specs default_output_spec = {
 	},
 };
 
+static const struct stat_specs default_csv_output_spec = {
+	.spec_cnt = 9,
+	.ids = {
+		FILE_NAME, PROG_NAME, VERDICT, DURATION,
+		TOTAL_INSNS, TOTAL_STATES, PEAK_STATES,
+		MAX_STATES_PER_INSN, MARK_READ_MAX_LEN,
+	},
+};
+
 static const struct stat_specs default_sort_spec = {
 	.spec_cnt = 2,
 	.ids = {
@@ -1561,8 +1570,12 @@ int main(int argc, char **argv)
 	if (env.verbose && env.log_level == 0)
 		env.log_level = 1;
 
-	if (env.output_spec.spec_cnt == 0)
-		env.output_spec = default_output_spec;
+	if (env.output_spec.spec_cnt == 0) {
+		if (env.out_fmt == RESFMT_CSV)
+			env.output_spec = default_csv_output_spec;
+		else
+			env.output_spec = default_output_spec;
+	}
 	if (env.sort_spec.spec_cnt == 0)
 		env.sort_spec = default_sort_spec;
 
-- 
2.30.2

