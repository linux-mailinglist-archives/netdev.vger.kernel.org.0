Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8D4D03DD
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbfJHXKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:10:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9896 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727966AbfJHXKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 19:10:31 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x98NAODe012591
        for <netdev@vger.kernel.org>; Tue, 8 Oct 2019 16:10:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=62jkZIEpbMn5ilAQoyZ2IKEoJq6Ac1YNqdTQSBOXkpk=;
 b=qkGxd1drFGwFEgKwKocLv4WxV+xZV1xL4NLApPcPLg8b2wpMFQRRvy8CLepMYn+tC8M8
 8fMHO30zl7tpBptsIfp43PbBr/TIg04KVBk57OHYhkUH8IaJQA6aEaFs6vrKektEcxyv
 vojFVvf2CBcczEXXqQPnXjZnDoYWeZ1g+Es= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vgpq9mb0r-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 16:10:30 -0700
Received: from 2401:db00:30:600c:face:0:39:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 8 Oct 2019 16:10:13 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id ED7358618FA; Tue,  8 Oct 2019 16:10:12 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 1/3] libbpf: fix struct end padding in btf_dump
Date:   Tue, 8 Oct 2019 16:10:06 -0700
Message-ID: <20191008231009.2991130-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191008231009.2991130-1-andriin@fb.com>
References: <20191008231009.2991130-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-08_08:2019-10-08,2019-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=545
 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0
 mlxscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910080183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a case where explicit padding at the end of a struct is necessary
due to non-standart alignment requirements of fields (which BTF doesn't
capture explicitly).

Fixes: 351131b51c7a ("libbpf: add btf_dump API for BTF-to-C conversion")
Reported-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf_dump.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index ede55fec3618..87f27e2664c5 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -876,7 +876,6 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 	__u16 vlen = btf_vlen(t);
 
 	packed = is_struct ? btf_is_struct_packed(d->btf, id, t) : 0;
-	align = packed ? 1 : btf_align_of(d->btf, id);
 
 	btf_dump_printf(d, "%s%s%s {",
 			is_struct ? "struct" : "union",
@@ -906,6 +905,13 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 		btf_dump_printf(d, ";");
 	}
 
+	/* pad at the end, if necessary */
+	if (is_struct) {
+		align = packed ? 1 : btf_align_of(d->btf, id);
+		btf_dump_emit_bit_padding(d, off, t->size * 8, 0, align,
+					  lvl + 1);
+	}
+
 	if (vlen)
 		btf_dump_printf(d, "\n");
 	btf_dump_printf(d, "%s}", pfx(lvl));
-- 
2.17.1

