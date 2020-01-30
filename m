Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6241014D8C6
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 11:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgA3KQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 05:16:20 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:53022 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbgA3KQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 05:16:20 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D30D520533;
        Thu, 30 Jan 2020 11:16:18 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ir1fhvgRdyYd; Thu, 30 Jan 2020 11:16:18 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6422220322;
        Thu, 30 Jan 2020 11:16:18 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 30 Jan 2020
 11:16:18 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 149D33180220;
 Thu, 30 Jan 2020 11:16:18 +0100 (CET)
Date:   Thu, 30 Jan 2020 11:16:18 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: [RFC] net: add gro frag support to udp tunnel api
Message-ID: <20200130101617.GJ27973@gauss3.secunet.de>
References: <20200127152411.15914-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200127152411.15914-1-Jason@zx2c4.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

On Mon, Jan 27, 2020 at 04:24:11PM +0100, Jason A. Donenfeld wrote:
> Hi Steffen,
> 
> This is very much a "RFC", in that the code here is fodder for
> discussion more than something I'm seriously proposing at the moment.
> I'm writing to you specifically because I recall us having discussed
> something like this a while ago and you being interested.
> 
> WireGuard would benefit from getting lists of SKBs all together in a
> bunch on the receive side. At the moment, encap_rcv splits them apart
> one by one before giving them to the API. This patch proposes a way to
> opt-in to receiving them before they've been split. The solution
> involves adding an encap_type flag that enables calling the encap_rcv
> function earlier before the skbs have been split apart.
> 
> I worry that it's not this straight forward, however, because of this
> function below called, "udp_unexpected_gso". It looks like there's a
> fast path for the case when it doesn't need to be split apart, and that
> if it is already split apart, that's expected, whereas splitting it
> apart would be "unexpected." I'm not too familiar with this code. Do you
> know off hand why this would be unexpected? And does that imply that a
> proper implementation of this might be a bit more involved? Or is the
> naming just silly and this actually is _the_ path where this happens?
> 
> The other thing I'm wondering with regards to this is how you even hit
> this path. So far I've only been able to hit it with the out of tree
> Qualcom driver, "rmnet_perf". I saw a mailing list discussion a few
> years ago about adding some flags to be able to simulate this with veth,
> but I didn't see that go anywhere. Figuring out how I can test this is
> probably a good idea before proceeding further.
> 
> Finally, and most importantly, is this overlapping with something you're
> working on at the moment? Where do you stand with this? Did you wind up
> solving your own use cases in a different way, or are you sitting on a
> more proper version of this RFC or something else?

I have a patch to enable GRO for ESP in UDP encapsulation.
The patch is not that well tested so far, so I hold it back
for now. But I think it won't overlap with enabling fraglist
GRO for encap sockets. I have not thought about enabling
fraglist GRO for encap sockets, but a flag to signal this
could be a way to go.

Other that that I plan to enable UDP GRO by default
once we are sure that this won't add a regression.
