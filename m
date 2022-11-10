Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE47A623A4E
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 04:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbiKJDTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 22:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKJDTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 22:19:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CA3286E4;
        Wed,  9 Nov 2022 19:19:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22C2261D2E;
        Thu, 10 Nov 2022 03:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27236C433D6;
        Thu, 10 Nov 2022 03:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668050382;
        bh=lEvNPQT64JP784ZbtlJ2vRiQt5VXmBZWy37oJLq+9Yk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lrc9jPwfm5wGLhnQjkl7vdG9A7eP3u7lsFf8egWyJF4miGX0qRqPnopIg0SHsKR37
         ic+zwMLPgK6+Q61c7SnN28o7e4lx+TjvwPIuKqrmguV41f+ohZb6RcT5pfeAHsi7vl
         OSvzBT7PlyaYFxCW6LUTi2h9XIMN2Knd7v7F9nLDGmn33FFA2IG6kq3r4d/eThHxsc
         FKdkE6U38d3+2N2mlxwAMWe21fXR82N/yLpJ99xeL0kvxFPMh4X+bMMta3ISYXl7Dd
         u6PWtqcB0RwTDyMic9P1HqLboUWP+uu6DEokI0tznZF3fh1kDTWJhH/amCzRMNLvtm
         Na04cS58cmSPw==
Date:   Wed, 9 Nov 2022 19:19:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, srk@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: cpsw_ale: optimize
 cpsw_ale_restore()
Message-ID: <20221109191941.6af4f71d@kernel.org>
In-Reply-To: <20221108135643.15094-1-rogerq@kernel.org>
References: <20221108135643.15094-1-rogerq@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Nov 2022 15:56:43 +0200 Roger Quadros wrote:
> If an entry was FREE then we don't have to restore it.

Motivation? Does it make the restore faster?

> Signed-off-by: Roger Quadros <rogerq@kernel.org>
> ---
> 
> Patch depends on
> https://lore.kernel.org/netdev/20221104132310.31577-3-rogerq@kernel.org/T/
> 
>  drivers/net/ethernet/ti/cpsw_ale.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
> index 0c5e783e574c..41bcf34a22f8 100644
> --- a/drivers/net/ethernet/ti/cpsw_ale.c
> +++ b/drivers/net/ethernet/ti/cpsw_ale.c
> @@ -1452,12 +1452,15 @@ void cpsw_ale_dump(struct cpsw_ale *ale, u32 *data)
>  	}
>  }
>  
> +/* ALE table should be cleared (ALE_CLEAR) before cpsw_ale_restore() */

Maybe my tree is old but I see we clear only if there is a netdev that
needs to be opened but then always call ale_restore(). Is that okay?

I'd also s/should/must/ 

>  void cpsw_ale_restore(struct cpsw_ale *ale, u32 *data)
>  {
> -	int i;
> +	int i, type;
>  
>  	for (i = 0; i < ale->params.ale_entries; i++) {
> -		cpsw_ale_write(ale, i, data);
> +		type = cpsw_ale_get_entry_type(data);
> +		if (type != ALE_TYPE_FREE)
> +			cpsw_ale_write(ale, i, data);
>  		data += ALE_ENTRY_WORDS;
>  	}
>  }

