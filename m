Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1857210090E
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 17:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKRQUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 11:20:01 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:34777 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfKRQUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 11:20:01 -0500
X-Originating-IP: 75.54.222.30
Received: from ovn.org (75-54-222-30.lightspeed.rdcyca.sbcglobal.net [75.54.222.30])
        (Authenticated sender: blp@ovn.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id B28741C0005;
        Mon, 18 Nov 2019 16:19:56 +0000 (UTC)
Date:   Mon, 18 Nov 2019 08:19:51 -0800
From:   Ben Pfaff <blp@ovn.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Simon Horman <simon.horman@netronome.com>, dev@openvswitch.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bindiya Kurle <bindiyakurle@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ovs-dev] [PATCH net-next] openvswitch: add TTL decrement action
Message-ID: <20191118161951.GF3988@ovn.org>
References: <20191112102518.4406-1-mcroce@redhat.com>
 <20191112150046.2aehmeoq7ri6duwo@netronome.com>
 <CAGnkfhyt7wV-qDODQL1DtDoW0anoehVX7zoVk8y_C4WB0tMuUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhyt7wV-qDODQL1DtDoW0anoehVX7zoVk8y_C4WB0tMuUw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 04:46:12PM +0100, Matteo Croce wrote:
> On Tue, Nov 12, 2019 at 4:00 PM Simon Horman <simon.horman@netronome.com> wrote:
> >
> > On Tue, Nov 12, 2019 at 11:25:18AM +0100, Matteo Croce wrote:
> > > New action to decrement TTL instead of setting it to a fixed value.
> > > This action will decrement the TTL and, in case of expired TTL, send the
> > > packet to userspace via output_userspace() to take care of it.
> > >
> > > Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectively.
> > >
> >
> > Usually OVS achieves this behaviour by matching on the TTL and
> > setting it to the desired value, pre-calculated as TTL -1.
> > With that in mind could you explain the motivation for this
> > change?
> >
> 
> Hi,
> 
> the problem is that OVS creates a flow for each ttl it see. I can let
> vswitchd create 255 flows with like this:
> 
> $ for i in {2..255}; do ping 192.168.0.2 -t $i -c1 -w1 &>/dev/null & done
> $ ovs-dpctl dump-flows |fgrep -c 'set(ipv4(ttl'
> 255

Sure, you can easily invent a situation.  In real traffic there's not
usually such a variety of TTLs for a flow that matches on the number of
fields that OVS usually needs to match.  Do you see a real problem given
actual traffic in practice?
