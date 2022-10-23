Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955C56091C0
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 10:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiJWIEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 04:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiJWIE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 04:04:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D9F393
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 01:04:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F46AB80880
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 08:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271BFC433C1;
        Sun, 23 Oct 2022 08:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666512259;
        bh=0TXIKmgRjz2SlSfKJW4zadQ+5nHQZMmUUuKMl+lGmTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sSGLdOBLRVSUFDa5wJnv8HRw8H3sIOTI3RZp7Xjpe5erTVIvMEdQzLRQi8r1eXNhs
         NhDchaovtZcHwLmkhtz5Y9d55tvGKVQ0B6+h+XLF+up9qEy3KRNu/IHD2ZcU8ZVrrC
         XFjhxP5rVk3OsiY4iTHPtTngcLF1Ay59UX/xkctmvr/+HZf3Ed07yEQ6ZDWhUfFsyP
         tXOyA3BcCu5Xwo7JxVN8sMOhGxNXDj3dKRumCKHFc6E5D7Ur7cn1aqqsyE566z+ALP
         ciM2NYiuUuZy6Wnkh3K7WrzLWGuuIEhEXDW+3sb4sbqytMGLqNe9HB0hTgAgEOjBC5
         TWK9/Keze8HGw==
Date:   Sun, 23 Oct 2022 11:04:15 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net
Subject: Re: [PATCH net] net: hns: fix possible memory leak in
 hnae_ae_register()
Message-ID: <Y1T1fxYXAICqHmLi@unreal>
References: <20221018122451.1749171-1-yangyingliang@huawei.com>
 <Y06i/kWwJNT5mbj8@unreal>
 <20221019172832.712eb056@kernel.org>
 <3e9539a9-e3b9-1418-cd3b-426d2efeaef1@huawei.com>
 <20221020124307.7822e881@kernel.org>
 <576a5bf8-8317-fe35-26c9-749cc8cf4fd6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <576a5bf8-8317-fe35-26c9-749cc8cf4fd6@huawei.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 11:01:47AM +0800, Yang Yingliang wrote:
> 
> On 2022/10/21 3:43, Jakub Kicinski wrote:
> > On Thu, 20 Oct 2022 15:48:38 +0800 Yang Yingliang wrote:
> > > On 2022/10/20 8:28, Jakub Kicinski wrote:
> > > > On Tue, 18 Oct 2022 15:58:38 +0300 Leon Romanovsky wrote:
> > > > > The change itself is ok.
> > > > Also the .release function is empty which is another bad smell?
> > > The upper device (struct dsaf_device *dsaf_dev) is allocated by
> > > devm_kzalloc(), so it's no need to free it in ->release().
> > Nah ah. devm_* is just for objects which tie their lifetime naturally
> > to the lifetime of the driver instance, IOW the device ->priv.
> > 
> > struct device allocated by the driver is not tied to that, it's
> > a properly referenced object. I don't think that just because
> > the driver that allocated it got ->remove()d you're safe to free
> > allocated struct devices.
> In this driver, I see the 'cls_dev' is used as driver data and it
> unregistered
> before got removed to free the device memory, I think it's safe for now.

Empty release means reference counting doesn't really count anything.
According to your reply, cls_dev is protected from outside and its life
time bounded to upper level.

The thing is that you was expected to create that cls_dev when you did
device_initalization and release it with not-empty release function.

Thanks

> 
> Thanks,
> Yang
> > .
