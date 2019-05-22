Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 163202721F
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 00:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbfEVWPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 18:15:36 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44571 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfEVWPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 18:15:36 -0400
Received: by mail-qt1-f195.google.com with SMTP id f24so4391883qtk.11
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 15:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=jaxcTuh24nBukjXAvHhgvzzryBOuT4T/a28QbtGTWjI=;
        b=Zr8vgiL5UUkpMC1YeqMErUIQCmCRERkAX6neVUnscLyAZ8xH8x6AspxqMArdyyBbDf
         7b/UMfcZE44sC6FqB+9/lb4v//xc541QUP3lilM21dfqfOV9h1DZSTa/0elKt9dK4mzM
         jLiQQS679igWoWHyP9bTH7dRigUa2PDo7sBCF+i3iCCosWKuzlfjwj5utLrFFY2wRonV
         BNTcTXLO8VoOcQmDzUmGt/H/woLSOFdlfX+XxMpBApyDarRNOA//r1b/xugA6PmEQJRk
         QrDL6fTMooY94tAHJ40h3qF0caunz86HKZQnQnNwzFxGb5msxG1R1ixCpyGN944g9TEF
         YpqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=jaxcTuh24nBukjXAvHhgvzzryBOuT4T/a28QbtGTWjI=;
        b=PA3XcW9WtarzUuPKawzzuBSH7zI362cReEYBw6styoMpR7wIj+snO1eZF5PB2JyOUY
         G4KtLhIbqkeEoj7Q6gC3pdqKEVluu5ynRIxa9qUns+ewLubLSJsv2v7rkQ0ne3d2N7kA
         cOa7mKjHM/lLCqmx9l95glxKSd2PeaRP7He9ahSEmDG18TfomNH3w6rH3cBVjzOXbXkl
         MNB2OWfO6V2ZUlekXBF20XR5teU8k51AGsY3OukXnDCbN/DMbPnVq1VaUI9LLmlZa2oL
         9ou5f2gazfaOyO7+VdiIKs8oeYsWf8W8UYC4muDYYSaUFDEOBoxnaM0Ebp8mrxFFP0/F
         elGg==
X-Gm-Message-State: APjAAAUXVjjjVfU5Mc7AQHqkQ1VDIlwHqc3HXGNFn+d4GosVZU1bp+sV
        9fpeerV6l5Yy2ZpNEPdwYnj2GA==
X-Google-Smtp-Source: APXvYqxw7za+bXOE4LW5kT+AFBMRAFmkt+RZceVW+RY7pU+tUdmP4RLH3vwnhwNvBAk4KnHOQOkFsA==
X-Received: by 2002:ac8:1a59:: with SMTP id q25mr77943872qtk.154.1558563334909;
        Wed, 22 May 2019 15:15:34 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x10sm1489607qkl.84.2019.05.22.15.15.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 22 May 2019 15:15:34 -0700 (PDT)
Date:   Wed, 22 May 2019 15:15:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org,
        David Beckett <david.beckett@netronome.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [bpf PATCH v4 1/4] bpf: tls, implement unhash to avoid
 transition out of ESTABLISHED
Message-ID: <20190522151530.0aca8bce@cakuba.netronome.com>
In-Reply-To: <5ce5c5cd23c59_44342b1a4abe25b410@john-XPS-13-9360.notmuch>
References: <155746412544.20677.8888193135689886027.stgit@john-XPS-13-9360>
        <155746426913.20677.2783358822817593806.stgit@john-XPS-13-9360>
        <20190522095730.047ad08f@cakuba.netronome.com>
        <5ce5c5cd23c59_44342b1a4abe25b410@john-XPS-13-9360.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 May 2019 14:57:33 -0700, John Fastabend wrote:
