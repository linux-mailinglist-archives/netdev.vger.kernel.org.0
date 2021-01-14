Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CDB2F5F30
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbhANKqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:46:47 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:41943 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbhANKqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 05:46:45 -0500
Date:   Thu, 14 Jan 2021 10:45:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610621155; bh=XpwNCeb1mFbjLCNKv9rUGAnouMUACeCtRMftN/AM0qc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=IudfYQhDlfGgR4hKqavEK/j7eLpgdoYg6P1XkmAKsrsEzXUobC/UgNMvsnnEYV4UE
         s6nzyGXe3jvtnAiLXg/o37Z1wRzayK3JaXUyr+06VlIGhgo9RKNz+pDgD8FDQ+LFx/
         LpZXWf5uitJLmfBFE5xiuTc/1L8xg3i+fV9VzKhIZVmsINwrF/61BjDPt2OEMf8OQc
         O9fd9WCPy+D08LE2084nyl/A9zfPUJL7BZ7DKctCkxjqp9tYTItJMbqiuiyu51ae5Y
         3X+qr6jTufxa/EjHhsSZIJjtku5n8XpN/EzPm2g/Ec4ml7DfKIX8qMsa+xMjWpZIOG
         8hqSTNECenywg==
To:     Paolo Abeni <pabeni@redhat.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree@solarflare.com>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 net-next] udp: allow forwarding of plain (non-fraglisted) UDP GRO packets
Message-ID: <20210114104510.6240-1-alobakin@pm.me>
In-Reply-To: <532f2d63cc7b842f6d75a22da277c2a841dcb40e.camel@redhat.com>
References: <20210113103232.4761-1-alobakin@pm.me> <532f2d63cc7b842f6d75a22da277c2a841dcb40e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 13 Jan 2021 19:37:18 +0100

> On Wed, 2021-01-13 at 10:32 +0000, Alexander Lobakin wrote:
>> Commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") actually
>> not only added a support for fraglisted UDP GRO, but also tweaked
>> some logics the way that non-fraglisted UDP GRO started to work for
>> forwarding too.
>> Commit 2e4ef10f5850 ("net: add GSO UDP L4 and GSO fraglists to the
>> list of software-backed types") added GSO UDP L4 to the list of
>> software GSO to allow virtual netdevs to forward them as is up to
>> the real drivers.
>>
>> Tests showed that currently forwarding and NATing of plain UDP GRO
>> packets are performed fully correctly, regardless if the target
>> netdevice has a support for hardware/driver GSO UDP L4 or not.
>> Add the last element and allow to form plain UDP GRO packets if
>> there is no socket -> we are on forwarding path.
>
> If I read correctly, the above will make UDP GRO in the forwarding path
> always enabled (admin can't disable that, if forwarding is enabled).
>
> UDP GRO can introduce measurable latency for UDP packets staging in the
> napi GRO hash (no push flag for UDP ;).
>
> Currently the admin (for fraglist) or the application (for socket-based
> "plain" GRO) have to explicitly enable the feature, but this change
> will impact every user.
>
> I think we need at lest an explict switch for this.

Fraglist UDP GRO is controlled by netdev feature / ethtool, plain UDO
GRO is controlled by the sockopt. Regarding that we have no sock on
forwarding, what kind of switch should we introduce here? One more
netdev feature, smth like NETIF_F_GRO_UDP_L4?

> Cheers,
>
> Paolo

Thanks,
Al

