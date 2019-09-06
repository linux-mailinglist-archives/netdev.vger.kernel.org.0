Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AB3AB5AC
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 12:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390993AbfIFKRt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Sep 2019 06:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389573AbfIFKRs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 06:17:48 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA81669060
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 10:17:47 +0000 (UTC)
Received: by mail-ed1-f70.google.com with SMTP id z39so3295118edc.15
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 03:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Of90RwY0BPgYlqIW5KJtWOerfX+Hnok6BAhYhxGfo3o=;
        b=nIGEXQ3JGC3f7psG3bBo8z4DBTaOsWmJGTCzsD6A8vGouSwUnLQ6G+Mx5Fj0fEYsmB
         hPBMS7H3umunPSvqerYBwGohIZGChyGy3oYptHEOeSsU8Ms7jpagM9h5sl2qO2dh+dfF
         LTZ8f0a8eEiOPxVyeX76o3imhMG/1NlX3XX1sT2J995EizJrWRaoYfYMyN2upLpJ16hd
         wynQ9pRB1jhJsOvmBIl7b4nb/8KBvyFiwYGhacY4MLJ0eqsS+onTCX+z41ybm7D4OUbm
         Gipk43q/zBX38+j2Mp81Xe9bd3RuzZ92TMXnJFxBUo4LwXxpdkOKir3N479tkDUXbDVZ
         nsTA==
X-Gm-Message-State: APjAAAUS8GiBNRJO7kPQ1rbz2YCUpJM2DL4l6ZgPPE78RBbRCmz8fb9K
        zJ7O68scOZx2KPXiqymjLmH1Q7OG1nHq0zOD9ooTHnJ15v6gGa/JyGqlpOM6ifbn9Y7RTxWnQWu
        bNr+tgWnao0pTipy47Z5qC1utX81uzBKb
X-Received: by 2002:a17:906:8251:: with SMTP id f17mr6732140ejx.222.1567765066352;
        Fri, 06 Sep 2019 03:17:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwPMzfJkM70nzqSWQclnB4OBWzzVyJHDFbejnGDRI9YueoyniSsdFdff6jtC4hSYH+U9RZAIPsBIjBZlQBUYH0=
X-Received: by 2002:a17:906:8251:: with SMTP id f17mr6732126ejx.222.1567765066134;
 Fri, 06 Sep 2019 03:17:46 -0700 (PDT)
MIME-Version: 1.0
References: <12a9cb8d91e41a08466141d4bb8ee659487d01df.1567611976.git.aclaudi@redhat.com>
 <83242eb4-6304-0fcf-2d2a-6ef4de464e81@gmail.com> <CAPpH65xtgWp2ELuPBdDOFfhJfHCA6brwxqbPxZogTnnnQ26CmA@mail.gmail.com>
 <20190905085147.72772bba@hermes.lan>
In-Reply-To: <20190905085147.72772bba@hermes.lan>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Fri, 6 Sep 2019 12:19:05 +0200
Message-ID: <CAPpH65xdYE1_n9zR8X0UUfAT1TzjMLP=z-eFDNnfzXGQnKzdrA@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] bpf: fix snprintf truncation warning
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>,
        linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 5, 2019 at 5:51 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Thu, 5 Sep 2019 13:44:55 +0200
> Andrea Claudi <aclaudi@redhat.com> wrote:
>
> > On Thu, Sep 5, 2019 at 12:15 AM David Ahern <dsahern@gmail.com> wrote:
> > >
> > > On 9/4/19 9:50 AM, Andrea Claudi wrote:
> > > > gcc v9.2.1 produces the following warning compiling iproute2:
> > > >
> > > > bpf.c: In function ‘bpf_get_work_dir’:
> > > > bpf.c:784:49: warning: ‘snprintf’ output may be truncated before the last format character [-Wformat-truncation=]
> > > >   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
> > > >       |                                                 ^
> > > > bpf.c:784:2: note: ‘snprintf’ output between 2 and 4097 bytes into a destination of size 4096
> > > >   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
> > > >       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >
> > > > Fix it extending bpf_wrk_dir size by 1 byte for the extra "/" char.
> > > >
> > > > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > > > ---
> > > >  lib/bpf.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/lib/bpf.c b/lib/bpf.c
> > > > index 7d2a322ffbaec..95de7894a93ce 100644
> > > > --- a/lib/bpf.c
> > > > +++ b/lib/bpf.c
> > > > @@ -742,7 +742,7 @@ static int bpf_gen_hierarchy(const char *base)
> > > >  static const char *bpf_get_work_dir(enum bpf_prog_type type)
> > > >  {
> > > >       static char bpf_tmp[PATH_MAX] = BPF_DIR_MNT;
> > > > -     static char bpf_wrk_dir[PATH_MAX];
> > > > +     static char bpf_wrk_dir[PATH_MAX + 1];
> > > >       static const char *mnt;
> > > >       static bool bpf_mnt_cached;
> > > >       const char *mnt_env = getenv(BPF_ENV_MNT);
> > > >
> > >
> > > PATH_MAX is meant to be the max length for a filesystem path including
> > > the null terminator, so I think it would be better to change the
> > > snprintf to 'sizeof(bpf_wrk_dir) - 1'.
> >
> > With 'sizeof(bpf_wrk_dir) - 1' snprintf simply truncates at byte 4095
> > instead of byte 4096.
> > This means that bpf_wrk_dir can again be truncated before the final
> > "/", as it is by now.
> > Am I missing something?
> >
> > Trying your suggestion I have this slightly different warning message:
> >
> > bpf.c: In function ‘bpf_get_work_dir’:
> > bpf.c:784:52: warning: ‘/’ directive output may be truncated writing 1
> > byte into a region of size between 0 and 4095 [-Wformat-truncation=]
> >   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir) - 1, "%s/", mnt);
> >       |                                                    ^
> > bpf.c:784:2: note: ‘snprintf’ output between 2 and 4097 bytes into a
> > destination of size 4095
> >   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir) - 1, "%s/", mnt);
> >       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Why not rework this to use asprintf and avoid having huge buffers on stack?

Thanks for the suggestion. There are a lot of similar usages in
lib/bpf.c, I'll send a v2 to rework them all.
