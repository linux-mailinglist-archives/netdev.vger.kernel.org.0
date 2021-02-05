Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A58D31163A
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 00:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhBEW6m convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Feb 2021 17:58:42 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:37015 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232223AbhBEMle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 07:41:34 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-jcChwwVFP-GA3zUkZXIv9w-1; Fri, 05 Feb 2021 07:40:32 -0500
X-MC-Unique: jcChwwVFP-GA3zUkZXIv9w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88011100CCC2;
        Fri,  5 Feb 2021 12:40:30 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.195.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C655660936;
        Fri,  5 Feb 2021 12:40:27 +0000 (UTC)
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
Date:   Fri,  5 Feb 2021 13:40:18 +0100
Message-Id: <20210205124020.683286-3-jolsa@kernel.org>
In-Reply-To: <20210205124020.683286-1-jolsa@kernel.org>
References: <20210205124020.683286-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 1d46a247ec95..be09ec4f03ff 100644
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
+ifneq ($(clean_objects),)
 clean: fixdep-clean
 	$(call msg,CLEAN,$(BINARY))
-	$(Q)$(RM) -f $(BINARY); \
-	$(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
-	$(RM) -rf $(OUTPUT)/libbpf; \
-	$(RM) -rf $(OUTPUT)/libsubcmd; \
-	find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
+	$(Q)$(RM) -rf $(clean_objects)
+else
+clean:
+endif
 
 tags:
 	$(call msg,GEN,,tags)
-- 
2.26.2

