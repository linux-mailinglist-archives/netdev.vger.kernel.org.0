Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5539A251FDE
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 21:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHYTWs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Aug 2020 15:22:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42243 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726090AbgHYTWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 15:22:47 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-hTnt2NlbM3W9WwC6odc6Hg-1; Tue, 25 Aug 2020 15:21:37 -0400
X-MC-Unique: hTnt2NlbM3W9WwC6odc6Hg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9CE281CAF9;
        Tue, 25 Aug 2020 19:21:35 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4319619C4F;
        Tue, 25 Aug 2020 19:21:33 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH v12 bpf-next 01/14] tools resolve_btfids: Add size check to get_id function
Date:   Tue, 25 Aug 2020 21:21:11 +0200
Message-Id: <20200825192124.710397-2-jolsa@kernel.org>
In-Reply-To: <20200825192124.710397-1-jolsa@kernel.org>
References: <20200825192124.710397-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make sure we don't crash on malformed symbols.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/resolve_btfids/main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index 4d9ecb975862..35a172d3d80d 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -199,9 +199,16 @@ static char *get_id(const char *prefix_end)
 	/*
 	 * __BTF_ID__func__vfs_truncate__0
 	 * prefix_end =  ^
+	 * pos        =    ^
 	 */
-	char *p, *id = strdup(prefix_end + sizeof("__") - 1);
+	int len = strlen(prefix_end);
+	int pos = sizeof("__") - 1;
+	char *p, *id;
 
+	if (pos >= len)
+		return NULL;
+
+	id = strdup(prefix_end + pos);
 	if (id) {
 		/*
 		 * __BTF_ID__func__vfs_truncate__0
-- 
2.25.4

