Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFE617359D
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 11:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgB1Ksq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 05:48:46 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38184 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgB1Ksp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 05:48:45 -0500
Received: by mail-ot1-f67.google.com with SMTP id z9so2161500oth.5
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 02:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MpoN/z4EwKEqxgzjR1c7PsvZNdK1eW/yjUEe0W4lv5k=;
        b=m2eJfkhXG5gnjCDjAyVtr6Y0WVyN1TxvXhmOar6O95eJGFpumXPtjEKp5Q2Rgu0qeR
         8N1x+FZXz+XxFCFEfjiqFj3P6HdLFmB47YQS65jxoSUynXGNXSQUsd+5oyjOse+ShQui
         aGpT1E14QZky8luiGXeHMLJzj5xQSi/Tqu7Vg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MpoN/z4EwKEqxgzjR1c7PsvZNdK1eW/yjUEe0W4lv5k=;
        b=mlI0upmUN7/keODkOHfs80GXZ4VqyPrBhel+w61WJvKcPDcBwYJBZRsCQAiJYjVu0Z
         NhIgX2G6SMOWiQBxaXYAyDpN5udRhVP36fm/jBR4mQEcQgRgOTzOvwEP7X3c//YKwvvh
         9FLsjogYf16NWpvmbjDM20ZD/aa2UX/bBJUc1UbnesDmF+MSp4wrOGPv/Nbwdn5hhdK6
         kIlwUguMGU8lSQn22BJOYmJ5f4hU22ZDlYoV74U/8CZOxUpghgDKG9dJBT15aijlHBID
         vsp6/ne9CQ+CWxywIpkNjp5i7ofWCN4nGQk9eNfNWehi0+l4sz4nkll977cS7thYxi/F
         aBRQ==
X-Gm-Message-State: APjAAAWT6WqL/fx+IUTpXLcGfk3y/fEjsVqsRYu9tzNLwnnn39dPCpfG
        19/YrX27oOxVg4VDL4DIVnZZXZcR5/Ds7+/uW5TpBA==
X-Google-Smtp-Source: APXvYqxVTETzTExegu7yyTuh0tZ2ID/kOglog1lkA5qXP4gomeiGfxe6s7V7iJdtN+t+4JweQbzKjKKoKwilvvzg6hA=
X-Received: by 2002:a05:6830:1185:: with SMTP id u5mr2540766otq.147.1582886925219;
 Fri, 28 Feb 2020 02:48:45 -0800 (PST)
MIME-Version: 1.0
References: <20200225135636.5768-1-lmb@cloudflare.com> <20200225135636.5768-4-lmb@cloudflare.com>
 <20200226183746.wvkp2mrstotyepyc@kafai-mbp>
In-Reply-To: <20200226183746.wvkp2mrstotyepyc@kafai-mbp>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 28 Feb 2020 10:48:33 +0000
Message-ID: <CACAyw99=ZL2dfpS9bCjNtCe7x8NOskTJbd06_X-UzieuhSrcJA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/7] skmsg: introduce sk_psock_hooks
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Feb 2020 at 18:37, Martin KaFai Lau <kafai@fb.com> wrote:
>
> > +int sk_psock_hooks_install(struct sk_psock_hooks *hooks, struct sock *sk)
> > +{
> > +     struct sk_psock *psock = sk_psock(sk);
> > +     struct proto *prot_base;
> > +
> > +     WARN_ON_ONCE(!rcu_read_lock_held());
> Is this only for the earlier sk_psock(sk)?

The function is an amalgamation of tcp_bpf_reinit and tcp_bpf_init,
which both take the
read lock. I figured it would make sense to assert this behaviour in
sk_psock_hooks_install.

>
> > +
> > +     if (unlikely(!psock))
> When will this happen?

I don't know to be honest, this is adapted from tcp_bpf_init:

       psock = sk_psock(sk);
       if (unlikely(!psock || psock->sk_proto ||
                    tcp_bpf_assert_proto_ops(ops))) {
               rcu_read_unlock();
               return -EINVAL;
       }

>
> > +             return -EINVAL;
> > +
> > +     /* Initialize saved callbacks and original proto only once.
> > +      * Since we've not installed the hooks, psock is not yet in use and
> > +      * we can initialize it without synchronization.
> > +      */
> > +     if (!psock->sk_proto) {
> If I read it correctly, this is to replace the tcp_bpf_reinit_sk_prot()?
>
> I think some of the current reinit comment is useful to keep also:
>
> /* Reinit occurs when program types change e.g. TCP_BPF_TX is removed ... */

Ack, I will elaborate.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
