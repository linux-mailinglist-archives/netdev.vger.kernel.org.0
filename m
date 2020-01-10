Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD725137A07
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 00:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgAJXQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 18:16:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25626 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727462AbgAJXQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 18:16:51 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00ANCW68004910
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 15:16:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=/ktD/Q1IY9kit9Yj2BJN5qP5d4ytbTQTL3TqvB1cE6k=;
 b=bFVZNeKBncSg4dZl021I/tUZGf+YgO0lrImSl88V0MZ5V7uXBQzFuQXNth6V7xVl+oSW
 DrMt7o+f85cphYzLR4c81NgAwu7FyTPDszzXwyOdwFxsOo10DMwJF94n5dhmp5ety/0K
 NRlie6nsda+RzP8EyQ7HSsC0iNtqQFF6RXU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2xenyt4vdx-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 15:16:50 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 10 Jan 2020 15:16:48 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 347EE29431EF; Fri, 10 Jan 2020 15:16:44 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpftool: Fix printing incorrect pointer in btf_dump_ptr
Date:   Fri, 10 Jan 2020 15:16:44 -0800
Message-ID: <20200110231644.3484151-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_03:2020-01-10,2020-01-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=658 spamscore=0
 phishscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001100190
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For plain text output, it incorrectly prints the pointer value
"void *data".  The "void *data" is actually pointing to memory that
contains a bpf-map's value.  The intention is to print the content of
the bpf-map's value instead of printing the pointer pointing to the
bpf-map's value.

In this case, a member of the bpf-map's value is a pointer type.
Thus, it should print the "*(void **)data".

Fixes: 22c349e8db89 ("tools: bpftool: fix format strings and arguments for jsonw_printf()")
Cc: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/bpf/bpftool/btf_dumper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index d66131f69689..397e5716ab6d 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -26,7 +26,7 @@ static void btf_dumper_ptr(const void *data, json_writer_t *jw,
 			   bool is_plain_text)
 {
 	if (is_plain_text)
-		jsonw_printf(jw, "%p", data);
+		jsonw_printf(jw, "%p", *(void **)data);
 	else
 		jsonw_printf(jw, "%lu", *(unsigned long *)data);
 }
-- 
2.17.1

