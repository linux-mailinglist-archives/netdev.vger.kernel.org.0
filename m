Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034A83F35D7
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 23:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240410AbhHTVDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 17:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231171AbhHTVDT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 17:03:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4A56610CC;
        Fri, 20 Aug 2021 21:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629493361;
        bh=33JaK0/fbEyjMyZ+m4/l2WT4mIztjD6TpKqqA6sCRjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hav620V/5S/BwH826daFi/LYbt1uT3g/4IKP/aoHuFMFtyFKcITkHCG851R6y3cMU
         neOKwgaL8WwWIE35MKLK2O2dAihizbBizQe3xMzxmOkt36/AXs3rUjVaBI2EgSJy/S
         aZ5vT3r4dc7f2ypP+NhGO8iuWKUBv9BefpzVzyuwS01k/o0t6hYE8cP78AvWbllj5V
         bqnUFmu3cZvV/kHPGbBttV8XMWnOWADF4QlgFQOTehgBYswDSeB8gjrj85HLw04Brq
         9XSx+hij1DgCxmavoyk3voaDoyoS5C/9RqHD7ldVIceQbGS0FcCx93iaCc8BURtyte
         /L0cqvKA2WB9g==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id A6D514007E; Fri, 20 Aug 2021 18:02:36 -0300 (-03)
Date:   Fri, 20 Aug 2021 18:02:36 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [RFC] dwarves/pahole: Add test scripts
Message-ID: <YSAYbH8ar7siefzS@kernel.org>
References: <20210223132321.220570-1-jolsa@kernel.org>
 <YSAS+kg3oeCnsuyk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YSAS+kg3oeCnsuyk@kernel.org>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Aug 20, 2021 at 05:39:22PM -0300, Arnaldo Carvalho de Melo escreveu:
> So, now looking at:
 
> test_btfdiff    on /var/home/acme/.pahole_test_objects/x86-gcc/vmlinux ... FAIL

Minor stuff, why would BTF get that const and DWARF not?

⬢[acme@toolbox pahole]$ btfdiff /var/home/acme/.pahole_test_objects/x86-gcc/vmlinux
--- /tmp/btfdiff.dwarf.j8SZhr	2021-08-20 17:40:52.052186096 -0300
+++ /tmp/btfdiff.btf.5QMi8C	2021-08-20 17:40:52.298191569 -0300
@@ -33719,7 +33719,7 @@ struct e1000_option {

 			/* XXX 4 bytes hole, try to pack */

-			struct e1000_opt_list * p;       /*    40     8 */
+			const struct e1000_opt_list  * p; /*    40     8 */
 		} l;                                     /*    32    16 */
 	} arg;                                           /*    32    16 */

⬢[acme@toolbox pahole]$ btfdiff /var/home/acme/.pahole_test_objects/x86-clang/vmlinux
--- /tmp/btfdiff.dwarf.1TAWtj	2021-08-20 17:41:18.821781610 -0300
+++ /tmp/btfdiff.btf.FMLZRt	2021-08-20 17:41:19.058786883 -0300
@@ -21584,7 +21584,7 @@ struct cpu_rmap {
 	struct {
 		u16                index;                /*    16     2 */
 		u16                dist;                 /*    18     2 */
-	} near[0]; /*    16     0 */
+	} near[]; /*    16     0 */

 	/* size: 16, cachelines: 1, members: 5 */
 	/* last cacheline: 16 bytes */
@@ -65743,7 +65743,7 @@ struct linux_efi_memreserve {
 	struct {
 		phys_addr_t        base;                 /*    16     8 */
 		phys_addr_t        size;                 /*    24     8 */
-	} entry[0]; /*    16     0 */
+	} entry[]; /*    16     0 */

 	/* size: 16, cachelines: 1, members: 4 */
 	/* last cacheline: 16 bytes */
@@ -72814,7 +72814,7 @@ struct netlink_policy_dump_state {
 	struct {
 		const struct nla_policy  * policy;       /*    16     8 */
 		unsigned int       maxtype;              /*    24     4 */
-	} policies[0]; /*    16     0 */
+	} policies[]; /*    16     0 */

 	/* size: 16, cachelines: 1, members: 4 */
 	/* sum members: 12, holes: 1, sum holes: 4 */
⬢[acme@toolbox pahole]$o

I see, there are two declarations for this struct, one at:

drivers/net/ethernet/intel/e1000/e1000_param.c

166 struct e1000_option {
167         enum { enable_option, range_option, list_option } type;
168         const char *name;
169         const char *err;
170         int def;
171         union {
172                 struct { /* range_option info */
173                         int min;
174                         int max;
175                 } r;
176                 struct { /* list_option info */
177                         int nr;
178                         const struct e1000_opt_list { int i; char *str; } *p;
179                 } l;
180         } arg;
181 };

and the other at (note that extra 'e' after 1000 :) ):

drivers/net/ethernet/intel/e1000e/param.c

141 struct e1000_option {
142         enum { enable_option, range_option, list_option } type;
143         const char *name;
144         const char *err;
145         int def;
146         union {
147                 /* range_option info */
148                 struct {
149                         int min;
150                         int max;
151                 } r;
152                 /* list_option info */
153                 struct {
154                         int nr;
155                         struct e1000_opt_list {
156                                 int i;
157                                 char *str;
158                         } *p;
159                 } l;
160         } arg;
161 };

The only difference is that 'const'.

I _guess_ that the BTF deduplicator is picking the one with the 'const'
while pahole's (which is just used when pretty printing, not when BTF
encoding) with the other (it shouldn't as per my intention, I'm not
arguing about if both should appear as different types).

I tested it with:

  pahole -j -F dwarf -C e1000_option /var/home/acme/.pahole_test_objects/x86-gcc/vmlinux

to use the new DWARF multithreaded loading, like 'btfdiff' now does, and
its related to which of these types get loaded first, but its just
related to pahole pretty printing, not for the BTF encoding, where all
types will be passed to BTF for deduplication.

Same thing happens with clang, its just that when pretty printing in
this test run the clang multithreaded DWARF loading saw the type that
BTF picked (the one with 'const').

When I re-run it with:

⬢[acme@toolbox pahole]$ git diff
diff --git a/btfdiff b/btfdiff
index 77543630d1965b5e..71d3dbf5fc861e16 100755
--- a/btfdiff
+++ b/btfdiff
@@ -26,7 +26,6 @@ pahole_bin=${PAHOLE-"pahole"}
 ${pahole_bin} -F dwarf \
              --flat_arrays \
              --sort \
-             --jobs \
              --suppress_aligned_attribute \
              --suppress_force_paddings \
              --suppress_packed \
⬢[acme@toolbox pahole]$ git diff

I get:

test_btfdiff    on /var/home/acme/.pahole_test_objects/aarch64-clang/vmlinux ... OK
test_btfdiff    on /var/home/acme/.pahole_test_objects/x86-clang/vmlinux ... FAIL

clang's is just that zero entries array diff again.

I'll get 1.22 out of the door tomorrow as it passed these tests and also
the ones at libbpf github CI and my local ones and get these scripts merged
in 1.23, will check the clang output as well.

Thanks for the scripts!

- Arnaldo
