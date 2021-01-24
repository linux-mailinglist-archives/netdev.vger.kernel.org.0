Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADC5301F26
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 23:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbhAXWQp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 24 Jan 2021 17:16:45 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:35900 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726583AbhAXWQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 17:16:32 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-7AGelVBuNLCOYGcgCSwgkQ-1; Sun, 24 Jan 2021 17:15:37 -0500
X-MC-Unique: 7AGelVBuNLCOYGcgCSwgkQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29041107ACE3;
        Sun, 24 Jan 2021 22:15:35 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1CCB6062F;
        Sun, 24 Jan 2021 22:15:31 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Subject: [PATCH 1/2] elf_symtab: Add support for SHN_XINDEX index to elf_section_by_name
Date:   Sun, 24 Jan 2021 23:15:18 +0100
Message-Id: <20210124221519.219750-2-jolsa@kernel.org>
In-Reply-To: <20210124221519.219750-1-jolsa@kernel.org>
References: <20210124221519.219750-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case the elf's header e_shstrndx contains SHN_XINDEX,
we need to call elf_getshdrstrndx to get the proper
string table index.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 dutil.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/dutil.c b/dutil.c
index 7b667647420f..11fb7202049c 100644
--- a/dutil.c
+++ b/dutil.c
@@ -179,12 +179,18 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 {
 	Elf_Scn *sec = NULL;
 	size_t cnt = 1;
+	size_t str_idx;
+
+	if (elf_getshdrstrndx(elf, &str_idx))
+		return NULL;
 
 	while ((sec = elf_nextscn(elf, sec)) != NULL) {
 		char *str;
 
 		gelf_getshdr(sec, shp);
-		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
+		str = elf_strptr(elf, str_idx, shp->sh_name);
+		if (!str)
+			return NULL;
 		if (!strcmp(name, str)) {
 			if (index)
 				*index = cnt;
-- 
2.26.2

