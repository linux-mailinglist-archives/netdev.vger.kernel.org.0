Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40E94DBD80
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 04:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiCQDYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 23:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiCQDYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 23:24:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C84140E7;
        Wed, 16 Mar 2022 20:22:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 57550CE2277;
        Thu, 17 Mar 2022 03:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D606C340EC;
        Thu, 17 Mar 2022 03:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647487373;
        bh=qZ6toP24YyEEfXrXc9wOoXI919Sb4ygcZxGBlcSjMsc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ck1dhiSYK2gDKz0mWgRR8Cwcwfk/Liz0XBZZvQf3cu+S7ZAo32EUzJ9fU9btfr+bB
         9a1hSmFbOJeDdCcVAnJslsOvKmJBgU/z5mj3RX7y9WV+Tpac7uN9LU/EcT3/HJdUdA
         GweuAdgJAbCHQ+DQ/aZjGLk5GvNPYtv25n1GrQd534QsEUmMEKqO37ZpO1q1CEFp9x
         Be9zHXY7HCKhnyiMoWrGVMj/bpXgsbm4kq9dvNfDEPjweo0jY8SRlX2MTCf2ctWpSL
         ni/DEiCTDqoCU0r2r/cXOVOIPHHwg5X00VhqIBBCSN/0I6NQU+khOpnUFb+DuBz/iI
         LzhfIvd3w6fJw==
Date:   Wed, 16 Mar 2022 20:22:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list),
        zhengkui_guo@outlook.com
Subject: Re: [PATCH] selftests: net: fix warning when compiling selftest/net
Message-ID: <20220316202251.382b687e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220316115040.10876-1-guozhengkui@vivo.com>
References: <20220316115040.10876-1-guozhengkui@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 19:50:40 +0800 Guo Zhengkui wrote:
> When I compile tools/testing/selftests/net/ by
> `make -C tools/testing/selftests/net` with gcc (Debian 8.3.0-6) 8.3.0,
> it reports the following warnings:
> 
> txtimestamp.c: In function 'validate_timestamp':
> txtimestamp.c:164:29: warning: format '%lu' expects argument of type
> 'long unsigned int', but argument 3 has type 'int64_t'
> {aka 'long long int'} [-Wformat=]
>    fprintf(stderr, "ERROR: %lu us expected between %d and %d\n",
>                            ~~^
>                            %llu
>      cur64 - start64, min_delay, max_delay);
>      ~~~~~~~~~~~~~~~
> txtimestamp.c: In function '__print_ts_delta_formatted':
> txtimestamp.c:173:22: warning: format '%lu' expects argument of type
> 'long unsigned int', but argument 3 has type 'int64_t'
> {aka 'long long int'} [-Wformat=]
>    fprintf(stderr, "%lu ns", ts_delta);
>                     ~~^      ~~~~~~~~
>                     %llu
> txtimestamp.c:175:22: warning: format '%lu' expects argument of type
> 'long unsigned int', but argument 3 has type 'int64_t'
> {aka 'long long int'} [-Wformat=]
>    fprintf(stderr, "%lu us", ts_delta / NSEC_PER_USEC);
>                     ~~^
>                     %llu
> 
> `int64_t` is the alias for `long long int`. '%lld' is more suitable.

That's on 32bit machines, I think what you need to use is PRId64.
Or just cast the result / change variable types to long long.
