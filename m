Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEA53082C4
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhA2A5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:57:14 -0500
Received: from novek.ru ([213.148.174.62]:35662 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231184AbhA2A5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 19:57:11 -0500
Received: from [172.23.108.4] (unknown [88.151.187.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 2D490500192;
        Fri, 29 Jan 2021 03:57:46 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 2D490500192
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1611881867; bh=9N0QnSar07E5KeSibtSwIh4NAYwkGpaVMenLg0MpxO4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=omDBIortq0VCP32yLiGVq3F1T/5f+FRNQzY+Rjyx9b3UenCqDFwoaqcecq5y2h65O
         X8pb6yIhPAeZij+0gT5XIa6iyOBsx6IVqQCskNJCwAvXj+pmkiSw8MeV0BMtImTVDy
         zxkBR4rm7JMPmo1Zv77WkCJNjxpxCOhQpvWxgSio=
Subject: Re: [net] net: ip_tunnel: fix mtu calculation
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Slava Bacherikov <mail@slava.cc>,
        Network Development <netdev@vger.kernel.org>
References: <1611805733-25072-1-git-send-email-vfedorenko@novek.ru>
 <CAF=yD-JA7OPLWTxnhkEbvFwuY_SJm7SociVSTi+GG2_Qr72+KQ@mail.gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <c7d2f150-cdbc-7423-8bd3-5875c2a54e04@novek.ru>
Date:   Fri, 29 Jan 2021 00:56:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-JA7OPLWTxnhkEbvFwuY_SJm7SociVSTi+GG2_Qr72+KQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.01.2021 21:48, Willem de Bruijn wrote:
> On Wed, Jan 27, 2021 at 11:14 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>>
>> dev->hard_header_len for tunnel interface is set only when header_ops
>> are set too and already contains full overhead of any tunnel encapsulation.
>> That's why there is not need to use this overhead twice in mtu calc.
>>
>> Fixes: fdafed459998 ("ip_gre: set dev->hard_header_len and dev->needed_headroom properly")
>> Reported-by: Slava Bacherikov <mail@slava.cc>
>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
>> ---
>>   net/ipv4/ip_tunnel.c | 18 +++++++++---------
>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
>> index 64594aa..ad78825 100644
>> --- a/net/ipv4/ip_tunnel.c
>> +++ b/net/ipv4/ip_tunnel.c
>> @@ -317,7 +317,7 @@ static int ip_tunnel_bind_dev(struct net_device *dev)
>>          }
>>
>>          dev->needed_headroom = t_hlen + hlen;
>> -       mtu -= (dev->hard_header_len + t_hlen);
>> +       mtu -= dev->hard_header_len ? : t_hlen;
> 
> Safety of this change also depends on whether any other ip tunnels
> might have non-zero hard_header_len.

Yes, sure.

> I haven't fully checked yet, but at first scan I only see one other
> instance of header_ops, and that ip_tunnel_header_ops does not have a
> create implementation.

Yes. The calls to ip_tunnel_setup are in ip_gre.c, ip_tunnel.c, ip_vti.c
and ipip.c. All of them except of ip_gre use ip_tunnel_header_ops which
doesn't have create implementation and have hard_header_len set to 0.

> 
>>
>>          if (mtu < IPV4_MIN_MTU)
>>                  mtu = IPV4_MIN_MTU;
>> @@ -347,7 +347,7 @@ static struct ip_tunnel *ip_tunnel_create(struct net *net,
>>          nt = netdev_priv(dev);
>>          t_hlen = nt->hlen + sizeof(struct iphdr);
>>          dev->min_mtu = ETH_MIN_MTU;
>> -       dev->max_mtu = IP_MAX_MTU - dev->hard_header_len - t_hlen;
>> +       dev->max_mtu = IP_MAX_MTU - dev->hard_header_len ? : t_hlen;
> 
> here and elsewhere: subtraction takes precedence over ternary
> conditional, so (IP_MAX_MTU - ..) always true.

Oh, sure, my bad. Will fix it in v2, thanks!

