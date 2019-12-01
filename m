Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B54710E2CB
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 18:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfLARyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 12:54:17 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39964 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbfLARyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 12:54:16 -0500
Received: by mail-lj1-f196.google.com with SMTP id s22so18249164ljs.7;
        Sun, 01 Dec 2019 09:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9H9SCSoxkgNiJzR8uzVPTTAqyRK3SZr0ck3SspsH/y4=;
        b=nNyD2jejk40SFGzFW4oZ45U5NcmczzOs0GpGLVTyu6RrJuVjqcwBSduqgEXAmfwM07
         +VTCQjHDzQIjpb2Yo2xofhHX+JpaSGkcjLIiibVRw1mv8GgoxvgxtG+CNWPc3TLHxMsW
         r99p/iY9aJr79LcUPaK5Lfo5p+DavAVeC9wpY4KbLgAt3n/d08zyrcVwcqrY3BIZ0u0H
         tiuOOmnk791Wgxp/joAgNX5AOM6H1g1GqJ3ajTqqf0u90BUjuhjndpHyPEy5EiTqvAoj
         qH+GgxERE6C3rAqkxV9aybIlqUEk/JU6cjAT0PPyemFV9JqVzGc1k1jUgafZGiQK43+9
         Pq4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9H9SCSoxkgNiJzR8uzVPTTAqyRK3SZr0ck3SspsH/y4=;
        b=ZBEbKyXxBoaeLSE13w8v+cwSEII7nKXxVLqFHCrsmOe9u1sKjLNRP9M4ztAsweg7wM
         v+tSd4pRSwUxN13DQEOiA1SPbyH+PskfN1y6cgL8B6vxIsA/fUKRri6vUDAtkvtHJ5rb
         NDlphRQ6vsflay/q5hg5RK9zX/jq4O/JGjulROCGaRCdIDNJPakBRQO8SI35iPpMs9+Q
         jJVO+AYWicjtWyUoUuhTMlFazYj3CXLhrObfmT0rMGuAZMKQ7dVpvI2S6rLGFtMAcbMT
         UFUyp25FN+WXCYIp+M3+QJzmf3Bea/xctUnyJ8EGokQsZjHI+qWRvyUTFMDv/xn8DugN
         Izmw==
X-Gm-Message-State: APjAAAVISwtk3iMAxcpvwYCRxPMZuIJ8ks6RNlvm134oU+OgC/bMu4JB
        uLjTE73+PUSE+GeQHnLhSdQfZzgjzS4f8/ZvcB0=
X-Google-Smtp-Source: APXvYqxoGaJMoLkaU0a3hunkmL+q4Au/MmUaEB2YHReelPt9T3RlRfOi4plWeH/1jGdOXm7NCc3VKDWHAKt7oX9SYsw=
X-Received: by 2002:a2e:5850:: with SMTP id x16mr5087825ljd.228.1575222853104;
 Sun, 01 Dec 2019 09:54:13 -0800 (PST)
MIME-Version: 1.0
References: <20191129222911.3710-1-daniel@iogearbox.net> <ec8264ad-8806-208a-1375-51e7cad1866e@gmail.com>
 <10d4c87c-3d53-2dbf-d8c0-8b36863fec60@iogearbox.net>
In-Reply-To: <10d4c87c-3d53-2dbf-d8c0-8b36863fec60@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 1 Dec 2019 09:54:01 -0800
Message-ID: <CAADnVQ+8nOiTXJYKV+36Yg8+bkxAJVW5LdcjqLVeEiLRyNLCDA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: avoid setting bpf insns pages read-only when
 prog is jited
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 30, 2019 at 1:52 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/30/19 2:37 AM, Eric Dumazet wrote:
> > On 11/29/19 2:29 PM, Daniel Borkmann wrote:
> >> For the case where the interpreter is compiled out or when the prog is jited
> >> it is completely unnecessary to set the BPF insn pages as read-only. In fact,
> >> on frequent churn of BPF programs, it could lead to performance degradation of
> >> the system over time since it would break the direct map down to 4k pages when
> >> calling set_memory_ro() for the insn buffer on x86-64 / arm64 and there is no
> >> reverse operation. Thus, avoid breaking up large pages for data maps, and only
> >> limit this to the module range used by the JIT where it is necessary to set
> >> the image read-only and executable.
> >
> > Interesting... But why the non JIT case would need RO protection ?
>
> It was done for interpreter around 5 years ago mainly due to concerns from security
> folks that the BPF insn image could get corrupted (through some other bug in the
> kernel) in post-verifier stage by an attacker and then there's nothing really that
> would provide any sort of protection guarantees; pretty much the same reasons why
> e.g. modules are set to read-only in the kernel.
>
> > Do you have any performance measures to share ?
>
> No numbers, and I'm also not aware of any reports from users, but it was recently
> brought to our attention from mm folks during discussion of a different set:
>
> https://lore.kernel.org/lkml/1572171452-7958-2-git-send-email-rppt@kernel.org/T/

Applied. Thanks
