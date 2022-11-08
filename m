Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E5D6209D7
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 08:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbiKHHBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 02:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiKHHBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 02:01:38 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD9727B1B;
        Mon,  7 Nov 2022 23:01:37 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.88.158])
        by gnuweeb.org (Postfix) with ESMTPSA id EA128804D1;
        Tue,  8 Nov 2022 07:01:34 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1667890897;
        bh=NeGUaX5AJwA8NeDSSOAcT5s8gAPORSuNE/XpOW11t1A=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=HA1CRsrkwed1Ebffy747WUoFSOMyiezoENpWJqKoWrJ/3f67S93txb+kYh4pBbZ6o
         fUgNVJKa7dr43yJhppDqUwBoUsCSujymCl5kvTtSpyRLDW9ZE2c5kfo3e2BhbCK1NS
         d7FmO/6QHTAeC7Qg42oi7+C04OHlFem3GHc8u4SaGQFa6VISQGOYP8DaaUgDitVW12
         7c9iXimA62XGDstkTh616/KJgjLqnngxwFynCO11p4p84Ru3UdnVlK0hdfKCxmpqtg
         eP0vk4ufvlYvIBUnjoVeC4/lhCUmkDBQrRnMb7rujbaBkyus/TKduaO/Z9/L+0MmBP
         dHZZDqe5K2MFQ==
Message-ID: <c4b27170-d166-171e-dc9e-c63d95e42509@gnuweeb.org>
Date:   Tue, 8 Nov 2022 14:01:32 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221107175357.2733763-1-shr@devkernel.io>
 <20221107175357.2733763-4-shr@devkernel.io>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [RFC PATCH v2 3/4] liburing: add test programs for napi busy poll
In-Reply-To: <20221107175357.2733763-4-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/22 12:53 AM, Stefan Roesch wrote:
> This adds two test programs to test the napi busy poll functionality. It
> consists of a client program and a server program. To get a napi id, the
> client and the server program need to be run on different hosts.
> 
> To test the napi busy poll timeout, the -t needs to be specified. A
> reasonable value for the busy poll timeout is 100. By specifying the
> busy poll timeout on the server and the client the best results are
> accomplished.
> 
> Signed-off-by: Stefan Roesch <shr@devkernel.io>
> ---
>   test/Makefile                |   2 +
>   test/napi-busy-poll-client.c | 422 +++++++++++++++++++++++++++++++++++
>   test/napi-busy-poll-server.c | 372 ++++++++++++++++++++++++++++++
>   3 files changed, 796 insertions(+)
>   create mode 100644 test/napi-busy-poll-client.c
>   create mode 100644 test/napi-busy-poll-server.c

Hi Stefan,

We don't write liburing tests this way. Your new tests break the "make runtests"
command:

   ...
   ...
   Running test napi-busy-poll-client.t                                address option is mandatory
   Usage: ./napi-busy-poll-client.t [-l|--listen] [-a|--address ip_address] [-p|--port port-no] [-s|--sqpoll] [-b|--busy] [-n|--num pings] [-t|--timeout busy-poll-timeout] [-h|--help]
   ... snip ...

   Test napi-busy-poll-client.t failed with ret 1
   Running test napi-busy-poll-server.t                                address option is mandatory
   Usage: ./napi-busy-poll-server.t [-l|--listen] [-a|--address ip_address] [-p|--port port-no] [-s|--sqpoll] [-b|--busy] [-n|--num pings] [-t|--timeout busy-poll-timeout] [-h|--help]
   ... snip ...
   ...
   ...
   Tests failed (3): <napi-busy-poll-client.t> <napi-busy-poll-server.t> <pipe-bug.t>
   make[1]: *** [Makefile:235: runtests] Error 1
   make[1]: Leaving directory '/home/ammarfaizi2/app/liburing/test'
   make: *** [Makefile:21: runtests] Error 2

All test programs in the "test/" directory are run by "make runtests" command.
Please try to run them with "make runtests" command.

If you want to test several arguments combination variants, you can do something
like this:

    https://github.com/axboe/liburing/blob/754bc068ec482/test/socket.c#L369-L409

Note: Since you're adding a new feature, your test program should check whether
the running kernel supports the new feature. If the running kernel doesn't
support it, use T_EXIT_SKIP as the exit code.

-- 
Ammar Faizi

