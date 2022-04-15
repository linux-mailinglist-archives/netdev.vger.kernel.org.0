Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02A5501FC8
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 02:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348159AbiDOAuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 20:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbiDOAuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 20:50:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71485B822C;
        Thu, 14 Apr 2022 17:47:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 230BAB82BF3;
        Fri, 15 Apr 2022 00:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC692C385A5;
        Fri, 15 Apr 2022 00:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649983652;
        bh=5hEZI1ItFtx5BzKjBL/+be3fKdvz/RR0aOlO6S3STIw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ghfquUVYzlp3tI5eaJrYnY83EbNVIzh6Slk4tawd9fdbhgffxm7wM/iPgj/iBGLvF
         5FAbHbGpeXLuOF+hc0m+zONvkP2QpIB+QogO3+DJr5vJSHl40UrqWQKEcrvC5ScT+K
         OdSj8sSF3C2R60qN7rFGEnmiz1Ji+9IGBe2cQzCcnrpp/VwcNCUVS0jpLgY2PRt6ax
         yNsqa8T3XumrOrM+fTdlpEmGhwwHRvN6Lvscrcz1OayM5MFC6mRKQSWi5ZLf1/Xocs
         5n2PvEckLA9GNjRRgmy4Kn14X+b4ZZBZgC4sCl28EuE1Slnxtgg4RN/KYVPqNuvkEV
         t07bzDCQiPyHA==
Date:   Fri, 15 Apr 2022 09:47:27 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 1/4] kallsyms: Add kallsyms_lookup_names function
Message-Id: <20220415094727.2880a321bb6674d94e104110@kernel.org>
In-Reply-To: <YlXlF5ivTR1QLMfk@krava>
References: <20220407125224.310255-1-jolsa@kernel.org>
        <20220407125224.310255-2-jolsa@kernel.org>
        <20220408231925.uc2cfeev7p6nzfww@MBP-98dd607d3435.dhcp.thefacebook.com>
        <YlXlF5ivTR1QLMfk@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

Sorry for replying later.

On Tue, 12 Apr 2022 22:46:15 +0200
Jiri Olsa <olsajiri@gmail.com> wrote:

> On Fri, Apr 08, 2022 at 04:19:25PM -0700, Alexei Starovoitov wrote:
> > On Thu, Apr 07, 2022 at 02:52:21PM +0200, Jiri Olsa wrote:
> > > Adding kallsyms_lookup_names function that resolves array of symbols
> > > with single pass over kallsyms.
> > > 
> > > The user provides array of string pointers with count and pointer to
> > > allocated array for resolved values.
> > > 
> > >   int kallsyms_lookup_names(const char **syms, u32 cnt,
> > >                             unsigned long *addrs)
> > > 
> > > Before we iterate kallsyms we sort user provided symbols by name and
> > > then use that in kalsyms iteration to find each kallsyms symbol in
> > > user provided symbols.
> > > 
> > > We also check each symbol to pass ftrace_location, because this API
> > > will be used for fprobe symbols resolving. This can be optional in
> > > future if there's a need.
> > > 
> > > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  include/linux/kallsyms.h |  6 +++++
> > >  kernel/kallsyms.c        | 48 ++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 54 insertions(+)
> > > 
> > > diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> > > index ce1bd2fbf23e..5320a5e77f61 100644
> > > --- a/include/linux/kallsyms.h
> > > +++ b/include/linux/kallsyms.h
> > > @@ -72,6 +72,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
> > >  #ifdef CONFIG_KALLSYMS
> > >  /* Lookup the address for a symbol. Returns 0 if not found. */
> > >  unsigned long kallsyms_lookup_name(const char *name);
> > > +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs);
> > >  
> > >  extern int kallsyms_lookup_size_offset(unsigned long addr,
> > >  				  unsigned long *symbolsize,
> > > @@ -103,6 +104,11 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
> > >  	return 0;
> > >  }
> > >  
> > > +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
> > > +{
> > > +	return -ERANGE;
> > > +}
> > > +
> > >  static inline int kallsyms_lookup_size_offset(unsigned long addr,
> > >  					      unsigned long *symbolsize,
> > >  					      unsigned long *offset)
> > > diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> > > index 79f2eb617a62..a3738ddf9e87 100644
> > > --- a/kernel/kallsyms.c
> > > +++ b/kernel/kallsyms.c
> > > @@ -29,6 +29,8 @@
> > >  #include <linux/compiler.h>
> > >  #include <linux/module.h>
> > >  #include <linux/kernel.h>
> > > +#include <linux/bsearch.h>
> > > +#include <linux/sort.h>
> > >  
> > >  /*
> > >   * These will be re-linked against their real values
> > > @@ -572,6 +574,52 @@ int sprint_backtrace_build_id(char *buffer, unsigned long address)
> > >  	return __sprint_symbol(buffer, address, -1, 1, 1);
> > >  }
> > >  
> > > +static int symbols_cmp(const void *a, const void *b)
> > > +{
> > > +	const char **str_a = (const char **) a;
> > > +	const char **str_b = (const char **) b;
> > > +
> > > +	return strcmp(*str_a, *str_b);
> > > +}
> > > +
> > > +struct kallsyms_data {
> > > +	unsigned long *addrs;
> > > +	const char **syms;
> > > +	u32 cnt;
> > > +	u32 found;
> > > +};
> > > +
> > > +static int kallsyms_callback(void *data, const char *name,
> > > +			     struct module *mod, unsigned long addr)
> > > +{
> > > +	struct kallsyms_data *args = data;
> > > +
> > > +	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> > > +		return 0;
> > > +
> > > +	addr = ftrace_location(addr);
> > > +	if (!addr)
> > > +		return 0;
> > > +
> > > +	args->addrs[args->found++] = addr;
> > > +	return args->found == args->cnt ? 1 : 0;
> > > +}
> > > +
> > > +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
> > > +{
> > > +	struct kallsyms_data args;
> > > +
> > > +	sort(syms, cnt, sizeof(*syms), symbols_cmp, NULL);
> > 
> > It's nice to share symbols_cmp for sort and bsearch,
> > but messing technically input argument 'syms' like this will cause
> > issues sooner or later.
> > Lets make caller do the sort.
> > Unordered input will cause issue with bsearch, of course,
> > but it's a lesser evil. imo.
> > 
> 
> Masami,
> this logic bubbles up to the register_fprobe_syms, because user
> provides symbols as its argument. Can we still force this assumption
> to the 'syms' array, like with the comment change below?
> 
> FYI the bpf side does not use register_fprobe_syms, it uses
> register_fprobe_ips, because it always needs ips as search
> base for cookie values

Hmm, in that case fprobe can call sort() in the register function.
That will be much easier and safer. The bpf case, the input array will
be generated by the bpftool (not by manual), so it can ensure the 
syms is sorted. But we don't know how fprobe user passes syms array.
Then register_fprobe_syms() will always requires sort(). I don't like
such redundant requirements.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
