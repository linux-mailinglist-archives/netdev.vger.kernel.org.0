Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3F56EA24C
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 05:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbjDUDUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 23:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjDUDUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 23:20:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF38119;
        Thu, 20 Apr 2023 20:20:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3494064D81;
        Fri, 21 Apr 2023 03:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D107C433EF;
        Fri, 21 Apr 2023 03:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682047204;
        bh=XU+D0MdM+YuBJFtISsPPujMJGfbkv33ya3jIvOXJCvw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f8qE5M0Ln+2SklnsUE/El9UWMoOegIKTAjfQqITYvnkL6N6QChoIcnwDfpxQG1spX
         8xDwq2mCo2EvAdZ0V5l6BOmIbwSoAVLoxbzAgMnrWBiCb3kfdB62E8/KlxSJaNfKCf
         j/WsmEkX18Or9KOLe3Oxl8KrWBaAOBda7MvWWOqqltYStUL17Trf80osEvbWk9c80t
         mDV5v401fqjZs7rC5k+orUXD3pPiV2Mj/h+YQ8pEWuhpPCGM1lmFaNUw+cT9gOm8aA
         SoCIMLIicF5JEclqOosRoKz4vHb6wT15qZ74IwJsbFRwIDBYFwgdOVtedw0ajv2tih
         USITon0RQCS+Q==
Date:   Thu, 20 Apr 2023 20:20:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shmuel Hazan <shmuel.h@siklu.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/3] net: mvpp2: tai: add refcount for ptp worker
Message-ID: <20230420202003.1e9af9e0@kernel.org>
In-Reply-To: <20230419151457.22411-2-shmuel.h@siklu.com>
References: <20230419151457.22411-1-shmuel.h@siklu.com>
        <20230419151457.22411-2-shmuel.h@siklu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Apr 2023 18:14:55 +0300 Shmuel Hazan wrote:
> +static void mvpp22_tai_stop_unlocked(struct mvpp2_tai *tai)
> +{
> +	tai->poll_worker_refcount--;
> +	if (tai->poll_worker_refcount)
> +		return;
> +	ptp_cancel_worker_sync(tai->ptp_clock);

How can you cancel it _sync() when the work takes the same
lock you're already holding? 

https://elixir.bootlin.com/linux/v6.3-rc7/source/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c#L246

>  void mvpp22_tai_stop(struct mvpp2_tai *tai)
>  {
> -	ptp_cancel_worker_sync(tai->ptp_clock);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tai->lock, flags);
> +	mvpp22_tai_stop_unlocked(tai);

-- 
pw-bot: cr
