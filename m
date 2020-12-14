Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CAC2DA21D
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503459AbgLNUzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:55:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388497AbgLNUzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 15:55:12 -0500
Date:   Mon, 14 Dec 2020 12:54:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607979272;
        bh=7302eTcszU62RCeSdlxhPQ0or7Xgr6aOyJEVaZIAlbM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=JBWK8n0ZBUlXsy0u2YFLwXo0DFoJPpMY4l+bMW/TbBgjmGPWoQOk4rqPon5WBvg3N
         ZvomlYvZBhOhx8a5ZBqsaWKp/mpGKsw5NFCCid11VAnzjntidCRRZyilaXyIF3rQkF
         5gt1gd1F8WWwL12XZliq0J/2pFFJ20S3BR+vSDXO0nFnui+Vfh+EMaeMx83GCcZhPZ
         V4Hd6HhPInSQgjUHC6OuHRd9LCqtiW7BUfymH/0dDUH3CLVGlqUkg+ttEaCz6hghpX
         z/oJErrOXmmpThOE6J32WE1Mh5Y3vRqHXlaawGwsFieUDlXtCMG8B5gciUnYM0rsnU
         1lAmWRuztj6ig==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: check skb partial checksum offset after trim
Message-ID: <20201214125430.244c9359@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAF=yD-JqVEQTKzTdO1BaR_2w6u2eyc6FvtghFb9bp3xYODHnqg@mail.gmail.com>
References: <7080e8a3-6eaa-e9e1-afd8-b1eef38d1e89@virtuozzo.com>
        <1f8e9b9f-b319-9c03-d139-db57e30ce14f@virtuozzo.com>
        <3749313e-a0dc-5d8a-ad0f-b86c389c0ba4@virtuozzo.com>
        <CA+FuTScG1iW6nBLxNSLrTXfxxg66-PTu3_5GpKdM+h2HjjY6KA@mail.gmail.com>
        <98675d3c-62fb-e175-60d6-c1c9964af295@virtuozzo.com>
        <CAF=yD-JqVEQTKzTdO1BaR_2w6u2eyc6FvtghFb9bp3xYODHnqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 13 Dec 2020 20:59:54 -0500 Willem de Bruijn wrote:
> On Sun, Dec 13, 2020 at 2:37 PM Vasily Averin <vvs@virtuozzo.com> wrote:
> > >> On 12/11/20 6:37 PM, Vasily Averin wrote:  
> > >>> It seems for me the similar problem can happen in __skb_trim_rcsum().
> > >>> Also I doubt that that skb_checksum_start_offset(skb) checks in
> > >>> __skb_postpull_rcsum() and skb_csum_unnecessary() are correct,
> > >>> becasue they do not guarantee that skb have correct CHECKSUM_PARTIAL.
> > >>> Could somebody confirm it?  
> > >>
> > >> I've rechecked the code and I think now that other places are not affected,
> > >> i.e. skb_push_rcsum() only should be patched.  
> > >
> > > Thanks for investigating this. So tun was able to insert a packet with
> > > csum_start + csum_off + 2 beyond the packet after trimming, using
> > > virtio_net_hdr.csum_...
> > >
> > > Any packet with an offset beyond the end of the packet is bogus
> > > really. No need to try to accept it by downgrading to CHECKSUM_NONE.  
> >
> > Do you mean it's better to force pskb_trim_rcsum() to return -EINVAL instead?  
> 
> I would prefer to have more strict input validation in
> tun/virtio/packet (virtio_net_hdr_to_skb), rather than new checks in
> the hot path. But that is a larger change and not feasible
> unconditionally due to performance impact and likely some false
> positive drops. So out of scope here.

Could you please elaborate? Is it the case that syzbot constructed some
extremely convoluted frame to trigger this? Otherwise the validation
at the source would work as well, no?

Does it actually trigger upstream? The linked syzbot report is for 4.14
but from the commit description it sounds like the problem should repro
rather reliably.

> Instead of adding a workaround in the not path, I thought about
> converting the two checks in skb_checksum_help
> 
>   BUG_ON(offset >= skb_headlen(skb));
>   BUG_ON(offset + sizeof(__sum16) > skb_headlen(skb));
> 
> to normal error paths and return EINVAL. But most callers, including
> this one (checksum_tg), don't check the return value to drop the
> packet.
> 
> Given that, your approach sounds the most reasonable. I would still
> drop these packets, as they are clearly bad and the only source of
> badness we know is untrusted user input.
> 
> In that case, perhaps the test can move into pskb_trim_rcsum_slow,
> below the CHECKSUM_COMPLETE branch.

