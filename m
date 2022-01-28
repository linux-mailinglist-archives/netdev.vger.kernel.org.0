Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7102C49F7A4
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347916AbiA1KyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:54:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52544 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244101AbiA1KyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 05:54:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D9F1B824E4;
        Fri, 28 Jan 2022 10:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94362C340E6;
        Fri, 28 Jan 2022 10:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643367259;
        bh=7rB4RSw/YRUBhZ9iCDfvb/m75/M6d4KAVqINfmGPkzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s9st9bm2lwi5XX75r94Czbb6OZD7hCkWFHtI9P2YGfPdZA1bTdEzt7GKjIctmwVgb
         gWTu2ABXs3fYYride+7/oC7AWoJGZ/RvRxuA7uQuuNStgummRF5JzWRkb+95DZwxhL
         Z2aFsMML3D0gixKcVGeFTIVjCDwqmptAQCQoWYbs=
Date:   Fri, 28 Jan 2022 11:54:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Zhou Qingyang <zhou1615@umn.edu>, kjlu@umn.edu,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Angus Ainslie <angus@akkea.ca>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: Fix a wild pointer dereference bug in
 brcmf_chip_recognition()
Message-ID: <YfPLVyo+4qvHASZm@kroah.com>
References: <20220124164847.54002-1-zhou1615@umn.edu>
 <YfPCahElneup1DJS@kroah.com>
 <875yq4gnhr.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yq4gnhr.fsf@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 12:31:44PM +0200, Kalle Valo wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > On Tue, Jan 25, 2022 at 12:48:45AM +0800, Zhou Qingyang wrote:
> >> In brcmf_chip_recognition(), the return value of brcmf_chip_add_core()
> >> is assigned to core and is passed to brcmf_chip_sb_corerev(). In
> >> brcmf_chip_sb_corerev(), there exists dereference of core without check.
> >> the return value of brcmf_chip_add_core() could be ERR_PTR on failure of
> >> allocation, which could lead to a NULL pointer dereference bug.
> >> 
> >> Fix this bug by adding IS_ERR check for every variable core.
> >> 
> >> This bug was found by a static analyzer.
> >> 
> >> Builds with 'make allyesconfig' show no new warnings,
> >> and our static analyzer no longer warns about this code
> >> 
> >> Fixes: cb7cf7be9eba ("brcmfmac: make chip related functions host
> >> interface independent")
> >> Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
> >> ---
> >> The analysis employs differential checking to identify inconsistent 
> >> security operations (e.g., checks or kfrees) between two code paths 
> >> and confirms that the inconsistent operations are not recovered in the
> >> current function or the callers, so they constitute bugs. 
> >> 
> >> Note that, as a bug found by static analysis, it can be a false
> >> positive or hard to trigger. Multiple researchers have cross-reviewed
> >> the bug.
> >
> > As stated before, umn.edu is still not allowed to contribute to the
> > Linux kernel.  Please work with your administration to resolve this
> > issue.
> 
> Thanks Greg, I didn't notice that this is from umn.edu. After seeing
> what kind of "research" umn.edu does I will not even look at umn.edu
> patches, they all will be automatically rejected without comments.

Thank you.  We could just block their emails from the mailing lists, but
then that would not let us see when they send a patch and cc: the
relevant maintainers, so we have to live with this way for now.

I'll be contacting the umn.edu administration again and ask them what
went wrong here.

greg k-h
