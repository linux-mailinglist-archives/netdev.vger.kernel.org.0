Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79166887AC
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 20:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbjBBTmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 14:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjBBTmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 14:42:18 -0500
Received: from forward500c.mail.yandex.net (forward500c.mail.yandex.net [178.154.239.208])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E807F80000
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 11:42:16 -0800 (PST)
Received: from sas8-838e1e461505.qloud-c.yandex.net (sas8-838e1e461505.qloud-c.yandex.net [IPv6:2a02:6b8:c1b:28d:0:640:838e:1e46])
        by forward500c.mail.yandex.net (Yandex) with ESMTP id B71FE5EE00;
        Thu,  2 Feb 2023 22:42:14 +0300 (MSK)
Received: by sas8-838e1e461505.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id CgdwHgbZ04Y1-DT0IkRSL;
        Thu, 02 Feb 2023 22:42:13 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1675366934;
        bh=NgOGR9SzMqnxyq3/zSauRlemvFQvwaKHTZ2YF1ws0zQ=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=Up1zd9DpeV+VyPpz6L7F/4y5w9eA6SBNkyvY1ElqcWv5GTu+5xa8mKNknLHeSu9YH
         Mfvp+G8Yz1vLcnbLYo4kG4QUJopiahuA37N9/E7X0O+PlOGhIENOqzXdt9s/WfXfOs
         CuzIQgtLF9TBwu5RxnbrptBQTjgpqoITgrYjcKyQ=
Authentication-Results: sas8-838e1e461505.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Message-ID: <f2972f3d-27cf-1453-9f7b-b502e1dfe14b@ya.ru>
Date:   Thu, 2 Feb 2023 22:42:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next] unix: Guarantee sk_state relevance in case of it
 was assigned by a task on other cpu
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuniyu@amazon.com, gorcunov@gmail.com
References: <72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru>
 <20230124173557.2b13e194@kernel.org>
 <6953ec3b-6c48-954e-f3db-63450a5ab886@ya.ru>
 <20230125221053.301c0341@kernel.org>
From:   Kirill Tkhai <tkhai@ya.ru>
In-Reply-To: <20230125221053.301c0341@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.01.2023 09:10, Jakub Kicinski wrote:
> On Thu, 26 Jan 2023 00:09:08 +0300 Kirill Tkhai wrote:
>> 1)There are a many combinations with third task involved:
>>
>> [CPU0:Task0]  [CPU1:Task1]                           [CPU2:Task2]
>> listen(sk)
>>               kernel:
>>                 sk_diag_fill(sk)
>>                   rep->udiag_state = TCP_LISTEN
>>                 return_from_syscall
>>               userspace:
>>                 mutex_lock()
>>                 shared_mem_var = rep->udiag_state 
>>                 mutex_unlock()
>>
>>                                                      userspace: 
>>                                                        mutex_lock()
>>                                                        if (shared_mem_var == TCP_LISTEN)
>>                                                          accept(sk); /* -> fail, since sk_state is not visible */
>>                                                        mutex_unlock()
>>
>> In this situation Task2 definitely knows Task0's listen() has succeed, but there is no a possibility
>> to guarantee its accept() won't fail. Despite there are appropriate barriers in mutex_lock() and mutex_unlock(),
>> there is no a possibility to add a barrier on CPU1 to make Task0's store visible on CPU2.
> 
> Me trying to prove that memory ordering is transitive would be 100%
> speculation. Let's ask Paul instead - is the above valid? Or the fact
> that CPU1 observes state from CPU0 and is strongly ordered with CPU2
> implies that CPU2 will also observe CPU0's state?

Thanks Paul for the answer about shared mutex. Despite that situation is safe, the issue with pidfd_getfd() still exists.
 
>> 2)My understanding is chronologically later accept() mustn't miss sk_state.
>> Otherwise, kernel says that ordering between internal syscalls data
>> is userspace duty, which is wrong. Userspace knows nothing about internal
>> kernel data.
> 
>> 3)Such possible situations in log file also look strange:
> 
> Dunno those points are a bit subjective. Squeezing perf out of
> distributed systems requires sacrifices 🤷️

