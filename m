Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F422FAAC8
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437708AbhART7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390382AbhART7G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 14:59:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DBFD22C9D;
        Mon, 18 Jan 2021 19:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610999897;
        bh=7DSRjq0tdxrLyUFJAHtwzljinnDtGmto18bO0yFeb6g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FAyD2IPTlITXhh5tqwsqG1zNg8kqzJH99N2eLtIcGP0cFSiRS0SczAE2Ox3auOqOE
         Lbq8lI75blykbsG5gjUo+S7JhOyblrfmQsVg41PrXNz2da9CP/NaoItStwnTR76PSL
         AcwBvIU+d3DhYWU57Mfd6LHGCOHsdWoRGN5zjJDLeA4JdmrSuDkBU8qbv2OCcyngBU
         ECdLXRePkZ5N/kfUz0TUcMT7NR7D3mzfQcdSvL9EP334Di+2k7hxokzNadDslL5XEc
         xOlAU/p1AtgunQDiq/4PHUJ90YLt46L/lOMJ5qxGHbmRP/4KccTpIF6qqz1KRxGuRW
         tbzr2PUWjG6rg==
Date:   Mon, 18 Jan 2021 11:58:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 7/7] net: ipa: allow arbitrary number of
 interconnects
Message-ID: <20210118115816.149d71f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <466069e3-2658-5ba7-7704-2cac3293f79a@linaro.org>
References: <20210115125050.20555-1-elder@linaro.org>
        <20210115125050.20555-8-elder@linaro.org>
        <20210116191207.277a391a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <466069e3-2658-5ba7-7704-2cac3293f79a@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Jan 2021 10:03:41 -0600 Alex Elder wrote:
> On 1/16/21 9:12 PM, Jakub Kicinski wrote:
> > On Fri, 15 Jan 2021 06:50:50 -0600 Alex Elder wrote:  
> >> Currently we assume that the IPA hardware has exactly three
> >> interconnects.  But that won't be guaranteed for all platforms,
> >> so allow any number of interconnects to be specified in the
> >> configuration data.
> >>
> >> For each platform, define an array of interconnect data entries
> >> (still associated with the IPA clock structure), and record the
> >> number of entries initialized in that array.
> >>
> >> Loop over all entries in this array when initializing, enabling,
> >> disabling, or tearing down the set of interconnects.
> >>
> >> With this change we no longer need the ipa_interconnect_id
> >> enumerated type, so get rid of it.  
> > 
> > Okay, all the platforms supported as of the end of the series
> > still have 3 interconnects, or there is no upstream user of
> > this functionality, if you will. What's the story?  
> 
> The short answer is that there is another version of IPA that
> has four interconnects instead of three.  (A DTS file for it is
> in "sdxprairie.dtsi" in the Qualcomm "downstream" code.)  I hope
> to have that version supported this year, but it's not my top
> priority right now.  Generalizing the interconnect definitions
> as done in this series improves the driver, but you're right, it
> is technically not required at this time.
> 
> And some more background:
> The upstream IPA driver is derived from the Qualcomm downstream
> code published at codeaurora.org.  The downstream driver is huge
> (it's well over 100,000 lines of code) and it supports lots of
> IPA versions and some features that are not present upstream.
> 
> In order to have any hope of getting upstream support for the
> IPA hardware, the downstream driver functionality was reduced,
> removing support for filtering, routing, and NAT.  I spent many
> months refactoring and reworking that code to make it more
> "upstreamable," and eventually posted the result for review.
> 
> Now that there is an upstream driver, a long term goal is to
> add back functionality that got removed, matching the most
> important features and hardware support found in the downstream
> code.  So in cases like this, even though this feature is not
> yet required, adding it now lays groundwork to make later work
> easier.
> 
> Everything I do with the upstream IPA driver is aimed at in-tree
> support for additional IPA features and hardware versions.  So
> even if an improvement isn't required *now*, there is at least
> a general plan to add support "soon" for something that will
> need it.
> 
> Beyond even that, there are some things I intend to do that
> will improve the driver, even if they aren't technically
> required near-term.  For example, I'd like to dynamically
> allocate endpoints based on what's needed, rather than
> having the driver support any number of them up to a maximum
> fixed at build time.
> 
> Probably a longer response than you needed, but I thought it
> would help to provide more background.  Besides, you *did* ask
> for "the story..."

Thanks, I think I get it now.

But it does sound a little too much like aligning with the vendor
driver for the sake of aligning with the vendor driver. This makes 
the review for someone not familiar with the vendor driver hard, 
and raises questions like "is this really needed upstream or just
downstream / out-of-tree". Please try to reorient the work towards
implementing particular pieces of functionality upstream start to end. 

Applied, with a warning :)
