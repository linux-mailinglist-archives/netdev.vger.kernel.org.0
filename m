Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C42B3CA87
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404103AbfFKL5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:57:08 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45091 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403877AbfFKL5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 07:57:08 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so14071085qtr.12;
        Tue, 11 Jun 2019 04:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K3Sm1X+d2sov0ITQpzgk6HQiz/Phckwgb6KD7DQ+q/M=;
        b=llBWdXc9ufcDn9VTjjDJIRoBqsPwIk2ZRp4tiC8CFA0r1N37TwKz0DFg1VJnA/Ci0B
         AIASlCCnSBtNmD0vnnp9Uf8Qrb5Y+o4AF47XzKEutUSdM63zFJ6sKA5OrHss4YVf4a7h
         Nw2X8po5gj7XsvO8TKbQJpe2LYtumG6dLw3D+6pqpxNCu1gcqnOVUzav05Swgq7CY4Re
         Z259UXi3eEjCaQavakLv8mKadadS+rs9ZgYa0EqO1vuDjIYdtqAnoINY7gebx3jz3aZ0
         7YkqT3ewCiyMiJSLN4m7sKToA0XWtCHNIuLUXjRoQ9x+I5hAM2PiDxlWb/+cocDsy0RH
         xx8w==
X-Gm-Message-State: APjAAAXawBW/+8+mShtA6q+NBSM8MbBcuyfjJIKiCURNabPQtNI3GDpM
        f0hb4zwLS0EiIeGTBThBy0ITA0DQiPOsgsgs2PU=
X-Google-Smtp-Source: APXvYqwirPrDDDsMco7I6kepiNjDwf87AqZbyPYaRT4gsoLYAygjHsKyh9v3e1zX7J05MHnONK4y+Dh0Ic32yh7e2fg=
X-Received: by 2002:ac8:2dae:: with SMTP id p43mr45188807qta.304.1560254226737;
 Tue, 11 Jun 2019 04:57:06 -0700 (PDT)
MIME-Version: 1.0
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org> <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
In-Reply-To: <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 11 Jun 2019 13:56:49 +0200
Message-ID: <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        Dan Williams <dcbw@redhat.com>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        syadagir@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 10:12 AM Johannes Berg
<johannes@sipsolutions.net> wrote:

> > As I've made clear before, my work on this has been focused on the IPA transport,
> > and some of this higher-level LTE architecture is new to me.  But it
> > seems pretty clear that an abstracted WWAN subsystem is a good plan,
> > because these devices represent a superset of what a "normal" netdev
> > implements.
>
> I'm not sure I'd actually call it a superset. By themselves, these
> netdevs are actually completely useless to the network stack, AFAICT.
> Therefore, the overlap with netdevs you can really use with the network
> stack is pretty small?

I think Alex meant the concept of having a type of netdev with a generic
user space interface for wwan and similar to a wlan device, as I understood
you had suggested as well, as opposed to a stacked device as in
rmnet or those drivers it seems to be modeled after (vlan, ip tunnel, ...)/.

> > HOWEVER I disagree with your suggestion that the IPA code should
> > not be committed until after that is all sorted out.  In part it's
> > for selfish reasons, but I think there are legitimate reasons to
> > commit IPA now *knowing* that it will need to be adapted to fit
> > into the generic model that gets defined and developed.  Here
> > are some reasons why.
>
> I can't really argue with those, though I would point out that the
> converse also holds - if we commit to this now, then we will have to
> actually keep the API offered by IPA/rmnet today, so we cannot actually
> remove the netdev again, even if we do migrate it to offer support for a
> WWAN framework in the future.

Right. The interface to support rmnet might be simple enough to keep
next to what becomes the generic interface, but it will always continue
to be an annoyance.

> > Second, the IPA code has been out for review recently, and has been
> > the subject of some detailed discussion in the past few weeks.  Arnd
> > especially has invested considerable time in review and discussion.
> > Delaying things until after a better generic model is settled on
> > (which I'm guessing might be on the order of months)
>
>
> I dunno if it really has to be months. I think we can cobble something
> together relatively quickly that addresses the needs of IPA more
> specifically, and then extend later?
>
> But OTOH it may make sense to take a more paced approach and think
> about the details more carefully than we have over in the other thread so far.

I would hope that as soon as we can agree on a general approach, it
would also be possible to merge a minimal implementation into the kernel
along with IPA. Alex already mentioned that IPA in its current state does
not actually support more than one data channel, so the necessary
setup for it becomes even simpler.

At the moment, the rmnet configuration in include/uapi/linux/if_link.h
is almost trivial, with the three pieces of information needed being
an IFLA_LINK to point to the real device (not needed if there is only
one device per channel, instead of two), the IFLA_RMNET_MUX_ID
setting the ID of the muxing channel (not needed if there is only
one channel ?), a way to specify software bridging between channels
(not useful if there is only one channel) and a few flags that I assume
must match the remote end:

#define RMNET_FLAGS_INGRESS_DEAGGREGATION         (1U << 0)
#define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
#define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
#define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
enum {
        IFLA_RMNET_UNSPEC,
        IFLA_RMNET_MUX_ID,
        IFLA_RMNET_FLAGS,
        __IFLA_RMNET_MAX,
};
#define IFLA_RMNET_MAX  (__IFLA_RMNET_MAX - 1)
struct ifla_rmnet_flags {
        __u32   flags;
        __u32   mask;
};

> > Third, having the code upstream actually means the actual requirements
> > for rmnet-over-IPA are clear and explicit.  This might not be a huge
> > deal, but I think it's better to devise a generic WWAN scheme that
> > can refer to actual code than to do so with assumptions about what
> > will work with rmnet (and others).  As far as I know, the upstream
> > rmnet has no other upstream back end; IPA will make it "real."
>
> Is that really true? I had previously been told that rmnet actually does
> have use with a few existing drivers.
>
>
> If true though, then I think this would be the killer argument *in
> favour* of *not* merging this - because that would mean we *don't* have
> to actually keep the rmnet API around for all foreseeable future.

I would agree with that. From the code I can see no other driver
including the rmnet protocol header (see the discussion about moving
the header to include/linux in order to merge ipa), and I don't see
any other driver referencing ETH_P_MAP either. My understanding
is that any driver used by rmnet would require both, but they are
all out-of-tree at the moment.

        Arnd
