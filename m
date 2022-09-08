Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5133A5B1A9C
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 12:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiIHKxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 06:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiIHKxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 06:53:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A692F7550;
        Thu,  8 Sep 2022 03:53:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0216E61B77;
        Thu,  8 Sep 2022 10:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8421BC433C1;
        Thu,  8 Sep 2022 10:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662634383;
        bh=T2b1neGCZ1zcm07GNhCg8eLRvHEy51UOJVapdPUXtW0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TSaXFTGxJghx3ThVEdgZXAba3w5CIXpD/ZK0ytZcf4EJ631fx8dzCGIQ11b1ytHJ1
         wM9vL4boRo/3uHtvMDA7t4JAt08w3v9eLB7WrVuVnc3eyKYktWNNnEgDA/LeJvapdX
         kKlL5+22qJ3+pNlttra6wHZEfrWcGyn0bEavCFFxYEySjEPHG0mwn1BZGgrEaYutFI
         nU1XKFSuGh3KVvneD45vAelfZZjV3rCXmlKN0IDK78Z4tsiL7uVIaV4AzUp0GCY+Q1
         Mxrb8M8hlfL4N9gLnQ+i3Ddx4mD9Qz0Q3NaXxwKPOkW3iarRnjYrL5ttlz6CaiV/qn
         cLJEZPFKBdz0A==
Message-ID: <5e6eb6d6-3221-856e-daa1-7c27b1a1d659@kernel.org>
Date:   Thu, 8 Sep 2022 04:53:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v8 01/26] tcp: authopt: Initial support and key management
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>
References: <cover.1662361354.git.cdleonard@gmail.com>
 <0e4c0a98509b907e33c2f80b95cc6cfe713ac2b2.1662361354.git.cdleonard@gmail.com>
 <9bb98d13313d2ebeb5804d67285e8e6320ce4e74.camel@redhat.com>
 <589e17df-e321-c8ad-5360-e286c10cb1a3@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <589e17df-e321-c8ad-5360-e286c10cb1a3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/22 4:47 AM, Leonard Crestez wrote:
> On 9/8/22 09:35, Paolo Abeni wrote:
>> On Mon, 2022-09-05 at 10:05 +0300, Leonard Crestez wrote:
>> [...]
>>> diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
>>> new file mode 100644
>>> index 000000000000..d38e9c89c89d
>>> --- /dev/null
>>> +++ b/net/ipv4/tcp_authopt.c
>>> @@ -0,0 +1,317 @@
>>> +// SPDX-License-Identifier: GPL-2.0-or-later
>>> +
>>> +#include <net/tcp_authopt.h>
>>> +#include <net/ipv6.h>
>>> +#include <net/tcp.h>
>>> +#include <linux/kref.h>
>>> +
>>> +/* This is enabled when first struct tcp_authopt_info is allocated
>>> and never released */
>>> +DEFINE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
>>> +EXPORT_SYMBOL(tcp_authopt_needed_key);
>>> +
>>> +static inline struct netns_tcp_authopt *sock_net_tcp_authopt(const
>>> struct sock *sk)
>>> +{
>>> +    return &sock_net(sk)->tcp_authopt;
>>> +}
>>
>> Please have a look at PW report for this series, there are a bunch of
>> issues to be addressed, e.g. above 'static inline' should be just
>> 'static'
> 
> What is a "PW report"? I can't find any info about this.

patchworks: https://patchwork.kernel.org/project/netdevbpf/list/

This set:
https://patchwork.kernel.org/project/netdevbpf/list/?series=&submitter=116101&state=7&q=&archive=&delegate=


>> I'm sorry to bring the next topic this late (If already discussed, I
>> missed that point), is possible to split this series in smaller chunks?
> 
> It's already 26 patches and 3675 added lines, less that 150 lines per
> patch seems reasonable?
> 
> The split is already somewhat artificial, for example there are patches
> that "add crypto" without actually using it because then it would be too
> large.
> 
> Some features could be dropped for later in order to make this smaller,
> for example TCP_REPAIR doesn't have many usecases. Features like
> prefixlen, vrf binding and ipv4-mapped-ipv6 were explicitly requested by
> maintainers so I included them as separate patches in the main series.
> 

The tests could be dropped from the first set along with TCP_REPAIR and
 /proc/net/tcp_authopt patch. That would get it down to 21 patches. From
there the refactor patches could be sent first in a separate PR that
would get it down to 19. Those 19 are the core feature split into small
patches; they should come in together IMHO.
