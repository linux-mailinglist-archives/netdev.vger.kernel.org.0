Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F2845AE39
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 22:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239701AbhKWVUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 16:20:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237545AbhKWVUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 16:20:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RSXZemgAgA8s7Q1KPoiQuPuxn56lemT0SfST8M7pCss=; b=PKWrDzd1WlzcpS9MGBTPrJm7Ar
        DbX6Tradu72YHB8U1ioL+dXwA2JcONEAvWXd6a2Nz1Pa0Z46Uzj7AqNTYwGbvYZLdP/AjynYgHvHf
        KEq+itLWi2qcKJDQESh/xHKv1nRJj0M4HzOB7CTjAQF4CGbvJbmDdcmOkkpxBZl/AIN4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mpdAH-00ERwC-Nm; Tue, 23 Nov 2021 22:17:21 +0100
Date:   Tue, 23 Nov 2021 22:17:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev <netdev@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [ethtool v5 2/6] Add cable test TDR support
Message-ID: <YZ1aYZgQ58e1bfLq@lunn.ch>
References: <20200705175452.886377-1-andrew@lunn.ch>
 <20200705175452.886377-3-andrew@lunn.ch>
 <YZvmzIVHP8nReWJC@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZvmzIVHP8nReWJC@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew, is this missing the following patch?
> 
> diff --git a/netlink/cable_test.c b/netlink/cable_test.c
> index 17139f7d297d..9305a4763c5b 100644
> --- a/netlink/cable_test.c
> +++ b/netlink/cable_test.c
> @@ -225,6 +225,7 @@ static int nl_cable_test_process_results(struct cmd_context *ctx)
>         nlctx->is_monitor = true;
>         nlsk->port = 0;
>         nlsk->seq = 0;
> +       nlctx->filter_devname = ctx->devname;
>  
>         ctctx.breakout = false;
>         nlctx->cmd_private = &ctctx;
> @@ -496,6 +497,7 @@ static int nl_cable_test_tdr_process_results(struct cmd_context *ctx)
>         nlctx->is_monitor = true;
>         nlsk->port = 0;
>         nlsk->seq = 0;
> +       nlctx->filter_devname = ctx->devname;
>  
>         ctctx.breakout = false;
>         nlctx->cmd_private = &ctctx;
> 
> I don't have hardware with cable test support so wondered if you could
> test it.

Hi Ido

I've tested this. No obvious regressions. My broken cable is still
broken.

> I think that without this patch you would see problems with two
> simultaneous cable tests. The first one to finish will terminate both
> ethtool processes because the code is processing all cable tests
> notifications regardless of the device for which the test was issued.

I did not test such a setup. But you are correct, the message from the
kernel is broadcast, and any waiting process will consume it, even if
it is for a different device.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
