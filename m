Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0539CEC727
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 17:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbfKAQ7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 12:59:31 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46810 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbfKAQ7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 12:59:31 -0400
Received: by mail-pl1-f195.google.com with SMTP id q21so4616430plr.13
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 09:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qBT//TFyqln1hdHMHBRKz79WCERvVEeYOmkpVU4gy2Y=;
        b=u1LzS6BHkuMKSQV9R9vwjPq27MFL5GcTtBzoupFB49XKRfnIRbR20LotOj0SsCYAkj
         rQ3KlAh86AN4jXM3k4QGUHhGtO8Kgp5DvWXoF2ii51ldEDtnIZMstPojR/dsjKAoo+jG
         TAUo0EVazJvZvBLupDbOtwm0Gy98D+t60J+opSSGqy0i2gheZIrdRZSQFLOSmfn2PneN
         uF7hwJhF0toFmmn9FP2YSw4uPiUNokeHepCNdbQfN6x9RD4FPua+2VNA+F1WIqPcjeF0
         H6055Fhj84ED1L5XfENU6nbhyEYrxKmaZWxWQBYHhGdimyeQ0HJboApeUjmOZSKoA5MW
         j7Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qBT//TFyqln1hdHMHBRKz79WCERvVEeYOmkpVU4gy2Y=;
        b=sNIl837OU9UIRLK3cYzu60yddj8Crb6VhbpGdXWUoFXyUGFB/PENXT0g7NImGxWpGF
         7ftkkxTtx4g9tpgdsLKUaRjippDaPVDQbMNxSpR8OTuc8OKdwYWV7XnoTlkaZYWY2y+d
         4UXSM9GfKPTx8fSNLwFVEKFe8AmPfD4aOQuDWOFQGuXMQt6NkmaZ+IL4Zick4+16lGmb
         t6phEJ/pR6WdCOrJnU977uIK6NSoKCB3h04RsRCUNFmtYoWz5Z5qT3GsnHqtepGcTZf0
         vEK9yXQuVgDiUKNqt77WYMKhqHg80PwayAVQk2JiDQP9xpsUGNEoIvQibBTkP90a+MRr
         FFeQ==
X-Gm-Message-State: APjAAAXD1mzIeM2YemNUk1anyP97m1S5Qm2NpeYSIw/OEaipDUPsFCVK
        ut110WERRTK55fWHCFPjZUGAWHe8
X-Google-Smtp-Source: APXvYqwpitc6il7wlS/SAQ6NxOW1vRqlPnwXs0RAuv02NyiOeNxIUB2FD/TUoxMYlAzJ79GPPGPxaw==
X-Received: by 2002:a17:902:70cb:: with SMTP id l11mr13389818plt.255.1572627568995;
        Fri, 01 Nov 2019 09:59:28 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id q8sm1761572pjp.10.2019.11.01.09.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 09:59:27 -0700 (PDT)
Subject: Re: [PATCH net-next 11/12] net: atlantic: implement UDP GSO offload
To:     Igor Russkikh <irusskikh@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>
References: <cover.1572610156.git.irusskikh@marvell.com>
 <e85100822a4656332c8aa208a2e98af3df12e325.1572610156.git.irusskikh@marvell.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <71644e07-8dc1-3391-2701-d989906d38a3@gmail.com>
Date:   Fri, 1 Nov 2019 09:59:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <e85100822a4656332c8aa208a2e98af3df12e325.1572610156.git.irusskikh@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/19 5:17 AM, Igor Russkikh wrote:
> atlantic hardware does support UDP hardware segmentation offload.
> This allows user to specify one large contiguous buffer with data
> which then will be split automagically into multiple UDP packets
> of specified size.


>  
> @@ -484,11 +485,19 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
>  
>  	if (unlikely(skb_is_gso(skb))) {
>  		dx_buff->mss = skb_shinfo(skb)->gso_size;
> -		dx_buff->is_gso = 1U;
> +		if (ip_hdr(skb)->protocol == IPPROTO_TCP) {
> +			dx_buff->is_gso_tcp = 1U;
> +			dx_buff->len_l4 = tcp_hdrlen(skb);
> +		} else if (ip_hdr(skb)->protocol == IPPROTO_UDP) {
> +			dx_buff->is_gso_udp = 1U;
> +			dx_buff->len_l4 = sizeof(struct udphdr);
> +			/* UDP GSO Hardware does not replace packet length. */
> +			udp_hdr(skb)->len = htons(dx_buff->mss +
> +						  dx_buff->len_l4);
> +		}

Have you tested IPv6 ?


>  		dx_buff->len_pkt = skb->len;
>  		dx_buff->len_l2 = ETH_HLEN;
>  		dx_buff->len_l3 = ip_hdrlen(skb);
> -		dx_buff->len_l4 = tcp_hdrlen(skb);
>  		dx_buff->eop_index = 0xffffU;
>  		dx_buff->is_ipv6 =
>  			(ip_hdr(skb)->version == 6) ? 1U : 0U;

I am asking because you seem to test IPv6 here, so blindly using ip_hdr(skb)->protocol
few lines above is weird.

