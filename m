Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6388566C1
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfFZK2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:28:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfFZK2z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 06:28:55 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 390D930024B1;
        Wed, 26 Jun 2019 10:28:42 +0000 (UTC)
Received: from localhost (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BE015C1A1;
        Wed, 26 Jun 2019 10:28:39 +0000 (UTC)
Date:   Wed, 26 Jun 2019 12:28:36 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] ipv4: fix suspicious RCU usage in
 fib_dump_info_fnhe()
Message-ID: <20190626122836.508db0ad@redhat.com>
In-Reply-To: <20190626100450.217106-1-edumazet@google.com>
References: <20190626100450.217106-1-edumazet@google.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 26 Jun 2019 10:28:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 03:04:50 -0700
Eric Dumazet <edumazet@google.com> wrote:

> sysbot reported that we lack appropriate rcu_read_lock()
> protection in fib_dump_info_fnhe()

Thanks for fixing this.

> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 6aee412a68bdd3c24a6a0eb9883e04b7a83998e0..59670fafcd2612b94c237cbe30109adb196cf3f0 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2872,12 +2872,13 @@ int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
>  		if (nhc->nhc_flags & RTNH_F_DEAD)
>  			continue;
>  
> +		rcu_read_lock();
>  		bucket = rcu_dereference(nhc->nhc_exceptions);
> -		if (!bucket)
> -			continue;
> -
> -		err = fnhe_dump_bucket(net, skb, cb, table_id, bucket, genid,
> -				       fa_index, fa_start);
> +		err = 0;

Could you perhaps move declaration and initialisation of 'err' outside
the block while at it? It looks a bit more readable at this point.

> +		if (bucket)
> +			err = fnhe_dump_bucket(net, skb, cb, table_id, bucket,
> +					       genid, fa_index, fa_start);
> +		rcu_read_unlock();
>  		if (err)
>  			return err;
>  	}

Either way,

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano
