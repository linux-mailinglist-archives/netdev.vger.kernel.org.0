Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7807B251FE5
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 21:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgHYTXo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Aug 2020 15:23:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29103 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726149AbgHYTXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 15:23:44 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-v6z3FJGfMR2DlR0vamUE4A-1; Tue, 25 Aug 2020 15:22:35 -0400
X-MC-Unique: v6z3FJGfMR2DlR0vamUE4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED5AE100670C;
        Tue, 25 Aug 2020 19:22:33 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF4F319C4F;
        Tue, 25 Aug 2020 19:22:27 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH v12 bpf-next 14/14] selftests/bpf: Add set test to resolve_btfids
Date:   Tue, 25 Aug 2020 21:21:24 +0200
Message-Id: <20200825192124.710397-15-jolsa@kernel.org>
In-Reply-To: <20200825192124.710397-1-jolsa@kernel.org>
References: <20200825192124.710397-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0.0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding test to for sets resolve_btfids. We're checking that
testing set gets properly resolved and sorted.

Acked-by: Andrii Nakryiko <andriin@fb.com>
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

