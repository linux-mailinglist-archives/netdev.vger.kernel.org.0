Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561B91D9945
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 16:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgESOSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 10:18:16 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59248 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728971AbgESOSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 10:18:16 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 656202007A;
        Tue, 19 May 2020 14:18:15 +0000 (UTC)
Received: from us4-mdac16-43.at1.mdlocal (unknown [10.110.48.14])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 60F076009B;
        Tue, 19 May 2020 14:18:15 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.9])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CEC50220077;
        Tue, 19 May 2020 14:18:14 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9574C580075;
        Tue, 19 May 2020 14:18:14 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 19 May
 2020 15:18:09 +0100
Subject: Re: [PATCH net v2] __netif_receive_skb_core: pass skb by reference
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        <netdev@vger.kernel.org>
References: <20200519073229.GA20624@noodle>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <3125de0d-c325-d520-20de-10bec6e156b3@solarflare.com>
Date:   Tue, 19 May 2020 15:18:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200519073229.GA20624@noodle>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25428.003
X-TM-AS-Result: No-7.503300-8.000000-10
X-TMASE-MatchedRID: scwq2vQP8OFq0U6EhO9EE/ZvT2zYoYOwC/ExpXrHizxs98Z8fG/6kaOI
        rKL+ynQk1zDqz+XJW8y5VfFVziS2Vn3+cicD1BhtSMFvyr5L84JSUGjg30KJa+ffrtw9TYLhwLd
        Z11vLmrUQVov51thXN754JsBOqBM2IeFIFB+CV+wD2WXLXdz+Adi5W7Rf+s6QPWuxj178aDHTv2
        PUTA1slEkN8NWa4RhQDyVcDYF9X2iR9GF2J2xqMzl/1fD/GopdWQy9YC5qGvz6APa9i04WGCq2r
        l3dzGQ1+YhGCyIW8u4Glc73RT2qNhg3/oZVmtJmZlHTpJKKQDxymmf9xEv3tXGpdpG9t5WbDjQK
        rvH7MnTEg6NRRnpfRHQ+HXve5RIoQSg2cVBUdl8pq2pZSxIsaKon7YxrK51SxywZbTuLLdqGmIr
        CFl3b3UMMprcbiest
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.503300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25428.003
X-MDID: 1589897895-zVHIrXksLg3b
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2020 08:32, Boris Sukholitko wrote:
> __netif_receive_skb_core may change the skb pointer passed into it (e.g.
> in rx_handler). The original skb may be freed as a result of this
> operation.
>
> The callers of __netif_receive_skb_core may further process original skb
> by using pt_prev pointer returned by __netif_receive_skb_core thus
> leading to unpleasant effects.
>
> The solution is to pass skb by reference into __netif_receive_skb_core.
>
> v2: Added Fixes tag and comment regarding ppt_prev and skb invariant.
>
> Fixes: 88eb1944e18c ("net: core: propagate SKB lists through packet_type lookup")
> Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
> ---
>  net/core/dev.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6d327b7aa813..38adb56624f7 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4988,7 +4988,7 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
>  	return 0;
>  }
>  
> -static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
> +static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
>  				    struct packet_type **ppt_prev)
>  {
>  	struct packet_type *ptype, *pt_prev;
> @@ -4997,6 +4997,7 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
>  	bool deliver_exact = false;
>  	int ret = NET_RX_DROP;
>  	__be16 type;
> +	struct sk_buff *skb = *pskb;
Reverse christmas tree here, or else David will complain ;-)

Apart from that,
Acked-by: Edward Cree <ecree@solarflare.com>
