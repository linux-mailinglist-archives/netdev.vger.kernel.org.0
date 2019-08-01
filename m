Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A127D3CB
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbfHADnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:43:47 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46714 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfHADnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 23:43:47 -0400
Received: by mail-lf1-f68.google.com with SMTP id z15so44798003lfh.13;
        Wed, 31 Jul 2019 20:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DsOiwp5AJ5StlOEyUqw3Y/9J7gKUCg+XqdMbh1c4nZs=;
        b=XJNFeLf7sH3vwkX92+5t7+jiFuLB4bpWuiKaDy7Pk+2I0c/wPEmIi/93ME26CjIvT/
         ZALhCl4flWdM1clFQSqGejWGYI8s6XyrEOyM50FLzId+wzF/qsxF1ifzrNKbhT8aP9VI
         +dp2TAz0xTg+FtlHw9wXff5+cEKHFhi/tSOzRCZ0YLbVu0WwnozmPh+DqGr/u2EBg+zW
         3wyXOlBmhxuKfVBGz/spKqtdx1lW8vHcryYK7wGmB18HX8iM4lla3YkFzl9i6qm0pHzk
         jjtaNovTjxgat2N2KUdKubU6tqIXqSOl2fkuYx2rfJmwgjcVf8hQ9zd6Nzfqn4RNsIpz
         S7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DsOiwp5AJ5StlOEyUqw3Y/9J7gKUCg+XqdMbh1c4nZs=;
        b=GoREtvUYCxV+3MZSxexga1IDWyNoCyWPXzha8+Zb3c+IQ9OqGUNGcu0soTlczF4kAB
         EQDYcw8hV3flfbgl0aDrvKgIf0Re+/7IIab366sHOdl+HmJ3WWcXjBER3gnKtU0IUe+r
         RKoDFt8zMMi1qShpzHRp0dHB+XMhiGGUd5Xmao72vivMxi0cg2tR4xgOHL79HoGbFwpq
         MZz89PanHyFA+wMcMjce57M7tfo5cpgXob0//lmBjKG09efjWXScrs5Z7rThTH5Re8iN
         HoSw9/qE7nTUWzTU8IR88qp63x6+ld3tIOV3ocN+gjEWZbazS08yK63WTivlCNOx7Mqd
         Spdw==
X-Gm-Message-State: APjAAAVqOWjTNNKrF4KzTlG3UI8MjFAEuiSidqr0D+H+BjGvp4PUHXRQ
        bROfHvxJSS4aFfiFL4l82y1BOK8x0FDVGbt8mog=
X-Google-Smtp-Source: APXvYqyLlvBQGvrYWVcZ7qOk0S2f0/T0yvlFL1zitQo/4Y33vLVfjhsok80FMTsTpiepOq0znXysKL5xL3shZ09EzQY=
X-Received: by 2002:a19:ca4b:: with SMTP id h11mr56590366lfj.162.1564631024412;
 Wed, 31 Jul 2019 20:43:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190731013827.2445262-1-ast@kernel.org> <20190731013827.2445262-2-ast@kernel.org>
 <B6B907F5-E6CA-4C0B-92F3-0411CA4F4D95@fb.com>
In-Reply-To: <B6B907F5-E6CA-4C0B-92F3-0411CA4F4D95@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 31 Jul 2019 20:43:33 -0700
Message-ID: <CAADnVQJu9s4a=tc0+C5hgSPX4KnpYDzKu0AxxU4nCoU1QaWVEg@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: fix x64 JIT code generation for jmp to 1st insn
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 12:36 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 30, 2019, at 6:38 PM, Alexei Starovoitov <ast@kernel.org> wrote:
> >
> > Introduction of bounded loops exposed old bug in x64 JIT.
> > JIT maintains the array of offsets to the end of all instructions to
> > compute jmp offsets.
> > addrs[0] - offset of the end of the 1st insn (that includes prologue).
> > addrs[1] - offset of the end of the 2nd insn.
> > JIT didn't keep the offset of the beginning of the 1st insn,
> > since classic BPF didn't have backward jumps and valid extended BPF
> > couldn't have a branch to 1st insn, because it didn't allow loops.
> > With bounded loops it's possible to construct a valid program that
> > jumps backwards to the 1st insn.
> > Fix JIT by computing:
> > addrs[0] - offset of the end of prologue == start of the 1st insn.
> > addrs[1] - offset of the end of 1st insn.
> >
> > Reported-by: syzbot+35101610ff3e83119b1b@syzkaller.appspotmail.com
> > Fixes: 2589726d12a1 ("bpf: introduce bounded loops")
> > Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> Do we need similar fix for x86_32?

Right. x86_32 would need similar fix.

Applied to bpf tree.
