Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4BA3A1658
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhFIOBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:01:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40695 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231175AbhFIOBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 10:01:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623247190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gjECBgepBKUOQN9KWDqQV7wge2o1vkGBrM1TtLcfPPc=;
        b=Kxb1Gd9oKb52QJ2t9NngKuOAQmHW26/9Xz8mvY1LadPNRGp6vZXWHyjFww92NlDRuX9/fN
        JFdvXE31VwbDzmIGBHiWJluXoPcoHWSDZ4JI/uGSgr8bckJhRG27JQkMSPPNdqVBF2sFw+
        4JLZLgSBB2U0FL7T+Zkh7sgJgZVQQAA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-FoeELBVfOO-qWzqvbyLVpg-1; Wed, 09 Jun 2021 09:59:49 -0400
X-MC-Unique: FoeELBVfOO-qWzqvbyLVpg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60D808049CD;
        Wed,  9 Jun 2021 13:59:47 +0000 (UTC)
Received: from krava (unknown [10.40.195.97])
        by smtp.corp.redhat.com (Postfix) with SMTP id 57EAC5C1C2;
        Wed,  9 Jun 2021 13:59:44 +0000 (UTC)
Date:   Wed, 9 Jun 2021 15:59:43 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 14/19] libbpf: Add btf__find_by_pattern_kind function
Message-ID: <YMDJT4fnLCOsfFuS@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-15-jolsa@kernel.org>
 <CAEf4BzaT9eiyMrpKbmmq3hOpD29b8K6DiRzB0eRKnTso93YRoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaT9eiyMrpKbmmq3hOpD29b8K6DiRzB0eRKnTso93YRoA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 10:29:19PM -0700, Andrii Nakryiko wrote:
> On Sat, Jun 5, 2021 at 4:14 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding btf__find_by_pattern_kind function that returns
> > array of BTF ids for given function name pattern.
> >
> > Using libc's regex.h support for that.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/lib/bpf/btf.c | 68 +++++++++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/btf.h |  3 ++
> >  2 files changed, 71 insertions(+)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index b46760b93bb4..421dd6c1e44a 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -1,6 +1,7 @@
> >  // SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> >  /* Copyright (c) 2018 Facebook */
> >
> > +#define _GNU_SOURCE
> >  #include <byteswap.h>
> >  #include <endian.h>
> >  #include <stdio.h>
> > @@ -16,6 +17,7 @@
> >  #include <linux/err.h>
> >  #include <linux/btf.h>
> >  #include <gelf.h>
> > +#include <regex.h>
> >  #include "btf.h"
> >  #include "bpf.h"
> >  #include "libbpf.h"
> > @@ -711,6 +713,72 @@ __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
> >         return libbpf_err(-ENOENT);
> >  }
> >
> > +static bool is_wildcard(char c)
> > +{
> > +       static const char *wildchars = "*?[|";
> > +
> > +       return strchr(wildchars, c);
> > +}
> > +
> > +int btf__find_by_pattern_kind(const struct btf *btf,
> > +                             const char *type_pattern, __u32 kind,
> > +                             __s32 **__ids)
> > +{
> > +       __u32 i, nr_types = btf__get_nr_types(btf);
> > +       __s32 *ids = NULL;
> > +       int cnt = 0, alloc = 0, ret;
> > +       regex_t regex;
> > +       char *pattern;
> > +
> > +       if (kind == BTF_KIND_UNKN || !strcmp(type_pattern, "void"))
> > +               return 0;
> > +
> > +       /* When the pattern does not start with wildcard, treat it as
> > +        * if we'd want to match it from the beginning of the string.
> > +        */
> 
> This assumption is absolutely atrocious. If we say it's regexp, then
> it has to always be regexp, not something based on some random
> heuristic based on the first character.
> 
> Taking a step back, though. Do we really need to provide this API? Why
> applications can't implement it on their own, given regexp
> functionality is provided by libc. Which I didn't know, actually, so
> that's pretty nice, assuming that it's also available in more minimal
> implementations like musl.
> 

so the only purpose for this function is to support wildcards in
tests like:

  SEC("fentry.multi/bpf_fentry_test*")

so the generic skeleton attach function can work.. but that can be
removed and the test programs can be attached manually through some
other attach function that will have list of functions as argument

jirka

> > +       asprintf(&pattern, "%s%s",
> > +                is_wildcard(type_pattern[0]) ? "^" : "",
> > +                type_pattern);
> > +
> > +       ret = regcomp(&regex, pattern, REG_EXTENDED);
> > +       if (ret) {
> > +               pr_warn("failed to compile regex\n");
> > +               free(pattern);
> > +               return -EINVAL;
> > +       }
> > +
> > +       free(pattern);
> > +
> > +       for (i = 1; i <= nr_types; i++) {
> > +               const struct btf_type *t = btf__type_by_id(btf, i);
> > +               const char *name;
> > +               __s32 *p;
> > +
> > +               if (btf_kind(t) != kind)
> > +                       continue;
> > +               name = btf__name_by_offset(btf, t->name_off);
> > +               if (name && regexec(&regex, name, 0, NULL, 0))
> > +                       continue;
> > +               if (cnt == alloc) {
> > +                       alloc = max(100, alloc * 3 / 2);
> > +                       p = realloc(ids, alloc * sizeof(__u32));
> 
> this memory allocation and re-allocation on behalf of users is another
> argument against this API
> 
> > +                       if (!p) {
> > +                               free(ids);
> > +                               regfree(&regex);
> > +                               return -ENOMEM;
> > +                       }
> > +                       ids = p;
> > +               }
> > +
> > +               ids[cnt] = i;
> > +               cnt++;
> > +       }
> > +
> > +       regfree(&regex);
> > +       *__ids = ids;
> > +       return cnt ?: -ENOENT;
> > +}
> > +
> >  static bool btf_is_modifiable(const struct btf *btf)
> >  {
> >         return (void *)btf->hdr != btf->raw_data;
> > diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> > index b54f1c3ebd57..036857aded94 100644
> > --- a/tools/lib/bpf/btf.h
> > +++ b/tools/lib/bpf/btf.h
> > @@ -371,6 +371,9 @@ btf_var_secinfos(const struct btf_type *t)
> >         return (struct btf_var_secinfo *)(t + 1);
> >  }
> >
> > +int btf__find_by_pattern_kind(const struct btf *btf,
> > +                             const char *type_pattern, __u32 kind,
> > +                             __s32 **__ids);
> >  #ifdef __cplusplus
> >  } /* extern "C" */
> >  #endif
> > --
> > 2.31.1
> >
> 

