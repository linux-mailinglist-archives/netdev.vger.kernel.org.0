Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD1A3EE54F
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhHQEJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:09:16 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:46632 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229477AbhHQEJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:09:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UjIiGvt_1629173319;
Received: from IT-C02W23QPG8WN.local(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UjIiGvt_1629173319)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 17 Aug 2021 12:08:39 +0800
Subject: Re: [PATCH v2 2/2] net: return early for possible invalid uaddr
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210811152431.66426-1-wenyang@linux.alibaba.com>
 <20210811152431.66426-2-wenyang@linux.alibaba.com>
 <247c8272-0e26-87ab-d492-140047d4abc4@gmail.com>
 <6c11b9e7-6aac-65c9-4755-99d41fbdcb4e@linux.alibaba.com>
Message-ID: <e926cd4f-9c87-8fa3-5b55-861ac299a184@linux.alibaba.com>
Date:   Tue, 17 Aug 2021 12:08:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6c11b9e7-6aac-65c9-4755-99d41fbdcb4e@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/8/13 上午1:35, Wen Yang 写道:
> 
> 
> 在 2021/8/12 上午12:11, Eric Dumazet 写道:
>>
>>
>> On 8/11/21 5:24 PM, Wen Yang wrote:
>>> The inet_dgram_connect() first calls inet_autobind() to select an
>>> ephemeral port, then checks uaddr in udp_pre_connect() or
>>> __ip4_datagram_connect(), but the port is not released until the socket
>>> is closed. This could cause performance issues or even exhaust ephemeral
>>> ports if a malicious user makes a large number of UDP connections with
>>> invalid uaddr and/or addr_len.
>>>
>>
>> This is a big patch.
>>
>> Can the malicious user still use a large number of UDP sockets,
>> with valid uaddr/add_len and consequently exhaust ephemeral ports ?
>>
>> If yes, it does not seem your patch is helping.
>>
> 
> Thank you for your comments.
> However, we could make these optimizations:
> 
> 1, If the user passed in some invalid parameters, we should return as
> soon as possible. We shouldn't assume that these parameters are valid
> first, then do some real work (such as select an ephemeral port), and
> then finally check that they are indeed valid or not.
> 
> 2. Unify the code for checking parameters in udp_pre_connect() and
> __ip4_datagram_connect() to make the code clearer.
> 
>> If no, have you tried instead to undo the autobind, if the connect 
>> fails ?
>>
> 
> Thanks. Undo the autobind is useful if the connect fails.
> We will add this logic and submit the v3 patch later.
> 

Hello, there is no undo autobind for udp. If this logic is added, the 
patch will be bigger; maybe we can release this ephemeral port through 
unhash()?

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 8a8dba7..43947d8 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -563,6 +563,7 @@ int inet_dgram_connect(struct socket *sock, struct 
sockaddr *uaddr,
                        int addr_len, int flags)
  {
         struct sock *sk = sock->sk;
+       bool autobind;
         int err;

         if (addr_len < sizeof(uaddr->sa_family))
@@ -581,9 +582,17 @@ int inet_dgram_connect(struct socket *sock, struct 
sockaddr *uaddr,
                         return err;
         }

-       if (data_race(!inet_sk(sk)->inet_num) && inet_autobind(sk))
+       autobind = data_race(!inet_sk(sk)->inet_num);
+       if (autobind && inet_autobind(sk))
                 return -EAGAIN;
-       return sk->sk_prot->connect(sk, uaddr, addr_len);
+
+       err = sk->sk_prot->connect(sk, uaddr, addr_len);
+       if (err && autobind) {
+               if (sk->sk_prot->unhash)
+                       sk->sk_prot->unhash(sk);
+       }
+
+       return err;
  }
  EXPORT_SYMBOL(inet_dgram_connect);

Could you kindly give some suggestions?

In addition, the previous v2 patch detects errors before bind and 
returns earlier, which should be reasonable.


-- 
Best wishes，
Wen




