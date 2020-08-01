Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FA2235396
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 19:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgHARDi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 1 Aug 2020 13:03:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43075 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727787AbgHARDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 13:03:37 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-wLsO2qkUM-6xiqdBUMR_gw-1; Sat, 01 Aug 2020 13:03:32 -0400
X-MC-Unique: wLsO2qkUM-6xiqdBUMR_gw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 498E318839C2;
        Sat,  1 Aug 2020 17:03:30 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 032075F7D8;
        Sat,  1 Aug 2020 17:03:26 +0000 (UTC)
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
Subject: [PATCH v9 bpf-next 01/14] tools resolve_btfids: Add size check to get_id function
Date:   Sat,  1 Aug 2020 19:03:09 +0200
Message-Id: <20200801170322.75218-2-jolsa@kernel.org>
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

To make sure we don't crash on malformed symbols.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/resolve_btfids/main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index 6956b6350cad..e0929620abc6 100644
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

