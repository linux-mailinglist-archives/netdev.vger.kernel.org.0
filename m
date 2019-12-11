Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F5411BF9F
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfLKWIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:08:09 -0500
Received: from forward500o.mail.yandex.net ([37.140.190.195]:60591 "EHLO
        forward500o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726345AbfLKWIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:08:09 -0500
Received: from mxback19j.mail.yandex.net (mxback19j.mail.yandex.net [IPv6:2a02:6b8:0:1619::95])
        by forward500o.mail.yandex.net (Yandex) with ESMTP id 3EEC160233;
        Thu, 12 Dec 2019 01:08:06 +0300 (MSK)
Received: from localhost (localhost [::1])
        by mxback19j.mail.yandex.net (mxback/Yandex) with ESMTP id oyvtMW7VsB-85ameenT;
        Thu, 12 Dec 2019 01:08:05 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1576102085;
        bh=de6sO5Pq3JufQtveSFYYlU1yJgZuDNyyQOSaCdxbKzg=;
        h=Message-Id:Cc:Subject:In-Reply-To:Date:References:To:From;
        b=fZpOi9BUx0Ku5LtTJswvoAc8G+3a9y8zS1SzxO0oN01Wl3IvBFt3jJYhcYL0hhUoU
         1ailijotLm4OyPU1FImsGYyBBxO8y0Nheh6m1SvJdnHOheRt2XwYIpqE4oB7cl8LMI
         eQAzlX2AeCL0My8GaGNQOvyNyH+dlzDdATqv30C0=
Authentication-Results: mxback19j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt2-c3952fd46804.qloud-c.yandex.net with HTTP;
        Thu, 12 Dec 2019 01:08:05 +0300
From:   Aleksei Zakharov <zakharov.a.g@yandex.ru>
Envelope-From: zakharov-a-g@yandex.ru
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
In-Reply-To: <CA+FuTSey4oa-WPRuAu8TAQFDO9e==e-+-SQ2p4237drq8GzOWQ@mail.gmail.com>
References: <83161576077966@vla4-87a00c2d2b1b.qloud-c.yandex.net> <CA+FuTSey4oa-WPRuAu8TAQFDO9e==e-+-SQ2p4237drq8GzOWQ@mail.gmail.com>
Subject: Re: RPS arp processing
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Thu, 12 Dec 2019 01:08:05 +0300
Message-Id: <911391576102085@myt2-c3952fd46804.qloud-c.yandex.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11.12.2019, 22:00, "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>:
> On Wed, Dec 11, 2019 at 10:34 AM Aleksei Zakharov
> <zakharov.a.g@yandex.ru> wrote:
>>  Hi, everyone
>>  Is it possible to balance ARP across CPUs with RPS?
>>  I don't clearly understand how hash is calulated for ARP packets, but it seems that it should consider source and target IPs.
>
> The hash is derived by flow dissection:
>
>     get_rps_cpus
>       ___skb_get_hash
>           skb_flow_dissect_flow_keys
>
> This calls __skb_flow_dissector with the flow_keys_dissector
> dissection program, which is initialized in
> init_default_flow_dissectors from flow_keys_dissector_keys.
>
> That program incorporates IPV4_ADDRS and IPV6_ADDRS. But that does not
> apply to ARP packets. Contrast case ETH_P_IPV6 with case ETH_P_ARP in
> __skb_flow_dissect.
>
> The flow dissector calls __skb_flow_dissect_arp() for deeper
> dissection, from which you could extract entropy for RPS. But the
> flow_keys_dissector program does not have FLOW_DISSECTOR_KEY_ARP
> enabled.
Thank you very much for the explanation!

>
>>  In our current setup we have one l2 segment between external hardware routers and namespaces on linux server.
>>  When router sends ARP request, it is passed through server's physical port, then via openvswitch bridge it is copied to every namespace.
>>  We've found that all ARPs (for different destination ips and few source ips) are processed on one CPU inside namespaces. We use RPS, and most packets are balanced between all CPUs.
>
> I suggest looking at the newer BPF flow dissector, which allows tuning
> dissection to specific use cases, like yours.
Thanks, I'll take a look at bpf dissector.

>
>>  Kernel 4.15.0-65 from ubuntu 18.04.
>>
>>  Might this issue be related to namespaces somehow?
>>
>>  --
>>  Regards,
>>  Aleksei Zakharov

-- 
Regards,
Aleksei Zakharov

