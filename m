Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4609C318B17
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhBKMos convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Feb 2021 07:44:48 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:46560 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231321AbhBKMlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:41:09 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-GOMo411QNbWKd0AdzePMTQ-1; Thu, 11 Feb 2021 07:40:11 -0500
X-MC-Unique: GOMo411QNbWKd0AdzePMTQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13A59107ACC7;
        Thu, 11 Feb 2021 12:40:09 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7D9760BF1;
        Thu, 11 Feb 2021 12:40:05 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH bpf-next] kbuild: Do not clean resolve_btfids if the output does not exist
Date:   Thu, 11 Feb 2021 13:40:04 +0100
Message-Id: <20210211124004.1144344-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nathan reported issue with cleaning empty build directory:

  $ make -s O=build distclean
  ../../scripts/Makefile.include:4: *** \
  O=/ho...build/tools/bpf/resolve_btfids does not exist.  Stop.

The problem that tools scripts require existing output
directory, otherwise it fails.

Adding check around the resolve_btfids clean target to
ensure the output directory is in place.

Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Makefile | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 159d9592b587..b6fa039c18b8 100644
--- a/Makefile
+++ b/Makefile
@@ -1088,8 +1088,14 @@ endif
 
 PHONY += resolve_btfids_clean
 
+resolve_btfids_O = $(abspath $(objtree))/tools/bpf/resolve_btfids
+
+# tools/bpf/resolve_btfids directory might not exist
+# in output directory, skip its clean in that case
 resolve_btfids_clean:
-	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
+ifneq ($(wildcard $(resolve_btfids_O)),)
+	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(resolve_btfids_O) clean
+endif
 
 ifdef CONFIG_BPF
 ifdef CONFIG_DEBUG_INFO_BTF
-- 
2.29.2

