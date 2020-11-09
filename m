Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470192AC972
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbgKIXim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:38:42 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:19491 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729451AbgKIXim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 18:38:42 -0500
Date:   Mon, 09 Nov 2020 23:38:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604965119; bh=0SNM8tghSknOpfRF/9rHNz25ic5+FUsysSSzdtpnF2c=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=QI6Fnwka8dzq1s5nSorKgKDFymjras+RRdLc8DPF9wkeHJWRxYoRcrDVP4SIxgttZ
         KnUjCXnTS50tJv6l4dI+rwzi0vyKmS0uYnsnhG06MZwFSqkQR6NBoWVYcegC9wkWrX
         BqJQUxvx/ylZZlhWSplhJkq8Y/X3KDoVDqi9WuLKWqcki5zATOi9HrJbC+0wArA50Y
         v5NQV9jkfeYQf+wrbeNk07UgQ8m0KH2ZxsKf3SURWYvvvjn5NDMSxUZsWCj+xV1flM
         v+0rsbIJ5AOnObT++u24biSp3cP2AHXrsOjGbAVYH2KYhzoDsnIIluoq+gMVEMSi5O
         8ABmtdSy+gT7A==
To:     Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Willem de Bruijn <willemb@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next] net: skb_vlan_untag(): don't reset transport offset if set by GRO layer
Message-ID: <bMQIWNWpqi1JM4GpszHDFF2THiN226YLT1l0j2oh08@cp7-web-042.plabs.ch>
In-Reply-To: <20201109152913.289c3cac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <zYurwsZRN7BkqSoikWQLVqHyxz18h4LhHU4NFa2Vw@cp4-web-038.plabs.ch> <20201109152913.289c3cac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 9 Nov 2020 15:29:13 -0800

> On Thu, 05 Nov 2020 21:29:01 +0000 Alexander Lobakin wrote:
>> Similar to commit fda55eca5a33f
>> ("net: introduce skb_transport_header_was_set()"), avoid resetting
>> transport offsets that were already set by GRO layer. This not only
>> mirrors the behavior of __netif_receive_skb_core(), but also makes
>> sense when it comes to UDP GSO fraglists forwarding: transport offset
>> of such skbs is set only once by GRO receive callback and remains
>> untouched and correct up to the xmitting driver in 1:1 case, but
>> becomes junk after untagging in ingress VLAN case and breaks UDP
>> GSO offload. This does not happen after this change, and all types
>> of forwarding of UDP GSO fraglists work as expected.
>>
>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>> ---
>>  net/core/skbuff.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index c5e6c0b83a92..39c13b9cf79d 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -5441,9 +5441,11 @@ struct sk_buff *skb_vlan_untag(struct sk_buff *sk=
b)
>>  =09=09goto err_free;
>>
>>  =09skb_reset_network_header(skb);
>> -=09skb_reset_transport_header(skb);
>>  =09skb_reset_mac_len(skb);
>>
>> +=09if (!skb_transport_header_was_set(skb))
>> +=09=09skb_reset_transport_header(skb);
>> +
>
> Patch looks fine, thanks, but I don't understand why you decided to
> move the reset?  It's not like it's not in order of headers, either.
> Let's keep the series of resets identical to __netif_receive_skb_core(),
> shall we?

Pure cosmetics, but yeah, let's keep. Will submit v2 in just a minute.

>>  =09return skb;
>>
>>  err_free:

Thanks,
Al

