Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91DE60E328
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiJZOUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbiJZOUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:20:11 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1E5A2B18D;
        Wed, 26 Oct 2022 07:20:09 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 096A011B4C;
        Wed, 26 Oct 2022 17:20:09 +0300 (EEST)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 9A79C11C8B;
        Wed, 26 Oct 2022 17:20:07 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id C2DE83C07E1;
        Wed, 26 Oct 2022 17:20:06 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 29QEK3RO087932;
        Wed, 26 Oct 2022 17:20:05 +0300
Date:   Wed, 26 Oct 2022 17:20:03 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Simon Horman <horms@verge.net.au>, stable@vger.kernel.org
Subject: Re: [PATCH] ipvs: use explicitly signed chars
In-Reply-To: <20221026123216.1575440-1-Jason@zx2c4.com>
Message-ID: <4cc36ff5-46fd-c2b3-3292-d6369337fec1@ssi.bg>
References: <20221026123216.1575440-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Wed, 26 Oct 2022, Jason A. Donenfeld wrote:

> The `char` type with no explicit sign is sometimes signed and sometimes
> unsigned. This code will break on platforms such as arm, where char is
> unsigned. So mark it here as explicitly signed, so that the
> todrop_counter decrement and subsequent comparison is correct.
> 
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

	Looks good to me for -next, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/netfilter/ipvs/ip_vs_conn.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index 8c04bb57dd6f..7c4866c04343 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -1249,40 +1249,40 @@ static const struct seq_operations ip_vs_conn_sync_seq_ops = {
>  	.next  = ip_vs_conn_seq_next,
>  	.stop  = ip_vs_conn_seq_stop,
>  	.show  = ip_vs_conn_sync_seq_show,
>  };
>  #endif
>  
>  
>  /* Randomly drop connection entries before running out of memory
>   * Can be used for DATA and CTL conns. For TPL conns there are exceptions:
>   * - traffic for services in OPS mode increases ct->in_pkts, so it is supported
>   * - traffic for services not in OPS mode does not increase ct->in_pkts in
>   * all cases, so it is not supported
>   */
>  static inline int todrop_entry(struct ip_vs_conn *cp)
>  {
>  	/*
>  	 * The drop rate array needs tuning for real environments.
>  	 * Called from timer bh only => no locking
>  	 */
> -	static const char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
> -	static char todrop_counter[9] = {0};
> +	static const signed char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
> +	static signed char todrop_counter[9] = {0};
>  	int i;
>  
>  	/* if the conn entry hasn't lasted for 60 seconds, don't drop it.
>  	   This will leave enough time for normal connection to get
>  	   through. */
>  	if (time_before(cp->timeout + jiffies, cp->timer.expires + 60*HZ))
>  		return 0;
>  
>  	/* Don't drop the entry if its number of incoming packets is not
>  	   located in [0, 8] */
>  	i = atomic_read(&cp->in_pkts);
>  	if (i > 8 || i < 0) return 0;
>  
>  	if (!todrop_rate[i]) return 0;
>  	if (--todrop_counter[i] > 0) return 0;
>  
>  	todrop_counter[i] = todrop_rate[i];
>  	return 1;
>  }
> -- 
> 2.38.1

Regards

--
Julian Anastasov <ja@ssi.bg>

