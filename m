Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B115C2B62C
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 15:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfE0NUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 09:20:21 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:49206 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfE0NUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 09:20:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hVFY1-0006cw-9c; Mon, 27 May 2019 15:20:17 +0200
Message-ID: <b59be15f1d0caa4eaa4476bbd8457afc44d57089.camel@sipsolutions.net>
Subject: cellular modem APIs - take 2
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Date:   Mon, 27 May 2019 15:20:16 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Sorry for the long delay in getting back to this. I'm meaning to write
some code soon also for this, to illustrate better, but I figured I'd
still get some thoughts out before I do that.

After more discussion (@Intel) and the previous thread(s), I've pretty
much come to the conclusion that we should have a small subsystem for
WWAN, rather than fudging everything like we previously did.

We can debate whether or not that should use 'real' netlink or generic
netlink - personally I know the latter better and I think it has some
real advantages like easier message parsing (it's automatic more or
less) including strict checking and automatic policy introspection (I
recently wrote the code for this and it's plugged into generic netlink
family, for other netlink families it needs more hand-written code). But
I could possibly be convinced of doing something else, and/or perhaps
building more infrastructure for 'real' netlink to realize those
benefits there as well.


In terms of what I APIs are needed, the kernel-driver side and userspace
side go pretty much hand in hand (the wwan subsystem just providing the
glue), so what I say below is pretty much both a method/function call
(kernel internal API) or a netlink message (userspace API).

1) I think a generic abstraction of WWAN device that is not a netdev
   is needed. Yes, on the one hand it's quite nice to be able to work on
   top of a given netdev, but it's also limiting because it requires the
   data flow to go through there, and packets that are tagged in some
   way be exchanged there.
   For VLANs this can be out-of-band (in a sense) with hw-accel, but for
   rmnet-style it's in-band, and that limits what we can do.

   Now, of course this doesn't mean there shouldn't be a netdev created
   by default in most cases, but it gives us a way to do additional
   things that we cannot do with *just* a netdev.

   From a driver POV though, it would register a new "wwan_device", and
   then get some generic callback to create a netdev on top, maybe by
   default from the subsystem or from the user.

2) Clearly, one needs to be able to create PDN netdevs, with the PDN
   given to the command. Here's another advantage: If these are created
   on top of another abstraction, not another netdev, they can have
   their own queues, multiqueue RX etc. much more easily.

   Also, things like the "if I have just a single channel, drop the mux
   headers" can then be entirely done in the driver, and the default
   netdev no longer has the possibility of muxed and IP frames on the
   same datapath.

   This also enables more things like handling checksum offload directly
   in the driver, which doesn't behave so well with VLANs I think.

   All of that will just be easier for 5G too, I believe, with
   acceleration being handled per PDN, multi-queue working without
   ndo_select_queue, etc.

   Quite possibly there might be some additional (vendor-dependent?)
   configuration for when such netdevs are created, but we need to
   figure out if that really needs to be at creation time, or just
   ethtool later or something like that. I guess it depends on how
   generic it needs to be.

3) Separately, we need to have an ability to create "generalized control
   channels". I'm thinking there would be a general command "create
   control channel" with a given type (e.g. ATCMD, RPC, MBIM, GNSS) plus
   a list of vendor-specific channels (e.g. for tracing).

   I'm unsure where this channel should really go - somehow it seems to
   me that for many (most?) of these registering them as a serial line
   would be most appropriate, but some, especially vendor-defined
   channels like tracing, would probably better use a transport that's
   higher bandwidth than, e.g. netdevs.

   One way I thought of doing this was to create an abstraction in the
   wwan framework that lets the driver use SKBs anyway (i.e. TX and RX
   on these channels using SKBs) and then translate them to some channel
   in the framework - that way, we can even select at runtime if we want
   a netdev (not really plugged into the network stack, ARPHDR_VOID?) or
   some other kind of transport. Building that would allow us to add
   transport types in the future too.

   I guess such a channel should also be created by default, if it's
   not already created by the driver in some out-of-band way anyway (and
   most likely it shouldn't be, but I guess drivers might have some
   entirely different communication channels for AT CMDs?)

4) There was a question about something like pure IP channels that
   belong to another PDN and apparently now separate netdevs might be
   used, but it seems to me that could just be a queue reserved on the
   regular netdevs and then when you say ("enable video streaming on
   wwan1 interface") that can do some magic to classify the video
   packets (DSCP?) to another hardware queue for better QoS.



Anyway, if all of this doesn't seem completely outlandish I'll try to
write some code to illustrate it (sooner, rather than later).

Thanks,
johannes

