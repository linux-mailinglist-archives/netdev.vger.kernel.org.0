Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0C325B681
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 00:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgIBWly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 18:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBWlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 18:41:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C67C061244;
        Wed,  2 Sep 2020 15:41:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EFC0A15734790;
        Wed,  2 Sep 2020 15:25:00 -0700 (PDT)
Date:   Wed, 02 Sep 2020 15:41:44 -0700 (PDT)
Message-Id: <20200902.154144.1959394275972532074.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     ulli.kroll@googlemail.com, wanghai38@huawei.com,
        linus.walleij@linaro.org, kuba@kernel.org, mirq-linux@rere.qmqm.pl,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: gemini: Fix another missing
 clk_disable_unprepare() in probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200902115631.GA286978@mwanda>
References: <20200902115631.GA286978@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 15:25:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 2 Sep 2020 14:56:31 +0300

> We recently added some calls to clk_disable_unprepare() but we missed
> the last error path if register_netdev() fails.
> 
> I made a couple cleanups so we avoid mistakes like this in the future.
> First I reversed the "if (!ret)" condition and pulled the code in one
> indent level.  Also, the "port->netdev = NULL;" is not required because
> "port" isn't used again outside this function so I deleted that line.
> 
> Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied and queued up for -stable, thanks.

Unrelated to your patch but...

>  	ret = register_netdev(netdev);
 ...
> +	ret = gmac_setup_phy(netdev);

Should we really be setting up the PHY after registering the netdev?

The moment we register it, entities can try to bring the interface up
and shouldn't we have the PHY bits all squared away before that?
