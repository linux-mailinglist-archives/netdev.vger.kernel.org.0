Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A77A3420BA
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhCSPS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230039AbhCSPR4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 11:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 252B66191F;
        Fri, 19 Mar 2021 15:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616167075;
        bh=f8JNp2JZnRLxy39cmanL+8/XATFEwk4TGweyALy8Czs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OujtCmetoezjX6vBcsLgHzQ+DlnUwm/fQHq7wji2Q2SnywFdsm07KkVbJ0foUA1ex
         gLkNw87m4rGYmIdfg8ypgGvdDJobQP5L0vENPKqKRZZMtjT3j0PxnrUSjRuf5q6grz
         mr8s/MlqHRi96G8iJFEkHPXwfI6V0YOGqsEcPRbI9gm7Ynwr9ZtVEhcZ3Xy5UHaai/
         Uzsh3TcurQaTlVHucX5tGHApCVRqqslBinsg7MWADuerv8oCfR+eaxWFb4R3mEXeNB
         X2iWyPlMKod5YCagVLZo6z7F7yXcuq7EHvuTIrPY+PeqbgvpMxcknKSF4oy6JkRPEm
         /l1gUj2lkIBeQ==
Date:   Fri, 19 Mar 2021 17:17:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: ipa: activate some commented assertions
Message-ID: <YFTAn7tHBAG2PO78@unreal>
References: <20210319042923.1584593-1-elder@linaro.org>
 <20210319042923.1584593-5-elder@linaro.org>
 <YFQwAYL15nEkfNf7@unreal>
 <7520639c-f08b-cb25-1a62-7e3d69981f95@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7520639c-f08b-cb25-1a62-7e3d69981f95@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 07:40:21AM -0500, Alex Elder wrote:
> On 3/19/21 12:00 AM, Leon Romanovsky wrote:
> > On Thu, Mar 18, 2021 at 11:29:23PM -0500, Alex Elder wrote:
> > > Convert some commented assertion statements into real calls to
> > > ipa_assert().  If the IPA device pointer is available, provide it,
> > > otherwise pass NULL for that.
> > > 
> > > There are lots more places to convert, but this serves as an initial
> > > verification of the new mechanism.  The assertions here implement
> > > both runtime and build-time assertions, both with and without the
> > > device pointer.
> > > 
> > > Signed-off-by: Alex Elder <elder@linaro.org>
> > > ---
> > >   drivers/net/ipa/ipa_reg.h   | 7 ++++---
> > >   drivers/net/ipa/ipa_table.c | 5 ++++-
> > >   2 files changed, 8 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
> > > index 732e691e9aa62..d0de85de9f08d 100644
> > > --- a/drivers/net/ipa/ipa_reg.h
> > > +++ b/drivers/net/ipa/ipa_reg.h
> > > @@ -9,6 +9,7 @@
> > >   #include <linux/bitfield.h>
> > >   #include "ipa_version.h"
> > > +#include "ipa_assert.h"
> > >   struct ipa;
> > > @@ -212,7 +213,7 @@ static inline u32 ipa_reg_bcr_val(enum ipa_version version)
> > >   			BCR_HOLB_DROP_L2_IRQ_FMASK |
> > >   			BCR_DUAL_TX_FMASK;
> > > -	/* assert(version != IPA_VERSION_4_5); */
> > > +	ipa_assert(NULL, version != IPA_VERSION_4_5);
> > 
> > This assert will fire for IPA_VERSION_4_2, I doubt that this is
> > something you want.
> 
> No, it will only fail if version == IPA_VERSION_4_5.
> The logic of an assertion is the opposite of BUG_ON().
> It fails only if the asserted condition yields false.

ok, this ipa_reg_bcr_val() is called in only one place and has a
protection from IPA_VERSION_4_5, why don't you code it at the same
.c file instead of adding useless assert?

> 
> 					-Alex
> 
> > 
> > Thanks
> > 
> 
