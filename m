Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B32267C46B
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 07:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjAZGK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 01:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjAZGK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 01:10:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71A028D2C
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 22:10:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76594B81BA5
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 06:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAA1C433EF;
        Thu, 26 Jan 2023 06:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674713455;
        bh=JKMJQQK/ppyCjBBY85vdtV9IzA4fhrWxUQpRW56AFTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TyRPoPy6AUgQv7TOy4lyO7NdPUemUEN1mAzyfOCjTPjwOu6n2YE4YGZTPe6CYqAAB
         rBrA24pTpVV3tz037X5X7HC595VZxsiN0ypMxZMZtWQRG+iYHDAGRW6lmwcJg1hv1f
         yGEsCm5Nf5hygaIRYxHUNEmyG8uukPklZ+eb3uyG6uPG3ObQ5k/Z/9uxVSP5zgD/0w
         TfQV9qMHnhIlz6uh/8d4gn/qTpC5mWGHUZj8V8j9+w6co+7SdBi/HVrr+Z3cG1oLSN
         WC7awxgLQyjegdbmXSQmNuAlgIZDeRQnLYa4UtSep5p7oialB8YgG5vOugp3F1Acht
         jtUJfTjo6//Iw==
Date:   Wed, 25 Jan 2023 22:10:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kirill Tkhai <tkhai@ya.ru>, "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuniyu@amazon.com, gorcunov@gmail.com
Subject: Re: [PATCH net-next] unix: Guarantee sk_state relevance in case of
 it was assigned by a task on other cpu
Message-ID: <20230125221053.301c0341@kernel.org>
In-Reply-To: <6953ec3b-6c48-954e-f3db-63450a5ab886@ya.ru>
References: <72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru>
        <20230124173557.2b13e194@kernel.org>
        <6953ec3b-6c48-954e-f3db-63450a5ab886@ya.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Jan 2023 00:09:08 +0300 Kirill Tkhai wrote:
> 1)There are a many combinations with third task involved:
>=20
> [CPU0:Task0]  [CPU1:Task1]                           [CPU2:Task2]
> listen(sk)
>               kernel:
>                 sk_diag_fill(sk)
>                   rep->udiag_state =3D TCP_LISTEN
>                 return_from_syscall
>               userspace:
>                 mutex_lock()
>                 shared_mem_var =3D rep->udiag_state=20
>                 mutex_unlock()
>=20
>                                                      userspace:=20
>                                                        mutex_lock()
>                                                        if (shared_mem_var=
 =3D=3D TCP_LISTEN)
>                                                          accept(sk); /* -=
> fail, since sk_state is not visible */
>                                                        mutex_unlock()
>=20
> In this situation Task2 definitely knows Task0's listen() has succeed, bu=
t there is no a possibility
> to guarantee its accept() won't fail. Despite there are appropriate barri=
ers in mutex_lock() and mutex_unlock(),
> there is no a possibility to add a barrier on CPU1 to make Task0's store =
visible on CPU2.

Me trying to prove that memory ordering is transitive would be 100%
speculation. Let's ask Paul instead - is the above valid? Or the fact
that CPU1 observes state from CPU0 and is strongly ordered with CPU2
implies that CPU2 will also observe CPU0's state?

> 2)My understanding is chronologically later accept() mustn't miss sk_stat=
e.
> Otherwise, kernel says that ordering between internal syscalls data
> is userspace duty, which is wrong. Userspace knows nothing about internal
> kernel data.

> 3)Such possible situations in log file also look strange:

Dunno those points are a bit subjective. Squeezing perf out of
distributed systems requires sacrifices =F0=9F=A4=B7=EF=B8=8F
