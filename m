Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C94E218C24
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbgGHPpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730499AbgGHPph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 11:45:37 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60AE7206DF;
        Wed,  8 Jul 2020 15:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594223136;
        bh=PVsTmkKdcsiCGxUsb5lyfGb5VY61/GKnxY5UTu5CsVI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z6cM4nzBljHStmUA+AcmnN0rSAv9M4S3pLhDuz50p92EBdTLqob7tZksCSOlpAZyb
         FsYnM6sGn3qRgm2839vddhKoifWwe9YAOIAC57bAoO3HcoYMq04DHsibJl/o5n4clN
         xIY/I11YdOLSY+KWZcNNZN359IWjGZFHbMWL1l00=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 42056405FF; Wed,  8 Jul 2020 12:45:34 -0300 (-03)
Date:   Wed, 8 Jul 2020 12:45:34 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf parse-events: report bpf errors
Message-ID: <20200708154534.GA22437@kernel.org>
References: <20200707211449.3868944-1-irogers@google.com>
 <20200708111935.GK1320@kernel.org>
 <CAP-5=fXr2xKbiYaNKOGytnwgNYOKYuGK-qT+GYpJZ4tdPb88eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fXr2xKbiYaNKOGytnwgNYOKYuGK-qT+GYpJZ4tdPb88eA@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Jul 08, 2020 at 08:15:24AM -0700, Ian Rogers escreveu:
> On Wed, Jul 8, 2020 at 4:19 AM Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > Em Tue, Jul 07, 2020 at 02:14:49PM -0700, Ian Rogers escreveu:
> > > Setting the parse_events_error directly doesn't increment num_errors
> > > causing the error message not to be displayed. Use the
> > > parse_events__handle_error function that sets num_errors and handle
> > > multiple errors.

> > What was the command line you used to exercise the error and then the
> > fix?
 
> You need something to stand in for the BPF event so:
 
> Before:
> ```
> $ /tmp/perf/perf record -e /tmp/perf/util/parse-events.o
> Run 'perf list' for a list of valid events
 
> Usage: perf record [<options>] [<command>]
>    or: perf record [<options>] -- <command> [<options>]
 
>    -e, --event <event>   event selector. use 'perf list' to list available event
> ```
> After:
> ```
> $ /tmp/perf/perf record -e /tmp/perf/util/parse-events.o
> event syntax error: '/tmp/perf/util/parse-events.o'
>                     \___ Failed to load /tmp/perf/util/parse-events.o:
> BPF object format invalid
> 
> (add -v to see detail)
> Run 'perf list' for a list of valid events
 
> Usage: perf record [<options>] [<command>]
>    or: perf record [<options>] -- <command> [<options>]
 
>    -e, --event <event>   event selector. use 'perf list' to list
> available events
> ```

Cool, I'll add that to the cset comment log.

If you need programs to test the Ok path, consider:

  # perf trace -e tools/perf/examples/bpf/5sec.c sleep 5.1
       0.000 perf_bpf_probe:hrtimer_nanosleep(__probe_ip: -1508461648, rqtp: 5100000000)
  # 

After applying tge patch below, that I'll have soon in my repo, I guess
this comes from those header includes path fixes from you :)

  # cat tools/perf/examples/bpf/5sec.c
  #include <bpf.h>
  
  #define NSEC_PER_SEC	1000000000L
  
  int probe(hrtimer_nanosleep, rqtp)(void *ctx, int err, long long sec)
  {
  	return sec / NSEC_PER_SEC == 5ULL;
  }
  
  license(GPL);
  #

Backtraces works as well and you can ask for the .o file to be retained
so that you then skip the compilation phase and use the .o file
directly:

  # perf config llvm.dump-obj=true
  # perf config llvm.dump-obj
  llvm.dump-obj=true
  # perf trace -e tools/perf/examples/bpf/5sec.c/max-stack=99/ sleep 5.1
       0.000 perf_bpf_probe:hrtimer_nanosleep(__probe_ip: -1508461648, rqtp: 5100000000)
                                         hrtimer_nanosleep ([kernel.kallsyms])
                                         __x64_sys_nanosleep ([kernel.kallsyms])
                                         do_syscall_64 ([kernel.kallsyms])
                                         entry_SYSCALL_64 ([kernel.kallsyms])
                                         __GI___nanosleep (/usr/lib64/libc-2.29.so)
  # 
  # file tools/perf/examples/bpf/5sec.o
  tools/perf/examples/bpf/5sec.o: ELF 64-bit LSB relocatable, eBPF, version 1 (SYSV), with debug_info, not stripped
  # 
  # perf trace -e tools/perf/examples/bpf/5sec.o/max-stack=3/ sleep 5.1
       0.000 perf_bpf_probe:hrtimer_nanosleep(__probe_ip: -1508461648, rqtp: 5100000000)
                                         hrtimer_nanosleep ([kernel.kallsyms])
                                         __x64_sys_nanosleep ([kernel.kallsyms])
                                         do_syscall_64 ([kernel.kallsyms])
  #


