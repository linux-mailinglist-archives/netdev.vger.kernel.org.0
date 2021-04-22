Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAE3367862
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhDVELu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:11:50 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:55487 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbhDVEKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:44 -0400
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
        (Authenticated sender: joe@ovn.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id A1CBB100010;
        Thu, 22 Apr 2021 04:10:08 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id k73so43492094ybf.3;
        Wed, 21 Apr 2021 21:10:08 -0700 (PDT)
X-Gm-Message-State: AOAM532ftW7g8pAEXVvM4YxTXJ8+FR7m/9uowpVCxmAsvGCJlMU5KEzE
        ndb6xLn3biujG5EGFI9h4fYAEhl4wOWh1+jyvVg=
X-Google-Smtp-Source: ABdhPJwXP5PsKga+gsABTn582f0ZNbO6oVx7Et/U+fU+xwoaHDnJQCv37IRLXdm5utZYVW+Jv5yr8Rj9twKfQz7/dUw=
X-Received: by 2002:a25:7612:: with SMTP id r18mr1939030ybc.172.1619064607436;
 Wed, 21 Apr 2021 21:10:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-127-gregkh@linuxfoundation.org> <20210422015957.4f6d4dfa@linux.microsoft.com>
In-Reply-To: <20210422015957.4f6d4dfa@linux.microsoft.com>
From:   Joe Stringer <joe@ovn.org>
Date:   Wed, 21 Apr 2021 21:09:56 -0700
X-Gmail-Original-Message-ID: <CAOftzPioU8h9b=isMPZtE8AYF=+qh_nNEp3rFEyQmb6Fi7QZ2g@mail.gmail.com>
Message-ID: <CAOftzPioU8h9b=isMPZtE8AYF=+qh_nNEp3rFEyQmb6Fi7QZ2g@mail.gmail.com>
Subject: Re: [PATCH 126/190] Revert "net: openvswitch: fix a NULL pointer dereference"
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 5:01 PM Matteo Croce <mcroce@linux.microsoft.com> wrote:
>
> On Wed, 21 Apr 2021 15:00:01 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> > This reverts commit 6f19893b644a9454d85e593b5e90914e7a72b7dd.
> >
> > Commits from @umn.edu addresses have been found to be submitted in
> > "bad faith" to try to test the kernel community's ability to review
> > "known malicious" changes.  The result of these submissions can be
> > found in a paper published at the 42nd IEEE Symposium on Security and
> > Privacy entitled, "Open Source Insecurity: Stealthily Introducing
> > Vulnerabilities via Hypocrite Commits" written by Qiushi Wu
> > (University of Minnesota) and Kangjie Lu (University of Minnesota).
> >
> > Because of this, all submissions from this group must be reverted from
> > the kernel tree and will need to be re-reviewed again to determine if
> > they actually are a valid fix.  Until that work is complete, remove
> > this change to ensure that no problems are being introduced into the
> > codebase.
> >
> > Cc: Kangjie Lu <kjlu@umn.edu>
> > Cc: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  net/openvswitch/datapath.c | 4 ----
> >  1 file changed, 4 deletions(-)
> >
> > diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> > index 9d6ef6cb9b26..99e63f4bbcaf 100644
> > --- a/net/openvswitch/datapath.c
> > +++ b/net/openvswitch/datapath.c
> > @@ -443,10 +443,6 @@ static int queue_userspace_packet(struct
> > datapath *dp, struct sk_buff *skb,
> >       upcall = genlmsg_put(user_skb, 0, 0, &dp_packet_genl_family,
> >                            0, upcall_info->cmd);
> > -     if (!upcall) {
> > -             err = -EINVAL;
> > -             goto out;
> > -     }
> >       upcall->dp_ifindex = dp_ifindex;
> >
> >       err = ovs_nla_put_key(key, key, OVS_PACKET_ATTR_KEY, false,
> > user_skb);
>
> This patch seems good to me, but given the situation I'd like another
> pair of eyes on it, at least.

The revert LGTM.

A few lines above:

        len = upcall_msg_size(upcall_info, hlen - cutlen,
                              OVS_CB(skb)->acts_origlen);
        user_skb = genlmsg_new(len, GFP_ATOMIC);
        if (!user_skb) {
                err = -ENOMEM;
                goto out;
        }

upcall_msg_size() calculates the expected size of the buffer,
including at the very least a nlmsg-aligned sizeof(struct ovs_header),
plus other constants and also potential (likely) variable lengths
based on the current flow context.

genlmsg_new() adds the (nlmsg-aligned) nlmsg header length to the
calculated length when allocating the buffer, and if the memory
allocation fails here then the error is already returned.

I don't then see a way for genlmsg_put() to fail per the hunk in the
commit here given that its buffer reservation is calculated based on:

        nlh = nlmsg_put(skb, portid, seq, family->id, GENL_HDRLEN +
                        family->hdrsize, flags);

Where family->hdrsize would be sizeof(struct ovs_header) since
dp_packet_genl_family is the family passed into the genlmsg_put()
call:

static struct genl_family dp_packet_genl_family __ro_after_init = {
        .hdrsize = sizeof(struct ovs_header),

Even if there were some allocation bug here to be fixed (due to
miscalculating the buffer size in the first place), I don't see how
the extra error path in the included patch could catch such an error.
The original patch doesn't seem necessarily problematic, but it
doesn't seem like it adds anything of value either (or at least,
nothing a comment couldn't clearly explain).

Cheers,
Joe
