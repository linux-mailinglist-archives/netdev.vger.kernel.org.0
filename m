Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D97012A667
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 07:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfLYGap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 01:30:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59110 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfLYGao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 01:30:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB339154E7071;
        Tue, 24 Dec 2019 22:30:43 -0800 (PST)
Date:   Tue, 24 Dec 2019 22:30:43 -0800 (PST)
Message-Id: <20191224.223043.792506164633103993.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, ja@ssi.bg, marcelo.leitner@gmail.com,
        dsahern@gmail.com, edumazet@google.com, gnault@redhat.com,
        pablo@netfilter.org, stephen@networkplumber.org,
        alexey.kodanev@oracle.com
Subject: Re: [PATCHv5 net 0/8] disable neigh update for tunnels during pmtu
 update
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191222025116.2897-1-liuhangbin@gmail.com>
References: <20191220032525.26909-1-liuhangbin@gmail.com>
        <20191222025116.2897-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 22:30:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Sun, 22 Dec 2019 10:51:08 +0800

> When we setup a pair of gretap, ping each other and create neighbour cache.
> Then delete and recreate one side. We will never be able to ping6 to the new
> created gretap.
> 
> The reason is when we ping6 remote via gretap, we will call like
> 
> gre_tap_xmit()
>  - ip_tunnel_xmit()
>    - tnl_update_pmtu()
>      - skb_dst_update_pmtu()
>        - ip6_rt_update_pmtu()
>          - __ip6_rt_update_pmtu()
>            - dst_confirm_neigh()
>              - ip6_confirm_neigh()
>                - __ipv6_confirm_neigh()
>                  - n->confirmed = now
> 
> As the confirmed time updated, in neigh_timer_handler() the check for
> NUD_DELAY confirm time will pass and the neigh state will back to
> NUD_REACHABLE. So the old/wrong mac address will be used again.
> 
> If we do not update the confirmed time, the neigh state will go to
> neigh->nud_state = NUD_PROBE; then go to NUD_FAILED and re-create the
> neigh later, which is what IPv4 does.
> 
> We couldn't remove the ip6_confirm_neigh() directly as we still need it
> for TCP flows. To fix it, we have to pass a bool parameter to
> dst_ops.update_pmtu() and only disable neighbor update for tunnels.
 ...

Series applied and queued up for -stable, thanks.
