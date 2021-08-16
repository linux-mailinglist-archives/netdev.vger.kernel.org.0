Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1503ED8C1
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhHPOQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhHPOQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 10:16:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 457E160FD8;
        Mon, 16 Aug 2021 14:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629123344;
        bh=1jYaq3pulCTBiY2onrHD7yAdtdvZB2Co4B3PYaUe4Z8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vz163sbJzGINyAv8crNo12ZC1JvSgZDTboa7dMgRdXXZ9v8jqlVYYdDWsO7+6sLAj
         q4i7xcCZTbCQhrW5qy+BhbvSRxwPwhamyz/FpWBTXHysqYwUVna9rpt8301ju9dtdO
         3zyE/+o5TMOUBCjclMt2Tk7UpwBecbveTEcfENeWPxMczDRz9ewbnxnl6YL0t/rbXq
         uHHtycpxLMGDBofRSjMxLYUN0df4mPHeu9letMfSDf5nV8TSI7Nn2bvVp1s8hVwiWn
         ClqESbqNkMLjlhBU8n6IR1PHNhitKcJdej/efcAtiFn2NRWJx+PIDv5RvJZEgQDRkk
         ziWhtd5kudWdg==
Date:   Mon, 16 Aug 2021 07:15:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/6] net: ipa: ensure hardware has power in
 ipa_start_xmit()
Message-ID: <20210816071543.39a44815@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3a9e82cc-c09e-62e8-4671-8f16d4f6a35b@linaro.org>
References: <20210812195035.2816276-1-elder@linaro.org>
        <20210812195035.2816276-5-elder@linaro.org>
        <20210813174655.1d13b524@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3a9e82cc-c09e-62e8-4671-8f16d4f6a35b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Aug 2021 21:25:23 -0500 Alex Elder wrote:
> > This is racy, what if the pm work gets scheduled on another CPU and
> > calls wake right here (i.e. before you call netif_stop_queue())?
> > The queue may never get woken up?  
> 
> I haven't been seeing this happen but I think you may be right.
> 
> I did think about this race, but I think I was relying on the
> PM work queue to somehow avoid the problem.  I need to think
> about this again after a good night's sleep.  I might need
> to add an atomic flag or something.

Maybe add a spin lock?  Seems like the whole wake up path will be
expensive enough for a spin lock to be in the noise. You can always 
add complexity later.
