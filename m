Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFB66355B3
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 06:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFEEGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 00:06:15 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:60648 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbfFEEGP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 00:06:15 -0400
Received: from sapphire.tkos.co.il (unknown [192.168.100.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 52E9A44030A;
        Wed,  5 Jun 2019 07:06:12 +0300 (IDT)
Date:   Wed, 5 Jun 2019 07:06:11 +0300
From:   Baruch Siach <baruch@tkos.co.il>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, "Dmitry V . Levin" <ldv@altlinux.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Subject: Re: [PATCH] bpf: fix uapi bpf_prog_info fields alignment
Message-ID: <20190605040611.dt5fiegte2ys7z7z@sapphire.tkos.co.il>
References: <f42c7b44b3f694056c4216e9d9ba914b44e72ab9.1559648367.git.baruch@tkos.co.il>
 <CAADnVQJ1vRvqNFsWjvwmzSc_-OY51HTsVa13XhgK1v9NbYY2_A@mail.gmail.com>
 <CAMuHMdV-0s_ikRmCrEcMCfkAp57Fu8WTUnJsopGagbYa+GGpbA@mail.gmail.com>
 <20190604153028.ysyzvmpxqaaln4v2@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604153028.ysyzvmpxqaaln4v2@ast-mbp.dhcp.thefacebook.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

(Adding Arnd and linux-arch to Cc)

On Tue, Jun 04, 2019 at 08:30:29AM -0700, Alexei Starovoitov wrote:
> On Tue, Jun 04, 2019 at 05:23:46PM +0200, Geert Uytterhoeven wrote:
> > On Tue, Jun 4, 2019 at 5:17 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > > On Tue, Jun 4, 2019 at 4:40 AM Baruch Siach <baruch@tkos.co.il> wrote:
> > > > Merge commit 1c8c5a9d38f60 ("Merge
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next") undid the
> > > > fix from commit 36f9814a494 ("bpf: fix uapi hole for 32 bit compat
> > > > applications") by taking the gpl_compatible 1-bit field definition from
> > > > commit b85fab0e67b162 ("bpf: Add gpl_compatible flag to struct
> > > > bpf_prog_info") as is. That breaks architectures with 16-bit alignment
> > > > like m68k. Widen gpl_compatible to 32-bit to restore alignment of the
> > > > following fields.
> > >
> > > The commit log is misleading and incorrect.
> > > Since compiler makes it into 16-bit field, it's a compiler bug.
> > > u32 in C should stay as u32 regardless of architecture.
> > 
> > C99 says (Section 6.7.2.1, Structure and union specifiers, Semantics)
> > 
> >     10  An implementation may allocate any addressable storage unit
> >         large enough to hold a bit-field.
> > 
> > $ cat hello.c
> > #include <stdio.h>
> > #include <stdint.h>
> > #include <stdlib.h>
> > 
> > struct x {
> >         unsigned int bit : 1;
> >         unsigned char byte;
> > };
> > 
> > int main(int argc, char *argv[])
> > {
> >         struct x x;
> > 
> >         printf("byte is at offset %zu\n", (uintptr_t)&x.byte - (uintptr_t)&x);
> >         printf("sizeof(x) = %zu\n", sizeof(x));
> >         exit(0);
> > }
> > $ gcc -Wall hello.c -o hello && ./hello
> > byte is at offset 1
> > sizeof(x) = 4
> > $ uname -m
> > x86_64
> > 
> > So the compiler allocates a single byte, even on a 64-bit platform!
> > The gap is solely determined by the alignment rule for the
> > successive field.
> 
> argh. then we need something like this:
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 7c6aef253173..a2ac0b961251 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3174,6 +3174,7 @@ struct bpf_prog_info {
>         char name[BPF_OBJ_NAME_LEN];
>         __u32 ifindex;
>         __u32 gpl_compatible:1;
> +       __u32 :31;
>         __u64 netns_dev;
>         __u64 netns_ino;
>         __u32 nr_jited_ksyms;

Is that guaranteed to work across platforms/compilers? Maybe an anonymous 
union would be safer? Something like:

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 63e0cf66f01a..06c9fb314ea5 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3140,7 +3140,10 @@ struct bpf_prog_info {
 	__aligned_u64 map_ids;
 	char name[BPF_OBJ_NAME_LEN];
 	__u32 ifindex;
-	__u32 gpl_compatible:1;
+	union {
+		__u32 gpl_compatible:1;
+		__u32 pad;
+	};
 	__u64 netns_dev;
 	__u64 netns_ino;
 	__u32 nr_jited_ksyms;

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
