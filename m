Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007EC3D17C
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405356AbfFKPyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:54:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405288AbfFKPyO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 11:54:14 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D9A48CB56;
        Tue, 11 Jun 2019 15:54:08 +0000 (UTC)
Received: from ovpn-112-53.rdu2.redhat.com (ovpn-112-53.rdu2.redhat.com [10.10.112.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEFE619C70;
        Tue, 11 Jun 2019 15:53:58 +0000 (UTC)
Message-ID: <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Dan Williams <dcbw@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        syadagir@codeaurora.org
Date:   Tue, 11 Jun 2019 10:53:57 -0500
In-Reply-To: <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
         <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
         <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 11 Jun 2019 15:54:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-11 at 13:56 +0200, Arnd Bergmann wrote:
> On Tue, Jun 11, 2019 at 10:12 AM Johannes Berg
> <johannes@sipsolutions.net> wrote:
> 
> > > As I've made clear before, my work on this has been focused on
> > > the IPA transport,
> > > and some of this higher-level LTE architecture is new to me.  But
> > > it
> > > seems pretty clear that an abstracted WWAN subsystem is a good
> > > plan,
> > > because these devices represent a superset of what a "normal"
> > > netdev
> > > implements.
> > 
> > I'm not sure I'd actually call it a superset. By themselves, these
> > netdevs are actually completely useless to the network stack,
> > AFAICT.
> > Therefore, the overlap with netdevs you can really use with the
> > network
> > stack is pretty small?
> 
> I think Alex meant the concept of having a type of netdev with a
> generic
> user space interface for wwan and similar to a wlan device, as I
> understood
> you had suggested as well, as opposed to a stacked device as in
> rmnet or those drivers it seems to be modeled after (vlan, ip tunnel,
> ...)/.
> 
> > > HOWEVER I disagree with your suggestion that the IPA code should
> > > not be committed until after that is all sorted out.  In part
> > > it's
> > > for selfish reasons, but I think there are legitimate reasons to
> > > commit IPA now *knowing* that it will need to be adapted to fit
> > > into the generic model that gets defined and developed.  Here
> > > are some reasons why.
> > 
> > I can't really argue with those, though I would point out that the
> > converse also holds - if we commit to this now, then we will have
> > to
> > actually keep the API offered by IPA/rmnet today, so we cannot
> > actually
> > remove the netdev again, even if we do migrate it to offer support
> > for a
> > WWAN framework in the future.
> 
> Right. The interface to support rmnet might be simple enough to keep
> next to what becomes the generic interface, but it will always
> continue
> to be an annoyance.
> 
> > > Second, the IPA code has been out for review recently, and has
> > > been
> > > the subject of some detailed discussion in the past few
> > > weeks.  Arnd
> > > especially has invested considerable time in review and
> > > discussion.
> > > Delaying things until after a better generic model is settled on
> > > (which I'm guessing might be on the order of months)
> > 
> > I dunno if it really has to be months. I think we can cobble
> > something
> > together relatively quickly that addresses the needs of IPA more
> > specifically, and then extend later?
> > 
> > But OTOH it may make sense to take a more paced approach and think
> > about the details more carefully than we have over in the other
> > thread so far.
> 
> I would hope that as soon as we can agree on a general approach, it
> would also be possible to merge a minimal implementation into the
> kernel
> along with IPA. Alex already mentioned that IPA in its current state
> does
> not actually support more than one data channel, so the necessary
> setup for it becomes even simpler.
> 
> At the moment, the rmnet configuration in
> include/uapi/linux/if_link.h
> is almost trivial, with the three pieces of information needed being
> an IFLA_LINK to point to the real device (not needed if there is only
> one device per channel, instead of two), the IFLA_RMNET_MUX_ID
> setting the ID of the muxing channel (not needed if there is only
> one channel ?), a way to specify software bridging between channels
> (not useful if there is only one channel) and a few flags that I
> assume
> must match the remote end:
> 
> #define RMNET_FLAGS_INGRESS_DEAGGREGATION         (1U << 0)
> #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
> #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
> #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
> enum {
>         IFLA_RMNET_UNSPEC,
>         IFLA_RMNET_MUX_ID,
>         IFLA_RMNET_FLAGS,
>         __IFLA_RMNET_MAX,
> };
> #define IFLA_RMNET_MAX  (__IFLA_RMNET_MAX - 1)
> struct ifla_rmnet_flags {
>         __u32   flags;
>         __u32   mask;
> };
> 
> > > Third, having the code upstream actually means the actual
> > > requirements
> > > for rmnet-over-IPA are clear and explicit.  This might not be a
> > > huge
> > > deal, but I think it's better to devise a generic WWAN scheme
> > > that
> > > can refer to actual code than to do so with assumptions about
> > > what
> > > will work with rmnet (and others).  As far as I know, the
> > > upstream
> > > rmnet has no other upstream back end; IPA will make it "real."
> > 
> > Is that really true? I had previously been told that rmnet actually
> > does
> > have use with a few existing drivers.
> > 
> > 
> > If true though, then I think this would be the killer argument *in
> > favour* of *not* merging this - because that would mean we *don't*
> > have
> > to actually keep the rmnet API around for all foreseeable future.
> 
> I would agree with that. From the code I can see no other driver
> including the rmnet protocol header (see the discussion about moving
> the header to include/linux in order to merge ipa), and I don't see
> any other driver referencing ETH_P_MAP either. My understanding
> is that any driver used by rmnet would require both, but they are
> all out-of-tree at the moment.

The general plan (and I believe Daniele Palmas was working on it) was
to eventually make qmi_wwan use rmnet rather than its internal sysfs-
based implementation. qmi_wwan and ipa are at essentially the same
level and both could utilize rmnet on top.

*That's* what I'd like to see. I don't want to see two different ways
to get QMAP packets to modem firmware from two different drivers that
really could use the same code.

Dan

