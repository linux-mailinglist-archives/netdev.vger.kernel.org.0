Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182A566D9CA
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbjAQJY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbjAQJYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:24:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4082CFED;
        Tue, 17 Jan 2023 01:21:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78CDFB811F8;
        Tue, 17 Jan 2023 09:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852E3C433D2;
        Tue, 17 Jan 2023 09:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673947298;
        bh=xp+LF0wP9tlZDcaFx4O1myVai0CG+iwcsolU0+B9Zf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t2upRhvT8/4knHAjg6IPzW/oBkEr7IP3lzIM4Q2x6xay2PmdSU67v/ge3AlhPVPTQ
         +VRwZMsxcIa1JsZ1dvvsOrX8PSWSxQ9oACW6HFpT4dFXPoFxbkLNbWgQS15WJjRFIx
         tapVz0aV+X0/KqYEAJDfV2SuU4hG31+/Uzcvm+jBfZFJepNxc6C/FivAW33jk+Th6j
         CtPFND25Jzos9IGPWq7J0SDidubZCNcujFvqKGedgM/N+fa67ajOeL7cgsZ9CiIX26
         nzXkDUy4Kka+a9S0bW1+Gn35lO4eQkFCwiT/xQiZNulZxHhG1UDUlTO1DahheS/Run
         yDQDHE32T2CTw==
Date:   Tue, 17 Jan 2023 11:21:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Maksim Davydov <davydov-max@yandex-team.ru>
Cc:     rajur@chelsio.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, anish@chelsio.com,
        hariprasad@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net/ethernet/chelsio: fix cxgb4_getpgtccfg wrong
 memory access
Message-ID: <Y8ZonuQJn8gO9GX5@unreal>
References: <20230116152100.30094-1-davydov-max@yandex-team.ru>
 <20230116152100.30094-2-davydov-max@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116152100.30094-2-davydov-max@yandex-team.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 06:20:59PM +0300, Maksim Davydov wrote:
> *pgid can be in range 0 to 0xF (bitmask 0xF) but valid values for PGID
> are between 0 and 7. Also the size of pgrate is 8. Thus, we are needed
> additional check to make sure that this code doesn't have access to tsa.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Fixes: 76bcb31efc06 ("cxgb4 : Add DCBx support codebase and dcbnl_ops")
> Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
> index 7d5204834ee2..3aa65f0f335e 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
> @@ -471,7 +471,10 @@ static void cxgb4_getpgtccfg(struct net_device *dev, int tc,
>  		return;
>  	}
>  
> -	*bw_per = pcmd.u.dcb.pgrate.pgrate[*pgid];
> +	/* Valid values are: 0-7 */

How do you see it?

There are lines below that assume something different.
   477         /* prio_type is link strict */
   478         if (*pgid != 0xF)
   479                 *prio_type = 0x2;


> +	if (*pgid <= 7)
> +		*bw_per = pcmd.u.dcb.pgrate.pgrate[*pgid];

Why do you think that it is valid simply do not set *bw_per?

Thanks
