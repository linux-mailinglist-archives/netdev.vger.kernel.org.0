Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BC12FF5C9
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 21:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbhAUUYY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Jan 2021 15:24:24 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:49508 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727095AbhAUUXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 15:23:19 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-YTBr82aLNZ2LImdhKfKboQ-1; Thu, 21 Jan 2021 15:22:24 -0500
X-MC-Unique: YTBr82aLNZ2LImdhKfKboQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A767F107ACE3;
        Thu, 21 Jan 2021 20:22:22 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9124461F55;
        Thu, 21 Jan 2021 20:22:19 +0000 (UTC)
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
Date:   Thu, 21 Jan 2021 21:22:01 +0100
Message-Id: <20210121202203.9346-2-jolsa@kernel.org>
In-Reply-To: <20210121202203.9346-1-jolsa@kernel.org>
References: <20210121202203.9346-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index 7b667647420f..9e0fdca3ae04 100644
--- a/dutil.c
+++ b/dutil.c
@@ -179,13 +179,17 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
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
-		if (!strcmp(name, str)) {
+		str = elf_strptr(elf, str_idx, shp->sh_name);
+		if (str && !strcmp(name, str)) {
 			if (index)
 				*index = cnt;
 			break;
-- 
2.27.0

