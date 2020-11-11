Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA01A2AF64A
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 17:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgKKQ1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 11:27:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgKKQ1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 11:27:00 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5385C20678;
        Wed, 11 Nov 2020 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605112019;
        bh=7+NJyL0GEgT4MSWcGvhvoBwfgx+wSr915jXUEQ7+QTQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bp3YMwRsfMHkL7gpAfC8e2Ic1iP2DKVRla+xYnINt2N2Xom8PtNSGxfLi5L3iEZCt
         jtjFui5izrHm6eW7DJAScvWOUYdjMPFfg0Mzg0JC6oWyN90AzvsWvFUPlAFK4XvtGT
         0qzwY0y47q7Flij5kk9IBKSQ0QH0V6SglLG1MBa4=
Date:   Wed, 11 Nov 2020 08:26:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <20201111082658.4cd3bb1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <zlsylwLJr9o9nP9fcmUnMBxSNs5tLc6rw2181IgE@cp7-web-041.plabs.ch>
References: <bEm19mEHLokLGc5HrEiEKEUgpZfmDYPoFtoLAAEnIUE@cp3-web-033.plabs.ch>
        <CA+FuTScriNKLu=q+xmBGjtBB06SbErZK26M+FPiJBRN-c8gVLw@mail.gmail.com>
        <zlsylwLJr9o9nP9fcmUnMBxSNs5tLc6rw2181IgE@cp7-web-041.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 11:29:06 +0000 Alexander Lobakin wrote:
> >>> +     sk = static_branch_unlikely(&udp_encap_needed_key) ?
> >>> +          udp4_gro_lookup_skb(skb, uh->source, uh->dest) :
> >>> +          NULL;  
> >
> > Does this indentation pass checkpatch?  
> 
> Sure, I always check my changes with checkpatch --strict.
> 
> > Else, the line limit is no longer strict,a and this only shortens the
> > line, so a single line is fine.  
> 
> These single lines is about 120 chars, don't find them eye-pleasant.
> But, as with "u32" above, they're pure cosmetics and can be changed.

let me chime in on the perhaps least important aspect of the patch :)

Is there are reason to use a ternary operator here at all?
Isn't this cleaner when written with an if statement?

	sk = NULL;
	if (static_branch_unlikely(&udp_encap_needed_key))
		sk = udp4_gro_lookup_skb(skb, uh->source, uh->dest);
