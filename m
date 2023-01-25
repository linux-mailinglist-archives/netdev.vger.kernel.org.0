Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D840C67A89F
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjAYCOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYCOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:14:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A8927986;
        Tue, 24 Jan 2023 18:14:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F37E26141D;
        Wed, 25 Jan 2023 02:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A356C4339B;
        Wed, 25 Jan 2023 02:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674612857;
        bh=/EQfk8Ioa05BdvwcvR/L4z3//Qrqq5xB91M9bgBc4yw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H0iviNjXQ+tvlwSWMqN1qIX4soSv5c8c0OqLxZ6kIrt02myr1ovCSkBL5SQibIXyt
         0Dc4pmESjhMLrw58xby/HWYioFPGZbaNiXp4+SXKO94a+qq0/+Ke4REObYrQ0k0bK0
         XLfE1jJjVc7Ex5eJsOdAbb+adoFik2LSvsiM7Bncfd2ksnnYoUnX4t0J5lwsBhzBTL
         RoKPxCTrIcR9h1PMtimFc7AIdSwPDp7BhNkP3M9vGm2RrzesAV1Dlrq5pPKv7ZYswK
         uFY0k7e94cbqpn96nVIMCWO5KVdREv21Pm/iSSLZVvL9nS+m1reis7E9XK9UEyKLqa
         qk83BmOXwuuRQ==
Date:   Tue, 24 Jan 2023 18:14:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        Pietro Borrello <borrello@diag.uniroma1.it>
Subject: Re: [PATCH net] sctp: fail if no bound addresses can be used for a
 given scope
Message-ID: <20230124181416.6218adb7@kernel.org>
In-Reply-To: <9fcd182f1099f86c6661f3717f63712ddd1c676c.1674496737.git.marcelo.leitner@gmail.com>
References: <9fcd182f1099f86c6661f3717f63712ddd1c676c.1674496737.git.marcelo.leitner@gmail.com>
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

On Mon, 23 Jan 2023 14:59:33 -0300 Marcelo Ricardo Leitner wrote:
> Currently, if you bind the socket to something like:
>         servaddr.sin6_family = AF_INET6;
>         servaddr.sin6_port = htons(0);
>         servaddr.sin6_scope_id = 0;
>         inet_pton(AF_INET6, "::1", &servaddr.sin6_addr);
> 
> And then request a connect to:
>         connaddr.sin6_family = AF_INET6;
>         connaddr.sin6_port = htons(20000);
>         connaddr.sin6_scope_id = if_nametoindex("lo");
>         inet_pton(AF_INET6, "fe88::1", &connaddr.sin6_addr);
> 
> What the stack does is:
>  - bind the socket
>  - create a new asoc
>  - to handle the connect
>    - copy the addresses that can be used for the given scope
>    - try to connect
> 
> But the copy returns 0 addresses, and the effect is that it ends up
> trying to connect as if the socket wasn't bound, which is not the
> desired behavior. This unexpected behavior also allows KASLR leaks
> through SCTP diag interface.
> 
> The fix here then is, if when trying to copy the addresses that can
> be used for the scope used in connect() it returns 0 addresses, bail
> out. This is what TCP does with a similar reproducer.
> 
> Reported-by: Pietro Borrello <borrello@diag.uniroma1.it>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Fixes tag?
