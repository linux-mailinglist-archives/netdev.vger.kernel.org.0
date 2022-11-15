Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3C8629007
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 03:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbiKOCuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 21:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiKOCub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 21:50:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B2F16588
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 18:50:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 256B061507
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AB8C433D6;
        Tue, 15 Nov 2022 02:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668480629;
        bh=Od/W7m8CamE4fg5e0TwB5IPcwrz5wXhILt/j88Ff79I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ES3w5GvzOBBBubNEUsW6OYOwlNjphATE1BWehx5mPHqLoP7r3hEpElQKGdF3FejF+
         RU684DsrJ2V4WGF2hj2y3GKNFMosJ1+MjQ68Yz2iw9Cc4yHGXZNArS/yubDUvi4iZk
         iixLPZsTZr6x9TWmuUax2mkUgJnhFuDiwBpi+stgnMzlzAK5yVRT1Nxu3zc7PA95ed
         8PYm5W+q6AfY6XOlylsZmTrBa0L1vGSINsYN0pUBWJJRspPeCnC468+YUOGX2sHSYj
         ZT+AjMI4R/Bc+5CvZNptw4iYucvr4IA2yISdWusUzzyodPHbyx2LD4lDwDUN56JYF2
         G4VxZv2zHw39g==
Date:   Mon, 14 Nov 2022 18:50:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH] netdevsim: Fix memory leak of nsim_dev->fa_cookie
Message-ID: <20221114185028.54fd7e14@kernel.org>
In-Reply-To: <1668234485-27635-1-git-send-email-wangyufen@huawei.com>
References: <1668234485-27635-1-git-send-email-wangyufen@huawei.com>
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

On Sat, 12 Nov 2022 14:28:05 +0800 Wang Yufen wrote:
> nsim_dev_trap_fa_cookie_write()
>   kmalloc() fa_cookie
>   nsim_dev->fa_cookie = fa_cookie
> ..
> nsim_drv_remove()
> 
> nsim_dev->fa_cookie alloced, but the nsim_dev_trap_report_work()
> job has not been done, the flow action cookie has not been assigned
> to the metadata. To fix, add kfree(nsim_dev->fa_cookie) to
> nsim_drv_remove().

I don't see the path thru nsim_dev_trap_report_work() which would free
the fa_cookie.

The fix looks right, but the commit message seems incorrect. Isn't the
leak always there, without any race?
