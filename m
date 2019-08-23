Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CED49B97A
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 02:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfHXATV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 20:19:21 -0400
Received: from smtp6.emailarray.com ([65.39.216.46]:28773 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfHXATV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 20:19:21 -0400
Received: (qmail 55021 invoked by uid 89); 23 Aug 2019 22:32:40 -0000
Received: from unknown (HELO ?172.26.99.184?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4z) (POLARISLOCAL)  
  by smtp6.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 23 Aug 2019 22:32:40 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "Hangbin Liu" <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "Stefano Brivio" <sbrivio@redhat.com>,
        wenxu <wenxu@ucloud.cn>, "Alexei Starovoitov" <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Julian Anastasov" <ja@ssi.bg>
Subject: Re: [PATCHv4 net 1/2] ipv4/icmp: fix rt dst dev null pointer
 dereference
Date:   Fri, 23 Aug 2019 15:32:35 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <FFD8767E-30A8-4092-8DB7-396C3269E82E@flugsvamp.com>
In-Reply-To: <20190822141949.29561-2-liuhangbin@gmail.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
 <20190822141949.29561-1-liuhangbin@gmail.com>
 <20190822141949.29561-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22 Aug 2019, at 7:19, Hangbin Liu wrote:

> In __icmp_send() there is a possibility that the rt->dst.dev is NULL,
> e,g, with tunnel collect_md mode, which will cause kernel crash.
> Here is what the code path looks like, for GRE:
>
> - ip6gre_tunnel_xmit
>   - ip6gre_xmit_ipv4
>     - __gre6_xmit
>       - ip6_tnl_xmit
>         - if skb->len - t->tun_hlen - eth_hlen > mtu; return -EMSGSIZE
>     - icmp_send
>       - net = dev_net(rt->dst.dev); <-- here
>
> The reason is __metadata_dst_init() init dst->dev to NULL by default.
> We could not fix it in __metadata_dst_init() as there is no dev supplied.
> On the other hand, the reason we need rt->dst.dev is to get the net.
> So we can just try get it from skb->dev when rt->dst.dev is NULL.
>
> v4: Julian Anastasov remind skb->dev also could be NULL. We'd better
> still use dst.dev and do a check to avoid crash.
>
> v3: No changes.
>
> v2: fix the issue in __icmp_send() instead of updating shared dst dev
> in {ip_md, ip6}_tunnel_xmit.
>
> Fixes: c8b34e680a09 ("ip_tunnel: Add tnl_update_pmtu in ip_md_tunnel_xmit")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
