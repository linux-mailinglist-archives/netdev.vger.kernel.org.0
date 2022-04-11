Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230034FB633
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343908AbiDKIlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiDKIlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:41:03 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0502A3EAA4;
        Mon, 11 Apr 2022 01:38:48 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V9kop81_1649666325;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V9kop81_1649666325)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 Apr 2022 16:38:45 +0800
Date:   Mon, 11 Apr 2022 16:38:45 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH net 3/3] net/smc: Fix af_ops of child socket pointing to
 released memory
Message-ID: <20220411083845.GA31900@e02h04389.eu6sqa>
Reply-To: "D. Wythe" <alibuda@linux.alibaba.com>
References: <20220408151035.1044701-1-kgraul@linux.ibm.com>
 <20220408151035.1044701-4-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408151035.1044701-4-kgraul@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 05:10:35PM +0200, Karsten Graul wrote:
> Child sockets may inherit the af_ops from the parent listen socket.
> When the listen socket is released then the af_ops of the child socket
> points to released memory.
> Solve that by restoring the original af_ops for child sockets which
> inherited the parent af_ops. And clear any inherited user_data of the
> parent socket.
> 
> Fixes: 8270d9c21041 ("net/smc: Limit backlog connections")
> Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> ---
>  net/smc/af_smc.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index f0d118e9f155..14ddc40149e8 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -121,6 +121,7 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
>  					  bool *own_req)
>  {
>  	struct smc_sock *smc;
> +	struct sock *child;
>  
>  	smc = smc_clcsock_user_data(sk);
>  
> @@ -134,8 +135,17 @@ static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk,
>  	}
>  
>  	/* passthrough to original syn recv sock fct */
> -	return smc->ori_af_ops->syn_recv_sock(sk, skb, req, dst, req_unhash,
> -					      own_req);
> +	child = smc->ori_af_ops->syn_recv_sock(sk, skb, req, dst, req_unhash,
> +					       own_req);
> +	/* child must not inherit smc or its ops */
> +	if (child) {
> +		rcu_assign_sk_user_data(child, NULL);
> +
> +		/* v4-mapped sockets don't inherit parent ops. Don't restore. */
> +		if (inet_csk(child)->icsk_af_ops == inet_csk(sk)->icsk_af_ops)
> +			inet_csk(child)->icsk_af_ops = smc->ori_af_ops;
> +	}
> +	return child;
>  
>  drop:
>  	dst_release(dst);
> -- 
> 2.32.0

My bad, LGTM, Thanks for your fix.

Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>

