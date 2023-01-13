Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62AC668EC5
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 08:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbjAMHD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 02:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240794AbjAMHCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 02:02:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4AD5C930
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 22:51:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99091B82011
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98359C433D2;
        Fri, 13 Jan 2023 06:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673592698;
        bh=zFOCELnZFjkYt042ZqCbi3CzFsPEQ9K/7bN5en4yd7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I2OUDhOGKjfUYp/aIn5MHwER/X++JSIuUcxgIXvyqqTBt+9P36aUj/MKHsh3ssvj/
         ZGI5ssLfEFNrI2EKxdZBUwGUdRc/n+oq2hCXER2Dq9LpzuMrQEoOSPEHviKG/eFswl
         6o652gDB8MV/igZbjbpcyZaCgwVwwigYsTu5l6RxlV7qf5wDrZffOn1Pop+D/4cVWB
         cfiXijz96OBdhEuJGsREKl58MLeNMMtAf9JmFfitqC8SOA50tLNqDWnBBswjtgJPuK
         O4t+dDzltlAwikNcXNrTxevCu4liZKmYqoccaFEOEF2tS7tT3GObofWGQoVayCCAPn
         rTC+ro5qq1FbA==
Date:   Fri, 13 Jan 2023 08:51:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Hao Lan <lanhao@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, edumazet@google.com, pabeni@redhat.com,
        richardcochran@gmail.com, shenjian15@huawei.com,
        wangjie125@huawei.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: hns3: add vf fault process in hns3 ras
Message-ID: <Y8D/dXTBxrLOwmgc@unreal>
References: <20230113020829.48451-1-lanhao@huawei.com>
 <20230113020829.48451-3-lanhao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113020829.48451-3-lanhao@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 10:08:29AM +0800, Hao Lan wrote:
> From: Jie Wang <wangjie125@huawei.com>
> 
> Currently hns3 driver supports vf fault detect feature. Several ras caused
> by VF resources don't need to do PF function reset for recovery. The driver
> only needs to reset the specified VF.
> 
> So this patch adds process in ras module. New process will get detailed
> information about ras and do the most correct measures based on these
> accurate information.
> 
> Signed-off-by: Jie Wang <wangjie125@huawei.com>
> Signed-off-by: Hao Lan <lanhao@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   1 +
>  .../hns3/hns3_common/hclge_comm_cmd.h         |   1 +
>  .../hisilicon/hns3/hns3pf/hclge_err.c         | 113 +++++++++++++++++-
>  .../hisilicon/hns3/hns3pf/hclge_err.h         |   2 +
>  .../hisilicon/hns3/hns3pf/hclge_main.c        |   3 +-
>  .../hisilicon/hns3/hns3pf/hclge_main.h        |   1 +
>  6 files changed, 115 insertions(+), 6 deletions(-)

Why is it good idea to reset VF from PF?
What will happen with driver bound to this VF?
Shouldn't PCI recovery handle it?

Thanks
