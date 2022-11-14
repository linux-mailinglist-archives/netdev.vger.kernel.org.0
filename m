Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED92627592
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 06:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbiKNFiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 00:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiKNFiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 00:38:03 -0500
Received: from smtp1.cs.Stanford.EDU (smtp1.cs.stanford.edu [171.64.64.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411FD15FCE
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 21:38:03 -0800 (PST)
Received: from mail-ed1-f51.google.com ([209.85.208.51]:40692)
        by smtp1.cs.Stanford.EDU with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1ouSAT-0000T9-Vr
        for netdev@vger.kernel.org; Sun, 13 Nov 2022 21:38:02 -0800
Received: by mail-ed1-f51.google.com with SMTP id e13so6741425edj.7
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 21:38:01 -0800 (PST)
X-Gm-Message-State: ANoB5plLYPbtbucrxeW5yGeeKwCcskWQHweMcsGbRmPT7soZzrNsQDPS
        vXudkyRMy/ajnIQwOcFVptwBkNAPDFIg7qDHAQ4=
X-Google-Smtp-Source: AA0mqf7JmKSFDTsz0wNiKruQ6y5COlwyF7FMtbrtF0J6QjGNrI+jawNmcpIjIdfi60xrLLjd4TSn3eW29R9PHOHA/VE=
X-Received: by 2002:a05:6402:1ada:b0:461:beb2:76e with SMTP id
 ba26-20020a0564021ada00b00461beb2076emr9892792edb.5.1668404280959; Sun, 13
 Nov 2022 21:38:00 -0800 (PST)
MIME-Version: 1.0
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
 <20221110132540.44c9463c@hermes.local> <Y22IDLhefwvjRnGX@lunn.ch>
 <CAGXJAmw=NY17=6TnDh0oV9WTmNkQCe9Q9F3Z=uGjG9x5NKn7TQ@mail.gmail.com>
 <Y26huGkf50zPPCmf@lunn.ch> <Y29RBxW69CtiML6I@nanopsycho> <CAGXJAmzdr1dBZb4=TYscXtN66weRvsO6p74K-K3aa_7UJ=sEuQ@mail.gmail.com>
 <Y3ElDxZi6Hswga2D@lunn.ch> <CAGXJAmwfyU0rdrp0g6UU8ctLHUrq_sAKTSk2R4LWoOgMTfPEAA@mail.gmail.com>
 <Y3FVpQAWI7kTzfhf@lunn.ch>
In-Reply-To: <Y3FVpQAWI7kTzfhf@lunn.ch>
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Sun, 13 Nov 2022 21:37:24 -0800
X-Gmail-Original-Message-ID: <CAGXJAmxKM5a95uhBwbmm1Z427=bGyZhcCUopycLMTEfc4dHnew@mail.gmail.com>
Message-ID: <CAGXJAmxKM5a95uhBwbmm1Z427=bGyZhcCUopycLMTEfc4dHnew@mail.gmail.com>
Subject: Re: Upstream Homa?
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Scan-Signature: 506ee2a94cbf17163a55f02c75f10d0d
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 13, 2022 at 12:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Nov 13, 2022 at 12:10:22PM -0800, John Ousterhout wrote:
> > On Sun, Nov 13, 2022 at 9:10 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > Homa implements RPCs rather than streams like TCP or messages like
> > > > UDP. An RPC consists of a request message sent from client to server,
> > > > followed by a response message from server back to client. This requires
> > > > additional information in the API beyond what is provided in the arguments to
> > > > sendto and recvfrom. For example, when sending a request message, the
> > > > kernel returns an RPC identifier back to the application; when waiting for
> > > > a response, the application can specify that it wants to receive the reply for
> > > > a specific RPC identifier (or, it can specify that it will accept any
> > > > reply, or any
> > > > request, or both).
> > >
> > > This sounds like the ancillary data you can pass to sendmsg(). I've
> > > not checked the code, it might be the current plumbing is only into to
> > > the kernel, but i don't see why you cannot extend it to also allow
> > > data to be passed back to user space. If this is new functionality,
> > > maybe add a new flags argument to control it.
> > >
> > > recvmsg() also has ancillary data.
> >
> > Whoah! I'd never noticed the msg_control and msg_controllen fields before.
> > These may be sufficient to do everything Homa needs. Thanks for pointing
> > this out.
>
> Is zero copy also required? https://lwn.net/Articles/726917/ talks
> about this. But rather than doing the transmit complete notification
> via MSG_ERRORQUEUE, maybe you could make it part of the ancillary data
> for a later message? That could save you some system calls? Or is the
> latency low enough that the RPC reply acts an implicitly indication
> the transmit buffer can be recycled?
>
> If your aim is to offload Homa to the NIC, it seems like zero copy is
> something you want, so even if you are not implementing it now, you
> probably should consider what the uAPI looks like.

I know that zero copy is all the rage these days, but I've become somewhat of
a skeptic. We spent quite a bit of time in the RAMCloud project
implementing zero
copy (and we were using kernel-bypass NICs, which make it about as efficient as
possible); we found that it is very difficult to get a real performance benefit.
Managing the space so you know when you can reclaim it adds a lot of complexity
and overhead. My current thinking is that zero copy only makes sense when you
have really large blocks of data. I'm inclined to let others
experiment with zero-copy
for a while and see if they can achieve sustainable benefits over a
meaningful range
of operating conditions.

-John-
