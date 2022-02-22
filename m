Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2604C021B
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 20:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbiBVTkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 14:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiBVTkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 14:40:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5730A24093;
        Tue, 22 Feb 2022 11:39:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E68F36162F;
        Tue, 22 Feb 2022 19:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFADC340EF;
        Tue, 22 Feb 2022 19:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645558784;
        bh=Ka+Jt97i/6B1ZTnoyEh7pScGrcvrwxi6OjLVAQP7djc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SvwpANSpHwetCqA+YlRXKF8bupqScUlUGiKfgm5g6MCnAkwSC0s+TbupnS4l5R+GA
         T0Me9Po382D5ur/VY29p+YZGi/JLtIzaXGOob49gMThsYmEoH8S/GSVUz6baYrswa4
         /aQBp6iA0HNGy6AF9P4dhzqYQeXlxFO2VeE8fxJrEhEfluCc3NCVSdYf+69JjTLUf3
         8975D+sLLckqxiIXl5uDNGstZeT3glpZUEi3gUina77CH0Ke8JX2M+LWC44wHFc3PY
         85PXy2KDWuEYTdvaNOhqyuudnZd+zpehBCYjJv9AtXvsVSFT042Bg0AOV7w/4hqDzk
         hdK1f78HcMg+A==
Date:   Tue, 22 Feb 2022 11:39:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wudaemon <wudaemon@163.com>
Cc:     davem@davemloft.net, chenhao288@hisilicon.com, arnd@arndb.de,
        shenyang39@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ksz884x: use time_before in netdev_open for
 compatibility
Message-ID: <20220222113942.1747f2dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220220122101.5017-1-wudaemon@163.com>
References: <20220220122101.5017-1-wudaemon@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Feb 2022 12:21:01 +0000 wudaemon wrote:
> use time_before instead of direct compare for compatibility
> 
> Signed-off-by: wudaemon <wudaemon@163.com>
> ---
>  drivers/net/ethernet/micrel/ksz884x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
> index d024983815da..fd3cb9ce438f 100644
> --- a/drivers/net/ethernet/micrel/ksz884x.c
> +++ b/drivers/net/ethernet/micrel/ksz884x.c
> @@ -5428,7 +5428,7 @@ static int netdev_open(struct net_device *dev)
>  		if (rc)
>  			return rc;
>  		for (i = 0; i < hw->mib_port_cnt; i++) {
> -			if (next_jiffies < jiffies)
> +			if (time_before(next_jiffies, jiffies))
>  				next_jiffies = jiffies + HZ * 2;
>  			else
>  				next_jiffies += HZ * 1;

I think this code is trying to space out the updates in time.
So neither way of doing the comparison seems great.
It'd be better to remove the static next_jiffies variable,
and just do something more akin to what mib_read_work() does
in open() as well.
