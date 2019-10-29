Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9396FE899E
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 14:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388671AbfJ2NfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 09:35:24 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37395 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388667AbfJ2NfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 09:35:24 -0400
Received: by mail-lf1-f65.google.com with SMTP id b20so10539746lfp.4
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 06:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uXLywZLsBR2oJkXRobT0lprCxQFuWkzMqdv49MEwo10=;
        b=hhw1N9eEqdVMxfBvGCgbrzMzdBR4yKMWaOfuaV2VIa9tYeN14dW/jLtGqj1F1wNB9C
         p2VYAM9vYQHlGZPMq4I2l9Izx/0tSh5srtq8fx6+iXtW9Dg27btcf8g+YBvMbszp5PQO
         qf9KT+SSbZWT4idBmOARRfnkviyXRDCCTX+dY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uXLywZLsBR2oJkXRobT0lprCxQFuWkzMqdv49MEwo10=;
        b=sOrmMWy/JbIK6Krp6B76ug8oc6bASy+7M+l4cOzVmxpOROH8Zfdo7+XAhLiu1mBUGE
         uSnObrpL4pWaYIn2uamYd+cpHr4VQ3OlO8fAx3kZH3VHjX/YiTnFrVIJ4sbNQDMrQpSE
         7aawyke6rockCd+5OIRHpPM/SJ9b6qnDzllGi6PX0ySmsD9W1udvtePcCX1CzPVqpyOH
         sSOIZMIselxdQvBSusUpFZwrud7e/riKQsplnWaC1L1Go7T5TVKgB0rGYc35S7kyWSSS
         HYkoEfS9cepnfgtYqqtf9Liv2PhyolsukGfDcnL6qlGVPf5J0XOu4sAAEUcOqFYNMjNg
         C9bA==
X-Gm-Message-State: APjAAAW21w9EfyU+vsN9Pkhc7Gx4+7UZfXPo6EBH65A37mbzv5TgdefZ
        atubzEo7Pdn580DhRHJe7nJBRA==
X-Google-Smtp-Source: APXvYqz8P7sqO8EXOsrGjqjEJx97/Cc7Nz17bAhVWH4cejo2d/Hh16OZb28C2f8afa6btQ33NLO6BQ==
X-Received: by 2002:a19:8c1c:: with SMTP id o28mr2536006lfd.105.1572356120818;
        Tue, 29 Oct 2019 06:35:20 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id k9sm6798437ljk.91.2019.10.29.06.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2019 06:35:20 -0700 (PDT)
Subject: Re: [PATCH net-next] inet: do not call sublist_rcv on empty list
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     syzbot+c54f457cad330e57e967@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, netfilter-devel@vger.kernel.org,
        Edward Cree <ecree@solarflare.com>
References: <0000000000003cc4980596006472@google.com>
 <20191029004404.8563-1-fw@strlen.de>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <5747d354-66a5-46aa-2b09-b67de8f8e960@cumulusnetworks.com>
Date:   Tue, 29 Oct 2019 15:35:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191029004404.8563-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/10/2019 02:44, Florian Westphal wrote:
> syzbot triggered struct net NULL deref in NF_HOOK_LIST:
> RIP: 0010:NF_HOOK_LIST include/linux/netfilter.h:331 [inline]
> RIP: 0010:ip6_sublist_rcv+0x5c9/0x930 net/ipv6/ip6_input.c:292
>  ipv6_list_rcv+0x373/0x4b0 net/ipv6/ip6_input.c:328
>  __netif_receive_skb_list_ptype net/core/dev.c:5274 [inline]
> 
> Reason:
> void ipv6_list_rcv(struct list_head *head, struct packet_type *pt,
>                    struct net_device *orig_dev)
> [..]
>         list_for_each_entry_safe(skb, next, head, list) {
> 		/* iterates list */
>                 skb = ip6_rcv_core(skb, dev, net);
> 		/* ip6_rcv_core drops skb -> NULL is returned */
>                 if (skb == NULL)
>                         continue;
> 	[..]
> 	}
> 	/* sublist is empty -> curr_net is NULL */
>         ip6_sublist_rcv(&sublist, curr_dev, curr_net);
> 
> Before the recent change NF_HOOK_LIST did a list iteration before
> struct net deref, i.e. it was a no-op in the empty list case.
> 
> List iteration now happens after *net deref, causing crash.
> 
> Follow the same pattern as the ip(v6)_list_rcv loop and add a list_empty
> test for the final sublist dispatch too.
> 
> Cc: Edward Cree <ecree@solarflare.com>
> Reported-by: syzbot+c54f457cad330e57e967@syzkaller.appspotmail.com
> Fixes: ca58fbe06c54 ("netfilter: add and use nf_hook_slow_list()")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/ipv4/ip_input.c  | 3 ++-
>  net/ipv6/ip6_input.c | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 

Fixed my boot problem as well.

Tested-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

