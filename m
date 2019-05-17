Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51326213A9
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 08:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfEQGVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 02:21:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33640 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726871AbfEQGVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 02:21:38 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4H6KHGE012878
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 23:21:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=1zM4i+9DBcU+/2vrPgNzYIEolzSQQ7YcSOPhfZYz4qE=;
 b=kEJmT5qSv5vITrKw4nwt6h8qlxKMA9HJhFTWuHUff9b4qRsX4HF7GsSI6FlfdujrWdcn
 YZWo2OXwzptGYf0qdpRvpn3l6rfcLzOIX0gN+PTkvd/wIjmu+ZkJiguHGx47d7hPrc6u
 OezEzhIyzwpKb8V1IQbhSQy2NEoloroKEtQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2she371snc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 23:21:37 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 16 May 2019 23:21:36 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id A39518617A7; Thu, 16 May 2019 23:21:35 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf] bpftool: fix BTF raw dump of FWD's fwd_kind
Date:   Thu, 16 May 2019 23:21:29 -0700
Message-ID: <20190517062129.2786346-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-17_03:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kflag bit determines whether FWD is for struct or union. Use that bit.

Fixes: c93cc69004df ("bpftool: add ability to dump BTF types")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 58a2cd002a4b..7317438ecd9e 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -208,8 +208,8 @@ static int dump_btf_type(const struct btf *btf, __u32 id,
 		break;
 	}
 	case BTF_KIND_FWD: {
-		const char *fwd_kind = BTF_INFO_KIND(t->info) ? "union"
-							      : "struct";
+		const char *fwd_kind = BTF_INFO_KFLAG(t->info) ? "union"
+							       : "struct";
 
 		if (json_output)
 			jsonw_string_field(w, "fwd_kind", fwd_kind);
-- 
2.17.1

