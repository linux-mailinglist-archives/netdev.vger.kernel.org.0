Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB879450D96
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhKOR7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:59:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239213AbhKOR5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 12:57:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A949560EFD;
        Mon, 15 Nov 2021 17:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636997713;
        bh=0NjHxuHIkW9kbUNtb0aCFQzVtuAnT+nVw5xKABLEFZ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uYQ+aaknw8JsX4eud01c3O+L/PApY6aYDVqTDPty57nWBI10pOLmvUO0o2IHeeMi6
         ElvHQQBDhi0pHjAmFRxl4c941kIKWZUS5QD/mEDMhzK+k4zgR3rz/PET0I41UBBLw3
         sfRWwK5jS0lOu5xH76+rLWxKiPF4fcUxizbNIX+M83b7oTDmR9dXAljUBmacc9wrLt
         9/JFVqgFtL21FCvwTHhuQQPlIkPiKIt7t4/Vc8PwgIJqgAGwILYzTpqOdjLVx5r531
         z1CdOTX39v6dodDzto2cRMvel79Nip9VolrSrVfBavhP28cHCGUKEisIcNYLs02cah
         3GrcR3d2V+UVQ==
Date:   Mon, 15 Nov 2021 09:35:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, hawk@kernel.org,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Subject: Re: [RFC net-next] net: guard drivers against shared skbs
Message-ID: <20211115093512.63404c26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <88391a1a-b8e4-96ca-7d80-df5c6674796d@gmail.com>
References: <20211115163205.1116673-1-kuba@kernel.org>
        <88391a1a-b8e4-96ca-7d80-df5c6674796d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 08:56:10 -0800 Eric Dumazet wrote:
> On 11/15/21 8:32 AM, Jakub Kicinski wrote:
> > Commit d8873315065f ("net: add IFF_SKB_TX_SHARED flag to priv_flags")
> > introduced IFF_SKB_TX_SHARED to protect drivers which are not ready
> > for getting shared skbs from pktgen sending such frames.
> > 
> > Some drivers dutifully clear the flag but most don't, even though
> > they modify the skb or call skb helpers which expect private skbs.
> > 
> > syzbot has also discovered more sources of shared skbs than just
> > pktgen (e.g. llc).
> > 
> > I think defaulting to opt-in is doing more harm than good, those
> > who care about fast pktgen should inspect their drivers and opt-in.
> > It's far too risky to enable this flag in ether_setup().

> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 15ac064b5562..476a826bb4f0 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -3661,6 +3661,10 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
> >  	if (unlikely(!skb))
> >  		goto out_null;
> >  
> > +	if (unlikely(skb_shared(skb)) &&
> > +	    !(dev->priv_flags & IFF_TX_SKB_SHARING))
> > +		goto out_kfree_skb;  
> 
> So this will break llc, right ?

Likely. I haven't checked why LLC thinks it's a good idea to send
shared skbs, probably convenience.

> I am sad we are adding so much tests in fast path.

What's our general stance on shared skbs in the Tx path? If we think
that it's okay maybe it's time to turn the BUG_ON(shared_skb)s in pskb
functions into return -EINVALs?

The IFF_TX_SKB_SHARING flag is pretty toothless as it stands.
