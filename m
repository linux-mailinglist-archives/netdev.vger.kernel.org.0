Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F97AA1EA
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 13:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731785AbfIELnj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 Sep 2019 07:43:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55584 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbfIELnj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 07:43:39 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6239B2A09CC
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 11:43:38 +0000 (UTC)
Received: by mail-ed1-f70.google.com with SMTP id e13so1327796edl.13
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 04:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D04TA81v364lO9nJt/9dgosV//n5Ru/JhSib4N6uUa4=;
        b=SFTS+1iudYOyHmrMYzyqMA1Dbd+68dFpsqXmKbrtaR6Ev6aQqwabCuvBGVkhgYVMWI
         85PbqZLvAPayioaczrj99SdYOH3k63dri1AvhPJ94X2/2xYx4bcTE57/RQi0nrcPL8PH
         0ceneBJ/htNY1fV/gFWFQvoRQY3NwMqEW3JAa8tdR4QQEhAppH+0n+LflsDsFikXi8et
         jo8kjZmNLGnF0Q6kFigCk6B92eLF+ou7oExXHA9mARtTxnsGLy1QILVK8nZYWZqELHmb
         UnriPtzBwgJVde7wwV7IA9tweWzc6lmA2wHDy5WtK/pJ1XitM57Xm5udU1IQwAFpUYJg
         Jz0Q==
X-Gm-Message-State: APjAAAUuwMocZV1Yo5hwaFJBnN3T3lQ73oYzhFGLlGOJUo31F6QwAz79
        UvyIjwbTqyC25daacQFx/XHmMt5gvH07jZAPsyk5fzO7ER5QqtTpCkYfpFeMN19gN+E17F8zfPH
        DwtNCL90yd3efM7yjw3rtFGrbPR25kK10
X-Received: by 2002:a50:b0e6:: with SMTP id j93mr3109476edd.169.1567683817123;
        Thu, 05 Sep 2019 04:43:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzsbwr9NRQs+RWqvX63zGUTBiNGp0UEDt+KZTC7UtdV8Vh/WEs8cMQyZlwUn78j4heqi4pQ2O7uCdMaFkmjdCw=
X-Received: by 2002:a50:b0e6:: with SMTP id j93mr3109468edd.169.1567683816950;
 Thu, 05 Sep 2019 04:43:36 -0700 (PDT)
MIME-Version: 1.0
References: <12a9cb8d91e41a08466141d4bb8ee659487d01df.1567611976.git.aclaudi@redhat.com>
 <83242eb4-6304-0fcf-2d2a-6ef4de464e81@gmail.com>
In-Reply-To: <83242eb4-6304-0fcf-2d2a-6ef4de464e81@gmail.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Thu, 5 Sep 2019 13:44:55 +0200
Message-ID: <CAPpH65xtgWp2ELuPBdDOFfhJfHCA6brwxqbPxZogTnnnQ26CmA@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] bpf: fix snprintf truncation warning
To:     David Ahern <dsahern@gmail.com>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 5, 2019 at 12:15 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 9/4/19 9:50 AM, Andrea Claudi wrote:
> > gcc v9.2.1 produces the following warning compiling iproute2:
> >
> > bpf.c: In function ‘bpf_get_work_dir’:
> > bpf.c:784:49: warning: ‘snprintf’ output may be truncated before the last format character [-Wformat-truncation=]
> >   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
> >       |                                                 ^
> > bpf.c:784:2: note: ‘snprintf’ output between 2 and 4097 bytes into a destination of size 4096
> >   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
> >       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > Fix it extending bpf_wrk_dir size by 1 byte for the extra "/" char.
> >
> > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > ---
> >  lib/bpf.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/lib/bpf.c b/lib/bpf.c
> > index 7d2a322ffbaec..95de7894a93ce 100644
> > --- a/lib/bpf.c
> > +++ b/lib/bpf.c
> > @@ -742,7 +742,7 @@ static int bpf_gen_hierarchy(const char *base)
> >  static const char *bpf_get_work_dir(enum bpf_prog_type type)
> >  {
> >       static char bpf_tmp[PATH_MAX] = BPF_DIR_MNT;
> > -     static char bpf_wrk_dir[PATH_MAX];
> > +     static char bpf_wrk_dir[PATH_MAX + 1];
> >       static const char *mnt;
> >       static bool bpf_mnt_cached;
> >       const char *mnt_env = getenv(BPF_ENV_MNT);
> >
>
> PATH_MAX is meant to be the max length for a filesystem path including
> the null terminator, so I think it would be better to change the
> snprintf to 'sizeof(bpf_wrk_dir) - 1'.

With 'sizeof(bpf_wrk_dir) - 1' snprintf simply truncates at byte 4095
instead of byte 4096.
This means that bpf_wrk_dir can again be truncated before the final
"/", as it is by now.
Am I missing something?

Trying your suggestion I have this slightly different warning message:

bpf.c: In function ‘bpf_get_work_dir’:
bpf.c:784:52: warning: ‘/’ directive output may be truncated writing 1
byte into a region of size between 0 and 4095 [-Wformat-truncation=]
  784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir) - 1, "%s/", mnt);
      |                                                    ^
bpf.c:784:2: note: ‘snprintf’ output between 2 and 4097 bytes into a
destination of size 4095
  784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir) - 1, "%s/", mnt);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
