Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEB54A64A5
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 20:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242298AbiBATIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 14:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241933AbiBATIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 14:08:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07D2C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 11:08:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FA00B82F4F
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 19:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB373C340EB;
        Tue,  1 Feb 2022 19:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643742520;
        bh=smVpuvsONHH3zfWXkFPGZ3q/UWmE2+7+snavaAr1zaI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=faRw/wC7XeXlEiBGJQh9xmfBVWl4zIXbfz7hRIeOxSnsZ70TN0BJb3AJdRXSzBS3F
         mocuE/AYA8Bk7EqgNAlG+b5NqPKcfARZi8tD5moeapVqjlFAbfxTlTC1PfPh8fptV/
         MdUV6CYEcATYNDi5IylbL0s34DJTL/VHXo7YT9XK7nQI3B4zKhWJ2OBrT0t4xY7X+x
         jH93rkYP8NQZBYvP3ezZSVfgJCnzUnt5nISpnyQaCSoLqLIZe/pRGxbONIFbnIOzbF
         AzS3zBWJnPChWqnM5vQ/A1tALLqVwutW+yGHpZle1GR97cWbJEzzX6H04cQomQtYn8
         OZletVNe8q6AA==
Date:   Tue, 1 Feb 2022 11:08:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Alexey Sheplyakov <asheplyakov@basealt.ru>,
        <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Evgeny Sinelnikov <sin@basealt.ru>,
        Serge Semin <fancer.lancer@gmail.com>
Subject: Re: [PATCH 1/2] net: stmmac: added Baikal-T1/M SoCs glue layer
Message-ID: <20220201110838.7d626862@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220201155439.hv42mqed2n7wekuo@mobilestation>
References: <20220126084456.1122873-1-asheplyakov@basealt.ru>
        <20220128150642.qidckst5mzkpuyr3@mobilestation>
        <YfQ8De5OMLDLKF6g@asheplyakov-rocket>
        <20220128122718.686912e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220201155439.hv42mqed2n7wekuo@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Feb 2022 18:54:39 +0300 Serge Semin wrote:
> On Fri, Jan 28, 2022 at 12:27:18PM -0800, Jakub Kicinski wrote:
> > On Fri, 28 Jan 2022 22:55:09 +0400 Alexey Sheplyakov wrote:  
> > > In general quite a number of Linux drivers (GPUs, WiFi chips, foreign
> > > filesystems, you name it) provide a limited support for the corresponding
> > > hardware (filesystem, protocol, etc) and don't cover all peculiarities.
> > > Yet having such a limited support in the mainline kernel is much more
> > > useful than no support at all (or having to use out-of-tree drivers,
> > > obosolete vendor kernels, binary blobs, etc).
> > > 
> > > Therefore "does not cover all peculiarities" does not sound like a valid
> > > reason for rejecting this driver. That said it's definitely up to stmmac
> > > maintainers to decide if the code meets the quality standards, does not
> > > cause excessive maintanence burden, etc.  
> > 
> > Sounds sensible, Serge please take a look at the v2 and let us know if
> > there are any bugs in there. Or any differences in DT bindings or user
> > visible behaviors with what you're planning to do. If the driver is
> > functional and useful it can evolve and gain support for features and
> > platforms over time.  
> 
> I've already posted my comments in this thread regarding the main
> problematic issues of the driver, but Alexey for some reason ignored
> them (dropped from his reply). Do you want me to copy my comments to
> v2 and to proceed with review there?

Right, on a closer look there are indeed comments you raised that were
not addressed and not constrained to future compatibility. 

Alexey, please take another look at those and provide a changelog in
your next posting so we can easily check what was addressed.

> Regarding the DT-bindings and the user-visible behavior. Right, I'll
> add my comments in this matter. Thanks for suggesting. This was one of
> the problems why I was against the driver integrating into the kernel.
> One of our patchset brings a better organization to the current
> DT-bindings of the Synopsys DW *MAC devices. In particular it splits
> up the generic bindings for the vendor-specific MACs to use and the
> bindings for the pure DW MAC compatible devices. In addition the
> patchset will add the generic Tx/Rx clocks DT-bindings and the
> DT-bindings for the AXI/MTL nodes. All of that and the rest of our
> work will be posted a bit later as a set of the incremental patchsets
> with small changes, one by one, for an easier review. We just need
> some more time to finish the left of the work. The reason why the
> already developed patches hasn't been delivered yet is that the rest
> of the work may cause adding changes into the previous patches. In
> order to decrease a number of the patches to review and present a
> complete work for the community, we decided to post the patchsets
> after the work is fully done.

TBH starting to post stuff is probably best choice you can make,
for example the DT rework you mention sounds like a refactoring 
you can perform without posting any Baikal support.
