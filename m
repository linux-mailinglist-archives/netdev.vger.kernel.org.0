Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC9B1CFE63
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 21:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbgELTfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 15:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgELTfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 15:35:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9868C061A0C;
        Tue, 12 May 2020 12:35:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 118B412832C6C;
        Tue, 12 May 2020 12:35:13 -0700 (PDT)
Date:   Tue, 12 May 2020 12:35:12 -0700 (PDT)
Message-Id: <20200512.123512.1831107664735178245.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     arnd@arndb.de, netdev@vger.kernel.org, tony@atomide.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, clay@daemons.net, dmurphy@ti.com
Subject: Re: [PATCH net v4] net: ethernet: ti: Remove TI_CPTS_MOD workaround
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200512100230.17752-1-grygorii.strashko@ti.com>
References: <20200512100230.17752-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 May 2020 12:35:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Tue, 12 May 2020 13:02:30 +0300

> From: Clay McClure <clay@daemons.net>
> 
> My recent commit b6d49cab44b5 ("net: Make PTP-specific drivers depend on
> PTP_1588_CLOCK") exposes a missing dependency in defconfigs that select
> TI_CPTS without selecting PTP_1588_CLOCK, leading to linker errors of the
> form:
> 
> drivers/net/ethernet/ti/cpsw.o: in function `cpsw_ndo_stop':
> cpsw.c:(.text+0x680): undefined reference to `cpts_unregister'
>  ...
> 
> That's because TI_CPTS_MOD (which is the symbol gating the _compilation_ of
> cpts.c) now depends on PTP_1588_CLOCK, and so is not enabled in these
> configurations, but TI_CPTS (which is the symbol gating _calls_ to the cpts
> functions) _is_ enabled. So we end up compiling calls to functions that
> don't exist, resulting in the linker errors.
> 
> This patch fixes build errors and restores previous behavior by:
>  - ensure PTP_1588_CLOCK=y in TI specific configs and CPTS will be built
>  - remove TI_CPTS_MOD and, instead, add dependencies from CPTS in
>    TI_CPSW/TI_KEYSTONE_NETCP/TI_CPSW_SWITCHDEV as below:
> 
>    config TI_CPSW_SWITCHDEV
>    ...
>     depends on TI_CPTS || !TI_CPTS
> 
>    which will ensure proper dependencies PTP_1588_CLOCK -> TI_CPTS ->
> TI_CPSW/TI_KEYSTONE_NETCP/TI_CPSW_SWITCHDEV and build type selection.
> 
> Note. For NFS boot + CPTS all of above configs have to be built-in.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Dan Murphy <dmurphy@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Fixes: b6d49cab44b5 ("net: Make PTP-specific drivers depend on PTP_1588_CLOCK")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Clay McClure <clay@daemons.net>
> [grygorii.strashko@ti.com: rewording, add deps cpsw/netcp from cpts, drop IS_REACHABLE]
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied, thanks.
