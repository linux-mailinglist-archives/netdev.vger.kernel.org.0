Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C00625FF18
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbgIGQ1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730372AbgIGQ13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:27:29 -0400
Received: from sym2.noone.org (sym2.noone.org [IPv6:2a01:4f8:120:4161::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3D1C061573;
        Mon,  7 Sep 2020 09:27:28 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4BlYbL5f6Gzvjc1; Mon,  7 Sep 2020 18:27:26 +0200 (CEST)
Date:   Mon, 7 Sep 2020 18:27:26 +0200
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH] perf tools: Do not use deprecated bpf_program__title
Message-ID: <20200907162726.o36peh673a7l46kn@distanz.ch>
References: <20200907110237.1329532-1-jolsa@kernel.org>
 <20200907110549.GI1199773@krava>
 <20200907155945.2ynl7dojgx572j62@distanz.ch>
 <20200907162249.GO1199773@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907162249.GO1199773@krava>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-07 at 18:22:49 +0200, Jiri Olsa <jolsa@redhat.com> wrote:
> On Mon, Sep 07, 2020 at 05:59:46PM +0200, Tobias Klauser wrote:
> > On 2020-09-07 at 13:05:49 +0200, Jiri Olsa <jolsa@redhat.com> wrote:
> > > On Mon, Sep 07, 2020 at 01:02:37PM +0200, Jiri Olsa wrote:
> > > > The bpf_program__title function got deprecated in libbpf,
> > > > use the suggested alternative.
> > > > 
> > > > Fixes: 521095842027 ("libbpf: Deprecate notion of BPF program "title" in favor of "section name"")
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > 
> > > Arnaldo,
> > > the commit in 'Fixes' is not yet in your tree yet and the patch
> > > below will make the perf compilation fail in your perf/core..
> > > 
> > > it fixes perf compilation on top of bpf-next tree.. so I think it
> > > should go in through bpf-next tree
> > > 
> > > thanks,
> > > jirka
> > > 
> > > > ---
> > > >  tools/perf/util/bpf-loader.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> > > > index 2feb751516ab..73de3973c8ec 100644
> > > > --- a/tools/perf/util/bpf-loader.c
> > > > +++ b/tools/perf/util/bpf-loader.c
> > > > @@ -328,7 +328,7 @@ config_bpf_program(struct bpf_program *prog)
> > > >  	probe_conf.no_inlines = false;
> > > >  	probe_conf.force_add = false;
> > > >  
> > > > -	config_str = bpf_program__title(prog, false);
> > > > +	config_str = bpf_program__section_name(prog);
> > > >  	if (IS_ERR(config_str)) {
> > > >  		pr_debug("bpf: unable to get title for program\n");
> > > >  		return PTR_ERR(config_str);
> > > > @@ -454,7 +454,7 @@ preproc_gen_prologue(struct bpf_program *prog, int n,
> > > >  	if (err) {
> > > >  		const char *title;
> > > >  
> > > > -		title = bpf_program__title(prog, false);
> > > > +		title = bpf_program__section_name(prog);
> > > >  		if (!title)
> > > >  			title = "[unknown]";
> > 
> > I think bpf_program__title at line 457 in preproc_gen_prologue also needs to be
> > changed given the following build failure:
> 
> hum, that's where the 2nd hunk, right? I dont see any other instance
> of bpf_program__title after the patch is applied

Sorry for the noise, I didn't read the patch correctly. You're of course
correct. I was confused because it is still assigned to variable
`title`.

Reviewed-by: Tobias Klauser <tklauser@distanz.ch>

Thanks
Tobias
