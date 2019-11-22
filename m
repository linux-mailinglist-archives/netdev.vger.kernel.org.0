Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6DF91076EC
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 19:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfKVSEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 13:04:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38456 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKVSEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 13:04:39 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0737315280C4C;
        Fri, 22 Nov 2019 10:04:38 -0800 (PST)
Date:   Fri, 22 Nov 2019 10:04:38 -0800 (PST)
Message-Id: <20191122.100438.416583996458136747.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, ja@ssi.bg, marcelo.leitner@gmail.com,
        dsahern@gmail.com, edumazet@google.com
Subject: Re: [PATCH net] ipv6/route: only update neigh confirm time if pmtu
 changed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191122061919.26157-1-liuhangbin@gmail.com>
References: <20191122061919.26157-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Nov 2019 10:04:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Fri, 22 Nov 2019 14:19:19 +0800

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

This whole callchain violates the assumptions of the MTU update
machinery.

In this case it's just the tunneling code accounting for the
encapsulation it is creating, and checking the MTU just in case.

But the MTU update code is supposed to be invoked in response to real
networking events that update the PMTU.

So for this ip_tunnel_xmit() case, _EVEN_ if the MTU is changed, we
should not be invoking dst_confirm_neigh() as we have no evidence
of successful two-way communication at this point.

We have to stop papering over the tunneling code's abuse of the PMTU
update framework and do this properly.

Sorry, I'm not applying this.
