Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4579B36C9BE
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 18:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbhD0Qtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 12:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237714AbhD0QtM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 12:49:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC65061027;
        Tue, 27 Apr 2021 16:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619542109;
        bh=Zf4nW1uoa9/CCo7LdD1TpEcDkI4hFISg6GkZnsY5BV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q67kPTJKUzb2HQWu6Y0JX9C1mdjLVFOnlVLflS1oENwLmIY/oon2kjdwvkKglhQVn
         LnH+tfnlWs5RzIZu2NmXQabFwB+C5cappjR5u2Fhm5080MDjZyYkkGoVmYeHl5ZNEa
         e2UdvjZoWmZhRkgeYilIwRvE6BdLxWNdfizlNxkc=
Date:   Tue, 27 Apr 2021 18:48:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joe Stringer <joe@ovn.org>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>, Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 126/190] Revert "net: openvswitch: fix a NULL pointer
 dereference"
Message-ID: <YIhAW9retWHN+D4i@kroah.com>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-127-gregkh@linuxfoundation.org>
 <20210422015957.4f6d4dfa@linux.microsoft.com>
 <CAOftzPioU8h9b=isMPZtE8AYF=+qh_nNEp3rFEyQmb6Fi7QZ2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOftzPioU8h9b=isMPZtE8AYF=+qh_nNEp3rFEyQmb6Fi7QZ2g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 09:09:56PM -0700, Joe Stringer wrote:
> On Wed, Apr 21, 2021 at 5:01 PM Matteo Croce <mcroce@linux.microsoft.com> wrote:
> >
> > On Wed, 21 Apr 2021 15:00:01 +0200
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > > This reverts commit 6f19893b644a9454d85e593b5e90914e7a72b7dd.
> > >
> > > Commits from @umn.edu addresses have been found to be submitted in
> > > "bad faith" to try to test the kernel community's ability to review
> > > "known malicious" changes.  The result of these submissions can be
> > > found in a paper published at the 42nd IEEE Symposium on Security and
> > > Privacy entitled, "Open Source Insecurity: Stealthily Introducing
> > > Vulnerabilities via Hypocrite Commits" written by Qiushi Wu
> > > (University of Minnesota) and Kangjie Lu (University of Minnesota).
> > >
> > > Because of this, all submissions from this group must be reverted from
> > > the kernel tree and will need to be re-reviewed again to determine if
> > > they actually are a valid fix.  Until that work is complete, remove
> > > this change to ensure that no problems are being introduced into the
> > > codebase.
> > >
> > > Cc: Kangjie Lu <kjlu@umn.edu>
> > > Cc: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  net/openvswitch/datapath.c | 4 ----
> > >  1 file changed, 4 deletions(-)
> > >
> > > diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> > > index 9d6ef6cb9b26..99e63f4bbcaf 100644
> > > --- a/net/openvswitch/datapath.c
> > > +++ b/net/openvswitch/datapath.c
> > > @@ -443,10 +443,6 @@ static int queue_userspace_packet(struct
> > > datapath *dp, struct sk_buff *skb,
> > >       upcall = genlmsg_put(user_skb, 0, 0, &dp_packet_genl_family,
> > >                            0, upcall_info->cmd);
> > > -     if (!upcall) {
> > > -             err = -EINVAL;
> > > -             goto out;
> > > -     }
> > >       upcall->dp_ifindex = dp_ifindex;
> > >
> > >       err = ovs_nla_put_key(key, key, OVS_PACKET_ATTR_KEY, false,
> > > user_skb);
> >
> > This patch seems good to me, but given the situation I'd like another
> > pair of eyes on it, at least.
> 
> The revert LGTM.
> 
> A few lines above:
> 
>         len = upcall_msg_size(upcall_info, hlen - cutlen,
>                               OVS_CB(skb)->acts_origlen);
>         user_skb = genlmsg_new(len, GFP_ATOMIC);
>         if (!user_skb) {
>                 err = -ENOMEM;
>                 goto out;
>         }
> 
> upcall_msg_size() calculates the expected size of the buffer,
> including at the very least a nlmsg-aligned sizeof(struct ovs_header),
> plus other constants and also potential (likely) variable lengths
> based on the current flow context.
> 
> genlmsg_new() adds the (nlmsg-aligned) nlmsg header length to the
> calculated length when allocating the buffer, and if the memory
> allocation fails here then the error is already returned.
> 
> I don't then see a way for genlmsg_put() to fail per the hunk in the
> commit here given that its buffer reservation is calculated based on:
> 
>         nlh = nlmsg_put(skb, portid, seq, family->id, GENL_HDRLEN +
>                         family->hdrsize, flags);
> 
> Where family->hdrsize would be sizeof(struct ovs_header) since
> dp_packet_genl_family is the family passed into the genlmsg_put()
> call:
> 
> static struct genl_family dp_packet_genl_family __ro_after_init = {
>         .hdrsize = sizeof(struct ovs_header),
> 
> Even if there were some allocation bug here to be fixed (due to
> miscalculating the buffer size in the first place), I don't see how
> the extra error path in the included patch could catch such an error.
> The original patch doesn't seem necessarily problematic, but it
> doesn't seem like it adds anything of value either (or at least,
> nothing a comment couldn't clearly explain).
> 
> Cheers,
> Joe

Many thanks for the review, now dropping this revert from my tree.

greg k-h
