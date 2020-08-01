Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987842353B2
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 19:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgHAREZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 1 Aug 2020 13:04:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44820 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728027AbgHAREZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 13:04:25 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-4YrwYg1tOwevycFaH6ynMQ-1; Sat, 01 Aug 2020 13:04:18 -0400
X-MC-Unique: 4YrwYg1tOwevycFaH6ynMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 411E010059A2;
        Sat,  1 Aug 2020 17:04:16 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08A6D5F7D8;
        Sat,  1 Aug 2020 17:04:12 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v9 bpf-next 14/14] selftests/bpf: Add set test to resolve_btfids
Date:   Sat,  1 Aug 2020 19:03:22 +0200
Message-Id: <20200801170322.75218-15-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-1-jolsa@kernel.org>
References: <20200801170322.75218-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding test to for sets resolve_btfids. We're checking that
testing set gets properly resolved and sorted.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/resolve_btfids.c | 39 ++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
index 3b127cab4864..8826c652adad 100644
--- a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
+++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
@@ -47,6 +47,15 @@ BTF_ID(struct,  S)
 BTF_ID(union,   U)
 BTF_ID(func,    func)
 
+BTF_SET_START(test_set)
+BTF_ID(typedef, S)
+BTF_ID(typedef, T)
+BTF_ID(typedef, U)
+BTF_ID(struct,  S)
+BTF_ID(union,   U)
+BTF_ID(func,    func)
+BTF_SET_END(test_set)
+
 static int
 __resolve_symbol(struct btf *btf, int type_id)
 {
@@ -116,12 +125,40 @@ int test_resolve_btfids(void)
 	 */
 	for (j = 0; j < ARRAY_SIZE(test_lists); j++) {
 		test_list = test_lists[j];
-		for (i = 0; i < ARRAY_SIZE(test_symbols) && !ret; i++) {
+		for (i = 0; i < ARRAY_SIZE(test_symbols); i++) {
 			ret = CHECK(test_list[i] != test_symbols[i].id,
 				    "id_check",
 				    "wrong ID for %s (%d != %d)\n",
 				    test_symbols[i].name,
 				    test_list[i], test_symbols[i].id);
+			if (ret)
+				return ret;
+		}
+	}
+
+	/* Check BTF_SET_START(test_set) IDs */
+	for (i = 0; i < test_set.cnt; i++) {
+		bool found = false;
+
+		for (j = 0; j < ARRAY_SIZE(test_symbols); j++) {
+			if (test_symbols[j].id != test_set.ids[i])
+				continue;
+			found = true;
+			break;
+		}
+
+		ret = CHECK(!found, "id_check",
+			    "ID %d not found in test_symbols\n",
+			    test_set.ids[i]);
+		if (ret)
+			break;
+
+		if (i > 0) {
+			ret = CHECK(test_set.ids[i - 1] > test_set.ids[i],
+				    "sort_check",
+				    "test_set is not sorted\n");
+			if (ret)
+				break;
 		}
 	}
 
-- 
2.25.4

