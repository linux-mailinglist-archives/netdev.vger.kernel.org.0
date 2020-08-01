Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7FE2353A2
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 19:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgHARD4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 1 Aug 2020 13:03:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20165 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727915AbgHARDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 13:03:54 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-l_dBGaV0N7GLeJFQ6rXIIQ-1; Sat, 01 Aug 2020 13:03:49 -0400
X-MC-Unique: l_dBGaV0N7GLeJFQ6rXIIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF594106B243;
        Sat,  1 Aug 2020 17:03:47 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC2A65F7D8;
        Sat,  1 Aug 2020 17:03:44 +0000 (UTC)
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
Subject: [PATCH v9 bpf-next 06/14] bpf: Remove recursion call in btf_struct_access
Date:   Sat,  1 Aug 2020 19:03:14 +0200
Message-Id: <20200801170322.75218-7-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-1-jolsa@kernel.org>
References: <20200801170322.75218-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

Andrii suggested we can simply jump to again label
instead of making recursion call.

Suggested-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/btf.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index bc05a24f7361..0f995038b589 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3931,14 +3931,13 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		/* Only allow structure for now, can be relaxed for
 		 * other types later.
 		 */
-		elem_type = btf_type_skip_modifiers(btf_vmlinux,
-						    array_elem->type, NULL);
-		if (!btf_type_is_struct(elem_type))
+		t = btf_type_skip_modifiers(btf_vmlinux, array_elem->type,
+					    NULL);
+		if (!btf_type_is_struct(t))
 			goto error;
 
-		off = (off - moff) % elem_type->size;
-		return btf_struct_access(log, elem_type, off, size, atype,
-					 next_btf_id);
+		off = (off - moff) % t->size;
+		goto again;
 
 error:
 		bpf_log(log, "access beyond struct %s at off %u size %u\n",
-- 
2.25.4

