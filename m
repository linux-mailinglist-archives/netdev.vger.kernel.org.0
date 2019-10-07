Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D59CDAA5
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 05:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfJGDa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 23:30:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1474 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbfJGDa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 23:30:56 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x973Nw83019903
        for <netdev@vger.kernel.org>; Sun, 6 Oct 2019 20:30:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=bCBj2ZS7TtfpnwwyIZ8pgfOtn2YOCrvuK4cQk7S3ek4=;
 b=oimpUIcJhorj8OHSbbu8uvZsQhGouhqppOMxcREt8cmw5gAaBjYOe0tGfHtJPvq4CILQ
 vr0U4t+sNnzc4wkGRGTDt4CF6PxxT8HsPoTuzqHIYV34gNQnr+gG19WJUSphCwQA/UMV
 oeTX8K14CFn+QnZFrMCAK4APL6cI49lmxXs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ves0gp5cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 20:30:55 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sun, 6 Oct 2019 20:30:54 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id F20C086190E; Sun,  6 Oct 2019 20:30:53 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] selftests/bpf: fix dependency ordering for attach_probe test
Date:   Sun, 6 Oct 2019 20:30:37 -0700
Message-ID: <20191007033037.2687437-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-06_11:2019-10-03,2019-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=8
 mlxscore=0 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0
 mlxlogscore=953 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910070034
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current Makefile dependency chain is not strict enough and allows
test_attach_probe.o to be built before test_progs's
prog_test/attach_probe.o is built, which leads to assembler compainig
about missing included binary.

This patch is a minimal fix to fix this issue by enforcing that
test_attach_probe.o (BPF object file) is built before
prog_tests/attach_probe.c is attempted to be compiled.

Fixes: 928ca75e59d7 ("selftests/bpf: switch tests to new bpf_object__open_{file, mem}() APIs")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 294d7472dad7..f899ed20ef4d 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -160,7 +160,8 @@ $(OUTPUT)/test_queue_map.o: test_queue_stack_map.h
 $(OUTPUT)/test_stack_map.o: test_queue_stack_map.h
 
 $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
-$(OUTPUT)/test_progs.o: flow_dissector_load.h $(OUTPUT)/test_attach_probe.o
+prog_tests/attach_probe.c: $(OUTPUT)/test_attach_probe.o
+$(OUTPUT)/test_progs.o: flow_dissector_load.h
 
 BTF_LLC_PROBE := $(shell $(LLC) -march=bpf -mattr=help 2>&1 | grep dwarfris)
 BTF_PAHOLE_PROBE := $(shell $(BTF_PAHOLE) --help 2>&1 | grep BTF)
-- 
2.17.1

