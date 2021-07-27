Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEF33D7567
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 14:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbhG0M4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 08:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232039AbhG0M4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 08:56:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A11DF608FB;
        Tue, 27 Jul 2021 12:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627390575;
        bh=kThALLVqBRLV7ik20Z89VlQJxb3y4aAAgY1LaiBL9zo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Es84RQPxAYEvM6pNLmFwZyHtMWo1zwpX8jxuh7IgLKzYCDewk/XewgRryXVk1RB3f
         JJv/Ed1q0xFtbyDNpyuJl8U2vWF7IlJikEoeph2wyOMlCZlPpuM3TI+GE/Z456WKF5
         4cju+nL9ltyRubHcbzOGKG3l72WpUsedW8jxgR7YG7uqDXW2BBC1cZS1uGVcuTKBsS
         SJrU8APmdflza0nVJV5vgJ69+zllmQK+jTs/DAJqxTIcdjU+u3Jv+qa3PNzMKUv8vt
         Auxo7j4BcoIMEVOMUHlkBEAIHI15h8T6Bz3YtRsgb2wxBPxzHR3Xv8n4ST9WOmd12V
         +nd7CYH3RRdRg==
Date:   Tue, 27 Jul 2021 15:56:11 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] net: ipa: kill IPA_VALIDATION
Message-ID: <YQACaxKhxDFZSCF3@unreal>
References: <20210726174010.396765-1-elder@linaro.org>
 <YP/rFwvIHOvIwMNO@unreal>
 <5b97f7b1-f65f-617e-61b4-2fdc5f08bc3e@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b97f7b1-f65f-617e-61b4-2fdc5f08bc3e@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 07:34:41AM -0500, Alex Elder wrote:
> On 7/27/21 6:16 AM, Leon Romanovsky wrote:
> > On Mon, Jul 26, 2021 at 12:40:06PM -0500, Alex Elder wrote:
> >> A few months ago I proposed cleaning up some code that validates
> >> certain things conditionally, arguing that doing so once is enough,
> >> thus doing so always should not be necessary.
> >>   https://lore.kernel.org/netdev/20210320141729.1956732-1-elder@linaro.org/
> >> Leon Romanovsky felt strongly that this was a mistake, and in the
> >> end I agreed to change my plans.
> > 
> > <...>
> > 
> >> The second patch fixes a bug that wasn't normally exposed because of
> >> the conditional compilation (a reason Leon was right about this).
> > 
> > Thanks Alex,
> > 
> > If you want another anti pattern that is very popular in netdev, the following pattern is
> > wrong by definition :):
> > if (WARN_ON(...))
> >   return ...
> 
> I understand this reasoning.
> 
> I had it return an error if the WARN_ON() condition was true in cases
> where the function returned a value and callers already handled errors.
> I looked back at the patch and here is one of those cases:
> 
> gsi_channel_trans_alloc()
> - If too many TREs are requested we do not want to allocate them
>   from the pool, or it will cause further breakage.  By returning
>   early, no transaction will be filled or committed, and an error
>   message will (often) be reported, which will indicate the source
>   of the error.  If any error occurs during initialization, we fail
>   that whole process and everything should be cleaned up.  So in
>   this case at least, returning if this ever occurred is better
>   than allowing control to continue into the function.
> 
> In any case I take your point.  I will now add to my task list
> a review of these spots.  I'd like to be sure an error message
> *is* reported at an appropriate level up the chain of callers so
> I can always identify the culprit in the a WARN_ON() fires (even
> though it should never
>  happen).  And in each case I'll evaluate
> whether returning is better than not.

You can, but users don't :). So if it is valid but error flow, that
needs user awareness, simply print something to the dmesg with *_err()
prints.


BTW, I'm trying to untangle some of the flows in net/core/devlink.c
and such if(WARN()) pattern is even harmful, because it is very hard to
understand when that error is rare/non-exist/real.

Thanks

> 
> Thanks.
> 
> 					-Alex
> 
> > The WARN_*() macros are intended catch impossible flows, something that
> > shouldn't exist. The idea that printed stack to dmesg and return to the
> > caller will fix the situation is a very naive one. That stack already
> > says that something very wrong in the system.
> > 
> > If such flow can be valid use "if(...) return ..", if not use plain
> > WARN_ON(...).
> > 
> > Thanks
> > 
> 
