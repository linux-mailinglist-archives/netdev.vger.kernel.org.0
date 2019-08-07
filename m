Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA3D85291
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 20:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389026AbfHGSBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 14:01:12 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46568 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387953AbfHGSBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 14:01:12 -0400
Received: by mail-qk1-f193.google.com with SMTP id r4so66426251qkm.13
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 11:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=RJ6dwC6KBBDkp7iURBtYOksb1lcUUgBCS7afrfMd6OI=;
        b=NQdwRjBL++fJ6jckdEER3z4/7YO5ZRTOdKot1U284gEJrTl4J3JzC/4rYKvaF8B8Zg
         k+QWZWfqAlM7FerTXD+GglNnMYL91hOpXL+0qff/eY2rezbCDAcBirdNiMFu+pitso/b
         c/Or+Li/p7IJ9B31vuZvFeBD12J+QMmF0OASdrWYr1yrPAKiBITye8vu2W2gK4Wx5PDH
         EE6Z1ToAX2s9RwDZdnIsmypqZhjv7p2DnunAm5dEHRXfWKNZd84QLV2yio+HViYpgb1g
         R7RPXuXnzGE+PsgR7I7LNWn3DK9Hzl8y/kKVfqlVExmF0NMj1Ahowc4D47bEeacItIJL
         iD1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=RJ6dwC6KBBDkp7iURBtYOksb1lcUUgBCS7afrfMd6OI=;
        b=m54kVunhCB6f6nZIm0w6C/ucgMOOE6LDKpmVp1j7Bs/kdfQnHG6eaBdNm8IkOs2ZZ/
         7IZDwOxvmZgfCx9s8dujlIXEJiwAbPdlQEqs0O5pnyuqVEB6bveeDZUOVG0sSqRH0edx
         FgY7JHqZ2i0OVB9A34Mvin/agnxETaab2Zhou0O17WxxnmfkBPPEgsSbqE6AnqW1g5p7
         4OmGFK0azhl+51gTx3xMInpzDGXqvm01NMHvPEEWkVqNJNzbd/259MReNTf2MYJNlsTB
         HVA0citASfvHOYdraUhsQjWWvNq1Ti1vuAqNh9+l7M/OqQfgRSZ5m9P3Hiem3VhI6QDM
         Giig==
X-Gm-Message-State: APjAAAU8yt/QilJy5Y7zxYIneJ22uKSyw2jx2l32RKrhMED16V0Dr0i5
        UMDI45qX+2jdkSHcLNDrSbCCIg==
X-Google-Smtp-Source: APXvYqydeTNq8CkWJjRFFkzXoMrFKynJPDPMeTRB6h1P/fpCrYFEc7lWmfdomgzqcLBy4v86Kpe7aQ==
X-Received: by 2002:a37:ac19:: with SMTP id e25mr9496413qkm.155.1565200871163;
        Wed, 07 Aug 2019 11:01:11 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z18sm41552281qka.12.2019.08.07.11.01.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 11:01:11 -0700 (PDT)
Date:   Wed, 7 Aug 2019 11:00:42 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        oss-drivers@netronome.com
Subject: Re: [PATCH net v2] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
Message-ID: <20190807110042.690cf50a@cakuba.netronome.com>
In-Reply-To: <CA+FuTScYkHho4hqrGf9q6=4iao-f2P2s258rjtQTCgn+nF-CYg@mail.gmail.com>
References: <20190807060612.19397-1-jakub.kicinski@netronome.com>
        <CA+FuTScYkHho4hqrGf9q6=4iao-f2P2s258rjtQTCgn+nF-CYg@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Aug 2019 12:59:00 -0400, Willem de Bruijn wrote:
> On Wed, Aug 7, 2019 at 2:06 AM Jakub Kicinski wrote:
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index d57b0cc995a0..0f9619b0892f 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -1992,6 +1992,20 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
> >  }
> >  EXPORT_SYMBOL(skb_set_owner_w);
> >
> > +static bool can_skb_orphan_partial(const struct sk_buff *skb)
> > +{
> > +#ifdef CONFIG_TLS_DEVICE
> > +       /* Drivers depend on in-order delivery for crypto offload,
> > +        * partial orphan breaks out-of-order-OK logic.
> > +        */
> > +       if (skb->decrypted)
> > +               return false;
> > +#endif
> > +       return (IS_ENABLED(CONFIG_INET) &&
> > +               skb->destructor == tcp_wfree) ||  
> 
> Please add parentheses around IS_ENABLED(CONFIG_INET) &&
> skb->destructor == tcp_wfree

Mm.. there are parenthesis around them, maybe I'm being slow, 
could you show me how?

> I was also surprised that this works when tcp_wfree is not defined if
> !CONFIG_INET. But apparently it does (at -O2?) :)

I was surprised to but in essence it should work the same as

	if (IS_ENABLED(CONFIG_xyz))
		call_some_xyz_code();

from compiler's perspective, and we do that a lot. Perhaps kbuild 
bot will prove us wrong :)

> > @@ -984,6 +984,9 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
> >                         if (!skb)
> >                                 goto wait_for_memory;
> >
> > +#ifdef CONFIG_TLS_DEVICE
> > +                       skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
> > +#endif  
> 
> Nothing is stopping userspace from passing this new flag. In send
> (tcp_sendmsg_locked) it is ignored. But can it reach do_tcp_sendpages
> through tcp_bpf_sendmsg?

Ah, I think you're right, thanks for checking that :( I don't entirely
follow how 0608c69c9a80 ("bpf: sk_msg, sock{map|hash} redirect through
ULP") is safe then.

One option would be to clear the flags kernel would previously ignore
in tcp_bpf_sendmsg(). But I feel like we should just go back to marking
the socket, since we don't need the per-message flexibility of a flag.

WDYT?

> >                         skb_entail(sk, skb);
> >                         copy = size_goal;
> >                 }
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index 6e4afc48d7bb..979520e46e33 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -1320,6 +1320,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
> >         buff = sk_stream_alloc_skb(sk, nsize, gfp, true);
> >         if (!buff)
> >                 return -ENOMEM; /* We'll just try again later. */
> > +       skb_copy_decrypted(buff, skb);  
> 
> This code has to copy timestamps, tx_flags, zerocopy state and now
> this in three locations. Eventually we'll want a single helper for all
> of them..

Ack, should I take an action on that for net-next or was it a
note-to-self? :)
