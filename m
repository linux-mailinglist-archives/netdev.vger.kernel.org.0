Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887B82FC328
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbhASWRF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Jan 2021 17:17:05 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:58823 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389002AbhASWNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 17:13:34 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-0Yh3F1GfNcqFt62fkVCS9w-1; Tue, 19 Jan 2021 17:12:36 -0500
X-MC-Unique: 0Yh3F1GfNcqFt62fkVCS9w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23144180A0A2;
        Tue, 19 Jan 2021 22:12:34 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 004AB9CA0;
        Tue, 19 Jan 2021 22:12:30 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     dwarves@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Subject: [PATCH 1/3] elf_symtab: Add support for SHN_XINDEX index to elf_section_by_name
Date:   Tue, 19 Jan 2021 23:12:18 +0100
Message-Id: <20210119221220.1745061-2-jolsa@kernel.org>
In-Reply-To: <20210119221220.1745061-1-jolsa@kernel.org>
References: <20210119221220.1745061-1-jolsa@kernel.org>
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

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 dutil.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/dutil.c b/dutil.c
index 7b667647420f..321f4be6669e 100644
--- a/dutil.c
+++ b/dutil.c
@@ -179,13 +179,17 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 {
 	Elf_Scn *sec = NULL;
 	size_t cnt = 1;
+	size_t shstrndx = ep->e_shstrndx;
+
+	if (shstrndx == SHN_XINDEX && elf_getshdrstrndx(elf, &shstrndx))
+		return NULL;
 
 	while ((sec = elf_nextscn(elf, sec)) != NULL) {
 		char *str;
 
 		gelf_getshdr(sec, shp);
-		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
-		if (!strcmp(name, str)) {
+		str = elf_strptr(elf, shstrndx, shp->sh_name);
+		if (str && !strcmp(name, str)) {
 			if (index)
 				*index = cnt;
 			break;
-- 
2.27.0

