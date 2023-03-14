Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22F86B86AD
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCNAPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCNAPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:15:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B9E90089;
        Mon, 13 Mar 2023 17:15:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BF7D61508;
        Tue, 14 Mar 2023 00:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556B3C433D2;
        Tue, 14 Mar 2023 00:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678752901;
        bh=evJR1w8qYrpD66HefdOGP8dyttHKpCWhWIZqlozlkmo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hds9HLCZ9WQqL5IbyGl+W9lMVUgeFdjT3SuPwxzkrckg5ryTMzJF4FEnPyYf07+Y5
         5ADdIQ73YIGNairewuou/fsxVpL819rnjLCu3TDqMDtKY1TOZh57Mun+8TuX2i45cP
         sAuZWzij201w1Ttuka8+1JKfv6xSqhtZXu4CHFTNnRFhnxt8BmC7f2uD5QvAcHnw+/
         bDCZn22IBjHIH9UmzwqVCgXUABuIFisDUkd6VCbnOLHG8tNMaY5ZWtBBUm1zmo3TfT
         IalW97n3LjzcijihVn/qh0F4ysRmST8vIEa6BGlEcgyYkklQj/mw2UigCMybD3P38e
         Qg1CA+Gy0KgUQ==
Date:   Mon, 13 Mar 2023 17:15:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     davem@davemloft.net, simon.horman@corigine.com,
        edumazet@google.com, pabeni@redhat.com, petrm@nvidia.com,
        thomas.lendacky@amd.com, wsa+renesas@sang-engineering.com,
        leon@kernel.org, shayagr@amazon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com
Subject: Re: [PATCH v2] xirc2ps_cs: Fix use after free bug in xirc2ps_detach
Message-ID: <20230313171500.35400df5@kernel.org>
In-Reply-To: <20230311170836.3919005-1-zyytlz.wz@163.com>
References: <20230311170836.3919005-1-zyytlz.wz@163.com>
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

On Sun, 12 Mar 2023 01:08:36 +0800 Zheng Wang wrote:
> In xirc2ps_probe, the local->tx_timeout_task was bounded
> with xirc2ps_tx_timeout_task. When timeout occurs,
> it will call xirc_tx_timeout->schedule_work to start the
> work.
> 
> When we call xirc2ps_detach to remove the driver, there
> may be a sequence as follows:
> 
> Stop responding to timeout tasks and complete scheduled
> tasks before cleanup in xirc2ps_detach, which will fix
> the problem.
> 
> CPU0                  CPU1
> 
>                     |xirc2ps_tx_timeout_task
> xirc2ps_detach      |
>   free_netdev       |
>     kfree(dev);     |
>                     |
>                     | do_reset
>                     |   //use dev
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
> v2:
> - fix indentation error suggested by Simon Horman,
> and stop the timeout tasks  suggested by Yunsheng Lin
> ---
>  drivers/net/ethernet/xircom/xirc2ps_cs.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
> index 894e92ef415b..c77ca11d9497 100644
> --- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
> +++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
> @@ -503,6 +503,11 @@ static void
>  xirc2ps_detach(struct pcmcia_device *link)
>  {
>      struct net_device *dev = link->priv;
> +		struct local_info *local = netdev_priv(dev);
> +
> +		netif_carrier_off(dev);
> +		netif_tx_disable(dev);
> +		cancel_work_sync(&local->tx_timeout_task);
>  
>      dev_dbg(&link->dev, "detach\n");
>  

Please fix the formatting and make sure you CC the maintainers when you
post v3.
