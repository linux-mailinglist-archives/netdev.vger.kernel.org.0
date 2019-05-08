Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2F318272
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 00:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfEHWuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 18:50:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55578 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725910AbfEHWuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 18:50:21 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48MgYm7015269
        for <netdev@vger.kernel.org>; Wed, 8 May 2019 15:50:20 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2sc50u8q7x-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 15:50:20 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 8 May 2019 15:50:17 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 989AA220D8337; Wed,  8 May 2019 15:50:16 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <ast@kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an xskmap
Date:   Wed, 8 May 2019 15:50:15 -0700
Message-ID: <20190508225016.2375828-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_12:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the AF_XDP code uses a separate map in order to
determine if an xsk is bound to a queue.  Instead of doing this,
have bpf_map_lookup_elem() return a boolean indicating whether
there is a valid entry at the map index.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 kernel/bpf/verifier.c                             |  6 +++++-
 kernel/bpf/xskmap.c                               |  2 +-
 .../selftests/bpf/verifier/prevent_map_lookup.c   | 15 ---------------
 3 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7b05e8938d5c..a8b8ff9ecd90 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2761,10 +2761,14 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	 * appear.
 	 */
 	case BPF_MAP_TYPE_CPUMAP:
-	case BPF_MAP_TYPE_XSKMAP:
 		if (func_id != BPF_FUNC_redirect_map)
 			goto error;
 		break;
+	case BPF_MAP_TYPE_XSKMAP:
+		if (func_id != BPF_FUNC_redirect_map &&
+		    func_id != BPF_FUNC_map_lookup_elem)
+			goto error;
+		break;
 	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
 	case BPF_MAP_TYPE_HASH_OF_MAPS:
 		if (func_id != BPF_FUNC_map_lookup_elem)
diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 686d244e798d..f6e49237979c 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -154,7 +154,7 @@ void __xsk_map_flush(struct bpf_map *map)
 
 static void *xsk_map_lookup_elem(struct bpf_map *map, void *key)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	return !!__xsk_map_lookup_elem(map, *(u32 *)key);
 }
 
 static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
diff --git a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
index bbdba990fefb..da7a4b37cb98 100644
--- a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
+++ b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
@@ -28,21 +28,6 @@
 	.errstr = "cannot pass map_type 18 into func bpf_map_lookup_elem",
 	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
 },
-{
-	"prevent map lookup in xskmap",
-	.insns = {
-	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-	BPF_LD_MAP_FD(BPF_REG_1, 0),
-	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
-	BPF_EXIT_INSN(),
-	},
-	.fixup_map_xskmap = { 3 },
-	.result = REJECT,
-	.errstr = "cannot pass map_type 17 into func bpf_map_lookup_elem",
-	.prog_type = BPF_PROG_TYPE_XDP,
-},
 {
 	"prevent map lookup in stack trace",
 	.insns = {
-- 
2.17.1