> Jakub Kicinski wrote:
> > On Thu, 09 May 2019 21:57:49 -0700, John Fastabend wrote:  
> 
> [...]
> 
> > 
> > Looks like David Beckett managed to trigger another nasty on the
> > release path :/
> > 
> >     BUG: kernel NULL pointer dereference, address: 0000000000000012
> >     PGD 0 P4D 0
> >     Oops: 0000 [#1] SMP PTI
> >     CPU: 7 PID: 0 Comm: swapper/7 Not tainted
> >     5.2.0-rc1-00139-g14629453a6d3 #21 RIP: 0010:tcp_peek_len+0x10/0x60
> >     RSP: 0018:ffffc02e41c54b98 EFLAGS: 00010246
> >     RAX: 0000000000000000 RBX: ffff9cf924c4e030 RCX: 0000000000000051
> >     RDX: 0000000000000000 RSI: 000000000000000c RDI: ffff9cf97128f480
> >     RBP: ffff9cf9365e0300 R08: ffff9cf94fe7d2c0 R09: 0000000000000000
> >     R10: 000000000000036b R11: ffff9cf939735e00 R12: ffff9cf91ad9ae40
> >     R13: ffff9cf924c4e000 R14: ffff9cf9a8fcbaae R15: 0000000000000020
> >     FS: 0000000000000000(0000) GS:ffff9cf9af7c0000(0000)
> >     knlGS:0000000000000000 CS: 0010 DS: 0000 ES: 0000 CR0:
> >     0000000080050033 CR2: 0000000000000012 CR3: 000000013920a003 CR4:
> >     00000000003606e0 DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> >     0000000000000000 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> >     0000000000000400 Call Trace:
> >      <IRQ>
> >      strp_data_ready+0x48/0x90
> >      tls_data_ready+0x22/0xd0 [tls]
> >      tcp_rcv_established+0x569/0x620
> >      tcp_v4_do_rcv+0x127/0x1e0
> >      tcp_v4_rcv+0xad7/0xbf0
> >      ip_protocol_deliver_rcu+0x2c/0x1c0
> >      ip_local_deliver_finish+0x41/0x50
> >      ip_local_deliver+0x6b/0xe0
> >      ? ip_protocol_deliver_rcu+0x1c0/0x1c0
> >      ip_rcv+0x52/0xd0
> >      ? ip_rcv_finish_core.isra.20+0x380/0x380
> >      __netif_receive_skb_one_core+0x7e/0x90
> >      netif_receive_skb_internal+0x42/0xf0
> >      napi_gro_receive+0xed/0x150
> >      nfp_net_poll+0x7a2/0xd30 [nfp]
> >      ? kmem_cache_free_bulk+0x286/0x310
> >      net_rx_action+0x149/0x3b0
> >      __do_softirq+0xe3/0x30a
> >      ? handle_irq_event_percpu+0x6a/0x80
> >      irq_exit+0xe8/0xf0
> >      do_IRQ+0x85/0xd0
> >      common_interrupt+0xf/0xf
> >      </IRQ>
> >     RIP: 0010:cpuidle_enter_state+0xbc/0x450
> > 
> > If I read this right strparser calls sock->ops->peek_len(sock), but the
> > sock->sk is already NULL.  I'm guess this is because inet_release()
> > does:
> > 
> > 		sock->sk = NULL;
> > 		sk->sk_prot->close(sk, timeout);
> > 
> > And I don't really see a way for ktls to know that sock->sk is about to
> > be cleared, and therefore no way to stop strparser.  Or for strparser
> > to always do the check, given tcp_peek_len() will do another dereference
> > of sock->sk :S
> > 
> > That's mostly a guess, it takes me half an hour of ktls connections
> > running to repro.
> > 
> > Any advice would be appreciated..  Can we move the sock->sk assignment
> > after close?..
> > 
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index 5183a2daba64..aff93e7cdb31 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -428,8 +428,8 @@ int inet_release(struct socket *sock)
> >                 if (sock_flag(sk, SOCK_LINGER) &&
> >                     !(current->flags & PF_EXITING))
> >                         timeout = sk->sk_lingertime;
> > -               sock->sk = NULL;
> >                 sk->sk_prot->close(sk, timeout);
> > +               sock->sk = NULL;
> >         }
> >         return 0;
> >  }
> > 
> > I don't see IPv6 clearing this pointer, perhaps we don't have to?

Correction here, IPv6 just calls the IPv4 code, that's why IPv6 was
also fixed after my change.

> > We tested it and it seems to works, but this is pre-git code, so
> > it's hard to tell what the reason to clear was :)  
> 
> How about making strp_peek_len tolerant of a null sock->sk?
> 
> diff --git a/net/strparser/strparser.c b/net/strparser/strparser.c
> index e137698e8aef..79518f93d2d8 100644
> --- a/net/strparser/strparser.c
> +++ b/net/strparser/strparser.c
> @@ -84,9 +84,10 @@ static void strp_parser_err(struct strparser *strp, int err,
>  static inline int strp_peek_len(struct strparser *strp)
>  {
>         if (strp->sk) {
> -               struct socket *sock = strp->sk->sk_socket;
> +               struct socket *sock = READ_ONCE(strp->sk->sk_socket);
>  
> -               return sock->ops->peek_len(sock);
> +               if (likely(sock))
> +                       return sock->ops->peek_len(sock);
>         }

Mmm..  I'm not sure - sk->sk_socket doesn't get cleared AFAICT, 
the NULL deref is on sk_state of sock->sk so sock is non-NULL here,
then:

int tcp_peek_len(struct socket *sock)
{
	return tcp_inq(sock->sk);
}
EXPORT_SYMBOL(tcp_peek_len);

Will pass NULL to tcp_inq, which then does:

static inline int tcp_inq(struct sock *sk)
{
	struct tcp_sock *tp = tcp_sk(sk);
	int answ;

	if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
		answ = 0;

And sk->sk_state is what crashes the machine.
