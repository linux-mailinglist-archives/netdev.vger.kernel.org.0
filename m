Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE152F4244
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 04:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbhAMDNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 22:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbhAMDNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 22:13:32 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BBCC061786;
        Tue, 12 Jan 2021 19:12:52 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id c132so586944pga.3;
        Tue, 12 Jan 2021 19:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n+GtAJdX02GEobGs/GY4hI1xOo4ulcWjQuscSmciDpA=;
        b=nSaZ1ABEqPUOTcU+VP9TtnSmHLljgDsCErzkwBQhku4uuJWzXnLxU6iWNrGrMj+xrl
         hprOlTkdSOyiE/kd6A7Q24LAyNMAptoAgjdEngZETNoF8LZImoZb9ra/qzECPkETvJwS
         /EqjXJepj6qnrm2AS8cR2QL63jsACbDsXx3TiANJWBq5OFsd0/VSn8wlrgz7sx2Xv9+b
         kQnmp8NVYc5BvQOnL2zdBHwap1XABHTpUZOHuh3PuA+LfD0GZ6NaUTsosDxcMqol/wyN
         sx+9TSrsKzMvruWl/xl9KCrLzZKjyDiO0M2+/rQ0njsvN+B31VqXnhfK4Xmz99Rv2Gin
         /cZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n+GtAJdX02GEobGs/GY4hI1xOo4ulcWjQuscSmciDpA=;
        b=M4bmthLrH9J1c5WNaUGREJijwrkJhoCNLuLRKi+JR0Gggrvq7bsewNWz9EbQWpMprq
         e+jqw5hjWx6WQ9UiQ4lAUJsJzj01iNu70Zk5YFb6XlyszTy3bNVQERKzNZBgK9RmFPjb
         MxAVjNAJyxIrXv4s1jklSKxM62HaeBqVMQ8FhMoL/8LPX1FZ4/TsLZoBEZSTxsKHq8ao
         pyfhis79mexqNRpeTxKQPbfSyLCis0VoVCAFN7LDp9WIjFxQ8qGitRLyhivPaqbjddVj
         t5RAujvufqrxFSKDV26MtpnuMSV+nE6f1GUFKP0EJWQ+zyBFZ0qRcahK2H7yDngrGrQS
         8ZCg==
X-Gm-Message-State: AOAM533RF+Yt1WtLCFMyGdWVgM/BqpsSYooM6I8XNMEVeWtVmcKP5DhQ
        vCbhxp85hXzYuD1s90YYKuPaaymo3VYODw==
X-Google-Smtp-Source: ABdhPJzfVxrsYSEZpfVIxbqsJ7UFxyAo14LDuc/ebkzHfgGyO3dAAFvHId6rl6uMV/cvf7Y84bAU4w==
X-Received: by 2002:a63:c444:: with SMTP id m4mr44594pgg.420.1610507571950;
        Tue, 12 Jan 2021 19:12:51 -0800 (PST)
Received: from [192.168.1.188] ([50.39.189.65])
        by smtp.googlemail.com with ESMTPSA id i25sm528341pfo.137.2021.01.12.19.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 19:12:51 -0800 (PST)
Subject: Re: [PATCH net-next] udp: allow forwarding of plain (non-fraglisted)
 UDP GRO packets
To:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree@solarflare.com>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210112211536.261172-1-alobakin@pm.me>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Message-ID: <6fb72534-d4d4-94d8-28d1-aabf16e11488@gmail.com>
Date:   Tue, 12 Jan 2021 19:10:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112211536.261172-1-alobakin@pm.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/21 1:16 PM, Alexander Lobakin wrote:
> Commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") actually
> not only added a support for fraglisted UDP GRO, but also tweaked
> some logics the way that non-fraglisted UDP GRO started to work for
> forwarding too.
> Tests showed that currently forwarding and NATing of plain UDP GRO
> packets are performed fully correctly, regardless if the target
> netdevice has a support for hardware/driver GSO UDP L4 or not.
> Add the last element and allow to form plain UDP GRO packets if
> there is no socket -> we are on forwarding path.
> 
> Plain UDP GRO forwarding even shows better performance than fraglisted
> UDP GRO in some cases due to not wasting one skbuff_head per every
> segment.
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>   net/ipv4/udp_offload.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index ff39e94781bf..9d71df3d52ce 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -460,12 +460,13 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
>   	if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
>   		NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
>   
> -	if ((sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist) {
> +	if (!sk || (sk && udp_sk(sk)->gro_enabled) ||
> +	    NAPI_GRO_CB(skb)->is_flist) {
>   		pp = call_gro_receive(udp_gro_receive_segment, head, skb);
>   		return pp;
>   	}
>   

The second check for sk in "(sk && udp_sk(sk)->gro_enabled)" is 
redundant and can be dropped. You already verified it is present when 
you checked for !sk before the logical OR.

> -	if (!sk || NAPI_GRO_CB(skb)->encap_mark ||
> +	if (NAPI_GRO_CB(skb)->encap_mark ||
>   	    (skb->ip_summed != CHECKSUM_PARTIAL &&
>   	     NAPI_GRO_CB(skb)->csum_cnt == 0 &&
>   	     !NAPI_GRO_CB(skb)->csum_valid) ||
> 

