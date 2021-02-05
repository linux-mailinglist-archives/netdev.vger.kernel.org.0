Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98B2310B47
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 13:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhBEMpY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Feb 2021 07:45:24 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:60757 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231757AbhBEMle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 07:41:34 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-XY0ZIqP-PDOaXbiuUMEF7g-1; Fri, 05 Feb 2021 07:40:35 -0500
X-MC-Unique: XY0ZIqP-PDOaXbiuUMEF7g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96511C7401;
        Fri,  5 Feb 2021 12:40:33 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.195.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6D8460936;
        Fri,  5 Feb 2021 12:40:30 +0000 (UTC)
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
Date:   Fri,  5 Feb 2021 13:40:19 +0100
Message-Id: <20210205124020.683286-4-jolsa@kernel.org>
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

We want this clean to be called from tree's root Makefile,
which defines same srctree variable and that will screw
the make setup.

We actually do not use srctree being passed from outside,
so we can solve this by setting current srctree value
directly.

Also changing the way how srctree is initialized as suggested
by Andrri.

Also root Makefile does not define the implicit RM variable,
so adding RM initialization.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/resolve_btfids/Makefile | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index be09ec4f03ff..bb9fa8de7e62 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -2,11 +2,7 @@
 include ../../scripts/Makefile.include
 include ../../scripts/Makefile.arch
 
-ifeq ($(srctree),)
-srctree := $(patsubst %/,%,$(dir $(CURDIR)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-endif
+srctree := $(abspath $(CURDIR)/../../../)
 
 ifeq ($(V),1)
   Q =
@@ -22,6 +18,7 @@ AR       = $(HOSTAR)
 CC       = $(HOSTCC)
 LD       = $(HOSTLD)
 ARCH     = $(HOSTARCH)
+RM      ?= rm
 
 OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
 
-- 
2.26.2

