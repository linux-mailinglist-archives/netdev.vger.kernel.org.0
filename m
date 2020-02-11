Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6854B15964A
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 18:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgBKRjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 12:39:39 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55244 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729669AbgBKRji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 12:39:38 -0500
Received: by mail-pj1-f65.google.com with SMTP id dw13so1620596pjb.4
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 09:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=91A5noViXAkZK1gW/L6CGIsmdNrH9RcpNU2N36BTV5s=;
        b=MfbKwAvRtRdkAhQ46Od2zkQZ4ojQEBHQNtg0ATjymWEutBuhrclw1GiQYT3xEfKP1W
         ohES3honN5xncqtbNRctBHXjL32DxOURAoUwsncv3KyieicAx8fBPzBY7Dq6mg2p/B0Y
         0pPYh0BCZtR20WvtNTqUDF6wNpoccQfXoc68+wQDPUIvBYp3niGl5JA7qhexRsa7ighc
         P5C87mDXA3Aim8MLRR7D/4gfCz+9OuB4gu2DrkU5WVYQHDSHU1Bm5E08D3P5zlHqHFqF
         kSMZcrJ5pmHTqbItdwNGgZswrpoEC7J5b6Rd52m6Rv1/P3Lb4nvnRPh30MTjL9Y12Ml6
         83Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=91A5noViXAkZK1gW/L6CGIsmdNrH9RcpNU2N36BTV5s=;
        b=gp2+90EqdDIPfocUYkdYPbpFpyOyzN8muMFw4H3bK2g0AFpE+l3z2qEXTwJE0fkoh5
         d6R2U/MtG1vgPD1cDF7oqoBFDX3xiQE6uwCBJoaElQmrYwFnRI5I4HiFgnS+S0THcyvT
         10IKg06IXRL0Ac0gIFu9HRW8/8MHf5ZE/d/BXFschOdglovMXIpwpfJasG1dXSj6xKT9
         6MVRKCetEL57lsRAj286AP7Jet2CQiffZrmeklyobphFYFnJ9r4DbKpxGivneduBisCb
         2ke6UMrx6zyiUCfR2NdhfEuuykfsaO2oex2AN2KeVWKiGPtgxg+lPW6i9TxoqXNoKhXt
         dZlg==
X-Gm-Message-State: APjAAAVfU1dAI1HslMnd5Q1MdlABrKDLAesG4ZxlIpkSPT9/fiT72zgN
        jI4SAPeEpg5aJmDmaxevl6M=
X-Google-Smtp-Source: APXvYqyY32pK1KIHJ+L7c+1DVK7O8wjg153Dw2YQdSRVMcE+rIPtdRNnYlftqNgN0/2RXp2hlubCKw==
X-Received: by 2002:a17:902:7c95:: with SMTP id y21mr4127118pll.186.1581442778190;
        Tue, 11 Feb 2020 09:39:38 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id h3sm5382236pfr.15.2020.02.11.09.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 09:39:34 -0800 (PST)
Subject: Re: [PATCH v3 net 7/9] ipvlan: remove skb_share_check from xmit path
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     Mahesh Bandewar <maheshb@google.com>
References: <20200210141423.173790-2-Jason@zx2c4.com>
 <20200211150028.688073-1-Jason@zx2c4.com>
 <20200211150028.688073-8-Jason@zx2c4.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <db688bb4-bafa-8e9b-34aa-7f1d5a04e10f@gmail.com>
Date:   Tue, 11 Feb 2020 09:39:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200211150028.688073-8-Jason@zx2c4.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/11/20 7:00 AM, Jason A. Donenfeld wrote:
> This is an impossible condition to reach; an skb in ndo_start_xmit won't
> be shared by definition.
> 

Yes, maybe, but can you elaborate in this changelog ?

AFAIK net/core/pktgen.c can definitely provide shared skbs.

     refcount_inc(&pkt_dev->skb->users);
     ret = dev_queue_xmit(pkt_dev->skb);

We might have to change pktgen to make sure we do not make skb shared
just because it was convenient.

Please do not give a link to some web page that might disappear in the future.

Having to follow an old thread to understand the reasoning is not appealing
for us having to fix bugs in the following years.

Thanks.

> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Mahesh Bandewar <maheshb@google.com>
> Link: https://lore.kernel.org/netdev/CAHmME9pk8HEFRq_mBeatNbwXTx7UEfiQ_HG_+Lyz7E+80GmbSA@mail.gmail.com/
> ---
>  drivers/net/ipvlan/ipvlan_core.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
> index 30cd0c4f0be0..da40723065f2 100644
> --- a/drivers/net/ipvlan/ipvlan_core.c
> +++ b/drivers/net/ipvlan/ipvlan_core.c
> @@ -605,9 +605,6 @@ static int ipvlan_xmit_mode_l2(struct sk_buff *skb, struct net_device *dev)
>  				return ipvlan_rcv_frame(addr, &skb, true);
>  			}
>  		}
> -		skb = skb_share_check(skb, GFP_ATOMIC);
> -		if (!skb)
> -			return NET_XMIT_DROP;
>  
>  		/* Packet definitely does not belong to any of the
>  		 * virtual devices, but the dest is local. So forward
> 
