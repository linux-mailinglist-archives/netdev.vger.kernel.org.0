Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB70F65E760
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbjAEJJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbjAEJJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:09:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6997C5017D;
        Thu,  5 Jan 2023 01:09:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0905E61929;
        Thu,  5 Jan 2023 09:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F44C433D2;
        Thu,  5 Jan 2023 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672909760;
        bh=Br5C/uDEZK1Yfd+HJpl97NIZZHEqGbxQ5YfknJjVjAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Txu4a/n2IHl5nt5WRP3pqB7IP4KyrZNf0l0ncRjbTsjYiQkIFxjMcPK4wNOXch7L3
         yb6QtPrpGTg8QyWHDg2p2MGW+1dyxXejtSCJ0wKCGV09mHXSzLQeuBPF2m/FEoYBWf
         MUwYMLp7EuLk+C7cE+ikg8VWLytjHOTHWVtVB2LozF5cN/oEevADVB+2jEOP+LLEAN
         vz2uZ1shdVpSazzRSv+CCunu4VqzwKekxQjclZQuuMOhfmWngiN/yJ0lHL0m/BMNe7
         sTb0R8VhZWNsO9ZnFzSdPGRX9ohZ8zR2H/i4Zg3EM43BMeB/279TKc1mxYrHiQ6m83
         bd2sX4vJXW3kg==
Date:   Thu, 5 Jan 2023 11:09:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: rtw89: Add missing check for alloc_workqueue
Message-ID: <Y7aTvDWQnHQfN3su@unreal>
References: <20230104142353.25093-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104142353.25093-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 10:23:53PM +0800, Jiasheng Jiang wrote:
> On Wed, Jan 04, 2023 at 07:41:36PM +0800, Leon Romanovsky wrote:
> > On Wed, Jan 04, 2023 at 05:33:53PM +0800, Jiasheng Jiang wrote:
> >> Add check for the return value of alloc_workqueue since it may return
> >> NULL pointer.
> >> 
> >> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> >> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> >> ---
> >>  drivers/net/wireless/realtek/rtw89/core.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >> 
> >> diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
> >> index 931aff8b5dc9..006fe0499f81 100644
> >> --- a/drivers/net/wireless/realtek/rtw89/core.c
> >> +++ b/drivers/net/wireless/realtek/rtw89/core.c
> >> @@ -3124,6 +3124,8 @@ int rtw89_core_init(struct rtw89_dev *rtwdev)
> >>  	INIT_DELAYED_WORK(&rtwdev->cfo_track_work, rtw89_phy_cfo_track_work);
> >>  	INIT_DELAYED_WORK(&rtwdev->forbid_ba_work, rtw89_forbid_ba_work);
> >>  	rtwdev->txq_wq = alloc_workqueue("rtw89_tx_wq", WQ_UNBOUND | WQ_HIGHPRI, 0);
> >> +	if (!rtwdev->txq_wq)
> >> +		return -ENOMEM;
> > 
> > While the change is fixing one issue, you are adding another one.
> > There is no destroy of this workqueue if rtw89_load_firmware fails.
> 
> Actually, I do not think the missing of destroy_workqueue is introduced by me.
> Even without my patch, the destroy_workqueue is still missing.

Not really, without your change, rtw89_core_init() never failed.

> Anyway, I will submit a v2 that adds the missing destroy_workqueue.

Thanks

> 
> Thanks,
> Jiang
> 
