Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04339429A4D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 02:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhJLANW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 20:13:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232888AbhJLANU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 20:13:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56FA960E54;
        Tue, 12 Oct 2021 00:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633997479;
        bh=Sxry5lBoLED+PmULe66+x8rW+kGtlngMtcUNj5tGH2o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T/qMwMhO851f8Det/z36Q63BzSmM43bo8/zAd+Ra3lvkBZP8R3dIDWK/CmKE8ti7R
         3haf8SQPbD0ylLndk+//4cwh9V/dFnw0lbzRnMskegEYuKBy+CWObTEiCGHrNf0gf0
         rqTkvamUNYa7eo3Q9usCsGWFbvLB0nhOvPWAapyc3Km2Hyi7siUuMwTML19nfzCZ0Q
         su/FJo6BtGa0BZFPAbjyhJRlUBaD4hNJFndfZnSHHTVzdZhw0v9AasuexAgDBqwj4Q
         9gVGJhXHQ/SA4/zbtKzlnvlMNQ7ly8uDS4Ea3lAdUS1DSdKZiX6JpA/w4XgBofDF6m
         PwgX/+oXzL93w==
Date:   Mon, 11 Oct 2021 17:11:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netpoll: Fix carrier_timeout for msleep()
Message-ID: <20211011171118.6e0bf5db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211011085753.20706-1-yajun.deng@linux.dev>
References: <20211011085753.20706-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 16:57:53 +0800 Yajun Deng wrote:
> It should be sleep carrier_timeout seconds rather than 4 seconds if
> carrier_timeout has been modified.

carrier_timeout is for changing the upper bound of the wait,
not for controlling how long to wait if carrier is untrustworthy.

> Add start variable, hence atleast and atmost use the same jiffies, and
> use msecs_to_jiffies() and MSEC_PER_SEC match with jiffies.
> At the same time, msleep() is not for 1ms - 20ms, use usleep_range()
> instead, see Documentation/timers/timers-howto.rst.
> 
> Fixes: bff38771e106 ("netpoll: Introduce netpoll_carrier_timeout kernel option")
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
