Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA5267BDBD
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjAYVKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbjAYVKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:10:22 -0500
Received: from forward500b.mail.yandex.net (forward500b.mail.yandex.net [178.154.239.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEF0241D3
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:09:15 -0800 (PST)
Received: from iva1-5283d83ef885.qloud-c.yandex.net (iva1-5283d83ef885.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:16a7:0:640:5283:d83e])
        by forward500b.mail.yandex.net (Yandex) with ESMTP id 1FD7C5F385;
        Thu, 26 Jan 2023 00:09:10 +0300 (MSK)
Received: by iva1-5283d83ef885.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 89XlGnEZViE1-mHujj7cd;
        Thu, 26 Jan 2023 00:09:09 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1674680949;
        bh=XuMcXDeCOagBRc89TCxuVF77C8IgTs9tgftyRueZ+Bk=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=jeZdgYnr9gmFLAvMiIPsZhD/TGN2zwOMHLGJYfbx6EtgJKj0IOUrb7GdDlHugUpeh
         VvLdJVItwfLcBNIW3EgWtiR1gUG5weohTpT9Iaphfb/ojtIejYhK1uJJGPlECLhzVq
         TzEuqpjJpT03g3HZ546o0Put9eIYz+NzV9tiMLMQ=
Authentication-Results: iva1-5283d83ef885.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Message-ID: <6953ec3b-6c48-954e-f3db-63450a5ab886@ya.ru>
Date:   Thu, 26 Jan 2023 00:09:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next] unix: Guarantee sk_state relevance in case of it
 was assigned by a task on other cpu
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuniyu@amazon.com, gorcunov@gmail.com
References: <72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru>
 <20230124173557.2b13e194@kernel.org>
Content-Language: en-US
From:   Kirill Tkhai <tkhai@ya.ru>
In-Reply-To: <20230124173557.2b13e194@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.01.2023 04:35, Jakub Kicinski wrote:
> On Mon, 23 Jan 2023 01:21:20 +0300 Kirill Tkhai wrote:
>> Since in this situation unix_accept() is called chronologically later, such
>> behavior is not obvious and it is wrong.
> 
> Noob question, perhaps - how do we establish the ordering ?
> CPU1 knows that listen() has succeed without a barrier ?

1)There are a many combinations with third task involved:

[CPU0:Task0]  [CPU1:Task1]                           [CPU2:Task2]
listen(sk)
              kernel:
                sk_diag_fill(sk)
                  rep->udiag_state = TCP_LISTEN
                return_from_syscall
              userspace:
                mutex_lock()
                shared_mem_var = rep->udiag_state 
                mutex_unlock()

                                                     userspace: 
                                                       mutex_lock()
                                                       if (shared_mem_var == TCP_LISTEN)
                                                         accept(sk); /* -> fail, since sk_state is not visible */
                                                       mutex_unlock()

In this situation Task2 definitely knows Task0's listen() has succeed, but there is no a possibility
to guarantee its accept() won't fail. Despite there are appropriate barriers in mutex_lock() and mutex_unlock(),
there is no a possibility to add a barrier on CPU1 to make Task0's store visible on CPU2.

2)My understanding is chronologically later accept() mustn't miss sk_state.
Otherwise, kernel says that ordering between internal syscalls data
is userspace duty, which is wrong. Userspace knows nothing about internal
kernel data.

It's not prohibited to call accept() for a socket obtained via pidfd_getfd()
by a side application. Why doesn't the code guarantee, that accept() see
actual sk_state?

[CPU0:Task0]          [CPU1:Task1]
listen(sk)
                      sk = pidfd_getfd()
                      accept(sk) /* -> fail */

3)Such possible situations in log file also look strange:

[CPU0:Task0]                                           [CPU1:Task1]
listen()
get_time(&time1)
write_log("listening at ...", time1)

                                                       get_time(&time2)
                                                       sk = accept()
                                                       if (sk < 0)
                                                          write_log("accept failed at ...", time2)

In case of there is no kernel ordering, we may see in their logs something
like the below:

Task1.log
"listening at time1"

Task2.log
"accept failed at time2"

and time2 > time1.

Kirill
