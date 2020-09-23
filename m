Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8448275955
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgIWOFL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 23 Sep 2020 10:05:11 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:46551 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726234AbgIWOFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:05:10 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-qmzJdKWMMwKbHlz_ht9Psg-1; Wed, 23 Sep 2020 10:05:05 -0400
X-MC-Unique: qmzJdKWMMwKbHlz_ht9Psg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF3458ECE56;
        Wed, 23 Sep 2020 14:05:03 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B011055777;
        Wed, 23 Sep 2020 14:05:00 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCHv2 bpf-next 1/2] bpf: Use --no-fail option if CONFIG_BPF is not enabled
Date:   Wed, 23 Sep 2020 16:04:58 +0200
Message-Id: <20200923140459.3029213-1-jolsa@kernel.org>
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

Currently all the resolve_btfids 'users' are under CONFIG_BPF
code, so if we have CONFIG_BPF disabled, resolve_btfids will
fail, because there's no data to resolve.

Disabling resolve_btfids if there's CONFIG_BPF disabled,
so we won't fail such builds.

Suggested-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
v2 changes:
  - disable resolve_btfids completely when CONFIG_BPF is not defined

 Makefile                | 4 +++-
 scripts/link-vmlinux.sh | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index c4470a4e131f..b05682eea2c0 100644
--- a/Makefile
+++ b/Makefile
@@ -1084,13 +1084,15 @@ ifdef CONFIG_STACK_VALIDATION
   endif
 endif
 
+ifdef CONFIG_BPF
 ifdef CONFIG_DEBUG_INFO_BTF
   ifeq ($(has_libelf),1)
     resolve_btfids_target := tools/bpf/resolve_btfids FORCE
   else
     ERROR_RESOLVE_BTFIDS := 1
   endif
-endif
+endif # CONFIG_DEBUG_INFO_BTF
+endif # CONFIG_BPF
 
 PHONY += prepare0
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index e6e2d9e5ff48..dbde59d343b1 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -341,9 +341,9 @@ fi
 vmlinux_link vmlinux "${kallsymso}" ${btf_vmlinux_bin_o}
 
 # fill in BTF IDs
-if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
-info BTFIDS vmlinux
-${RESOLVE_BTFIDS} vmlinux
+if [ -n "${CONFIG_DEBUG_INFO_BTF}" -a -n "${CONFIG_BPF}" ]; then
+	info BTFIDS vmlinux
+	${RESOLVE_BTFIDS} vmlinux
 fi
 
 if [ -n "${CONFIG_BUILDTIME_TABLE_SORT}" ]; then
-- 
2.26.2

