Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D368285BF2
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 11:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgJGJfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 05:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgJGJfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 05:35:45 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA24C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 02:35:45 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id d3so1578923wma.4
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 02:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eJpxoMZMd7eF0KuEyvDDYFrCUUxVRbT72I6NAxy9SQ4=;
        b=FECIFstkk4KY2rd2tirvGm3ZoLpn6b4zAg87Ik/reauR+VencQJNn0zkS5kHR+Msx+
         t+JbsIXCRU2iQNxRVNs0b7YpyQz9rjTvQeA6T0GJs+qTIulu89bMyPP8egC0flo/vgU3
         OqvpH8kMmFETz0wuDppUBy68gpFBw6D2an1Pa3ityeKllGR7CwHulpsGssBsHcHXDZq2
         5WTA4WUmnpDqtaXYouSNjId4ZEH5pyQysQbl+rOZVvLpFVFQwePR2gCUfNjTftQIoamk
         XIMovGII2pmk+dm/eLcyAEOcDDYGsQD7WcUfsYwV+5/mT0Kxjguh9yzW4jS6CTZlX3MA
         Yr0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eJpxoMZMd7eF0KuEyvDDYFrCUUxVRbT72I6NAxy9SQ4=;
        b=H0jn2+vIT7ykLgrbEoXkoFzlXNJV5U7ej/7X2rXhYSWv5Kw6of8DJx7Wg254qCJ+NH
         bGayJh9w/y7ATLpiR5N+X4DtFNgXOk8foXaWxrYS9txSWK0s9fzK5jBGIX/fKMxJDSk/
         j/Z4oF0+/RBu+m8HPGT4PMRoxFtmLBxFfNbq0AC8DfHhb/VN3WbVTKQsJzXceeT0M6C5
         RvmAMJClJQZnm0TdP5GJ/OX0xU+jiAcWqiUCvNsH4DgqQ5xOQWA+E/0KGe2U+jEZec7b
         LBYiy1G0v57UJcMJsnYR74J/fv7wkiI46cSyyYQqAJHXI4PHIA/BO6Te2FlleVyVw3L7
         8B7Q==
X-Gm-Message-State: AOAM533XRXI1cUYg0Z71BCiZPFyy9w+Of8Gz0gqDCmwWqxWAsVsUtpRt
        yIyJCDYDGP22aD5uKblt4ipe56ZMDY0=
X-Google-Smtp-Source: ABdhPJzAtcaxhes2a7G3s0jvGpX3PRDEps6BL1wHqvbGlM13+tKCRVm26UyrRmu9hiKaBRRkb2TdzQ==
X-Received: by 2002:a1c:bcd5:: with SMTP id m204mr2247267wmf.26.1602063343887;
        Wed, 07 Oct 2020 02:35:43 -0700 (PDT)
Received: from [192.168.8.147] ([37.172.192.62])
        by smtp.gmail.com with ESMTPSA id t124sm1972336wmg.31.2020.10.07.02.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 02:35:43 -0700 (PDT)
Subject: Re: [PATCH net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
 <20201007035502.3928521-3-liuhangbin@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <91f5b71e-416d-ebf1-750b-3e1d5cf6b732@gmail.com>
Date:   Wed, 7 Oct 2020 11:35:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201007035502.3928521-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/7/20 5:55 AM, Hangbin Liu wrote:

>  		kfree_skb(skb);
> @@ -282,6 +285,21 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>  		}
>  	}
>  
> +	/* RFC 8200, Section 4.5 Fragment Header:
> +	 * If the first fragment does not include all headers through an
> +	 * Upper-Layer header, then that fragment should be discarded and
> +	 * an ICMP Parameter Problem, Code 3, message should be sent to
> +	 * the source of the fragment, with the Pointer field set to zero.
> +	 */
> +	nexthdr = hdr->nexthdr;
> +	offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
> +	if (frag_off == htons(IP6_MF) && !pskb_may_pull(skb, offset + 1)) {
> +		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
> +		icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
> +		rcu_read_unlock();
> +		return NULL;
> +	}
> +
>  	rcu_read_unlock();
>  
>  	/* Must drop socket now because of tproxy. */
> 

Ouch, this is quite a buggy patch.

I doubt we want to add yet another ipv6_skip_exthdr() call in IPv6 fast path.

Surely the presence of NEXTHDR_FRAGMENT is already tested elsewhere ?

Also, ipv6_skip_exthdr() does not pull anything in skb->head, it would be strange
to force a pull of hundreds of bytes just because you want to check if an extra byte is there,
if the packet could be forwarded as is, without additional memory allocations.

Testing skb->len should be more than enough at this stage.

Also ipv6_skip_exthdr() can return an error.
