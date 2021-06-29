Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79D13B7766
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 19:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhF2Rv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 13:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhF2Rv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 13:51:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6F4861DC8;
        Tue, 29 Jun 2021 17:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624988971;
        bh=qeivbnpYYv2NfIGODb0jY2+d5rdKnmM3+1jdUWCjvyg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cQa1yq6v8BCpUXxpBsad9tIIQqzWtgOt31UAsc5pTCF1X18AgCyoAj64JyXBOQR4z
         eKo/Wp0e7yHCrSZCobrTpf5F3Y3cpTeja9Jro2BjhVTA84OeKu3K5+vfZaRaZ1gFZg
         BnN54xj1Tgk5C6vRH5vAk9gLDLEn4jlW+Xarw81Q=
Date:   Tue, 29 Jun 2021 19:49:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Davis <davikovs@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Posible memory corruption from "mac80211: do not accept/forward
 invalid EAPOL frames"
Message-ID: <YNtdKb+2j02fxfJl@kroah.com>
References: <CAHQn7pKcyC_jYmGyTcPCdk9xxATwW5QPNph=bsZV8d-HPwNsyA@mail.gmail.com>
 <a7f11cc2-7bef-4727-91b7-b51da218d2ee@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7f11cc2-7bef-4727-91b7-b51da218d2ee@nbd.name>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 07:26:03PM +0200, Felix Fietkau wrote:
> 
> Hi,
> 
> On 2021-06-29 06:48, Davis wrote:
> > Greetings!
> > 
> > Could it be possible that
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.12.13&id=a8c4d76a8dd4fb9666fc8919a703d85fb8f44ed8
> > or at least its backport to 4.4 has the potential for memory
> > corruption due to incorrect pointer calculation?
> > Shouldn't the line:
> >   struct ethhdr *ehdr = (void *)skb_mac_header(skb);
> > be:
> >   struct ethhdr *ehdr = (struct ethhdr *) skb->data;
> > 
> > Later ehdr->h_dest is referenced, read and (when not equal to expected
> > value) written:
> >   if (unlikely(skb->protocol == sdata->control_port_protocol &&
> >       !ether_addr_equal(ehdr->h_dest, sdata->vif.addr)))
> >     ether_addr_copy(ehdr->h_dest, sdata->vif.addr);
> > 
> > In my case after cherry-picking
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.4.273&id=e3d4030498c304d7c36bccc6acdedacf55402387
> > to 4.4 kernel of an ARM device occasional memory corruption was observed.
> > 
> > To investigate this issue logging was added - the pointer calculation
> > was expressed as:
> >   struct ethhdr *ehdr = (void *)skb_mac_header(skb);
> >   struct ethhdr *ehdr2 = (struct ethhdr *) skb->data;
> > and memory writing was replaced by logging:
> >   if (unlikely(skb->protocol == sdata->control_port_protocol &&
> >       (!ether_addr_equal(ehdr->h_dest, sdata->vif.addr) ||
> > !ether_addr_equal(ehdr2->h_dest, sdata->vif.addr))))
> >     printk(KERN_ERR "Matching1: %u, matching2: %u, addr1: %px, addr2:
> > %px", !ether_addr_equal(ehdr->h_dest, sdata->vif.addr),
> > !ether_addr_equal(ehdr2->h_dest, sdata->vif.addr), ehdr->h_dest,
> > ehdr2->h_dest);
> > 
> > During normal use of wifi (in residential environment) logging was
> > triggered several times, in all cases matching1 was 1 and matching2
> > was 0.
> > This makes me think that normal control frames were received and
> > correctly validated by !ether_addr_equal(ehdr2->h_dest,
> > sdata->vif.addr), however !ether_addr_equal(ehdr->h_dest,
> > sdata->vif.addr) was checking incorrect buffer and identified the
> > frames as malformed/correctable.
> > This also explains memory corruption - offset difference between both
> > buffers (addr1 and addr2) was close to 64 KB in all cases, virtually
> > always a random memory location (around 64 KB away from the correct
> > buffer) will belong to something else, will have a value that differs
> > from the expected MAC address and will get overwritten by the
> > cherry-picked code.
> It seems that the 4.4 backport is broken. The problem is the fact that
> skb_mac_header is called before eth_type_trans(). This means that the
> mac header offset still has the default value of (u16)-1, resulting in
> the 64 KB memory offset that you observed.
> 
> I think that for 4.4, the code should be changed to use skb->data
> instead of skb_mac_header. 4.9 looks broken in the same way.
> 5.4 seems fine, so newer kernels should be fine as well.

Thanks for looking into this, can you submit a patch to fix this up in
the older kernel trees?

thanks,

greg k-h
