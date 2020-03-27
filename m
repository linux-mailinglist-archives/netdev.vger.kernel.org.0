Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E4B195CFD
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 18:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgC0RjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 13:39:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50443 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgC0RjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 13:39:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id d198so12323117wmd.0;
        Fri, 27 Mar 2020 10:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RRMRFFVrO3TBJxAH0Dp6DKoyRreSDngQLn/DaYv294I=;
        b=IH+V6M9W0ZYafu5U+qu6BYrSF+qCZ6JxT86tPL2xf0m2l2ZXkPcVjBcOVOCQUsrBpC
         WkIQ3Wm/C2UUBP0Csx91mIS+Yd5HlxyC2vJqKMkPdD6IigKA/BDD/Uw7E7ibmrUFjbCo
         Q9RalpnA47unNS4X+w9uYcip9rByBPRnMAB3dqUeAwE/EKcRbd0zFF0Ih5ivG2RQU6SZ
         3C+KRte14YCHKz+JAeP6zWAUfWrOjJpM9o2pm3K4NB4sM29XwdF/+sitgvmqvAqRsjKw
         1Z/+o8KAMzfh51EWdz/HCIXuDpfd1upi6w1Cy6FrI3sc+dceKpq4hc3rZr0N6nZybo9G
         1dAA==
X-Gm-Message-State: ANhLgQ1gKf3SAIokKvN5rCXHjs6jQHflfiHaEyhBEbheLMCvOeJsrF66
        NOSj8l5KJRK56OZdveAkMLw2oUoZ8MAjW3yRKog=
X-Google-Smtp-Source: ADFU+vvcHfkticuSWbJuhV4gA7aQhcdlMVYin9vPuwZ6IkOLmCQTGJQuzOxIRbTq6FpZr7BsB5LTqPihFwVVmLiTYzg=
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr6779679wme.185.1585330748807;
 Fri, 27 Mar 2020 10:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200327042556.11560-1-joe@wand.net.nz> <20200327042556.11560-4-joe@wand.net.nz>
 <daf11ebd-e578-10d4-6e4a-00bb396258cf@mojatatu.com>
In-Reply-To: <daf11ebd-e578-10d4-6e4a-00bb396258cf@mojatatu.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Fri, 27 Mar 2020 10:38:41 -0700
Message-ID: <CAOftzPjHhcFpadsBz6qGwx3hcmj2Xe2fs0HN-jBM+-Eh5OgZvg@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 3/5] bpf: Don't refcount LISTEN sockets in sk_assign()
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 7:26 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2020-03-27 12:25 a.m., Joe Stringer wrote:
> > BPF_CALL_1(bpf_sk_release, struct sock *, sk)
> >   {
> > -     /* Only full sockets have sk->sk_flags. */
> > -     if (!sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE))
> > +     if (sk_is_refcounted(sk))
> >               sock_gen_put(sk);
> >       return 0;
> >   }
>
>
> Would it make sense to have both the bpf_sk_release and bpf_sk_assign()
> centralized so we dont replicate the functionality in tc? Reduces
> maintainance overhead.

I think sock_pfree() steps in that direction, we would just need the
corresponding refactoring for sk_assign bits. Sounds like a good idea.

This shouldn't functionally affect this series, I'm happy to either
spin this into next revision of this series (if there's other
feedback), or send a followup refactor for this, or defer this to your
TC follow-up series that would consume the refactored functions.
