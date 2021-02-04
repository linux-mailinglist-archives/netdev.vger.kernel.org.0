Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4EA30FF32
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhBDVTf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 4 Feb 2021 16:19:35 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:39621 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhBDVTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 16:19:32 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-blhucydMPx-xTAXynG_zvA-1; Thu, 04 Feb 2021 16:18:37 -0500
X-MC-Unique: blhucydMPx-xTAXynG_zvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DD1E4236B;
        Thu,  4 Feb 2021 21:18:35 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7FA05B697;
        Thu,  4 Feb 2021 21:18:32 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH bpf-next 2/4] tools/resolve_btfids: Check objects before removing
Date:   Thu,  4 Feb 2021 22:18:23 +0100
Message-Id: <20210204211825.588160-3-jolsa@kernel.org>
In-Reply-To: <20210204211825.588160-1-jolsa@kernel.org>
References: <20210129134855.195810-1-jolsa@redhat.com>
 <20210204211825.588160-1-jolsa@kernel.org>
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

We want this clean to be called from tree's root clean
and that one is silent if there's nothing to clean.

Adding check for all object to clean and display CLEAN
messages only if there are objects to remove.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/resolve_btfids/Makefile | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index b780b3a9fb07..3007cfabf5e6 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -64,13 +64,20 @@ $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
 	$(call msg,LINK,$@)
 	$(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
 
+clean_objects := $(wildcard $(OUTPUT)/*.o                \
+                            $(OUTPUT)/.*.o.cmd           \
+                            $(OUTPUT)/.*.o.d             \
+                            $(OUTPUT)/libbpf             \
+                            $(OUTPUT)/libsubcmd          \
+                            $(OUTPUT)/resolve_btfids)
+
+clean:
+
+ifneq ($(clean_objects),)
 clean: fixdep-clean
 	$(call msg,CLEAN,$(BINARY))
-	$(Q)$(RM) -f $(BINARY); \
-	$(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
-	$(RM) -rf $(OUTPUT)libbpf; \
-	$(RM) -rf $(OUTPUT)libsubcmd; \
-	find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
+	$(Q)$(RM) -rf $(clean_objects)
+endif
 
 tags:
 	$(call msg,GEN,,tags)
-- 
2.26.2

