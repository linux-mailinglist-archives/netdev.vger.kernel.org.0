Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEB25B1006
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 00:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiIGWuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 18:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiIGWum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 18:50:42 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA52A6C32;
        Wed,  7 Sep 2022 15:50:38 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oW3rf-002EsR-Hq; Thu, 08 Sep 2022 08:49:48 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Sep 2022 06:49:47 +0800
Date:   Thu, 8 Sep 2022 06:49:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 08/26] tcp: authopt: Disable via sysctl by default
Message-ID: <YxkgC1XKmCNGzk3t@gondor.apana.org.au>
References: <cover.1662361354.git.cdleonard@gmail.com>
 <298e4e87ce3a822b4217b309438483959082e6bb.1662361354.git.cdleonard@gmail.com>
 <CANn89iKq4rUkCwSSD-35u+Lb8s9u-8t5bj1=aZuQ8+oYwuC-Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKq4rUkCwSSD-35u+Lb8s9u-8t5bj1=aZuQ8+oYwuC-Eg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 04:11:58PM -0700, Eric Dumazet wrote:
>
> WRITE_ONCE(sysctl_tcp_authopt, val),  or even better:
> 
> if (val)
>      cmpxchg(&sysctl_tcp_authopt, 0, val);

What's the point of the cmpxchg? Since you're simply trying to prevent
sysctl_tcp_authopt from going back to zero, then the if clause
by itself is enough:

	if (val)
		WRITE_ONCE(sysctl_tcp_authopt, val);

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
