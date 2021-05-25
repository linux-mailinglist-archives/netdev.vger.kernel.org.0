Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BDA390334
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhEYN6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 09:58:46 -0400
Received: from outbound-smtp50.blacknight.com ([46.22.136.234]:38859 "EHLO
        outbound-smtp50.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233373AbhEYN6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 09:58:46 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2021 09:58:45 EDT
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp50.blacknight.com (Postfix) with ESMTPS id D6D9EFAC38
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 14:51:02 +0100 (IST)
Received: (qmail 3215 invoked from network); 25 May 2021 13:51:02 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.23.168])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 25 May 2021 13:51:02 -0000
Date:   Tue, 25 May 2021 14:51:01 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Michal Such?nek <msuchanek@suse.de>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>
Subject: Re: BPF: failed module verification on linux-next
Message-ID: <20210525135101.GT30378@techsingularity.net>
References: <20210519141936.GV8544@kitsune.suse.cz>
 <CAEf4BzZuU2TYMapSy7s3=D8iYtVw_N+=hh2ZMGG9w6N0G1HvbA@mail.gmail.com>
 <CAEf4BzZ0-sihSL-UAm21JcaCCY92CqfNxycHRZYXcoj8OYb=wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ0-sihSL-UAm21JcaCCY92CqfNxycHRZYXcoj8OYb=wA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 03:58:29PM -0700, Andrii Nakryiko wrote:
> > It took me a while to reliably bisect this, but it clearly points to
> > this commit:
> >
> > e481fac7d80b ("mm/page_alloc: convert per-cpu list protection to local_lock")
> >
> > One commit before it, 676535512684 ("mm/page_alloc: split per cpu page
> > lists and zone stats -fix"), works just fine.
> >
> > I'll have to spend more time debugging what exactly is happening, but
> > the immediate problem is two different definitions of numa_node
> > per-cpu variable. They both are at the same offset within
> > .data..percpu ELF section, they both have the same name, but one of
> > them is marked as static and another as global. And one is int
> > variable, while another is struct pagesets. I'll look some more
> > tomorrow, but adding Jiri and Arnaldo for visibility.
> >
> > [110907] DATASEC '.data..percpu' size=178904 vlen=303
> > ...
> >         type_id=27753 offset=163976 size=4 (VAR 'numa_node')
> >         type_id=27754 offset=163976 size=4 (VAR 'numa_node')
> >
> > [27753] VAR 'numa_node' type_id=27556, linkage=static
> > [27754] VAR 'numa_node' type_id=20, linkage=global
> >
> > [20] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
> >
> > [27556] STRUCT 'pagesets' size=0 vlen=1
> >         'lock' type_id=507 bits_offset=0
> >
> > [506] STRUCT '(anon)' size=0 vlen=0
> > [507] TYPEDEF 'local_lock_t' type_id=506
> >
> > So also something weird about those zero-sized struct pagesets and
> > local_lock_t inside it.
> 
> Ok, so nothing weird about them. local_lock_t is designed to be
> zero-sized unless CONFIG_DEBUG_LOCK_ALLOC is defined.
> 
> But such zero-sized per-CPU variables are confusing pahole during BTF
> generation, as now two different variables "occupy" the same address.
> 
> Given this seems to be the first zero-sized per-CPU variable, I wonder
> if it would be ok to make sure it's never zero-sized, while pahole
> gets fixed and it's latest version gets widely packaged and
> distributed.
> 
> Mel, what do you think about something like below? Or maybe you can
> advise some better solution?
> 

Ouch, something like that may never go away. How about just this?

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 58426acf5983..dce2df33d823 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -338,6 +338,9 @@ config DEBUG_INFO_BTF
 config PAHOLE_HAS_SPLIT_BTF
 	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
 
+config PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT
+	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "122")
+
 config DEBUG_INFO_BTF_MODULES
 	def_bool y
 	depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1599985e0ee1..cb1f84848c99 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -124,6 +124,17 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 
 struct pagesets {
 	local_lock_t lock;
+#if defined(CONFIG_DEBUG_INFO_BTF) &&			\
+    !defined(CONFIG_DEBUG_LOCK_ALLOC) &&		\
+    !defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
+	/*
+	 * pahole 1.21 and earlier gets confused by zero-sized per-CPU
+	 * variables and produces invalid BTF. Ensure that
+	 * sizeof(struct pagesets) != 0 for older versions of pahole.
+	 */
+	char __pahole_hack;
+	#warning "pahole too old to support zero-sized struct pagesets"
+#endif
 };
 static DEFINE_PER_CPU(struct pagesets, pagesets) = {
 	.lock = INIT_LOCAL_LOCK(lock),
diff --git a/scripts/rust-version.sh b/scripts/rust-version.sh
old mode 100644
new mode 100755
-- 
Mel Gorman
SUSE Labs
