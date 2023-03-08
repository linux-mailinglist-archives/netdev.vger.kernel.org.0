Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11736B00F4
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCHIZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjCHIYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:24:39 -0500
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF4CA4012;
        Wed,  8 Mar 2023 00:24:18 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VdOh35C_1678263855;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VdOh35C_1678263855)
          by smtp.aliyun-inc.com;
          Wed, 08 Mar 2023 16:24:15 +0800
Date:   Wed, 8 Mar 2023 16:24:15 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v2] net/smc: fix fallback failed while sendmsg with
 fastopen
Message-ID: <ZAhGL4mp/U34ipGP@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <1678159426-72671-1-git-send-email-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1678159426-72671-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 11:23:46AM +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> Before determining whether the msg has unsupported options, it has been
> prematurely terminated by the wrong status check.
> 
> For the application, the general usages of MSG_FASTOPEN likes
> 
> fd = socket(...)
> /* rather than connect */
> sendto(fd, data, len, MSG_FASTOPEN)
> 
> Hence, We need to check the flag before state check, because the sock
> state here is always SMC_INIT when applications tries MSG_FASTOPEN.
> Once we found unsupported options, fallback it to TCP.
> 
> Fixes: ee9dfbef02d1 ("net/smc: handle sockopts forcing fallback")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

Thanks.

> v2 -> v1: Optimize code style
> 
> ---
>  net/smc/af_smc.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index b233c94..1c580ac 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2659,16 +2659,14 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
>  {
>  	struct sock *sk = sock->sk;
>  	struct smc_sock *smc;
> -	int rc = -EPIPE;
> +	int rc;
>  
>  	smc = smc_sk(sk);
>  	lock_sock(sk);
> -	if ((sk->sk_state != SMC_ACTIVE) &&
> -	    (sk->sk_state != SMC_APPCLOSEWAIT1) &&
> -	    (sk->sk_state != SMC_INIT))
> -		goto out;
>  
> +	/* SMC does not support connect with fastopen */
>  	if (msg->msg_flags & MSG_FASTOPEN) {
> +		/* not connected yet, fallback */
>  		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
>  			rc = smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
>  			if (rc)
> @@ -2677,6 +2675,11 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
>  			rc = -EINVAL;
>  			goto out;
>  		}
> +	} else if ((sk->sk_state != SMC_ACTIVE) &&
> +		   (sk->sk_state != SMC_APPCLOSEWAIT1) &&
> +		   (sk->sk_state != SMC_INIT)) {
> +		rc = -EPIPE;
> +		goto out;
>  	}
>  
>  	if (smc->use_fallback) {
> -- 
> 1.8.3.1