- Arnaldo

[root@quaco perf]# git diff
diff --git a/tools/perf/examples/bpf/5sec.c b/tools/perf/examples/bpf/5sec.c
index 65c4ff6892d9..e6b6181c6dc6 100644
--- a/tools/perf/examples/bpf/5sec.c
+++ b/tools/perf/examples/bpf/5sec.c
@@ -39,7 +39,7 @@
    Copyright (C) 2018 Red Hat, Inc., Arnaldo Carvalho de Melo <acme@redhat.com>
 */

-#include <bpf/bpf.h>
+#include <bpf.h>

 #define NSEC_PER_SEC   1000000000L

[root@quaco perf]#

- Arnaldo
 
> Thanks,
> Ian
> 
> > - Arnaldo
> >
> > > Signed-off-by: Ian Rogers <irogers@google.com>
> > > ---
> > >  tools/perf/util/parse-events.c | 38 ++++++++++++++++++----------------
> > >  1 file changed, 20 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > > index c4906a6a9f1a..e88e4c7a2a9a 100644
> > > --- a/tools/perf/util/parse-events.c
> > > +++ b/tools/perf/util/parse-events.c
> > > @@ -767,8 +767,8 @@ int parse_events_load_bpf_obj(struct parse_events_state *parse_state,
> > >
> > >       return 0;
> > >  errout:
> > > -     parse_state->error->help = strdup("(add -v to see detail)");
> > > -     parse_state->error->str = strdup(errbuf);
> > > +     parse_events__handle_error(parse_state->error, 0,
> > > +                             strdup(errbuf), strdup("(add -v to see detail)"));
> > >       return err;
> > >  }
> > >
> > > @@ -784,36 +784,38 @@ parse_events_config_bpf(struct parse_events_state *parse_state,
> > >               return 0;
> > >
> > >       list_for_each_entry(term, head_config, list) {
> > > -             char errbuf[BUFSIZ];
> > >               int err;
> > >
> > >               if (term->type_term != PARSE_EVENTS__TERM_TYPE_USER) {
> > > -                     snprintf(errbuf, sizeof(errbuf),
> > > -                              "Invalid config term for BPF object");
> > > -                     errbuf[BUFSIZ - 1] = '\0';
> > > -
> > > -                     parse_state->error->idx = term->err_term;
> > > -                     parse_state->error->str = strdup(errbuf);
> > > +                     parse_events__handle_error(parse_state->error, term->err_term,
> > > +                                             strdup("Invalid config term for BPF object"),
> > > +                                             NULL);
> > >                       return -EINVAL;
> > >               }
> > >
> > >               err = bpf__config_obj(obj, term, parse_state->evlist, &error_pos);
> > >               if (err) {
> > > +                     char errbuf[BUFSIZ];
> > > +                     int idx;
> > > +
> > >                       bpf__strerror_config_obj(obj, term, parse_state->evlist,
> > >                                                &error_pos, err, errbuf,
> > >                                                sizeof(errbuf));
> > > -                     parse_state->error->help = strdup(
> > > +
> > > +                     if (err == -BPF_LOADER_ERRNO__OBJCONF_MAP_VALUE)
> > > +                             idx = term->err_val;
> > > +                     else
> > > +                             idx = term->err_term + error_pos;
> > > +
> > > +                     parse_events__handle_error(parse_state->error, idx,
> > > +                                             strdup(errbuf),
> > > +                                             strdup(
> > >  "Hint:\tValid config terms:\n"
> > >  "     \tmap:[<arraymap>].value<indices>=[value]\n"
> > >  "     \tmap:[<eventmap>].event<indices>=[event]\n"
> > >  "\n"
> > >  "     \twhere <indices> is something like [0,3...5] or [all]\n"
> > > -"     \t(add -v to see detail)");
> > > -                     parse_state->error->str = strdup(errbuf);
> > > -                     if (err == -BPF_LOADER_ERRNO__OBJCONF_MAP_VALUE)
> > > -                             parse_state->error->idx = term->err_val;
> > > -                     else
> > > -                             parse_state->error->idx = term->err_term + error_pos;
> > > +"     \t(add -v to see detail)"));
> > >                       return err;
> > >               }
> > >       }
> > > @@ -877,8 +879,8 @@ int parse_events_load_bpf(struct parse_events_state *parse_state,
> > >                                                  -err, errbuf,
> > >                                                  sizeof(errbuf));
> > >
> > > -             parse_state->error->help = strdup("(add -v to see detail)");
> > > -             parse_state->error->str = strdup(errbuf);
> > > +             parse_events__handle_error(parse_state->error, 0,
> > > +                                     strdup(errbuf), strdup("(add -v to see detail)"));
> > >               return err;
> > >       }
> > >
> > > --
> > > 2.27.0.383.g050319c2ae-goog
> > >
> >
> > --
> >
> > - Arnaldo


-- 

- Arnaldo
