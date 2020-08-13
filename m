Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7AE243FFB
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 22:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHMUlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 16:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726499AbgHMUlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 16:41:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4DAD2078B;
        Thu, 13 Aug 2020 20:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597351274;
        bh=kGxqP91BSjtS/0aejUyGPdk0U2ERqe1vZu5dp7v4zUo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qEW45v/FRmlS/yRXA85GD3Z61mTPz1LK7lO29eQQST98FPZYVCSstUR+Z6B/a9YuN
         014S97qQz0YElcSzKS8MkTFEPcEBdhI8Cb4NvUBw+H0DMPRmNgQIDPBa+XXC+MtqwX
         vGtXLLBqWoOcRHeNwXJQzMXToGHv9FzSYnpaJs7E=
Date:   Thu, 13 Aug 2020 13:41:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: Re: [PATCH V1 net 1/3] net: ena: Prevent reset after device
 destruction
Message-ID: <20200813134111.3d22b6ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <pj41zleeoapv31.fsf@u4b1e9be9d67d5a.ant.amazon.com>
References: <20200812101059.5501-1-shayagr@amazon.com>
        <20200812101059.5501-2-shayagr@amazon.com>
        <20200812105219.4c4e3e3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <pj41zleeoapv31.fsf@u4b1e9be9d67d5a.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Aug 2020 15:51:46 +0300 Shay Agroskin wrote:
> Long answer:
> The ena_destroy_device() function is called with rtnl_lock() held, 
> so it cannot run in parallel with the reset function. Also the 
> destroy function clears the bit ENA_FLAG_TRIGGER_RESET without 
> which the reset function just exits without doing anything.
> 
> A problem can then only happen when some routine sets the 
> ENA_FLAG_TRIGGER_RESET bit before the reset function is executed, 
> the following describes all functions from which this bit can be 
> set:

ena_fw_reset_device() runs from a workqueue, it can be preempted right
before it tries to take the rtnl_lock. Then after arbitrarily long
delay it will start again, take the lock, and dereference
adapter->flags. But adapter could have been long freed at this point.

Unless you flush a workqueue or cancel_work_sync() you can never be
sure it's not scheduled. And I can only see a flush when module is
unloaded now.
