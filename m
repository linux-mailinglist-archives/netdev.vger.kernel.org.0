Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA878CC3A3
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 21:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbfJDTgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 15:36:22 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44195 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfJDTgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 15:36:21 -0400
Received: by mail-lj1-f193.google.com with SMTP id m13so7609628ljj.11;
        Fri, 04 Oct 2019 12:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qqn/Z5GvazZJH84kF7SgLAV4a1MJgjrOh+lAraGE9yo=;
        b=E6qAZN9IrJXdpDv9tQTtCzBYVQFDK120IO+OFjzz2K1qgYgqxXRC0G0qtMMAMx7eNs
         RIpupBKwlGIXCh/p/+0u6yc5i5naMpoMNn5tnQmFNN1L7eZjhLxoqeTLokQLftUlwgT8
         4gZ5pg1jVz5vEYzEVqH1Jat60rrajbHajRGCDJXfezbjI5VqlzSasdjy4jTCCrC0v/wJ
         zElPOd8z6nfkr6HjayHJ9EZuO729QlElmixnsYielc/lm9UI5HdNE9NDxml4S7F3YaLP
         E+v+6wAQlylGkEvJNk4lYJMJMMmFacNTC/a9Nla0uhl7mQgDzzu87eHbmnxZLDF9BDNe
         ZKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qqn/Z5GvazZJH84kF7SgLAV4a1MJgjrOh+lAraGE9yo=;
        b=jglN1pJDjfW+aOaY/8HFNs4LaexNMpd4QS6C+EtZunXJLQ/astN4MW8vs3dhRULUWL
         a3cCxEglD4uFZ5lvZtm+L4JqkZLhREw0mtEsB+k5XuqezEre8SeNA+fjELIY9YfshuVv
         K3nlm4kYpg3nPL8T0hRK5TuXkGv32/xAejxGzyjpt8s/hauQxd199a/+NXvmaPtCoJns
         1Kh6R3RIvlBzsHxbOeM4IYQUvA3Zio6fP8rCteIvEaEcblPhIMnma6K9v6R60Wr8DPq4
         dO6HfaSIFPU53ShwbhZdb4WHapQjcED0KJFg3bbk+am1dArCV+OcP5mrf/zhVea/id/O
         Je7w==
X-Gm-Message-State: APjAAAVSaARcsvU/kKpIOYyEypt08fEq2ZgOhL5CDlP4PSB9XPYGRtfw
        4oHDlgiVjipTjsYuCYdkQfAIobHMlYZF4QB4Fxo=
X-Google-Smtp-Source: APXvYqx9CVpIGRM3EK44eWv42NIEI5bpwbW+AaX1jnEHUEKjgveNZltvhgP6XVn2GVFfdDpET2G6pCV7e4xLNpkq5qs=
X-Received: by 2002:a2e:b0f4:: with SMTP id h20mr10511470ljl.10.1570217779344;
 Fri, 04 Oct 2019 12:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20191002234512.25902-1-daniel@iogearbox.net> <CAPhsuW6==Ukxjh69SVLusC=GMf=65Y2T0gLNig55obwbS-7VqQ@mail.gmail.com>
 <5d9663547acce_59e82ace6a9345b4a3@john-XPS-13-9370.notmuch>
In-Reply-To: <5d9663547acce_59e82ace6a9345b4a3@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 4 Oct 2019 12:36:07 -0700
Message-ID: <CAADnVQLXdNU8V=EBrriPNThFS7fbPSqUekkMR3M4WW8mkKCuRA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf, x86: Small optimization in comparing
 against imm0
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Song Liu <liu.song.a23@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 2:08 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Song Liu wrote:
> > On Wed, Oct 2, 2019 at 5:30 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > Replace 'cmp reg, 0' with 'test reg, reg' for comparisons against
> > > zero. Saves 1 byte of instruction encoding per occurrence. The flag
> > > results of test 'reg, reg' are identical to 'cmp reg, 0' in all
> > > cases except for AF which we don't use/care about. In terms of
> > > macro-fusibility in combination with a subsequent conditional jump
> > > instruction, both have the same properties for the jumps used in
> > > the JIT translation. For example, same JITed Cilium program can
> > > shrink a bit from e.g. 12,455 to 12,317 bytes as tests with 0 are
> > > used quite frequently.
> > >
> > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> >
> > Acked-by: Song Liu <songliubraving@fb.com>
>
> Bonus points for causing me to spend the morning remembering the
> differences between cmd, and, or, and test.
>
> Also wonder if at some point we should clean up the jit a bit and
> add some defines/helpers for all the open coded opcodes and such.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Applied both. Thanks
