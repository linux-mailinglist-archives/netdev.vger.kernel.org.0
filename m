Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF1F2B5632
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbgKQBUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731455AbgKQBUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 20:20:46 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 385CD24687;
        Tue, 17 Nov 2020 01:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605576045;
        bh=ztyBwJLMlocjEoRhiD56Z6jPA2fhMR2Df8qyUs9Uhzc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=njlSfwPALC8/4AtZmUO68tYDpSg4dMktK3S9UIEMbX7+k+loiOp6dRQ1SXzDeZqo2
         wTqY9ksucG/F/3JPiiUOqtRT/bucAoNKMe91qhz13QavCP8BWA3t9E5CUPyZC6CSKz
         GuYXwASQzhokLRAnvCdJT9QA3X27jm5d3hWMHk44=
Date:   Mon, 16 Nov 2020 17:20:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Jeffery <andrew@aj.id.au>,
        Ivan Mikhaylov <i.mikhaylov@yadro.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: ftgmac100: Fix crash when removing driver
Message-ID: <20201116172044.36bf1bad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116032715.1011071-1-joel@jms.id.au>
References: <20201116032715.1011071-1-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 13:57:15 +1030 Joel Stanley wrote:
> When removing the driver we would hit BUG_ON(!list_empty(&dev->ptype_specific))
> in net/core/dev.c due to still having the NC-SI packet handler
> registered.
> 
>  # echo 1e660000.ethernet > /sys/bus/platform/drivers/ftgmac100/unbind
>   ------------[ cut here ]------------
>   kernel BUG at net/core/dev.c:10254!
>   Internal error: Oops - BUG: 0 [#1] SMP ARM
>   CPU: 0 PID: 115 Comm: sh Not tainted 5.10.0-rc3-next-20201111-00007-g02e0365710c4 #46
>   Hardware name: Generic DT based system
>   PC is at netdev_run_todo+0x314/0x394
>   LR is at cpumask_next+0x20/0x24
>   pc : [<806f5830>]    lr : [<80863cb0>]    psr: 80000153
>   sp : 855bbd58  ip : 00000001  fp : 855bbdac
>   r10: 80c03d00  r9 : 80c06228  r8 : 81158c54
>   r7 : 00000000  r6 : 80c05dec  r5 : 80c05d18  r4 : 813b9280
>   r3 : 813b9054  r2 : 8122c470  r1 : 00000002  r0 : 00000002
>   Flags: Nzcv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment none
>   Control: 00c5387d  Table: 85514008  DAC: 00000051
>   Process sh (pid: 115, stack limit = 0x7cb5703d)
>  ...
>   Backtrace:
>   [<806f551c>] (netdev_run_todo) from [<80707eec>] (rtnl_unlock+0x18/0x1c)
>    r10:00000051 r9:854ed710 r8:81158c54 r7:80c76bb0 r6:81158c10 r5:8115b410
>    r4:813b9000
>   [<80707ed4>] (rtnl_unlock) from [<806f5db8>] (unregister_netdev+0x2c/0x30)
>   [<806f5d8c>] (unregister_netdev) from [<805a8180>] (ftgmac100_remove+0x20/0xa8)
>    r5:8115b410 r4:813b9000
>   [<805a8160>] (ftgmac100_remove) from [<805355e4>] (platform_drv_remove+0x34/0x4c)
> 
> Fixes: bd466c3fb5a4 ("net/faraday: Support NCSI mode")
> Signed-off-by: Joel Stanley <joel@jms.id.au>

> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 983b6db2d80d..88bfe2107938 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1926,6 +1926,8 @@ static int ftgmac100_probe(struct platform_device *pdev)
>  err_phy_connect:
>  	ftgmac100_phy_disconnect(netdev);

This line does not exist in net, only in net-next, please respin on top
of net so we can apply this to Linux 5.10 and backport to older stable
releases.

