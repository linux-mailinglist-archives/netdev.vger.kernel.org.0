Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5F830FF34
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhBDVTg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 4 Feb 2021 16:19:36 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:41969 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229705AbhBDVTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 16:19:33 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-XdWrGnxIPauF11nYIZe4XA-1; Thu, 04 Feb 2021 16:18:40 -0500
X-MC-Unique: XdWrGnxIPauF11nYIZe4XA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7AB9107ACC7;
        Thu,  4 Feb 2021 21:18:38 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFBA85B695;
        Thu,  4 Feb 2021 21:18:35 +0000 (UTC)
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
Subject: [PATCH bpf-next 3/4] tools/resolve_btfids: Set srctree variable unconditionally
Date:   Thu,  4 Feb 2021 22:18:24 +0100
Message-Id: <20210204211825.588160-4-jolsa@kernel.org>
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

We want this clean to be called from tree's root Makefile,
which defines same srctree variable and that will screw
the make setup.

We actually do not use srctree being passed from outside,
so we can solve this by setting current srctree value
directly.

Also root Makefile does not define the implicit RM variable,
so adding RM initialization.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/resolve_btfids/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index 3007cfabf5e6..b41fc9a81e83 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -2,11 +2,9 @@
 include ../../scripts/Makefile.include
 include ../../scripts/Makefile.arch
 
-ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
-endif
 
 ifeq ($(V),1)
   Q =
@@ -22,6 +20,7 @@ AR       = $(HOSTAR)
 CC       = $(HOSTCC)
 LD       = $(HOSTLD)
 ARCH     = $(HOSTARCH)
+RM      ?= rm
 
 OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
 
-- 
2.26.2

