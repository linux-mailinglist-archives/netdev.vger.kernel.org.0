Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406E21B6BA2
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgDXC4J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Apr 2020 22:56:09 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:40109 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbgDXC4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 22:56:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TwTgjRt_1587696962;
Received: from 30.225.76.126(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0TwTgjRt_1587696962)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 24 Apr 2020 10:56:02 +0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH net-next v2] net: Add TCP_FORCE_LINGER2 to TCP setsockopt
From:   Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <2df5f6de-ee68-8309-8b48-a139a4fb6b36@gmail.com>
Date:   Fri, 24 Apr 2020 10:56:02 +0800
Cc:     netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <73F510E3-F212-47B5-B575-97D15A3311C7@linux.alibaba.com>
References: <eea2a2c3-79dc-131c-4ef5-ee027b30b701@gmail.com>
 <20200423073529.92152-1-cambda@linux.alibaba.com>
 <3e780f88-41df-413c-7a81-6a63fd750605@gmail.com>
 <256723ED-43E5-4123-B096-15AD417366CD@linux.alibaba.com>
 <2df5f6de-ee68-8309-8b48-a139a4fb6b36@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 24, 2020, at 00:59, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> 
> 
> On 4/23/20 7:46 AM, Cambda Zhu wrote:
>> 
>> 
>>> On Apr 23, 2020, at 21:40, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>> 
>>> 
>>> 
>>> On 4/23/20 12:35 AM, Cambda Zhu wrote:
>>>> This patch adds a new TCP socket option named TCP_FORCE_LINGER2. The
>>>> option has same behavior as TCP_LINGER2, except the tp->linger2 value
>>>> can be greater than sysctl_tcp_fin_timeout if the user_ns is capable
>>>> with CAP_NET_ADMIN.
>>>> 
>>>> As a server, different sockets may need different FIN-WAIT timeout and
>>>> in most cases the system default value will be used. The timeout can
>>>> be adjusted by setting TCP_LINGER2 but cannot be greater than the
>>>> system default value. If one socket needs a timeout greater than the
>>>> default, we have to adjust the sysctl which affects all sockets using
>>>> the system default value. And if we want to adjust it for just one
>>>> socket and keep the original value for others, all the other sockets
>>>> have to set TCP_LINGER2. But with TCP_FORCE_LINGER2, the net admin can
>>>> set greater tp->linger2 than the default for one socket and keep
>>>> the sysctl_tcp_fin_timeout unchanged.
>>>> 
>>>> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
>>>> ---
>>>> Changes in v2:
>>>>  - Add int overflow check.
>>>> 
>>>> include/uapi/linux/capability.h |  1 +
>>>> include/uapi/linux/tcp.h        |  1 +
>>>> net/ipv4/tcp.c                  | 11 +++++++++++
>>>> 3 files changed, 13 insertions(+)
>>>> 
>>>> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
>>>> index 272dc69fa080..0e30c9756a04 100644
>>>> --- a/include/uapi/linux/capability.h
>>>> +++ b/include/uapi/linux/capability.h
>>>> @@ -199,6 +199,7 @@ struct vfs_ns_cap_data {
>>>> /* Allow multicasting */
>>>> /* Allow read/write of device-specific registers */
>>>> /* Allow activation of ATM control sockets */
>>>> +/* Allow setting TCP_LINGER2 regardless of sysctl_tcp_fin_timeout */
>>>> 
>>>> #define CAP_NET_ADMIN        12
>>>> 
>>>> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
>>>> index f2acb2566333..e21e0ce98ca1 100644
>>>> --- a/include/uapi/linux/tcp.h
>>>> +++ b/include/uapi/linux/tcp.h
>>>> @@ -128,6 +128,7 @@ enum {
>>>> #define TCP_CM_INQ		TCP_INQ
>>>> 
>>>> #define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
>>>> +#define TCP_FORCE_LINGER2	38	/* Set TCP_LINGER2 regardless of sysctl_tcp_fin_timeout */
>>>> 
>>>> 
>>>> #define TCP_REPAIR_ON		1
>>>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>>>> index 6d87de434377..d8cd1fd66bc1 100644
>>>> --- a/net/ipv4/tcp.c
>>>> +++ b/net/ipv4/tcp.c
>>>> @@ -3149,6 +3149,17 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
>>>> 			tcp_enable_tx_delay();
>>>> 		tp->tcp_tx_delay = val;
>>>> 		break;
>>>> +	case TCP_FORCE_LINGER2:
>>>> +		if (val < 0)
>>>> +			tp->linger2 = -1;
>>>> +		else if (val > INT_MAX / HZ)
>>>> +			err = -EINVAL;
>>>> +		else if (val > net->ipv4.sysctl_tcp_fin_timeout / HZ &&
>>>> +			 !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
>>>> +			tp->linger2 = 0;
>>>> +		else
>>>> +			tp->linger2 = val * HZ;
>>>> +		break;
>>>> 	default:
>>>> 		err = -ENOPROTOOPT;
>>>> 		break;
>>>> 
>>> 
>>> INT_MAX looks quite 
>>> 
>>> Anyway, I do not think we need a new socket option, since really it will need documentation and add more confusion.
>>> 
>>> net->ipv4.sysctl_tcp_fin_timeout is the default value for sockets which have tp->linger2 cleared.
>>> 
>>> Fact that it has been used to cap TCP_LINGER2 was probably a mistake.
>>> 
>>> What about adding a new define and simply let TCP_LINGER2 use it ?
>>> 
>>> Really there is no point trying to allow hours or even days for FIN timeout,
>>> and no point limiting a socket from having a value between net->ipv4.sysctl_tcp_fin_timeout and 2 minutes,
>>> at least from security perspective, these values seem legal as far as TCP specs are concerned.
>>> 
>>> 
>> 
>> I also think using sysctl_tcp_fin_timeout to cap TCP_LINGER2 is probably a mistake,
>> and adding a new define for TCP_LINGER2 is a good idea. I have considered the solution
>> and found it may have some compatibility issues. Whatever it’s a mistake or not, a
>> system administrator may have used it to limit the max timeout for all sockets. And
>> when I think about the behavior of TCP_LINGER2, I'm afraid the server may also rely on
>> the behavior so the server can set any value greater than sysctl_tcp_fin_timeout and
>> result in the same timeout.
>> 
>> Maybe my worry is unnecessary. If so, I think your suggestion is better.
>> 
> 
> Ṕlease send a v3 with a proper changelog then, thanks !

If the value between sysctl_tcp_fin_timeout and 2 minutes is legal, should we set tp->linger2
to TCP_FIN_TIMEOUT_MAX or return an error instead of set it to zero which means the default value?

Regards,
Cambda

