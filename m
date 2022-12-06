Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C46B643B2B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiLFCIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiLFCIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:08:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFB85590
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 18:08:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4EB061407
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6785AC433D6;
        Tue,  6 Dec 2022 02:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670292524;
        bh=sA2CJmOxPyHRsCGUJOn5KyHKL4aDgmqtTfNBMigmphI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VquWoWZSP7qvXaV9kUF0pdEnVy3jlDpgDK8dEsZ/oZOmrydJ9GAj5fj0saJuo2jqd
         cregB3rfCZ/DGjSYqcYHWPTKDbrNFiI1/3sDwoXVqvvwfNrFOWRxycMF+oeOjX0B/J
         DIC8AOwAfFh9RsM6ek3yhfwTlfkX5VPVQvVWSZ17BWnegIHi5+8NJI1C0IImwyF/Hm
         WX2+71WfAyQKeC6mhzLMWybzKlm7DM8QJyIbAqrgV/eiyHAVuW9KTkvxtmClBzEDdY
         byAoV/YYcdoNf8ZuQAOeM7HTD3Cl0+2xcd/GnRvXuAShkQZDzcWa3R16nnJo25YTrV
         J1kf0xYrqj/Lw==
Date:   Mon, 5 Dec 2022 18:08:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nir Levy <bhr166@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH] atm: Fix use-after-free bug in atm_dev_register()
Message-ID: <20221205180842.014cd7e9@kernel.org>
In-Reply-To: <CAJey7buiiSqO+tXDUYDTue6Hy06Jbyo5yeaGBeBz5b8wLiW+pQ@mail.gmail.com>
References: <20221203110924.7759-1-bhr166@gmail.com>
        <Y42X+OMcsHiht/jv@unreal>
        <CAJey7buiiSqO+tXDUYDTue6Hy06Jbyo5yeaGBeBz5b8wLiW+pQ@mail.gmail.com>
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

On Tue, 6 Dec 2022 00:08:32 +0200 Nir Levy wrote:
> From 5cb38a02b10a2f52bf7f7eef67fa4abc0974b21b Mon Sep 17 00:00:00 2001
> From: Nir Levy <bhr166@gmail.com>
> Date: Fri, 25 Nov 2022 21:06:48 +0200
> Subject: [PATCH net] net: atm: Fix use-after-free bug in atm_dev_register()
> 
> When device_register() return failed in atm_register_sysfs,
> the program will return to atm_dev_register and will kfree
> the device. As the comment of device_register() says,
> put_device() needs to be used to give up the reference
> in the error path. Using kfree instead triggers a UAF,
> as shown by the following KASAN report, obtained by causing
> device_register() to fail. This patch calls put_device
> when atm_register_sysfs has failed, and call kfree
> only when atm_proc_dev_register has failed.

Please make a fresh submission, it doesn't have to be in the same
thread (in fact that's discouraged).
