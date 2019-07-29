Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520D5789A1
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfG2KbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:31:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfG2KbA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 06:31:00 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 015CAC049E10;
        Mon, 29 Jul 2019 10:31:00 +0000 (UTC)
Received: from localhost (unknown [10.40.205.71])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D3E860623;
        Mon, 29 Jul 2019 10:30:57 +0000 (UTC)
Date:   Mon, 29 Jul 2019 12:30:55 +0200
From:   Jiri Benc <jbenc@redhat.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     davem@davemloft.net, sbrivio@redhat.com, sd@queasysnail.net,
        liuhangbin@gmail.com, dsahern@gmail.com, natechancellor@gmail.com,
        tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: geneve: Fix a possible null-pointer dereference in
 geneve_link_config()
Message-ID: <20190729123055.5a7ba416@redhat.com>
In-Reply-To: <20190729102611.2338-1-baijiaju1990@gmail.com>
References: <20190729102611.2338-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 29 Jul 2019 10:31:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jul 2019 18:26:11 +0800, Jia-Ju Bai wrote:
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -1521,9 +1521,10 @@ static void geneve_link_config(struct net_device *dev,
>  		rt = rt6_lookup(geneve->net, &info->key.u.ipv6.dst, NULL, 0,
>  				NULL, 0);
>  
> -		if (rt && rt->dst.dev)
> +		if (rt && rt->dst.dev) {
>  			ldev_mtu = rt->dst.dev->mtu - GENEVE_IPV6_HLEN;
> -		ip6_rt_put(rt);
> +			ip6_rt_put(rt);
> +		}
>  		break;
>  	}
>  #endif

Are you sure rt6_lookup can never return a non-NULL rt with rt->dst.dev
being NULL? You'd leak the reference in such case.

 Jiri
