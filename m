Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8C21B5E89
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 17:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgDWPCO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Apr 2020 11:02:14 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:40223 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728981AbgDWPCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 11:02:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TwS.bDT_1587654126;
Received: from zhuguangmudembp.lan(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0TwS.bDT_1587654126)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Apr 2020 23:02:07 +0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH net-next v2] net: Add TCP_FORCE_LINGER2 to TCP setsockopt
From:   Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <CA+FuTSf3udp_d13Y8wg-vFsF2vttZ_A5_tE-EDj9z+pfZVCf5g@mail.gmail.com>
Date:   Thu, 23 Apr 2020 23:02:06 +0800
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E916471E-1A7E-41A2-9DCA-771FC6E876FE@linux.alibaba.com>
References: <eea2a2c3-79dc-131c-4ef5-ee027b30b701@gmail.com>
 <20200423073529.92152-1-cambda@linux.alibaba.com>
 <CA+FuTSf3udp_d13Y8wg-vFsF2vttZ_A5_tE-EDj9z+pfZVCf5g@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 23, 2020, at 21:43, Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> 
> On Thu, Apr 23, 2020 at 3:36 AM Cambda Zhu <cambda@linux.alibaba.com> wrote:
>> 
>> This patch adds a new TCP socket option named TCP_FORCE_LINGER2. The
>> option has same behavior as TCP_LINGER2, except the tp->linger2 value
>> can be greater than sysctl_tcp_fin_timeout if the user_ns is capable
>> with CAP_NET_ADMIN.
>> 
>> As a server, different sockets may need different FIN-WAIT timeout and
>> in most cases the system default value will be used. The timeout can
>> be adjusted by setting TCP_LINGER2 but cannot be greater than the
>> system default value. If one socket needs a timeout greater than the
>> default, we have to adjust the sysctl which affects all sockets using
>> the system default value. And if we want to adjust it for just one
>> socket and keep the original value for others, all the other sockets
>> have to set TCP_LINGER2. But with TCP_FORCE_LINGER2, the net admin can
>> set greater tp->linger2 than the default for one socket and keep
>> the sysctl_tcp_fin_timeout unchanged.
>> 
>> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
>> ---
>> Changes in v2:
>>   - Add int overflow check.
>> 
>> include/uapi/linux/capability.h |  1 +
>> include/uapi/linux/tcp.h        |  1 +
>> net/ipv4/tcp.c                  | 11 +++++++++++
>> 3 files changed, 13 insertions(+)
>> 
>> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
>> index 272dc69fa080..0e30c9756a04 100644
>> --- a/include/uapi/linux/capability.h
>> +++ b/include/uapi/linux/capability.h
>> @@ -199,6 +199,7 @@ struct vfs_ns_cap_data {
>> /* Allow multicasting */
>> /* Allow read/write of device-specific registers */
>> /* Allow activation of ATM control sockets */
>> +/* Allow setting TCP_LINGER2 regardless of sysctl_tcp_fin_timeout */
>> 
>> #define CAP_NET_ADMIN        12
>> 
>> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
>> index f2acb2566333..e21e0ce98ca1 100644
>> --- a/include/uapi/linux/tcp.h
>> +++ b/include/uapi/linux/tcp.h
>> @@ -128,6 +128,7 @@ enum {
>> #define TCP_CM_INQ             TCP_INQ
>> 
>> #define TCP_TX_DELAY           37      /* delay outgoing packets by XX usec */
>> +#define TCP_FORCE_LINGER2      38      /* Set TCP_LINGER2 regardless of sysctl_tcp_fin_timeout */
>> 
>> 
>> #define TCP_REPAIR_ON          1
>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> index 6d87de434377..d8cd1fd66bc1 100644
>> --- a/net/ipv4/tcp.c
>> +++ b/net/ipv4/tcp.c
>> @@ -3149,6 +3149,17 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
>>                        tcp_enable_tx_delay();
>>                tp->tcp_tx_delay = val;
>>                break;
>> +       case TCP_FORCE_LINGER2:
>> +               if (val < 0)
>> +                       tp->linger2 = -1;
>> +               else if (val > INT_MAX / HZ)
>> +                       err = -EINVAL;
>> +               else if (val > net->ipv4.sysctl_tcp_fin_timeout / HZ &&
>> +                        !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
>> +                       tp->linger2 = 0;
> 
> Instead of silently falling back to LINGER2 behavior for unprivileged
> users, I would fail without privileges, similar to
> SO_(SND|RCV)BUFFORCE.
> 

Yes, I have considered failing without privileges too. It’s clearer
but the user may have to set both of TCP_LINGER2 and TCP_FORCE_LINGER2
to set the timeout as TCP_FORCE_LINGER2 not introduced.

> Also, those have capable instead of ns_capable. If there is risk to
> system integrity, that is the right choice.
> 

I think both are ok, but the sysctl_tcp_fin_timeout is in net ns.

> Slight aside, if the original setsockopt had checked optval ==
> sizeof(int), we could have added a variant of different size (say,
> with an additional flags field), instead of having to create a new
> socket option.
> 

Maybe it’s a little weird… I don’t know. :)

Regards,
Cambda

>> +               else
>> +                       tp->linger2 = val * HZ;
>> +               break;
>>        default:
>>                err = -ENOPROTOOPT;
>>                break;
>> --
>> 2.16.6

