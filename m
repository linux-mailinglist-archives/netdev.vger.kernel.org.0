Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9970609996
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 07:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiJXFBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 01:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiJXFBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 01:01:49 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFDD7AC1C;
        Sun, 23 Oct 2022 22:01:45 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ompa3-005TdM-7f; Mon, 24 Oct 2022 13:01:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Oct 2022 13:01:31 +0800
Date:   Mon, 24 Oct 2022 13:01:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     syzbot <syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] kernel BUG in warn_crc32c_csum_combine
Message-ID: <Y1YcK0LPqP5nan40@gondor.apana.org.au>
References: <000000000000fd9a4005ebbeac67@google.com>
 <CANn89iJdYrAsp8X61ojw=ZVPEZeYu2vWaTcyDQL8NQ5aZW+8cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJdYrAsp8X61ojw=ZVPEZeYu2vWaTcyDQL8NQ5aZW+8cA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 23, 2022 at 07:49:44PM -0700, Eric Dumazet wrote:
>
> pfkey_send_acquire() allocates and skb, and then later this skb seems
> to be too small to fit all dump info.
> 
> Maybe ->available status flips during the duration of the call ?
> 
> (So count_esp_combs() might return a value, but later dump_esp_combs()
> needs more space)

Thanks!

> Relevant patch suggests this could happen
> 
> commit ba953a9d89a00c078b85f4b190bc1dde66fe16b5
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Thu Aug 4 18:03:46 2022 +0800
> 
>     af_key: Do not call xfrm_probe_algs in parallel

Yes this looks like the same issue just in a different spot.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
