Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 036665F510
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 10:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfGDI7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 04:59:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17397 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbfGDI67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 04:58:59 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CD8530BCCE2;
        Thu,  4 Jul 2019 08:58:59 +0000 (UTC)
Received: from krava.brq.redhat.com (unknown [10.43.17.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 903B888F04;
        Thu,  4 Jul 2019 08:58:57 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Michael Petlan <mpetlan@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH] tools bpftool: Fix json dump crash on powerpc
Date:   Thu,  4 Jul 2019 10:58:56 +0200
Message-Id: <20190704085856.17502-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 04 Jul 2019 08:58:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
fprintf callback, so there's no point to return error in case of
allocation failure.

Reported-by: Michael Petlan <mpetlan@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/bpftool/jit_disasm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
index 3ef3093560ba..05fa6dc970f8 100644
--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -11,6 +11,8 @@
  * Licensed under the GNU General Public License, version 2.0 (GPLv2)
  */
 
+#define _GNU_SOURCE
+#include <stdio.h>
 #include <stdarg.h>
 #include <stdint.h>
 #include <stdio.h>
@@ -44,11 +46,13 @@ static int fprintf_json(void *out, const char *fmt, ...)
 	char *s;
 
 	va_start(ap, fmt);
+	if (vasprintf(&s, fmt, ap) < 0)
+		return 0;
+	va_end(ap);
+
 	if (!oper_count) {
 		int i;
 
-		s = va_arg(ap, char *);
-
 		/* Strip trailing spaces */
 		i = strlen(s) - 1;
 		while (s[i] == ' ')
@@ -61,11 +65,10 @@ static int fprintf_json(void *out, const char *fmt, ...)
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
2.21.0

