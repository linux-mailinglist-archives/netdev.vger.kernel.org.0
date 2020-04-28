Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762501BB962
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgD1JAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:00:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48425 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726271AbgD1JAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:00:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588064418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/D7IUJaHVeqhYqyfJK923a/ASGcuo1XdhwZGpbQkuNg=;
        b=IJrgUeW6+DLwl6q2VUA1g7i9kGzw97mXHa0R8QR0dMqV/F5q4wzbY2dSodClx1tBtolAAP
        1qtWRwtBEflEmWjVaf0I3DofQb0PhceDfR0wbthw+ztLlftc+DcCd/fD6j9KRXBrz9Gayk
        sE5BTieENxepQWeuLIVCchwHpU7YkcE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-EAbsempkMH-u0MfD5PN5yg-1; Tue, 28 Apr 2020 05:00:14 -0400
X-MC-Unique: EAbsempkMH-u0MfD5PN5yg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 927B981CBE1;
        Tue, 28 Apr 2020 09:00:13 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.193.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53B50648C8;
        Tue, 28 Apr 2020 09:00:12 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH iproute2-next] tc: full JSON support for 'bpf' filter
Date:   Tue, 28 Apr 2020 11:00:07 +0200
Message-Id: <57923a5a17573e7939a78a55ba5b6dd28ad1862f.1588064112.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

example using eBPF:

 # tc filter add dev dummy0 ingress bpf \
 > direct-action obj ./bpf/filter.o sec tc-ingress
 # tc  -j filter show dev dummy0 ingress | jq
 [
   {
     "protocol": "all",
     "pref": 49152,
     "kind": "bpf",
     "chain": 0
   },
   {
     "protocol": "all",
     "pref": 49152,
     "kind": "bpf",
     "chain": 0,
     "options": {
       "handle": "1",
       "bpf_name": "filter.o:[tc-ingress]",
       "direct-action": true,
       "not_in_hw": true,
       "prog": {
         "id": 101,
         "tag": "a04f5eef06a7f555",
         "jited": 1
       }
     }
   }
 ]

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 tc/f_bpf.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/tc/f_bpf.c b/tc/f_bpf.c
index 135271aa1697..519186f929e5 100644
--- a/tc/f_bpf.c
+++ b/tc/f_bpf.c
@@ -203,22 +203,24 @@ static int bpf_print_opt(struct filter_util *qu, FI=
LE *f,
 	parse_rtattr_nested(tb, TCA_BPF_MAX, opt);
=20
 	if (handle)
-		fprintf(f, "handle 0x%x ", handle);
+		print_hex(PRINT_ANY, "handle", "handle 0x%x ", handle);
=20
 	if (tb[TCA_BPF_CLASSID]) {
 		SPRINT_BUF(b1);
-		fprintf(f, "flowid %s ",
+		print_string(PRINT_ANY, "flowid", "flowid %s ",
 			sprint_tc_classid(rta_getattr_u32(tb[TCA_BPF_CLASSID]), b1));
 	}
=20
 	if (tb[TCA_BPF_NAME])
-		fprintf(f, "%s ", rta_getattr_str(tb[TCA_BPF_NAME]));
+		print_string(PRINT_ANY, "bpf_name", "%s ",
+			     rta_getattr_str(tb[TCA_BPF_NAME]));
=20
 	if (tb[TCA_BPF_FLAGS]) {
 		unsigned int flags =3D rta_getattr_u32(tb[TCA_BPF_FLAGS]);
=20
 		if (flags & TCA_BPF_FLAG_ACT_DIRECT)
-			fprintf(f, "direct-action ");
+			print_bool(PRINT_ANY,
+				   "direct-action", "direct-action ", true);
 	}
=20
 	if (tb[TCA_BPF_FLAGS_GEN]) {
@@ -226,14 +228,14 @@ static int bpf_print_opt(struct filter_util *qu, FI=
LE *f,
 			rta_getattr_u32(tb[TCA_BPF_FLAGS_GEN]);
=20
 		if (flags & TCA_CLS_FLAGS_SKIP_HW)
-			fprintf(f, "skip_hw ");
+			print_bool(PRINT_ANY, "skip_hw", "skip_hw ", true);
 		if (flags & TCA_CLS_FLAGS_SKIP_SW)
-			fprintf(f, "skip_sw ");
-
+			print_bool(PRINT_ANY, "skip_sw", "skip_sw ", true);
 		if (flags & TCA_CLS_FLAGS_IN_HW)
-			fprintf(f, "in_hw ");
+			print_bool(PRINT_ANY, "in_hw", "in_hw ", true);
 		else if (flags & TCA_CLS_FLAGS_NOT_IN_HW)
-			fprintf(f, "not_in_hw ");
+			print_bool(PRINT_ANY,
+				   "not_in_hw", "not_in_hw ", true);
 	}
=20
 	if (tb[TCA_BPF_OPS] && tb[TCA_BPF_OPS_LEN])
@@ -245,14 +247,13 @@ static int bpf_print_opt(struct filter_util *qu, FI=
LE *f,
 	if (!dump_ok && tb[TCA_BPF_TAG]) {
 		SPRINT_BUF(b);
=20
-		fprintf(f, "tag %s ",
-			hexstring_n2a(RTA_DATA(tb[TCA_BPF_TAG]),
-				      RTA_PAYLOAD(tb[TCA_BPF_TAG]),
-				      b, sizeof(b)));
+		print_string(PRINT_ANY, "tag", "tag %s ",
+			     hexstring_n2a(RTA_DATA(tb[TCA_BPF_TAG]),
+			     RTA_PAYLOAD(tb[TCA_BPF_TAG]), b, sizeof(b)));
 	}
=20
 	if (tb[TCA_BPF_POLICE]) {
-		fprintf(f, "\n");
+		print_string(PRINT_FP, NULL, "\n", "");
 		tc_print_police(f, tb[TCA_BPF_POLICE]);
 	}
=20
--=20
2.25.3

