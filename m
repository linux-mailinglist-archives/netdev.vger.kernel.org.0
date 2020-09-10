Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C40F264F95
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgIJTq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgIJTqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:46:34 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D268FC061757
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:46:33 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id o20so5282292pfp.11
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KwQLdHy1k5OS/S7hWq8PLRlPUMills58QlT6vHYjZF4=;
        b=XZSyJKf0y3qVKojUyVWt38g1BM6fUQeN/xiwaGhAZ44icKSbDlufxWFe4mkgfparEl
         OG99ts0dHrQGwUldSJbZmxnRRD2HlX9WX/pYfRhHYkoOpcZXWeuTr4VdGAPHYTcr45s9
         h1r33oRcRPYwG5DMpO0uH4CpHG6C4UxUhEaNerd0cC5/4OExW6qSmdPafKrAzgi+5X2Q
         y0xCfXDmRz2ygqw0xLFsf1sCib+543oaw53NTl90G/P9fv8BhSGQLLvPXKgyL5Ao3nHP
         2dacfofumjyCg7j1optEyPgWXwMUHMGdXCmGe0cEoigGweGGfuvfMePkQLIpVvL7ndUa
         d3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KwQLdHy1k5OS/S7hWq8PLRlPUMills58QlT6vHYjZF4=;
        b=XYEOIojdXYg8o7x5E2rl4bfbb309SHk/8yYr1Kv3wpYCu28jI0dp1Vv9+y1aZg1Vk3
         HLl9k5K64Ci9vh38BO5Nnm2o3E6DKR9XhhXxcp4BwqCjzHq6ab/InQ345AJ4h32vePxK
         gGDDpeZcmfyeCaK4nAv3KIsSJHEBKOzdVrxsd7d5U1jUl4RHF+MLAW1OPrMfE0aGaZnI
         gxAOrEy9Ufw6eyVgb4wcDbGgjLj6DBu4EgVP6C0VxTrrnfoyIB2by0sZKIB3voEkdA1m
         Rt698hqz2x4KbTUrJL+tRQzFDgIwwqcplH4GMfCgGEa9H3y48nE/UNiWBhvCZYTKPYxm
         mflg==
X-Gm-Message-State: AOAM531kaL89JsHHc0hQbGT75iIZhwmoo5Q4jqEPRCoIOFpz3fLTVuu+
        Z8fXdHKjGt5GKh/JVDH0GqrfotxDn0Y=
X-Google-Smtp-Source: ABdhPJxyCIWtqie+5Mj3rPICCv/vA1CdFAyd4K6YXF+pL96CMOnO3YgNQhhN63kSXwETQcRzCI0hMw==
X-Received: by 2002:a63:5c66:: with SMTP id n38mr5654744pgm.217.1599767192716;
        Thu, 10 Sep 2020 12:46:32 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d17sm6954551pfq.157.2020.09.10.12.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 12:46:32 -0700 (PDT)
Subject: Re: [RFC PATCH] __netif_receive_skb_core: don't untag vlan from skb
 on DSA master
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org,
        andrew@lunn.ch, willemdebruijn.kernel@gmail.com,
        edumazet@google.com
Cc:     netdev@vger.kernel.org
References: <20200910162218.1216347-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ea9437b4-e7ba-e31c-0576-36eaeee806a1@gmail.com>
Date:   Thu, 10 Sep 2020 12:46:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200910162218.1216347-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 9:22 AM, Vladimir Oltean wrote:
> A DSA master interface has upper network devices, each representing an
> Ethernet switch port attached to it. Demultiplexing the source ports and
> setting skb->dev accordingly is done through the catch-all ETH_P_XDSA
> packet_type handler. Catch-all because DSA vendors have various header
> implementations, which can be placed anywhere in the frame: before the
> DMAC, before the EtherType, before the FCS, etc. So, the ETH_P_XDSA
> handler acts like an rx_handler more than anything.
> 
> It is unlikely for the DSA master interface to have any other upper than
> the DSA switch interfaces themselves. Only maybe a bridge upper*, but it
> is very likely that the DSA master will have no 8021q upper. So
> __netif_receive_skb_core() will try to untag the VLAN, despite the fact
> that the DSA switch interface might have an 8021q upper. So the skb will
> never reach that.
> 
> So far, this hasn't been a problem because most of the possible
> placements of the DSA switch header mentioned in the first paragraph
> will displace the VLAN header when the DSA master receives the frame, so
> __netif_receive_skb_core() will not actually execute any VLAN-specific
> code for it. This only becomes a problem when the DSA switch header does
> not displace the VLAN header (for example with a tail tag).
> 
> What the patch does is it bypasses the untagging of the skb when there
> is a DSA switch attached to this net device. So, DSA is the only
> packet_type handler which requires seeing the VLAN header. Once skb->dev
> will be changed, __netif_receive_skb_core() will be invoked again and
> untagging, or delivery to an 8021q upper, will happen in the RX of the
> DSA switch interface itself.
> 
> *see commit 9eb8eff0cf2f ("net: bridge: allow enslaving some DSA master
> network devices". This is actually the reason why I prefer keeping DSA
> as a packet_type handler of ETH_P_XDSA rather than converting to an
> rx_handler. Currently the rx_handler code doesn't support chaining, and
> this is a problem because a DSA master might be bridged.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> Resent, sorry, I forgot to copy the list.
> 
>   net/core/dev.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 152ad3b578de..952541ce1d9d 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -98,6 +98,7 @@
>   #include <net/busy_poll.h>
>   #include <linux/rtnetlink.h>
>   #include <linux/stat.h>
> +#include <net/dsa.h>
>   #include <net/dst.h>
>   #include <net/dst_metadata.h>
>   #include <net/pkt_sched.h>
> @@ -5192,7 +5193,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
>   		}
>   	}
>   
> -	if (unlikely(skb_vlan_tag_present(skb))) {
> +	if (unlikely(skb_vlan_tag_present(skb)) && !netdev_uses_dsa(skb->dev)) {

Not that I have performance numbers to claim  this, but we would 
probably want:

&& likely(!netdev_uses_dsa(skb->dev))

as well?

>   check_vlan_id:
>   		if (skb_vlan_tag_get_id(skb)) {
>   			/* Vlan id is non 0 and vlan_do_receive() above couldn't
> 

-- 
Florian
