Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C707CBDB
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 20:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbfGaSXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 14:23:52 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:34317 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfGaSXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 14:23:52 -0400
Received: by mail-yb1-f193.google.com with SMTP id q5so12623421ybp.1
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 11:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8di294UA/9UkIQ1KpvqgEL5wdc0IuRXwzoXUWwxH6dA=;
        b=Io+mGAXR0SAFZNohmg1/dv90LkR+0Q2HUOAkgJCv3Idaub8NR0hHAn93Ugq0Lj4mm1
         VQyHWTssqw4b5yxYO9Bkg3LZ3OjSf5XK7Es29AKDyYpjgfQ9Ei9xcohpORQJts6w14tt
         n4dBMo31MvvWWqfp1fCcyqhfiQCjaZZhIOQjjBe1S1tGtj1vqvuBk1E9n1JbZGLZ0aXd
         jVSDcN9fPvHUyBTY7bFmil8AEUA9Mvxrgu1/1lSdIzE77ksnxgTh+YEY2mDE5NhJCy1w
         ZMURUSx7Ys6K9kkpsYqxjU7Q6MjEqfB+WuICCTM4BeBmaUDqi/lFD0aaw+yxf7pxKpYO
         iKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8di294UA/9UkIQ1KpvqgEL5wdc0IuRXwzoXUWwxH6dA=;
        b=MC8P2lR6FjcS+bZI6iqPFPwtWHqu+gMXQs919PhsUrpDHStmv0YFMomzgcPxeciYTC
         UymzKbZaUAbe6tppWGVlfyOfoY52JHanBCc76YQVyqqoKKreDeK/o0n4XFhULhdFkeqV
         5Vd1pcnevLoN+90afZCPdgJg5FygF6ICjT98B11bUf+tzBTuVtjIbifOkgQvhpiZTC47
         YVzwemiBsUOrw7hlz8AfxfZ0hTxD69ijAN7ZgNzf4CeO2jqwK5eAMrgDpZYIN/SzQq3c
         zkzfxeKyTR+Lam2sJboM0DDVG6r5OFgJrEXoz5zrFx9Lyd8CZ5Dz5QL2LEHrWIGIRWRN
         X+LA==
X-Gm-Message-State: APjAAAVP13VGo6puM1NdH26+YsjDy1K5y9CdnifA+L+0opmAKBQ91qW2
        My7v0WaW/LSkhHkb4Z333KBvU4BkdEMagGGunA==
X-Google-Smtp-Source: APXvYqy+IRSysyNmoXVjFNsI5rafbimN/SjLsY/ouDcD4kMgk41E8gpJalMIsnMRwjkbck/goE3c9NkC9BpmN0vaT6E=
X-Received: by 2002:a25:d38c:: with SMTP id e134mr31944373ybf.349.1564597431520;
 Wed, 31 Jul 2019 11:23:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190730184821.10833-1-danieltimlee@gmail.com>
 <20190730184821.10833-2-danieltimlee@gmail.com> <20190731120805.1091d5c9@carbon>
In-Reply-To: <20190731120805.1091d5c9@carbon>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Thu, 1 Aug 2019 03:23:40 +0900
Message-ID: <CAEKGpziq3fGWHxibHSkM48sR=6A-_oBJkiy3kKRQq4m-6s-2Mg@mail.gmail.com>
Subject: Re: [PATCH 1/2] tools: bpftool: add net load command to load XDP on interface
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 7:08 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Wed, 31 Jul 2019 03:48:20 +0900
> "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
>
> > By this commit, using `bpftool net load`, user can load XDP prog on
> > interface. New type of enum 'net_load_type' has been made, as stated at
> > cover-letter, the meaning of 'load' is, prog will be loaded on interface.
>
> Why the keyword "load" ?
> Why not "attach" (and "detach")?
>
> For BPF there is a clear distinction between the "load" and "attach"
> steps.  I know this is under subcommand "net", but to follow the
> conversion of other subcommands e.g. "prog" there are both "load" and
> "attach" commands.
>
>
> > BPF prog will be loaded through libbpf 'bpf_set_link_xdp_fd'.
>
> Again this is a "set" operation, not a "load" operation.

From earlier at cover-letter, I thought using the same word 'load' might give
confusion since XDP program is not considered as 'bpf_attach_type' and can't
be attached with 'BPF_PROG_ATTACH'.

But, according to the feedback from you and Andrii Nakryiko, replacing
the word 'load' as 'attach' would be more clear and more consistent.

> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>
> [...]
> >  static int do_show(int argc, char **argv)
> >  {
> >       struct bpf_attach_info attach_info = {};
> > @@ -305,13 +405,17 @@ static int do_help(int argc, char **argv)
> >
> >       fprintf(stderr,
> >               "Usage: %s %s { show | list } [dev <devname>]\n"
> > +             "       %s %s load PROG LOAD_TYPE <devname>\n"
>
> The "PROG" here does it correspond to the 'bpftool prog' syntax?:
>
>  PROG := { id PROG_ID | pinned FILE | tag PROG_TAG }
>

Yes. By using the same 'prog_parse_fd' from 'bpftool prog',
user can 'attach' XDP prog with id, pinned file or tag.

> >               "       %s %s help\n"
> > +             "\n"
> > +             "       " HELP_SPEC_PROGRAM "\n"
> > +             "       LOAD_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload }\n"
> >               "Note: Only xdp and tc attachments are supported now.\n"
> >               "      For progs attached to cgroups, use \"bpftool cgroup\"\n"
> >               "      to dump program attachments. For program types\n"
> >               "      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
> >               "      consult iproute2.\n",
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

And about the enum 'NET_LOAD_TYPE_XDP_DRIVE',
'DRIVER' looks more clear to understand.

Will change to it right away.

Thanks for the review.
