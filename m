Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058FE216AA6
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 12:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgGGKok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 06:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgGGKoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 06:44:38 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DD1C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 03:44:38 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mn17so4809909pjb.4
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 03:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qf4pp+chzAbby4mB2Q9eid/KAY6XYVLlyc0I9zbRSSw=;
        b=nKogjC/ASE1D/E23dLWsBoLjHCJO4i4x2qyYJsNa+H7Dciw/69xXlAWosqJAn/yIQ7
         0Ejw8gcJhDQ5K+c8yE8T+tfJLOiNzBGMjxt/PVzlkSmYLgDc2EcBkiLNmBAsS+wBn1c0
         ckqXYuQZSOw6/w+B113YXTtNWfvptLfywSwcrCHjYGdcBhwkrdnI6hch9a3OcNyAF8pN
         v6vE7InLswKrA00RbyRnE/E04BZQm+7EfNB8kkpQQ+R1Fj2fXomR/3dhJ+zJgR8fj1LM
         y3Y9U9q6gSuMK18z/gwI6pRtttw4Io+7R5cUIjOk7+pgJDALXU/9jHk4Fw2CFMz3ZaTl
         2wYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qf4pp+chzAbby4mB2Q9eid/KAY6XYVLlyc0I9zbRSSw=;
        b=a7OAOTiETOHJAndSBcPhAzr4UfjOIUfUT0p8f3vOd91O1NE9OsQ4yHc6s3rs6jxPfC
         qxiA+fW2Qx2qhvXauA07N6mnDbdH3FT68irVBXqGWBL4KjGuxCdJKqWWZnlkGZEFzpK1
         VgCCrZVLthmEK27Tvl7nnWP2vatzuE1LQlYusygMdb+poJjW8Hmg1dFPoAlg2xmuUWQ+
         HVAXFVuliPXzlT9LXtRDPi//wTf0Yt5EuOaegPLec9Vf4lkg1fp1W2QoeXHp/JTUdOO4
         VgMD39c1q8p9gH1/8ycn9GzKZf7znbqfAOy90WqfWCyF4TtS1ux/dNegFlDs6DMT0P2u
         jLvQ==
X-Gm-Message-State: AOAM531lYOt/nVKQOMQkdEQU0IfGVvJnvZYMJb+E+TQ23Yl0/09K5sxX
        o6/BeDgwvDAWvfkNJPRxvHI=
X-Google-Smtp-Source: ABdhPJxD5uCSBJ1ORQ4K2XTJDxZ0y7uv0ZI7DMrs6t44zKl1P4+hdj4Nf+Pza4dVLVX/9DUswHUePQ==
X-Received: by 2002:a17:90a:cb81:: with SMTP id a1mr3782297pju.11.1594118678291;
        Tue, 07 Jul 2020 03:44:38 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id v22sm8642168pfe.48.2020.07.07.03.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 03:44:37 -0700 (PDT)
Subject: Re: [PATCH net] vlan: consolidate VLAN parsing code and limit max
 parsing depth
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20200706122951.48142-1-toke@redhat.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <234d54c2-5b34-7651-5e57-490bee9920ae@gmail.com>
Date:   Tue, 7 Jul 2020 19:44:30 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200706122951.48142-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/07/06 21:29, Toke Høiland-Jørgensen wrote:
> Toshiaki pointed out that we now have two very similar functions to extract
> the L3 protocol number in the presence of VLAN tags. And Daniel pointed out
> that the unbounded parsing loop makes it possible for maliciously crafted
> packets to loop through potentially hundreds of tags.
> 
> Fix both of these issues by consolidating the two parsing functions and
> limiting the VLAN tag parsing to an arbitrarily-chosen, but hopefully
> conservative, max depth of 32 tags. As part of this, switch over
> __vlan_get_protocol() to use skb_header_pointer() instead of
> pskb_may_pull(), to avoid the possible side effects of the latter and keep
> the skb pointer 'const' through all the parsing functions.
> 
> Reported-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
> Reported-by: Daniel Borkmann <daniel@iogearbox.net>
> Fixes: d7bf2ebebc2b ("sched: consistently handle layer3 header accesses in the presence of VLANs")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
...
> @@ -623,13 +597,12 @@ static inline __be16 __vlan_get_protocol(struct sk_buff *skb, __be16 type,
>   			vlan_depth = ETH_HLEN;
>   		}
>   		do {
> -			struct vlan_hdr *vh;
> +			struct vlan_hdr vhdr, *vh;
>   
> -			if (unlikely(!pskb_may_pull(skb,
> -						    vlan_depth + VLAN_HLEN)))
> +			vh = skb_header_pointer(skb, vlan_depth, sizeof(vhdr), &vhdr);

Some drivers which use vlan_get_protocol to get IP protocol for checksum offload discards
packets when it cannot get the protocol.
I guess for such users this function should try to get protocol even if it is not in skb header?
I'm not sure such a case can happen, but since you care about this, you know real cases where
vlan tag can be in skb frags?

Toshiaki Makita
