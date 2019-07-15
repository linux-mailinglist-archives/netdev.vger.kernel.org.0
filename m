Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9716694E6
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391111AbfGOO1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390431AbfGOO1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:27:35 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 672FA21850;
        Mon, 15 Jul 2019 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200854;
        bh=XBq78g8jmN+Da3vgAN/HM+QTKF806VoyDkgM1mv4sPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xm2OP+kpXVE2ECSevrb+PnJYHB3hP0tjJ9MjS1rlwNiun8q9qs0YhCNBgyHhkICaO
         f8CNKPf/bJ+CC/Dgr3r4GR9tt1MNGjYK+mj/TsUFRJn7QvIq/xAdJXzT1Upp7vRTsy
         tFUhZgWfEwgp3VPSCSaiRkK+Zwi+hra+n9HMatGE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@redhat.com>, Michael Petlan <mpetlan@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 145/158] tools: bpftool: Fix json dump crash on powerpc
Date:   Mon, 15 Jul 2019 10:17:56 -0400
Message-Id: <20190715141809.8445-145-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

[ Upstream commit aa52bcbe0e72fac36b1862db08b9c09c4caefae3 ]

Michael reported crash with by bpf program in json mode on powerpc:

  # bpftool prog -p dump jited id 14
  [{
        "name": "0xd00000000a9aa760",
        "insns": [{
                "pc": "0x0",
                "operation": "nop",
                "operands": [null
                ]
            },{
                "pc": "0x4",
                "operation": "nop",
                "operands": [null
                ]
            },{
                "pc": "0x8",
                "operation": "mflr",
  Segmentation fault (core dumped)

The code is assuming char pointers in format, which is not always
true at least for powerpc. Fixing this by dumping the whole string
into buffer based on its format.

Please note that libopcodes code does not check return values from
fprintf callback, but as per Jakub suggestion returning -1 on allocation
failure so we do the best effort to propagate the error.

Fixes: 107f041212c1 ("tools: bpftool: add JSON output for `bpftool prog dump jited *` command")
Reported-by: Michael Petlan <mpetlan@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/jit_disasm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
index 87439320ef70..73d7252729fa 100644
--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -10,6 +10,8 @@
  * Licensed under the GNU General Public License, version 2.0 (GPLv2)
  */
 
+#define _GNU_SOURCE
+#include <stdio.h>
 #include <stdarg.h>
 #include <stdint.h>
 #include <stdio.h>
@@ -51,11 +53,13 @@ static int fprintf_json(void *out, const char *fmt, ...)
 	char *s;
 
 	va_start(ap, fmt);
+	if (vasprintf(&s, fmt, ap) < 0)
+		return -1;
+	va_end(ap);
+
 	if (!oper_count) {
 		int i;
 
-		s = va_arg(ap, char *);
-
 		/* Strip trailing spaces */
 		i = strlen(s) - 1;
 		while (s[i] == ' ')
@@ -68,11 +72,10 @@ static int fprintf_json(void *out, const char *fmt, ...)
 	} else if (!strcmp(fmt, ",")) {
 		   /* Skip */
 	} else {
-		s = va_arg(ap, char *);
 		jsonw_string(json_wtr, s);
 		oper_count++;
 	}
-	va_end(ap);
+	free(s);
 	return 0;
 }
 
-- 
2.20.1

