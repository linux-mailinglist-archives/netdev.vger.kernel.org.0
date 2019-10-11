Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1EFBD37C4
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfJKDNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:13:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34468 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726096AbfJKDNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:13:30 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9B394Rk017865
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:13:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=VoDEj23fzofbPx+FUBCrFd5Bx8lK3uAoE0lXwiLOJoo=;
 b=Z5PPlqTbjax9ZxWE9ReA01I5vIE5uInozvyfwFQcXRkf5Q0hH/YKyA2FTVQPk5t6c+NV
 EqhHhDxw5qlWuq4Y378U1cSKadG6OkzVaNzFej59nm84OD4VWfxUlnrG4amCNhM503I7
 1jRQWPdr3YQdYyw1ePjW0BcfEgD45Fk+dy4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vjekprr5w-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:13:29 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 10 Oct 2019 20:13:27 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id A5BAF861907; Thu, 10 Oct 2019 20:13:26 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 1/2] selftests/bpf: enforce libbpf build before BPF programs are built
Date:   Thu, 10 Oct 2019 20:13:17 -0700
Message-ID: <20191011031318.388493-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011031318.388493-1-andriin@fb.com>
References: <20191011031318.388493-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_01:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 spamscore=0 adultscore=0 mlxscore=0 mlxlogscore=539 clxscore=1015
 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910110028
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given BPF programs rely on libbpf's bpf_helper_defs.h, which is
auto-generated during libbpf build, libbpf build has to happen before
we attempt progs/*.c build. Enforce it as order-only dependency.

Fixes: 24f25763d6de ("libbpf: auto-generate list of BPF helper definitions")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 40552fb441e5..f958643d36da 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -256,7 +256,8 @@ ifeq ($(DWARF2BTF),y)
 	$(BTF_PAHOLE) -J $@
 endif
 
-$(OUTPUT)/%.o: progs/%.c
+# libbpf has to be built before BPF programs due to bpf_helper_defs.h
+$(OUTPUT)/%.o: progs/%.c | $(BPFOBJ)
 	($(CLANG) $(BPF_CFLAGS) $(CLANG_CFLAGS) -O2 -target bpf -emit-llvm \
 		-c $< -o - || echo "clang failed") | \
 	$(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
-- 
2.17.1

