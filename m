Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D74460690A
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 21:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiJTTnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 15:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJTTnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 15:43:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63C51119DC
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 12:43:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CC2D61B59
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 19:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B50CC433D6;
        Thu, 20 Oct 2022 19:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666294988;
        bh=hc4++yrN8gRrLH7jkLFuxdnX5JaAD2+H04PNzzxzxc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g5grLK7uWDTOKdG6u2Ztu6J0fq8jq9JU200MNjmzPI31B2K9jmnSi9fD3bG4Z4nMM
         SSbZu4sa1YwaQYVIm28pSV73LDrp3MO2zrAcsa55B4CWqHCHtQtNr4J2w75kXViBJj
         pc2cEKNhMUxR4M7O4hZ6wnYn+TxYqDU2AuS5lB7cBcWiCT5fmDG2DJna+QS7ETcwuR
         2Qb3wbgYTEJ02YjNKr25RUtRUYD7W9J8/g78b9kk1wzsI47J4qJYxW8fKhiQvkDexJ
         XKeuj78CxIgkcEU6Ll9ost0LouAgSCLlxVMGpFzjLC591xqBAZYD9vK25hQJB2jemK
         Xu09S4xs0L0Yw==
Date:   Thu, 20 Oct 2022 12:43:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     Leon Romanovsky <leon@kernel.org>, <netdev@vger.kernel.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>
Subject: Re: [PATCH net] net: hns: fix possible memory leak in
 hnae_ae_register()
Message-ID: <20221020124307.7822e881@kernel.org>
In-Reply-To: <3e9539a9-e3b9-1418-cd3b-426d2efeaef1@huawei.com>
References: <20221018122451.1749171-1-yangyingliang@huawei.com>
        <Y06i/kWwJNT5mbj8@unreal>
        <20221019172832.712eb056@kernel.org>
        <3e9539a9-e3b9-1418-cd3b-426d2efeaef1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Oct 2022 15:48:38 +0800 Yang Yingliang wrote:
> On 2022/10/20 8:28, Jakub Kicinski wrote:
> > On Tue, 18 Oct 2022 15:58:38 +0300 Leon Romanovsky wrote:  
> >> The change itself is ok.  
> >
> > Also the .release function is empty which is another bad smell?  
>
> The upper device (struct dsaf_device *dsaf_dev) is allocated by 
> devm_kzalloc(), so it's no need to free it in ->release().

Nah ah. devm_* is just for objects which tie their lifetime naturally
to the lifetime of the driver instance, IOW the device ->priv.

struct device allocated by the driver is not tied to that, it's 
a properly referenced object. I don't think that just because 
the driver that allocated it got ->remove()d you're safe to free
allocated struct devices.
