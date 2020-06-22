Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3C2203498
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgFVKNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:13:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46559 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727776AbgFVKNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:13:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592820790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=69klgGVI1dkB36AMFFulBdvM0svnrLhrX7+lM5J9xrc=;
        b=XASkgD2GHv3gznFmNGnre0CG8DDdNUtEzeR3+ttevEDPdpsczcxBdu1vvBej6feGwC/V4w
        m0lF+Yew3lIN9cH4gHAhNXO68hmqwOzLB23gAOeA+zIN/lUIqf6ylcONsQbcfbCClS5jQh
        +1uViRqM4zlAzfbcgA8DDHYyBHbksiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-Tu-T-sZ6OluCyn6PgjnbLQ-1; Mon, 22 Jun 2020 06:13:08 -0400
X-MC-Unique: Tu-T-sZ6OluCyn6PgjnbLQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6E071005513;
        Mon, 22 Jun 2020 10:13:06 +0000 (UTC)
Received: from ovpn-113-146.ams2.redhat.com (ovpn-113-146.ams2.redhat.com [10.36.113.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDCD55C1BD;
        Mon, 22 Jun 2020 10:13:04 +0000 (UTC)
Message-ID: <daac77afd98bd9c10c4c52309067b8dfbba3fad0.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] ipv6: fib6: avoid indirect calls from
 fib6_rule_lookup
From:   Paolo Abeni <pabeni@redhat.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Luigi Rizzo <lrizzo@google.com>
Date:   Mon, 22 Jun 2020 12:13:03 +0200
In-Reply-To: <20200620031419.219106-2-brianvv@google.com>
References: <20200620031419.219106-1-brianvv@google.com>
         <20200620031419.219106-2-brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 2020-06-19 at 20:14 -0700, Brian Vazquez wrote:
> @@ -111,11 +111,13 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
>  	} else {
>  		struct rt6_info *rt;
>  
> -		rt = lookup(net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
> +		rt = pol_lookup_func(lookup,
> +			     net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
>  		if (rt != net->ipv6.ip6_null_entry && rt->dst.error != -EAGAIN)
>  			return &rt->dst;
>  		ip6_rt_put_flags(rt, flags);
> -		rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
> +		rt = pol_lookup_func(lookup,
> +			     net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
>  		if (rt->dst.error != -EAGAIN)
>  			return &rt->dst;
>  		ip6_rt_put_flags(rt, flags);

Have you considered instead factoring out the slice of
fib6_rule_lookup() using indirect calls to an header file? it looks
like here (gcc 10.1.1) it sufficent let the compiler use direct calls
and will avoid the additional branches.

Thanks!

Paolo


