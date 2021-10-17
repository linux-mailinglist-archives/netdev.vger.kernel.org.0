Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1420F430C8A
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344747AbhJQWGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:06:34 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53358 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344746AbhJQWGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:06:34 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E352A605E1;
        Mon, 18 Oct 2021 00:02:41 +0200 (CEST)
Date:   Mon, 18 Oct 2021 00:04:19 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH netfilter] netfilter: conntrack: udp: generate event on
 switch to stream timeout
Message-ID: <YWyd44P+ey9VXvRn@salvia>
References: <20211015090934.2870662-1-zenczykowski@gmail.com>
 <YWlKGFpHa5o5jFgJ@salvia>
 <CANP3RGdCBzjWuK8FfHOOKcFAbd_Zru=DkOBBpD3d_PYDR91P5g@mail.gmail.com>
 <20211015095716.GH2942@breakpoint.cc>
 <CAHo-OoxsN5d+ipbp0TQ=a+o=ynd3-w5RZ3S3F8Vg89ipT5=UHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-OoxsN5d+ipbp0TQ=a+o=ynd3-w5RZ3S3F8Vg89ipT5=UHw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 03:15:07AM -0700, Maciej Żenczykowski wrote:
> On Fri, Oct 15, 2021 at 2:57 AM Florian Westphal <fw@strlen.de> wrote:
> > Maciej Żenczykowski <zenczykowski@gmail.com> wrote:
[...]
> A udp flow becoming bidirectional seems like an important event to
> notify about...
> Afterall, the UDP flow might become a stream 29 seconds after it
> becomes bidirectional...
> That seems like a pretty long time (and it's user configurable to be
> even longer) to delay the notification.
> 
> I imagine the pair of you know best whether 2 events or delay assured
> event until stream timeout is applied makes more sense...

This 2 events looks awkward to me, currently the model we have to
report events is:

- status bits are updated
- flow has changed protocol state (TCP).

but in this case, this is reporting a timer update. Timeout updates
are not reported on events, since this would trigger too many events
one per packet.

What's the concern with delaying the IPS_ASSURED bit?

By setting a lower timeout (30 second) my understanding is that this
flow is less important to those that are in the stream state (120s),
so these should also be candidate to be removed by early_drop. IIRC,
the idea behind the stream concept is to reduce lifetime of shortlived
UDP flows to release slots from the conntrack table earlier.
