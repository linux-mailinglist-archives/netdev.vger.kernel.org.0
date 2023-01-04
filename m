Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F17165D1AC
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 12:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbjADLln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 06:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbjADLlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 06:41:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD90C33;
        Wed,  4 Jan 2023 03:41:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1425A613F8;
        Wed,  4 Jan 2023 11:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CDCC433F2;
        Wed,  4 Jan 2023 11:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672832500;
        bh=UOkLJ8/shdFIUGOHuDtn1pstz2A0lwIELqP5/G4QGxg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IUvMkekXwUhgXkcFN6GX8/l6d2AIgq5hX80C4CNjR7HrY78UcWjMUwemItN56TNWh
         eqDojVtBvTEMX3KErRmtOerTa/L//2fIoG4NXZSLqqWLncwRljPP/FVZLJrOf0811h
         1SHP8SIZI5UrjHBKZZAqUIi+iccyIQHfJ7ZCyd4NlgNWDpdDpo5vSwMmyW9TaHIaD7
         zDF6l39V99cM/4vpKVkdG2n7HJBTFdYY5KzFtG2hr+yu5enbRLNXg2M9rjbNZZ1CwO
         kmbS1QzG+m9gq4+5YeKxyWP217Ugt70A69jBcHiYQE/ErghSMjGblretA6q7oBa+sY
         rN/ciz4yMoEVg==
Date:   Wed, 4 Jan 2023 13:41:36 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: rtw89: Add missing check for alloc_workqueue
Message-ID: <Y7Vl8CHL935On/7o@unreal>
References: <20230104093353.48239-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104093353.48239-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 05:33:53PM +0800, Jiasheng Jiang wrote:
> Add check for the return value of alloc_workqueue since it may return
> NULL pointer.
> 
> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/net/wireless/realtek/rtw89/core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
> index 931aff8b5dc9..006fe0499f81 100644
> --- a/drivers/net/wireless/realtek/rtw89/core.c
> +++ b/drivers/net/wireless/realtek/rtw89/core.c
> @@ -3124,6 +3124,8 @@ int rtw89_core_init(struct rtw89_dev *rtwdev)
>  	INIT_DELAYED_WORK(&rtwdev->cfo_track_work, rtw89_phy_cfo_track_work);
>  	INIT_DELAYED_WORK(&rtwdev->forbid_ba_work, rtw89_forbid_ba_work);
>  	rtwdev->txq_wq = alloc_workqueue("rtw89_tx_wq", WQ_UNBOUND | WQ_HIGHPRI, 0);
> +	if (!rtwdev->txq_wq)
> +		return -ENOMEM;

While the change is fixing one issue, you are adding another one.
There is no destroy of this workqueue if rtw89_load_firmware fails.

Thanks

>  	spin_lock_init(&rtwdev->ba_lock);
>  	spin_lock_init(&rtwdev->rpwm_lock);
>  	mutex_init(&rtwdev->mutex);
> -- 
> 2.25.1
> 
