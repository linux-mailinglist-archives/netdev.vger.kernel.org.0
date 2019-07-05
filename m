Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D930605BC
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 14:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbfGEMKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 08:10:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47918 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfGEMKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 08:10:34 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2316C01F28C;
        Fri,  5 Jul 2019 12:10:33 +0000 (UTC)
Received: from krava (unknown [10.43.17.81])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4B7C16961D;
        Fri,  5 Jul 2019 12:10:32 +0000 (UTC)
Date:   Fri, 5 Jul 2019 14:10:31 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Michael Petlan <mpetlan@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>
Subject: [PATCHv2] tools bpftool: Fix json dump crash on powerpc
Message-ID: <20190705121031.GA10777@krava>
References: <20190704085856.17502-1-jolsa@kernel.org>
 <20190704134210.17b8407c@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704134210.17b8407c@cakuba.netronome.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 05 Jul 2019 12:10:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 01:42:10PM -0700, Jakub Kicinski wrote:
> On Thu,  4 Jul 2019 10:58:56 +0200, Jiri Olsa wrote:
> > Michael reported crash with by bpf program in json mode on powerpc:
> > 
> >   # bpftool prog -p dump jited id 14
> >   [{
> >         "name": "0xd00000000a9aa760",
> >         "insns": [{
> >                 "pc": "0x0",
> >                 "operation": "nop",
> >                 "operands": [null
> >                 ]
> >             },{
> >                 "pc": "0x4",
> >                 "operation": "nop",
> >                 "operands": [null
> >                 ]
> >             },{
> >                 "pc": "0x8",
> >                 "operation": "mflr",
> >   Segmentation fault (core dumped)
> > 
> > The code is assuming char pointers in format, which is not always
> > true at least for powerpc. Fixing this by dumping the whole string
> > into buffer based on its format.
> > 
> > Please note that libopcodes code does not check return values from
> > fprintf callback, so there's no point to return error in case of
> > allocation failure.
> 
> Well, it doesn't check it today, it may perhaps do it in the future?
> Let's flip the question - since it doesn't check it today, why not
> propagate the error? :)  We should stay close to how fprintf would
> behave, IMHO.
> 
> Fixes: 107f041212c1 ("tools: bpftool: add JSON output for `bpftool prog dump jited *` command")

ok fair enough, v2 attached

thanks,
jirka


---
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

Reported-by: Michael Petlan <mpetlan@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/bpftool/jit_disasm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
index 3ef3093560ba..bfed711258ce 100644
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

