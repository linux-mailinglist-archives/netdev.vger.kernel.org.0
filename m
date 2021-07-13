Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FE93C704C
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbhGMMeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:34:05 -0400
Received: from relay.sw.ru ([185.231.240.75]:57742 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236042AbhGMMeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 08:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=XQyIxcK98G6lEsMVec2tH73MENqW2sT8IW/2E/0h5Wc=; b=BuaBJhcEW1OlqeCx2
        4Ne3E6OEyiYbB6jwM7acBVkbgD2MWI2+NpjAB47fu3zxZ5Tu0RUMH43yjrXatz/NGlaDQx5+cDj+C
        aUHQk/XjfjW+WRITFUAJ9Fyuzz9yPqPw4OFSMIw05SyLpMtYt3eEzsS6Jut8u1bP7oXDt4dssoGyY
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m3HZB-003pRd-Lu; Tue, 13 Jul 2021 15:31:13 +0300
Subject: Re: [PATCH IPV6 v3 1/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
From:   Vasily Averin <vvs@virtuozzo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <74e90fba-df9f-5078-13de-41df54d2b257@virtuozzo.com>
 <cover.1626069562.git.vvs@virtuozzo.com>
 <1b1efd52-dd34-2023-021c-c6c6df6fec5f@virtuozzo.com>
 <e44bfeb9-5a5a-9f44-12bd-ec3d61eb3a14@virtuozzo.com>
Message-ID: <0e8a23d0-a16b-20f1-f465-31bc306ee24b@virtuozzo.com>
Date:   Tue, 13 Jul 2021 15:31:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e44bfeb9-5a5a-9f44-12bd-ec3d61eb3a14@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/21 10:46 AM, Vasily Averin wrote:
>> +			if (likely(nskb)) {
>> +				if (skb->sk)
>> +					skb_set_owner_w(skb, skb->sk);
> 
> need to assign sk not to skb but to nskb 
> 
>> +				consume_skb(skb);
>> +			} else {
>> +				kfree_skb(skb);

Please disread, I was wrong here.
> It is quite strange to call consume_skb() on one case and kfree_skb() in another one.
> We know that original skb was shared so we should not call kfree_skb here.
> 
> Btw I've noticed similar problem in few other cases:
> in pptp_xmit, pvc_xmit, ip_vs_prepare_tunneled_skb
> they call consume_skb() in case of success and kfree_skb on error path.
> It looks like potential bug for me.
