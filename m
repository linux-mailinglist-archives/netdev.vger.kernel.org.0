Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452B368BE60
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjBFNgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjBFNgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:36:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CAFB468
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:36:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD59BB80D81
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FE1C4339E;
        Mon,  6 Feb 2023 13:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675690593;
        bh=+YU4JAc1ck8rfV+3n+/tAMV/DBHK4zfKIYLcBJOk5fE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h6wWeKviqL8HuOnSiGmSiPFN7arFSn5FnHoU6GSexV774tOBdXTaWKfhiF2/QUtLh
         tr2YtSLNleKnbLk3+ra3UXeJQU83bN6sQIbx3NCHLMk81sCpQhxkaGMVdd/x2s+a5Y
         KNnCrWlArFliZ6v8ETw1MPqtZUHKeMTZjWwUrV8LQLnOXSLmTrptEIX79l/TnR2OND
         RyH/HWEVTT7LnlYDxbazQgniRH1PzEdB0bXZkOL/XLUeoEVaRzcDuI942LDZjHcbL0
         rP25vF/7WRFWHGUnGf/C/ERQGxPSfmgYdRHGr+oCUNLpZUkKUZje8k+yLpVvbuquFz
         6lYIjzIlFYv2g==
Date:   Mon, 6 Feb 2023 15:36:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "wangjie (L)" <wangjie125@huawei.com>
Cc:     Hao Lan <lanhao@huawei.com>, davem@davemloft.net, kuba@kernel.org,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        edumazet@google.com, pabeni@redhat.com, richardcochran@gmail.com,
        shenjian15@huawei.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: hns3: add vf fault process in hns3 ras
Message-ID: <Y+ECXjVqA316k+Sf@unreal>
References: <20230113020829.48451-1-lanhao@huawei.com>
 <20230113020829.48451-3-lanhao@huawei.com>
 <Y8D/dXTBxrLOwmgc@unreal>
 <a5a603bb-ae04-f274-5d68-f8d63a4bf13b@huawei.com>
 <Y8aEymyUf+WB8T8g@unreal>
 <3ce018d9-e005-f988-37ed-016c559973ec@huawei.com>
 <Y8rLguafAPjNGRpK@unreal>
 <06188aca-7080-2506-1155-a739d84a420f@huawei.com>
 <Y9kWh59tootFniqK@unreal>
 <d23688f8-ca8e-cfa5-7fad-517810bee433@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d23688f8-ca8e-cfa5-7fad-517810bee433@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 09:08:37PM +0800, wangjie (L) wrote:
> 
> 
> On 2023/1/31 21:24, Leon Romanovsky wrote:
> > On Tue, Jan 31, 2023 at 08:04:14PM +0800, wangjie (L) wrote:
> > > 
> > > 
> > > On 2023/1/21 1:12, Leon Romanovsky wrote:
> > > > On Wed, Jan 18, 2023 at 08:34:03PM +0800, wangjie (L) wrote:
> > > > > 
> > > > > 
> > > > > On 2023/1/17 19:21, Leon Romanovsky wrote:
> > > > > > On Tue, Jan 17, 2023 at 03:04:15PM +0800, wangjie (L) wrote:
> > > > > > > 
> > > > > > > 
> > > > > > > On 2023/1/13 14:51, Leon Romanovsky wrote:
> > > > > > > > On Fri, Jan 13, 2023 at 10:08:29AM +0800, Hao Lan wrote:
> > > > > > > > > From: Jie Wang <wangjie125@huawei.com>
> > > > > > > > > 
> > > > > > > > > Currently hns3 driver supports vf fault detect feature. Several ras caused
> > > > > > > > > by VF resources don't need to do PF function reset for recovery. The driver
> > > > > > > > > only needs to reset the specified VF.
> > > > > > > > > 
> > > > > > > > > So this patch adds process in ras module. New process will get detailed
> > > > > > > > > information about ras and do the most correct measures based on these
> > > > > > > > > accurate information.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Jie Wang <wangjie125@huawei.com>
> > > > > > > > > Signed-off-by: Hao Lan <lanhao@huawei.com>
> > > > > > > > > ---
> > > > > > > > >  drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   1 +
> > > > > > > > >  .../hns3/hns3_common/hclge_comm_cmd.h         |   1 +
> > > > > > > > >  .../hisilicon/hns3/hns3pf/hclge_err.c         | 113 +++++++++++++++++-
> > > > > > > > >  .../hisilicon/hns3/hns3pf/hclge_err.h         |   2 +
> > > > > > > > >  .../hisilicon/hns3/hns3pf/hclge_main.c        |   3 +-
> > > > > > > > >  .../hisilicon/hns3/hns3pf/hclge_main.h        |   1 +
> > > > > > > > >  6 files changed, 115 insertions(+), 6 deletions(-)
> > > > > > > > 
> > > > > > > > Why is it good idea to reset VF from PF?
> > > > > > > > What will happen with driver bound to this VF?
> > > > > > > > Shouldn't PCI recovery handle it?
> > > > > > > > 
> > > > > > > > Thanks
> > > > > > > > .
> > > > > > > PF doesn't reset VF directly. These VF faults are detected by hardware,
> > > > > > > and only reported to PF. PF get the VF id from firmware, then notify the VF
> > > > > > > that it needs reset. VF will do reset after receive the request.
> > > > > > 
> > > > > > This description isn't aligned with the code. You are issuing
> > > > > > hclge_func_reset_cmd() command which will reset VF, while notification
> > > > > > are handled by hclge_func_reset_notify_vf().
> > > > > > 
> > > > > > It also doesn't make any sense to send notification event to VF through
> > > > > > FW while the goal is to recover from stuck FW in that VF.
> > > > > > 
> > > > > Yes, I misunderstand the hclge_func_reset_notify_vf and
> > > > > hclge_func_reset_cmd. It should use hclge_func_reset_notify_vf to inform
> > > > > the VF for recovery. I will fix and retest it in V2.
> > > > > 
> > > > > This patch is used to recover specific vf hardware errors, for example the
> > > > > tx queue configuration exceptions. It make sense in these cases for the
> > > > > firmware is still working properly and can do the recovery rightly.
> > > > 
> > > > If FW is operational and knows about failure, why can't FW do recovery
> > > > internally to that VF without PF involvement?
> > > I'm sorry to reply so late because I took a vacation. If firmware reset VF
> > > hardware directly without notify the running VF driver, it will cause VF
> > > driver works abnormal.
> > 
> > mlx5 health recovery code proves that it is possible to do.
> > Even in your case, FW can notify VF without PF in the middle.
> > 
> > Thanks
> > 
> These faults only report to PF in hns3 devices, even if devlink health is
> used in hns3 driver, these faults also need to report to PF.

I don't think that it is correct, but let's see your v2 without VF reset
and with PF notifications.

Thanks

> 
> Thanks
> > > 
> > > Thanks
> > > > 
> > > > Thanks
> > > > .
> > > > 
> > .
> > 
