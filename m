Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6773EEB844
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbfJaUK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:10:57 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43841 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfJaUK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:10:57 -0400
Received: by mail-qk1-f195.google.com with SMTP id a194so8349183qkg.10;
        Thu, 31 Oct 2019 13:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=izZ0JdqmpNUx1/JL1U4fSJY23FHeniLaDbyAYNzp/sY=;
        b=G59Fmh2I9poVrLHeh1n+p/Gir9NpKSNW11Coz3TAtFvpbuSfAPtfWkxX/7Yr/safnU
         IijJIU5aW2Icgy5BYCLcQJqpG8CZPCY/MOyHu1gmJmMjWUazPjp21lwQ9PqtB0t3U/xB
         MnuWdMlEuejK9mSu9XjVnmvBXJN1KgUDwoURQM4g2hTo81DwEqvTQ9e31XVy+HOjRMIC
         Vy33fcx3rL39E/nV3hED9jwE3DoLeMLrU9mZK99fGoJuE1Iw6TcPhnnqSP0i5n//HBl+
         8UvyY9H82z6nQVsEkgstyl18akMId9jLf20+RrArHPrhrc2fmGRDc8r+4JzpNYlGHyU4
         orYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=izZ0JdqmpNUx1/JL1U4fSJY23FHeniLaDbyAYNzp/sY=;
        b=S6YirstE6mKEPnV6o+N/uHgHwYAlF0oGDuTseMdakRQrFm7VjQaa9bbqq1NNcmOlOo
         eR5yelHbEeoA3xuDNDq68VDUCR0S/sJJjpNu1GbPYqyWqmzCAJbMqjXSlmKbJb10jaDO
         ldw1PaHCXOnRo/Q0X2YhjjnNneiWTywMJSKjZssZHv+6AiEYnpYLbbdUX5q0Y5cP88S7
         BlEdfz4AoazU3IZaG7DXTgCypXsjLb/9TPbqH/6gMDF3Y7ewDejVKS8JJkW2UFGFVZHc
         JzJiaA+u9Kh88+02SBbDgY1OVwO7T6kls1O8lLX00y04YblDwAS9OijvHpjUhpUyayr9
         zshg==
X-Gm-Message-State: APjAAAWMPndmdzEzwt/snaKquTqMa9fgMXT4qr9i4AdCUioah7s9uqUj
        R4AevCirzZq359Sk8GPIKseFhj8U73G9UajThKI=
X-Google-Smtp-Source: APXvYqxOZVh0KWw43Cyi9iSdvMkizinIwsVRuc82tmKwBEKS//kc6Y1sEdXUhf7UICacp3cMHGuecY64xCwtEihrnn4=
X-Received: by 2002:a37:8f83:: with SMTP id r125mr2426740qkd.36.1572552656234;
 Thu, 31 Oct 2019 13:10:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1572483054.git.daniel@iogearbox.net> <9693ff29e27b25a6bfcd9bc0f0f81a37f4c6e800.1572483054.git.daniel@iogearbox.net>
In-Reply-To: <9693ff29e27b25a6bfcd9bc0f0f81a37f4c6e800.1572483054.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 31 Oct 2019 13:10:45 -0700
Message-ID: <CAEf4BzaeYn4=MTujkGwdiJYgFyXJ7xEpSjW_YSEp=Dxe=8zPnQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 7/8] bpf, testing: Convert prog tests to
 probe_read_{user,kernel}{,_str} helper
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 6:00 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Use probe read *_{kernel,user}{,_str}() helpers instead of bpf_probe_read()
> or bpf_probe_read_user_str() for program tests where appropriate.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/progs/kfree_skb.c |  4 +-
>  tools/testing/selftests/bpf/progs/pyperf.h    | 67 ++++++++++---------
>  .../testing/selftests/bpf/progs/strobemeta.h  | 36 +++++-----
>  .../selftests/bpf/progs/test_tcp_estats.c     |  2 +-
>  4 files changed, 57 insertions(+), 52 deletions(-)
>

[...]
