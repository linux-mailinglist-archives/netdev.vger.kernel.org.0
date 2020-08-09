Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CEF23FEDB
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 17:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgHIPDZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 9 Aug 2020 11:03:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22012 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726266AbgHIPDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 11:03:22 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-rR8m0nkEML24wLbAetfLbQ-1; Sun, 09 Aug 2020 11:03:17 -0400
X-MC-Unique: rR8m0nkEML24wLbAetfLbQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BE3180183C;
        Sun,  9 Aug 2020 15:03:15 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 618CD72AD1;
        Sun,  9 Aug 2020 15:03:12 +0000 (UTC)
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
Subject: [RFC PATCH v11 bpf-next 02/14] tools resolve_btfids: Add support for set symbols
Date:   Sun,  9 Aug 2020 17:02:50 +0200
Message-Id: <20200809150302.686149-3-jolsa@kernel.org>
In-Reply-To: <20200809150302.686149-1-jolsa@kernel.org>
References: <20200809150302.686149-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The set symbol does not have the unique number suffix,
so we need to give it a special parsing function.

This was omitted in the first batch, because there was
no set support yet, so it slipped in the testing.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/resolve_btfids/main.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index b83369887df6..81782c3ff485 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -227,6 +227,24 @@ static char *get_id(const char *prefix_end)
 	return id;
 }
 
+static struct btf_id *add_set(struct object *obj, char *name)
+{
+	/*
+	 * __BTF_ID__set__name
+	 * name =    ^
+	 * id   =         ^
+	 */
+	char *id = name + sizeof(BTF_SET "__") - 1;
+	int len = strlen(name);
+
+	if (id >= name + len) {
+		pr_err("FAILED to parse set name: %s\n", name);
+		return NULL;
+	}
+
+	return btf_id__add(&obj->sets, id, true);
+}
+
 static struct btf_id *add_symbol(struct rb_root *root, char *name, size_t size)
 {
 	char *id;
@@ -383,7 +401,7 @@ static int symbols_collect(struct object *obj)
 			id = add_symbol(&obj->funcs, prefix, sizeof(BTF_FUNC) - 1);
 		/* set */
 		} else if (!strncmp(prefix, BTF_SET, sizeof(BTF_SET) - 1)) {
-			id = add_symbol(&obj->sets, prefix, sizeof(BTF_SET) - 1);
+			id = add_set(obj, prefix);
 			/*
 			 * SET objects store list's count, which is encoded
 			 * in symbol's size, together with 'cnt' field hence
-- 
2.25.4

