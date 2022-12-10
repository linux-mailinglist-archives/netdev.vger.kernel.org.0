Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59C2648BF9
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiLJAys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLJAys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:54:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF8C9764F;
        Fri,  9 Dec 2022 16:54:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25F99623C2;
        Sat, 10 Dec 2022 00:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A419C433D2;
        Sat, 10 Dec 2022 00:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670633686;
        bh=FP1qLoUU0jd+2nXYMOllgA1lD6uDuIS62Q6du/B++M0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XZqF4zvTXtTvVVFsAGnuBfiFvso/jnHfd/eziHuArjtHt+s5JXLUTDp5I4AkkpLHy
         ruCo2bxFp9cqtBUwvAhdzzUCalejLFBtRcLDnhwdFo/s/DGzO1hLUSUTRdL//JtP6e
         G2QU/HzsVH8ABQKR3KMMYYTkscuWN8sRNhEH24BLjv+mizndCQd8z21Omu9dWtWlTT
         4eNpZCMxkxmh44Y0ksmlwe9WoWuyHOKu01jQbvNKH1MMtj1O4QK6hJOs3tITP6hTAC
         EJcZl2Ol1qtaubE669lpzktaF/zJBb+X8j3sC9npmNMgduR0S23DEZTCz7OuGjyRk9
         NsGmgPKX49sow==
Date:   Fri, 9 Dec 2022 16:54:44 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org,
        andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, s-vadapalli@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpsw: Fix PM runtime
 leakage in am65_cpsw_nuss_ndo_slave_open()
Message-ID: <Y5PY1Cdp3px3vRqE@x130>
References: <20221208105534.63709-1-rogerq@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221208105534.63709-1-rogerq@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Dec 12:55, Roger Quadros wrote:
>Ensure pm_runtime_put() is issued in error path.
>
>Reported-by: Jakub Kicinski <kuba@kernel.org>
>Signed-off-by: Roger Quadros <rogerq@kernel.org>


Reviewed-by: Saeed Mahameed <saeed@kernel.org>


[...]

>@@ -622,6 +623,10 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
> error_cleanup:
> 	am65_cpsw_nuss_ndo_slave_stop(ndev);

BTW, while looking at the ndo_slave_stop() call, it seems to abort if 
am65_cpsw_nuss_common_stop() fails, but looking deeper at that and it seems 
am65_cpsw_nuss_common_stop() can never fail, so you might want to fix that.

> 	return ret;
>+
>+runtime_put:
>+	pm_runtime_put(common->dev);
>+	return ret;
> }
>
> static void am65_cpsw_nuss_rx_cleanup(void *data, dma_addr_t desc_dma)
>-- 
>2.34.1
>
