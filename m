Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109283E2B0E
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 15:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343904AbhHFNAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 09:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343900AbhHFNAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 09:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20F2B611C6;
        Fri,  6 Aug 2021 13:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628254800;
        bh=ZQUudtF0X8VZucm2a0aCFIgc5GwN+06NNws+XZzlUVU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oek7skYNw8UyDiUGhbWoUu/PzYo+hJVlX9slHl/ifM32RWJBI+Qa3u24OUGw39KK/
         /ZN8MV52NPuGJClVx4NtNGpZsOXHe30P6xd75Ry1oORKQ6mOiALHJer4Oq0u4nCX5X
         YUSLbBY3E8cgV7NcWOCvrwK9WHqmcCS7+wL5Fuaft0UsLTVJsGzHZ2VeZiKxfXa/im
         P9EfnC6xe1o6f+IPyV4muCVNBcg1VtDCWDDOCR32i/neqC9dh1x/qq2p1uqsUlCfJs
         n+pt99PA6CEyyhu4LLNqI2rq9SnP6m32k7CSwpZnZfqRn0cZPTJBgTiFvhiC2Gajb8
         0C8sq3QTogeJA==
Date:   Fri, 6 Aug 2021 05:59:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] net: ipa: don't suspend/resume modem if
 not up
Message-ID: <20210806055959.51245c90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9aedc291-c424-9a9b-eac2-052d404ba0ad@linaro.org>
References: <20210804153626.1549001-1-elder@linaro.org>
        <20210804153626.1549001-2-elder@linaro.org>
        <20210805182628.02ebf355@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9aedc291-c424-9a9b-eac2-052d404ba0ad@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Aug 2021 06:39:46 -0500 Alex Elder wrote:
> On 8/5/21 8:26 PM, Jakub Kicinski wrote:
> > On Wed,  4 Aug 2021 10:36:21 -0500 Alex Elder wrote:  
> >> The modem network device is set up by ipa_modem_start().  But its
> >> TX queue is not actually started and endpoints enabled until it is
> >> opened.
> >>
> >> So avoid stopping the modem network device TX queue and disabling
> >> endpoints on suspend or stop unless the netdev is marked UP.  And
> >> skip attempting to resume unless it is UP.
> >>
> >> Signed-off-by: Alex Elder <elder@linaro.org>  
> > 
> > You said in the cover letter that in practice this fix doesn't matter.  
> 
> I don't think we've seen this problem with system suspend, but
> with runtime suspend we could get a forced suspend request at
> any time (and frequently), so if there is a problem, it will be
> much more likely to occur.
> 
> For suspend, I don't think it's actually a "problem".  Disabling
> the TX queue if it wasn't open is harmless--it just sets the
> DRV_XOFF bit in the TX queue state field.  And we have a
> separate "enabled endpoints" mask that prevents stopping or
> suspending the endpoint if it wasn't opened.
> 
> But for resume, waking the queue schedules it.  I'm not sure
> what exactly ensues in that case, but it's not correct if the
> network device hasn't been opened.  For endpoints, again, they
> won't be resumed if they weren't enabled, so that part's OK.
> 
> > It seems trivial to test so perhaps it doesn't and we should leave the
> > code be? Looking at dev->flags without holding rtnl_lock() seems
> > suspicious, drivers commonly put the relevant portion of suspend/resume
> > routines under rtnl_lock()/rtnl_unlock() (although to be completely  
> 
> I don't use rtnl_lock()/rtnl_unlock() *anywhere* in the driver.
> It has no netlink interface (yet), and therefore I didn't even
> think about using rtnl_lock().  Do I need it?

Runtime PM interactions with rtnl_lock get really tricky, if there are
callers which will wake the device up while holding rtnl then taking
rtnl in .resume will cause an obvious deadlock, right?

I'm starting to feel like driver's RPM-related code has to be under it's
own lock, and interrogating higher layer's (e.g. network stack's) state
from RPM code should be avoided...

Long story short I don't think we have a good handle on this, 
I certainly don't so maybe let's leave your code be, for now.

> > frank IDK if it's actually possible for concurrent suspend +
> > open/close to happen).  
> 
> I think it isn't possible, but I'm less than 100% sure.  I've
> been thinking a lot about exactly this sort of question lately...
> 
> > Are there any callers of ipa_modem_stop() which don't hold rtnl_lock()?  
> 
> None of them take that lock.  It is called in the driver ->remove
> callback, and is called during cleanup if the modem crashes.
> 
> I think this fix is good, but as I said in the cover letter I'm
> not aware of ever having hit it to date.
> 
> Thank you very much for your review and comments.
