Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E034635FE5E
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237282AbhDNXVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232330AbhDNXVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:21:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C9B16109F;
        Wed, 14 Apr 2021 23:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618442470;
        bh=AgTMtsQPM47cFcTN1hq5KRhhhyYS65Px0szt4dymWD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dsRV2nSCNJfP6uGLA7fUUX/z4UEcuoxUBq30pFF+etRMN0ke6ATvBoPkGavJ3Sv4d
         9i/f1qj6D2+4f6i/ZzzFIm7ivUG5A8e8rJygOd5OtrR5KGEM+dK/H2EIf2aL6P5452
         ExdAOZCGTA8iny74w1oohjRh/rR3l1/MI7WHYS367/Cs9xLtEPQ0jrm5ydMoJ0z8jp
         AEVwrtFz4xxI9wgFQTlmRlIs8ZGsa70uLgXujMSF82+tI2ONSIv/G6xxL4ufkUf2Jz
         +fO2slWnX0iW2j8iqVx3CI331YSjarH6pzPFsOWvxPIPnWGJQz94olNWbdM2Maiyma
         aSdlP00n9Oizw==
Date:   Wed, 14 Apr 2021 16:21:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: core: make napi_disable more robust
Message-ID: <20210414162109.77eecf47@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210414080845.11426-1-lijunp213@gmail.com>
References: <20210414080845.11426-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 03:08:45 -0500 Lijun Pan wrote:
> There are chances that napi_disable can be called twice by NIC driver.
> This could generate deadlock. For example,
> the first napi_disable will spin until NAPI_STATE_SCHED is cleared
> by napi_complete_done, then set it again.
> When napi_disable is called the second time, it will loop infinitely
> because no dev->poll will be running to clear NAPI_STATE_SCHED.
> 
> Though it is driver writer's responsibility to make sure it being
> called only once, making napi_disable more robust does not hurt, not
> to say it can prevent a buggy driver from crashing a system.
> So, we check the napi state bit to make sure that if napi is already
> disabled, we exit the call early enough to avoid spinning infinitely.

You've already been told by Eric & Dave to fix the driver instead.

Your check is _not_ correct - SCHED && NPSVC && !MISSED && !BUSY_POLL 
can well arise without disabling the NAPI.

But regardless, a driver bug should be relatively easy to identify with
task getting stuck in napi_disable(). We don't provide "protection" 
for taking spin locks or ref counts twice either. Unless you can show 
a strong use case please stop posting new versions of this patch.
