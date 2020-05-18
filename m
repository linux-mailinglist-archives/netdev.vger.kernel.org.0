Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560001D7E32
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgERQUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:20:23 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54030 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727005AbgERQUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 12:20:22 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B9BB42008C;
        Mon, 18 May 2020 16:20:21 +0000 (UTC)
Received: from us4-mdac16-25.at1.mdlocal (unknown [10.110.49.207])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B7A38800A3;
        Mon, 18 May 2020 16:20:21 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.107])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3E146100076;
        Mon, 18 May 2020 16:20:21 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0512A28006A;
        Mon, 18 May 2020 16:20:21 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 18 May
 2020 17:20:16 +0100
Subject: Re: [PATCH net] __netif_receive_skb_core: pass skb by reference
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        <netdev@vger.kernel.org>
References: <20200518090152.GA10405@noodle>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <66773afc-e802-5af0-a80f-1cd43ecdf041@solarflare.com>
Date:   Mon, 18 May 2020 17:20:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200518090152.GA10405@noodle>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25426.003
X-TM-AS-Result: No-11.469800-8.000000-10
X-TMASE-MatchedRID: UuaOI1zLN1hq0U6EhO9EE/ZvT2zYoYOwC/ExpXrHizxs98Z8fG/6kaOI
        rKL+ynQk1zDqz+XJW8y5VfFVziS2Vn3+cicD1BhtSMFvyr5L84JSUGjg30KJa+ffrtw9TYLhUS0
        xEYUYNYO5aogRwgmmugbtLa9sUi53qbt/wkKSxwy8coKUcaOOvTVfUuzvrtymGcBq4eMuIsxteT
        tnRURBcISCXSeMuWOS75y0vbqdxvpSHub/JvkszRo8wYJxWb0O39sqjopLqbv8c+aoiytjxWtwO
        oXDbvJwtNLxXjvzW/fgs5wGYsVdwPXe67dfbMS+mL8m0JtKLVPdXhRKGhNdp6AHKYK2asik5JC9
        NB/g7LPx0jLr9FmWFSXRFwQ5brtZLaseLy1WdxaeAiCmPx4NwHJnzNw42kCxxEHRux+uk8h+ICq
        uNi0WJMU7+hJkz/Z32BtedbRU/JZaMwwYyn3WMGeysIugXJ7pftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--11.469800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25426.003
X-MDID: 1589818821-OFmpHW3Uddyo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/05/2020 10:01, Boris Sukholitko wrote:
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
> Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
I think this patch is correct, but there's a couple of things I'd like
 to see before adding my Ack.
Firstly, please add a Fixes: tag; I expect the relevant commit will be
 88eb1944e18c ("net: core: propagate SKB lists through packet_type lookup")
 but I'm not 100% sure so do check that yourself.
Secondly:
> @@ -5174,6 +5177,7 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
>  	}
>  
>  out:
> +	*pskb = skb;
>  	return ret;
>  }
Could we have some sort of WARN_ONs (maybe under #ifdef DEBUG) to check
 that we never have a NULL skb with a non-NULL pt_prev?  Or at least a
 comment at the top of the function stating this part of its contract
 with callers?  I've gone through and convinced myself that it never
 happens currently, but that depends on some fairly subtle details.

-ed
