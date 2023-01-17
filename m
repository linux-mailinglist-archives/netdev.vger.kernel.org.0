Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C9866DC40
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbjAQLWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236751AbjAQLWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:22:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C674482
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:21:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A0C2B81339
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AADC433EF;
        Tue, 17 Jan 2023 11:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673954510;
        bh=ZWJi7ZCtRLFbsHm35s3Nc7NymR00gAJ3znD40Zkk6aw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ALYgchzM24NkjyTZERXmay5yWL3u85wJlyykexLoEyGhvBEZe6HqZpuRdpZXU2mVb
         Qg0+XWWw/VvAKrr2NQosu+Bu0+U/WFwipOxeET2gi73/vU3mJHLw88lhmpzxwdsM+R
         A4Ilr378msm+avxyIlHrxf+XNwnYr26tq6I47zN358N8dgz++32yJ5kL0iuarQWTxK
         DkNIYZkbWqOirG0WC/3C9Em2T7D9z2wg9I2n9vwSNBg8PNqWpC2NKjhEDlji+PwPyd
         u3gyhfAGuFHFwh/KUYiHl1Tx7hZGuvPAR7N/2/9TRuEGOAyXrL0YeZqs4/1ECtZ0iz
         MAGqwgkU8PSYQ==
Date:   Tue, 17 Jan 2023 13:21:46 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "wangjie (L)" <wangjie125@huawei.com>
Cc:     Hao Lan <lanhao@huawei.com>, davem@davemloft.net, kuba@kernel.org,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        edumazet@google.com, pabeni@redhat.com, richardcochran@gmail.com,
        shenjian15@huawei.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: hns3: add vf fault process in hns3 ras
Message-ID: <Y8aEymyUf+WB8T8g@unreal>
References: <20230113020829.48451-1-lanhao@huawei.com>
 <20230113020829.48451-3-lanhao@huawei.com>
 <Y8D/dXTBxrLOwmgc@unreal>
 <a5a603bb-ae04-f274-5d68-f8d63a4bf13b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5a603bb-ae04-f274-5d68-f8d63a4bf13b@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 03:04:15PM +0800, wangjie (L) wrote:
> 
> 
> On 2023/1/13 14:51, Leon Romanovsky wrote:
> > On Fri, Jan 13, 2023 at 10:08:29AM +0800, Hao Lan wrote:
> > > From: Jie Wang <wangjie125@huawei.com>
> > > 
> > > Currently hns3 driver supports vf fault detect feature. Several ras caused
> > > by VF resources don't need to do PF function reset for recovery. The driver
> > > only needs to reset the specified VF.
> > > 
> > > So this patch adds process in ras module. New process will get detailed
> > > information about ras and do the most correct measures based on these
> > > accurate information.
> > > 
> > > Signed-off-by: Jie Wang <wangjie125@huawei.com>
> > > Signed-off-by: Hao Lan <lanhao@huawei.com>
> > > ---
> > >  drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   1 +
> > >  .../hns3/hns3_common/hclge_comm_cmd.h         |   1 +
> > >  .../hisilicon/hns3/hns3pf/hclge_err.c         | 113 +++++++++++++++++-
> > >  .../hisilicon/hns3/hns3pf/hclge_err.h         |   2 +
> > >  .../hisilicon/hns3/hns3pf/hclge_main.c        |   3 +-
> > >  .../hisilicon/hns3/hns3pf/hclge_main.h        |   1 +
> > >  6 files changed, 115 insertions(+), 6 deletions(-)
> > 
> > Why is it good idea to reset VF from PF?
> > What will happen with driver bound to this VF?
> > Shouldn't PCI recovery handle it?
> > 
> > Thanks
> > .
> PF doesn't reset VF directly. These VF faults are detected by hardware,
> and only reported to PF. PF get the VF id from firmware, then notify the VF
> that it needs reset. VF will do reset after receive the request.

This description isn't aligned with the code. You are issuing
hclge_func_reset_cmd() command which will reset VF, while notification
are handled by hclge_func_reset_notify_vf().

It also doesn't make any sense to send notification event to VF through
FW while the goal is to recover from stuck FW in that VF.

> 
> These hardware faults are not standard PCI ras event, so we prefer to use
> MSIx path.

What is different here?

> > 
