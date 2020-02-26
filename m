Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC601701AC
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 15:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgBZO5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 09:57:54 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41151 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgBZO5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 09:57:53 -0500
Received: by mail-lf1-f67.google.com with SMTP id y17so2201477lfe.8
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 06:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=5b76ZlhEfnqBCIW7EGO5bE2y5s/Wr2P7TZK16lYt0G4=;
        b=Wq4hWukEEodtucPp8TvW1L2EHqdJX5vpd4M/3mXwlfsbUlNkBl6AtLg0tEQ+UJvqZf
         Nm4BfTWOWawWNW5gbov1ya4U4TkasDQayr51P5Bt1Ipmmz55BGLzV3xpMstiQpdba3zZ
         XUg4BNZ7LzemBx/5vCA052QnYh1mzK8xNSZLI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=5b76ZlhEfnqBCIW7EGO5bE2y5s/Wr2P7TZK16lYt0G4=;
        b=Bu5SnVbUst35gB5NyQs6vzsZSnUpXYcj+F6rJyMLw6hqj5SFoWQ/deiqlE9r7Pf8JR
         MhkugIRYFSTYlImOc9LYI33/pMlDMCzK04loRir0GOAXzlANWcAD0QB7rr/2Aki7sAdC
         K9HPj488zILbVGGJxO8XbgMgCN5XHIbLbuCqrNzTJaipFokJCF9M5ytkhbHtq+UIy7uO
         tVspb32enwTqBNBs3Scn2Uy3ST+Te7RCwDWeJW5OJiPs0b31aI6qOux5haK6yycuU//a
         i/1dD2+k2gEN86rlJFsv9XZtpHan5redZrzIOJmMF77Otbh88N4fM6VquAYGG/frJCzm
         zMEQ==
X-Gm-Message-State: APjAAAWuEvouSII8xcSFAr7EzyCTJqjXv1OBWB75AbJL0QjW8/oEpAAy
        mqyYMxLn7mOb9MFOiH5RGCmIXg==
X-Google-Smtp-Source: APXvYqzObEuI79wXEMbmIN6/z5CCY8CG1rs0yddOF9cR1ub4qFqeYAAmVNEPLm8ngkzLN15g+JcTtg==
X-Received: by 2002:a05:6512:1041:: with SMTP id c1mr2751792lfb.211.1582729071726;
        Wed, 26 Feb 2020 06:57:51 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id n189sm1148348lfa.14.2020.02.26.06.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 06:57:51 -0800 (PST)
References: <20200225135636.5768-1-lmb@cloudflare.com> <20200225135636.5768-4-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 3/7] skmsg: introduce sk_psock_hooks
In-reply-to: <20200225135636.5768-4-lmb@cloudflare.com>
Date:   Wed, 26 Feb 2020 15:57:50 +0100
Message-ID: <87blplcs5t.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 02:56 PM CET, Lorenz Bauer wrote:
> The sockmap works by overriding some of the callbacks in sk->sk_prot, while
> leaving others untouched. This means that we need access to the struct proto
> for any protocol we want to support. For IPv4 this is trivial, since both
> TCP and UDP are always compiled in. IPv6 may be disabled or compiled as a
> module, so the existing TCP sockmap hooks use some trickery to lazily
> initialize the modified struct proto for TCPv6.
>
> Pull this logic into a standalone struct sk_psock_hooks, so that it can be
> re-used by UDP sockmap.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  include/linux/skmsg.h |  36 ++++++++-----
>  include/net/tcp.h     |   1 -
>  net/core/skmsg.c      |  52 +++++++++++++++++++
>  net/core/sock_map.c   |  24 ++++-----
>  net/ipv4/tcp_bpf.c    | 114 ++++++++++++------------------------------
>  5 files changed, 116 insertions(+), 111 deletions(-)
>
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index c881094387db..70d65ab10b5c 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h

[...]

> @@ -424,4 +425,13 @@ static inline void psock_progs_drop(struct sk_psock_progs *progs)
>  	psock_set_prog(&progs->skb_verdict, NULL);
>  }
>  
> +static inline int sk_psock_hooks_init(struct sk_psock_hooks *hooks,
> +				       struct proto *ipv4_base)
> +{
> +	hooks->ipv6_lock = __SPIN_LOCK_UNLOCKED();

We will need spin_lock_init instead to play nice with CONFIG_DEBUG_SPINLOCK.

> +	return hooks->rebuild_proto(hooks->ipv4, ipv4_base);
> +}
> +
> +int sk_psock_hooks_install(struct sk_psock_hooks *hooks, struct sock *sk);
> +
>  #endif /* _LINUX_SKMSG_H */

[...]
