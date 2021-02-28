Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F3832744C
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 21:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbhB1UCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 15:02:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231397AbhB1UCu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 15:02:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49E9064E31;
        Sun, 28 Feb 2021 20:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614542529;
        bh=jxgBkADyboKNrCMtHiteGyeJj2eyK5PhsKvy3XetYEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZidvcWXyOzPRQ1d8ZXsHOvpYPmH3m4NZdnPW7Lr8GlQTYmCila/eclmX/pxX4c+Dc
         n2lzIIN39Rvl6is5wDidM220vDCdkT+YqjsWrrM0w1+yDVahM6mnvAIKgB90p+KYhj
         c4tF4CPGNu+1JkS/N58xPHw7Pi07wQRXXGWj7OX8bsWnxgsDfCk7ZD0fq8/ERIRPSc
         OFf/3ntfNlohgj/yKej7sgxjaol5C3+w9ehe3bdn+JTylPx4wea3LwA3e9ICvPLO3q
         8rTHLkCb/n4xT6dX/w9mI5oIcBQlATJOAJ/vwxhYdorZmdcVw8F7mX+n7a0/GEBz7V
         7EOAapyoT0S/g==
Date:   Sun, 28 Feb 2021 12:02:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [PATCH net] net: Fix gro aggregation for udp encaps with zero
 csum
Message-ID: <20210228120208.36bb503a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <603a7e767e1a8_25e5d20864@john-XPS-13-9370.notmuch>
References: <20210226212248.8300-1-daniel@iogearbox.net>
        <CA+FuTSdn3zbynYOvuhLxZ02mmcDoRWQ5vUmBCbAgxeTa2X33YQ@mail.gmail.com>
        <603a7e767e1a8_25e5d20864@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Feb 2021 09:16:38 -0800 John Fastabend wrote:
> Willem de Bruijn wrote:
> > On Fri, Feb 26, 2021 at 4:23 PM Daniel Borkmann <daniel@iogearbox.net> wrote:  
> > >
> > > We noticed a GRO issue for UDP-based encaps such as vxlan/geneve when the
> > > csum for the UDP header itself is 0. In that case, GRO aggregation does
> > > not take place on the phys dev, but instead is deferred to the vxlan/geneve
> > > driver (see trace below).
> > >
> > > The reason is essentially that GRO aggregation bails out in udp_gro_receive()
> > > for such case when drivers marked the skb with CHECKSUM_UNNECESSARY (ice, i40e,
> > > others) where for non-zero csums 2abb7cdc0dc8 ("udp: Add support for doing
> > > checksum unnecessary conversion") promotes those skbs to CHECKSUM_COMPLETE
> > > and napi context has csum_valid set. This is however not the case for zero
> > > UDP csum (here: csum_cnt is still 0 and csum_valid continues to be false).
> > >
> > > At the same time 57c67ff4bd92 ("udp: additional GRO support") added matches
> > > on !uh->check ^ !uh2->check as part to determine candidates for aggregation,
> > > so it certainly is expected to handle zero csums in udp_gro_receive(). The
> > > purpose of the check added via 662880f44203 ("net: Allow GRO to use and set
> > > levels of checksum unnecessary") seems to catch bad csum and stop aggregation
> > > right away.
> > >
> > > One way to fix aggregation in the zero case is to only perform the !csum_valid
> > > check in udp_gro_receive() if uh->check is infact non-zero.
> >
> > Acked-by: Willem de Bruijn <willemb@google.com>  
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Applied, thanks!
