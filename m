Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0F36454FA
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 08:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiLGH45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 02:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiLGH4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 02:56:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5ABC303E9
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 23:56:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38ED760A39
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 07:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A558C433D6;
        Wed,  7 Dec 2022 07:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670399808;
        bh=w0x+p26eGSVWfPaOAVMcn9rzf/NKP4LFWsEPsRiCqQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PjI/z0XAecuj1FOswH7yUC67gS6GLtcQuKS8gTpoFq2v9xB0Uyi7wt5CQf2H4p0U7
         9NZ8oHMFS+I6XPqIybp/PnVWC2zWHs3JiMpFd4jLKTY9bAs+VhRci1MPUxTAKIao4e
         PDCpuBz70M0bwacXJ4GvqRukfecTHTQkhUzuKy5KhgipSDLeuurHorpKSJEHLe4QrA
         HDr/hLbxyUWpacBFuJedDWYsZm9FWAtjOG9JGg2I42GtIMeRnEUtIUzpGiQvwF9zr3
         JJhLYLcRxNE1w4owRj6N7U6OJ0ieFWxE1pUSGiMXz+Tiof2uJOSHfQsfl7ndYwVVI1
         R2pYSLPET4NIA==
Date:   Wed, 7 Dec 2022 09:56:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yuan Can <yuancan@huawei.com>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sucheta.chakraborty@qlogic.com, rajesh.borundia@qlogic.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] drivers: net: qlcnic: Fix potential memory leak in
 qlcnic_sriov_init()
Message-ID: <Y5BHPCE5rfQ0cmne@unreal>
References: <20221206103031.20609-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206103031.20609-1-yuancan@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 10:30:31AM +0000, Yuan Can wrote:
> If vp alloc failed in qlcnic_sriov_init(), all previously allocated vp
> needs to be freed.
> 
> Fixes: f197a7aa6288 ("qlcnic: VF-PF communication channel implementation")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
> index 9282321c2e7f..d0470c62e1b2 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
> @@ -222,6 +222,8 @@ int qlcnic_sriov_init(struct qlcnic_adapter *adapter, int num_vfs)
>  
>  qlcnic_destroy_async_wq:
>  	destroy_workqueue(bc->bc_async_wq);
> +	while (i--)
> +		kfree(sriov->vf_info[i].vp);

These lines should be before destroy_workqueue(bc->bc_async_wq);

Thanks

>  
>  qlcnic_destroy_trans_wq:
>  	destroy_workqueue(bc->bc_trans_wq);
> -- 
> 2.17.1
> 
