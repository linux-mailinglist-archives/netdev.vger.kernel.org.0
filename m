Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51737251FC4
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 21:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgHYTVv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Aug 2020 15:21:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27941 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726066AbgHYTVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 15:21:50 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-vTs8F96kOoaze9bzHRiYtQ-1; Tue, 25 Aug 2020 15:21:44 -0400
X-MC-Unique: vTs8F96kOoaze9bzHRiYtQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF6E01005E5B;
        Tue, 25 Aug 2020 19:21:39 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30B5619C4F;
        Tue, 25 Aug 2020 19:21:36 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH v12 bpf-next 02/14] tools resolve_btfids: Add support for set symbols
Date:   Tue, 25 Aug 2020 21:21:12 +0200
Message-Id: <20200825192124.710397-3-jolsa@kernel.org>
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
index 35a172d3d80d..6152d1356d7b 100644
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

