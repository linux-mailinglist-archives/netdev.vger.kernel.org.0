Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE134341412
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 05:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbhCSEQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 00:16:01 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:50580 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231599AbhCSEPp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 00:15:45 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 12J4FZJ4003460;
        Fri, 19 Mar 2021 05:15:35 +0100
Date:   Fri, 19 Mar 2021 05:15:35 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atl1c: optimize rx loop
Message-ID: <20210319041535.GA3441@1wt.eu>
References: <20210319040447.527-1-liew.s.piaw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319040447.527-1-liew.s.piaw@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 12:04:47PM +0800, Sieng Piaw Liew wrote:
> Remove this trivial bit of inefficiency from the rx receive loop,
> results in increase of a few Mbps in iperf3. Tested on Intel Core2
> platform.
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
> ---
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 3f65f2b370c5..b995f9a0479c 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -1796,9 +1796,7 @@ static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
>  	struct atl1c_recv_ret_status *rrs;
>  	struct atl1c_buffer *buffer_info;
>  
> -	while (1) {
> -		if (*work_done >= work_to_do)
> -			break;
> +	while (*work_done < work_to_do) {

It should not change anything, or only based on the compiler's optimization
and should not result in a measurable difference because what it does is
exactly the same. Have you really compared the compiled output code to
explain the difference ? I strongly suspect you'll find no difference at
all.

Thus for me it's certainly not an optimization, it could be qualified as
a cleanup to improve code readability however.

Willy
