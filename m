Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3377E603BF8
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 10:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiJSImC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 04:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiJSIkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 04:40:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A2B8276C
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 01:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C60E7B822BC
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 08:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E9FC433C1;
        Wed, 19 Oct 2022 08:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666168753;
        bh=wroCQuOxIloBexMk0mYsaVpwZ6tvz/fGoDs4QlR6VxU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LI34cb6hjjkRY6nGN1iOp2sgI+Ku+vY8xahVjcZeAtS4Py1AojVaCQrFKaMvhURtq
         j0ppbFXfI/wqKbmfD5ko/QrPisbgm3dBWokGHTpp1ZaPHu8gIZvMAWNfsqck4cXC8z
         pTshySaNM1DojOjN7mRFt6wnsCmxRz8mi4/033kxp3j8Rsogty1SaqEoF7gFL4XC/E
         iBlHk7+xkrvcAMo/3+5Elf5z1+rh3iDjicHNlsEH+2ltGC5dU2buBM4e5ME1obiku6
         GqMLT0Dm1klI6PTSP/PrUVGgUiNiWekjfVaVSaEZjE7/GCxajNbD1IUmOUTifJjCMX
         58r081Bq91D4g==
Date:   Wed, 19 Oct 2022 11:39:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, keescook@chromium.org,
        gustavoars@kernel.org, gregkh@linuxfoundation.org, ast@kernel.org,
        peter.chen@kernel.org, bin.chen@corigine.com, luobin9@huawei.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net 3/4] net: hinic: fix the issue of CMDQ memory leaks
Message-ID: <Y0+3rd/tmB289uPX@unreal>
References: <20221019024220.376178-1-shaozhengchao@huawei.com>
 <20221019024220.376178-4-shaozhengchao@huawei.com>
 <Y0+lRITJ1kPNCY0c@unreal>
 <8d79818c-21a3-9a78-7b80-15f5c60875a4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d79818c-21a3-9a78-7b80-15f5c60875a4@huawei.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 03:41:06PM +0800, shaozhengchao wrote:
> 
> 
> On 2022/10/19 15:20, Leon Romanovsky wrote:
> > On Wed, Oct 19, 2022 at 10:42:19AM +0800, Zhengchao Shao wrote:
> > > When hinic_set_cmdq_depth() fails in hinic_init_cmdqs(), the cmdq memory is
> > > not released correctly. Fix it.
> > > 
> > > Fixes: 72ef908bb3ff ("hinic: add three net_device_ops of vf")
> > > Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> > > ---
> > >   drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 5 +++++
> > >   1 file changed, 5 insertions(+)
> > 
> > <...>
> > 
> > > +	cmdq_type = HINIC_CMDQ_SYNC;
> > > +	for (; cmdq_type < HINIC_MAX_CMDQ_TYPES; cmdq_type++)
> > 
> > Why do you have this "for loops" in all places? There is only one cmdq_type.
> > 
> > Thanks
> Hi Leon:
> 	Thank you for your review. Now, only the synchronous CMDQ is
> enabled for the current CMDQs. New type of CMDQ could be added later.

Single command type was added in 2017, and five years later, new type wasn't added yet.

> So looping style is maintained on both the allocation and release paths.
> 
> Zhengchao Shao
