Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25EF214E8E
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgGESdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727869AbgGESdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 14:33:17 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF24C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 11:33:16 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id dg28so32714835edb.3
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 11:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H0dBiMlIz57i5a6OQd6NNT0qs7e4FvnqEbY3KZH5hD8=;
        b=CdFIz0ffcFB5FT8t5IaEhDZyUUp01nVtQqvO1mpda5BxsFn2930XF2Z2oE2exxz4wn
         l7XKnvQC3uMablm/vg23TOUkkdnchyDUsIDZcmMkE88p5vjGI/eQhYjCk2qARTMEzSB7
         TGa0jTtLBjq/jNgaLRuSK9wALpCB3Y9hy0Dds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H0dBiMlIz57i5a6OQd6NNT0qs7e4FvnqEbY3KZH5hD8=;
        b=FqsJt3VV1qjoK9jTfNQos6S0sDQAtF89jfFGe2I3ohR4mqbH61ppCc04Wqil1CfPQZ
         tFwE1UTjNi7h59XMrZL/PnwQ0S9sFuckID0i9/7cPT06thwbvjHXrQONZV1h6phijUR7
         t/M0shBp1stAGjAaOLzfndTxkjmzeB0Dow9Ei+Jt2Z9X/ur1CoLTZIdomI6z6yOV24Ca
         z7+iKJZ6CQWEJ7YsxSbRI+EUF/bOP2z7TRAcji8Iwgm9QxYdGKUD/4y1MgYpiE43JEw+
         igGY8JxiEAwRjg97xz8ABFnfS2m2xxiVQA+aycQEDf2dIQngFndOWKV975AacQaMFgIC
         MwWg==
X-Gm-Message-State: AOAM530wy2igYm4sQ4W+WQpfjkGgTfNcp1/9R0Apb9orHhG8OdzuqS8L
        yaktQS2oH+cYgww1AUUDgbX3KQ==
X-Google-Smtp-Source: ABdhPJw1YolUJEgQOjHxaMMgrtEFfdKzMndj+fP4DQxRb8lTkT+E4qELkvffnnn/b1BV5qIxiEI5+g==
X-Received: by 2002:a50:fc88:: with SMTP id f8mr20587991edq.314.1593973995305;
        Sun, 05 Jul 2020 11:33:15 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id u17sm14476477eje.74.2020.07.05.11.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 11:33:14 -0700 (PDT)
Subject: Re: [PATCH net] bridge: mcast: Fix MLD2 Report IPv6 payload length
 check
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Martin Weinelt <martin@linuxlounge.net>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20200705182234.10257-1-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <093beb97-87e8-e112-78ad-b3e4fe230cdb@cumulusnetworks.com>
Date:   Sun, 5 Jul 2020 21:33:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200705182234.10257-1-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/07/2020 21:22, Linus Lüssing wrote:
> Commit e57f61858b7c ("net: bridge: mcast: fix stale nsrcs pointer in
> igmp3/mld2 report handling") introduced a small bug which would potentially
> lead to accepting an MLD2 Report with a broken IPv6 header payload length
> field.
> 
> The check needs to take into account the 2 bytes for the "Number of
> Sources" field in the "Multicast Address Record" before reading it.
> And not the size of a pointer to this field.
> 
> Fixes: e57f61858b7c ("net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report handling")
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_multicast.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

I'd rather be more concerned with it rejecting a valid report due to wrong size. The ptr
size would always be bigger. :)

Thanks!
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 83490bf73a13..4c4a93abde68 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1000,21 +1000,21 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
>  	num = ntohs(icmp6h->icmp6_dataun.un_data16[1]);
>  	len = skb_transport_offset(skb) + sizeof(*icmp6h);
>  
>  	for (i = 0; i < num; i++) {
>  		__be16 *_nsrcs, __nsrcs;
>  		u16 nsrcs;
>  
>  		nsrcs_offset = len + offsetof(struct mld2_grec, grec_nsrcs);
>  
>  		if (skb_transport_offset(skb) + ipv6_transport_len(skb) <
> -		    nsrcs_offset + sizeof(_nsrcs))
> +		    nsrcs_offset + sizeof(__nsrcs))
>  			return -EINVAL;
>  
>  		_nsrcs = skb_header_pointer(skb, nsrcs_offset,
>  					    sizeof(__nsrcs), &__nsrcs);
>  		if (!_nsrcs)
>  			return -EINVAL;
>  
>  		nsrcs = ntohs(*_nsrcs);
>  		grec_len = struct_size(grec, grec_src, nsrcs);
>  
> 

