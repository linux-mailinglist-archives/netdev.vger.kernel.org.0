Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA832E314
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfE2RWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:22:04 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40746 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfE2RWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 13:22:04 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hW2H0-0001IK-4N; Wed, 29 May 2019 19:21:58 +0200
Date:   Wed, 29 May 2019 19:21:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [net-next PATCH] net: rtnetlink: Enslave device before bringing
 it up
Message-ID: <20190529172158.GE31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        David Ahern <dsahern@gmail.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
References: <20190529135120.32241-1-phil@nwl.cc>
 <e684c23a-93cc-d424-e217-e6ac2a371029@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e684c23a-93cc-d424-e217-e6ac2a371029@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 09:41:07AM -0600, David Ahern wrote:
> On 5/29/19 7:51 AM, Phil Sutter wrote:
> > Unlike with bridges, one can't add an interface to a bond and set it up
> > at the same time:
> > 
> > | # ip link set dummy0 down
> > | # ip link set dummy0 master bond0 up
> > | Error: Device can not be enslaved while up.
> > 
> > Of all drivers with ndo_add_slave callback, bond and team decline if
> > IFF_UP flag is set, vrf cycles the interface (i.e., sets it down and
> > immediately up again) and the others just don't care.
> > 
> > Support the common notion of setting the interface up after enslaving it
> > by sorting the operations accordingly.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  net/core/rtnetlink.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> 
> I agree with the intent - enslave before up.
> 
> Not sure how likely this is, but it does break the case:
> ip li set dummy0 master bond0 down

That's right. I could allow for that by ordering the enslave and state
change dynamically, but doubt it's worth the effort. Instead of the
above I'd rather expect 'ip l s d0 nomaster down' to be a more common
use-case (which is not affected by my patch).

Thanks, Phil
