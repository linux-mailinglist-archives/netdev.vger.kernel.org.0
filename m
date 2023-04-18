Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE066E55FC
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjDRAoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDRAog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:44:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B98040C8;
        Mon, 17 Apr 2023 17:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bnsZiXNLzJijyULrYUfO4S0JPXhMB76tF9V0ZZt95Js=; b=0GAPn7bZVQv4/DPi6zGxw/KEc3
        K+1xb2+q7sfPCPkDhvlrnxShzp28zKIyVwfuzYxj+OixV7+oV9iWh3g6qEVxUQDkSi0kfsVcgJc4N
        oUvD1wMtzNDOOvEX1xtfxAEEPUOR9JuvHXP+OnHaLd0A44Nl9uMnDenha53ERENnbprM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1poZSK-00AYGP-Ne; Tue, 18 Apr 2023 02:44:24 +0200
Date:   Tue, 18 Apr 2023 02:44:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shmuel Hazan <shmuel.h@siklu.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: mvpp2: tai: add refcount for ptp worker
Message-ID: <cab62ad6-c495-48f3-91c8-5c27c43582ba@lunn.ch>
References: <20230417170741.1714310-1-shmuel.h@siklu.com>
 <20230417170741.1714310-2-shmuel.h@siklu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417170741.1714310-2-shmuel.h@siklu.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 08:07:39PM +0300, Shmuel Hazan wrote:
> In some configurations, a single TAI can be responsible for multiple
> mvpp2 interfaces. However, the mvpp2 driver will call mvpp22_tai_stop
> and mvpp22_tai_start per interface RX timestamp disable/enable.
> 
> As a result, disabling timestamping for one interface would stop the
> worker and corrupt the other interface's RX timestamps.
> 
> This commit solves the issue by introducing a simpler ref count for each
> TAI instance.
> 
> Fixes: ce3497e2072e ("net: mvpp2: ptp: add support for receive timestamping")
> Signed-off-by: Shmuel Hazan <shmuel.h@siklu.com>
> ---
>  .../net/ethernet/marvell/mvpp2/mvpp2_tai.c    | 30 ++++++++++++++++---
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> index 95862aff49f1..2e3d43b1bac1 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> @@ -61,6 +61,7 @@ struct mvpp2_tai {
>  	u64 period;		// nanosecond period in 32.32 fixed point
>  	/* This timestamp is updated every two seconds */
>  	struct timespec64 stamp;
> +	u16 poll_worker_refcount;
>  };
>  
>  static void mvpp2_tai_modify(void __iomem *reg, u32 mask, u32 set)
> @@ -368,18 +369,39 @@ void mvpp22_tai_tstamp(struct mvpp2_tai *tai, u32 tstamp,
>  	hwtstamp->hwtstamp = timespec64_to_ktime(ts);
>  }
>  
> +static void mvpp22_tai_start_unlocked(struct mvpp2_tai *tai)
> +{
> +	tai->poll_worker_refcount++;
> +	if (tai->poll_worker_refcount > 1)
> +		return;
> +
> +	ptp_schedule_worker(tai->ptp_clock, 0);

So the old code used to have delay here, not 0. And delay would be
returned by mvpp22_tai_aux_work() and have a value of 2000ms. So this
is a clear change in behaviour. Why is it O.K. not to delay for 2
seconds?  Should you actually still have the delay, pass it as a
parameter into this function?

     Andrew
