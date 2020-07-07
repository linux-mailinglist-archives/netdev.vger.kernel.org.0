Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46556216877
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 10:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgGGIj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 04:39:59 -0400
Received: from mail134-4.atl141.mandrillapp.com ([198.2.134.4]:21974 "EHLO
        mail134-4.atl141.mandrillapp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbgGGIj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 04:39:59 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jul 2020 04:39:58 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=mandrill; d=nexedi.com;
 h=From:Subject:To:Cc:In-Reply-To:References:Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding; i=thomas.gambier@nexedi.com;
 bh=kKg+uSIlv++SijT4VbFda0/YH/bvE4D7BFl6JIt8uh8=;
 b=bPU7uPdwfa1OnxjrOok9vZRqlmOMxBJSDg0PmkoOVyyq4Eq/dBY/DUOcHvS5jeOBYF9fKfjvQ2r8
   71Q2Tzrr2pF1sL0Hxymd9OLR12XZmNygT4kso+auVEx64V3e5Y5zAvvfq9JOAAt5DkR/heq7wF0d
   n34pFoqsOPKQTvDpBGw=
Received: from pmta03.mandrill.prod.atl01.rsglab.com (127.0.0.1) by mail134-4.atl141.mandrillapp.com id h0gqds1sau8b for <netdev@vger.kernel.org>; Tue, 7 Jul 2020 08:24:57 +0000 (envelope-from <bounce-md_31050260.5f043159.v1-5c7b703fee4e4263a60e594ec121d70c@mandrillapp.com>)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com; 
 i=@mandrillapp.com; q=dns/txt; s=mandrill; t=1594110297; h=From : 
 Subject : To : Cc : In-Reply-To : References : Message-Id : Date : 
 MIME-Version : Content-Type : Content-Transfer-Encoding : From : 
 Subject : Date : X-Mandrill-User : List-Unsubscribe; 
 bh=kKg+uSIlv++SijT4VbFda0/YH/bvE4D7BFl6JIt8uh8=; 
 b=jbzXWV9TR63KdsQYjR0cGXOG2QFDyd8Crvw1BAMPcLNHkXuruxANOGDHTHSIAyY0wmO+/D
 yGuNHoiwcBKxG9FaclDfiLTAdXtyFQ9g/c3yp+FlDQc2QCoSq2Ekjl7dOkMFoCEMhzjPQALv
 ekWOpSu0DDp0xt7ECLixqz0Ua0Al4=
From:   thomas.gambier@nexedi.com
Subject: Re: PROBLEM: can't ping anycast IPv6 address on lo interface
Received: from [87.98.221.171] by mandrillapp.com id 5c7b703fee4e4263a60e594ec121d70c; Tue, 07 Jul 2020 08:24:57 +0000
X-Sender: thomas.gambier@nexedi.com
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Julien Muchembled <jm@nexedi.com>,
        Jean-Paul Smets <jp@nexedi.com>,
        Juliusz Chroboczek <jch@irif.fr>
In-Reply-To: <4a87a3f2-8960-b7dc-47c0-1801d92b544e@gmail.com>
References: <fcb3d6853922beec880dda255e249288@nexedi.com> <4a87a3f2-8960-b7dc-47c0-1801d92b544e@gmail.com>
Message-Id: <2c03f7b2f5546cb33ba860fdb0dcbe2f@nexedi.com>
X-Report-Abuse: Please forward a copy of this message, including all headers, to abuse@mandrill.com
X-Report-Abuse: You can also report abuse here: http://mandrillapp.com/contact/abuse?id=31050260.5c7b703fee4e4263a60e594ec121d70c
X-Mandrill-User: md_31050260
Date:   Tue, 07 Jul 2020 08:24:57 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-07 02:25, David Ahern wrote:
> [ sorry for the delay; on PTO for a couple weeks ]
> 
> On 6/26/20 3:20 AM, thomas.gambier@nexedi.com wrote:
>> Hello,
>> 
>> this is the first time I report a bug to the kernel team. Please let 
>> me
>> know if there are any missing information or if I should post on
>> bugzilla instead.
>> 
>> 
>> Since Linux 5.2, I can't ping anycast address on lo interface.
>> 
>> If you enable IPv6 forwarding for an interface and add a IPv6 address
>> range on this interface, it is possible to ping the addres 0 of the
>> range (anycast address). This doesn't work for "lo" interface since
>> Linux 5.2.
>> 
>> I bisected to find that the commit
>> c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
>> (https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?=
id=3Dc7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43)
>> introduced the regression. Please note that the regression is still
>> present on master branch of net repository (commit
>> 2570284060b48f3f79d8f1a2698792f36c385e9a from yesterday).
>> 
>> I attach my config file to this email (this config was used to compile
>> latest master branch).
>> 
>> In order to reproduce you can use this small script:
>> 
>> root@kernel-compil-vm:~# cat test.bash
>> #! /bin/bash
>> echo 1 >=C2=A0 /proc/sys/net/ipv6/conf/all/forwarding
>> ip -6 a add fc12::1/16 dev lo
>> sleep 2
>> echo "pinging lo"
>> ping6 -c 2 fc12::
>> 
> 
> Thanks for the quick reproducer.
> 
>> 
>> Before the regression you will see:
>> pinging lo
>> PING fc12::(fc12::) 56 data bytes
>> 64 bytes from fc12::1: icmp_seq=3D1 ttl=3D64 time=3D0.111 ms
>> 64 bytes from fc12::1: icmp_seq=3D2 ttl=3D64 time=3D0.062 ms
>> 
>> 
>> After the regression you will see:
>> pinging lo
>> PING fc12::(fc12::) 56 data bytes
>> From fc12::: icmp_seq=3D1 Destination unreachable: No route
>> From fc12::: icmp_seq=3D2 Destination unreachable: No route
>> 
> 
> This solves the problem for me; can you try it out in your environment?
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index ea0be7cf3d93..f3279810d765 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -3405,7 +3405,7 @@ static bool fib6_is_reject(u32 flags, struct
> net_device *dev, int addr_type)
>         if ((flags & RTF_REJECT) ||
>             (dev && (dev->flags & IFF_LOOPBACK) &&
>              !(addr_type & IPV6_ADDR_LOOPBACK) &&
> -            !(flags & RTF_LOCAL)))
> +            !(flags & (RTF_ANYCAST | RTF_LOCAL))))
>                 return true;
> 
>         return false;

Yes, I confirm this patch solves the bug.

Thank you very much.

