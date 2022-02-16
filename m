Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB064B863C
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 11:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiBPKzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 05:55:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiBPKzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 05:55:54 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F7F2A39DF;
        Wed, 16 Feb 2022 02:55:41 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4d6LsK_1645008938;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V4d6LsK_1645008938)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Feb 2022 18:55:39 +0800
Date:   Wed, 16 Feb 2022 18:55:38 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] net/smc: Add autocork support
Message-ID: <20220216105538.GA54562@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220216034903.20173-1-dust.li@linux.alibaba.com>
 <6e9c637c-50b0-394c-f405-8b98deafa2ef@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e9c637c-50b0-394c-f405-8b98deafa2ef@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 11:32:52AM +0100, Karsten Graul wrote:
>On 16/02/2022 04:49, Dust Li wrote:
>> This patch adds autocork support for SMC which could improve
>> throughput for small message by x2 ~ x4.
>> 
>> The main idea is borrowed from TCP autocork with some RDMA
>> specific modification:
>
>Sounds like a valuable improvement, thank you!
>
>> ---
>>  net/smc/smc.h     |   2 +
>>  net/smc/smc_cdc.c |  11 +++--
>>  net/smc/smc_tx.c  | 118 ++++++++++++++++++++++++++++++++++++++++------
>>  3 files changed, 114 insertions(+), 17 deletions(-)
>> 
>> diff --git a/net/smc/smc.h b/net/smc/smc.h
>> index a096d8af21a0..bc7df235281c 100644
>> --- a/net/smc/smc.h
>> +++ b/net/smc/smc.h
>> @@ -192,6 +192,8 @@ struct smc_connection {
>>  						 * - dec on polled tx cqe
>>  						 */
>>  	wait_queue_head_t	cdc_pend_tx_wq; /* wakeup on no cdc_pend_tx_wr*/
>> +	atomic_t		tx_pushing;     /* nr_threads trying tx push */
>> +
>
>Is this extra empty line needed?

Will remove this empty line in the next version.

>
>>  	struct delayed_work	tx_work;	/* retry of smc_cdc_msg_send */
>>  	u32			tx_off;		/* base offset in peer rmb */
>>  
>> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
>> index 9d5a97168969..2b37bec90824 100644
>> --- a/net/smc/smc_cdc.c
>> +++ b/net/smc/smc_cdc.c
>> @@ -48,9 +48,14 @@ static void smc_cdc_tx_handler(struct smc_wr_tx_pend_priv *pnd_snd,
>>  		conn->tx_cdc_seq_fin = cdcpend->ctrl_seq;
>>  	}
>>  
>> -	if (atomic_dec_and_test(&conn->cdc_pend_tx_wr) &&
>> -	    unlikely(wq_has_sleeper(&conn->cdc_pend_tx_wq)))
>> -		wake_up(&conn->cdc_pend_tx_wq);
>> +	if (atomic_dec_and_test(&conn->cdc_pend_tx_wr)) {
>> +		/* If this is the last pending WR complete, we must push to
>> +		 * prevent hang when autocork enabled.
>> +		 */
>> +		smc_tx_sndbuf_nonempty(conn);
>> +		if (unlikely(wq_has_sleeper(&conn->cdc_pend_tx_wq)))
>> +			wake_up(&conn->cdc_pend_tx_wq);
>> +	}
>>  	WARN_ON(atomic_read(&conn->cdc_pend_tx_wr) < 0);
>>  
>>  	smc_tx_sndbuf_nonfull(smc);
>> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
>> index 5df3940d4543..bc737ac79805 100644
>> --- a/net/smc/smc_tx.c
>> +++ b/net/smc/smc_tx.c
>> @@ -31,6 +31,7 @@
>>  #include "smc_tracepoint.h"
>>  
>>  #define SMC_TX_WORK_DELAY	0
>> +#define SMC_DEFAULT_AUTOCORK_SIZE	(64 * 1024)
>>  
>>  /***************************** sndbuf producer *******************************/
>>  
>> @@ -127,10 +128,52 @@ static int smc_tx_wait(struct smc_sock *smc, int flags)
>>  static bool smc_tx_is_corked(struct smc_sock *smc)
>>  {
>>  	struct tcp_sock *tp = tcp_sk(smc->clcsock->sk);
>> -
>>  	return (tp->nonagle & TCP_NAGLE_CORK) ? true : false;
>>  }
>>  
>> +/* If we have pending CDC messages, do not send:
>> + * Because CQE of this CDC message will happen shortly, it gives
>> + * a chance to coalesce future sendmsg() payload in to one RDMA Write,
>> + * without need for a timer, and with no latency trade off.
>> + * Algorithm here:
>> + *  1. First message should never cork
>> + *  2. If we have pending CDC messages, wait for the first
>> + *     message's completion
>> + *  3. Don't cork to much data in a single RDMA Write to prevent burst,
>> + *     total corked message should not exceed min(64k, sendbuf/2)
>> + */
>> +static bool smc_should_autocork(struct smc_sock *smc, struct msghdr *msg,
>> +				int size_goal)
>> +{
>> +	struct smc_connection *conn = &smc->conn;
>> +
>> +	if (atomic_read(&conn->cdc_pend_tx_wr) == 0 ||
>> +	    smc_tx_prepared_sends(conn) > min(size_goal,
>> +					      conn->sndbuf_desc->len >> 1))
>> +		return false;
>> +	return true;
>> +}
>> +
>> +static bool smc_tx_should_cork(struct smc_sock *smc, struct msghdr *msg)
>> +{
>> +	struct smc_connection *conn = &smc->conn;
>> +
>> +	if (smc_should_autocork(smc, msg, SMC_DEFAULT_AUTOCORK_SIZE))
>> +		return true;
>> +
>> +	if ((msg->msg_flags & MSG_MORE ||
>> +	     smc_tx_is_corked(smc) ||
>> +	     msg->msg_flags & MSG_SENDPAGE_NOTLAST) &&
>> +	    (atomic_read(&conn->sndbuf_space)))
>> +		/* for a corked socket defer the RDMA writes if
>> +		 * sndbuf_space is still available. The applications
>> +		 * should known how/when to uncork it.
>> +		 */
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>>  /* sndbuf producer: main API called by socket layer.
>>   * called under sock lock.
>>   */
>> @@ -177,6 +220,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>>  		if (msg->msg_flags & MSG_OOB)
>>  			conn->local_tx_ctrl.prod_flags.urg_data_pending = 1;
>>  
>> +		/* If our send queue is full but peer have RMBE space,
>> +		 * we should send them out before wait
>> +		 */
>> +		if (!atomic_read(&conn->sndbuf_space) &&
>> +		    atomic_read(&conn->peer_rmbe_space) > 0)
>> +			smc_tx_sndbuf_nonempty(conn);
>> +
>>  		if (!atomic_read(&conn->sndbuf_space) || conn->urg_tx_pend) {
>>  			if (send_done)
>>  				return send_done;
>> @@ -235,15 +285,12 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>>  		 */
>>  		if ((msg->msg_flags & MSG_OOB) && !send_remaining)
>>  			conn->urg_tx_pend = true;
>> -		if ((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc) ||
>> -		     msg->msg_flags & MSG_SENDPAGE_NOTLAST) &&
>> -		    (atomic_read(&conn->sndbuf_space)))
>> -			/* for a corked socket defer the RDMA writes if
>> -			 * sndbuf_space is still available. The applications
>> -			 * should known how/when to uncork it.
>> -			 */
>> -			continue;
>> -		smc_tx_sndbuf_nonempty(conn);
>> +
>> +		/* If we need to cork, do nothing and wait for the next
>> +		 * sendmsg() call or push on tx completion
>> +		 */
>> +		if (!smc_tx_should_cork(smc, msg))
>> +			smc_tx_sndbuf_nonempty(conn);
>>  
>>  		trace_smc_tx_sendmsg(smc, copylen);
>>  	} /* while (msg_data_left(msg)) */
>> @@ -590,13 +637,26 @@ static int smcd_tx_sndbuf_nonempty(struct smc_connection *conn)
>>  	return rc;
>>  }
>>  
>> -int smc_tx_sndbuf_nonempty(struct smc_connection *conn)
>> +static int __smc_tx_sndbuf_nonempty(struct smc_connection *conn)
>>  {
>> -	int rc;
>> +	int rc = 0;
>> +	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
>
>Reverse Christmas tree style please.

Sure, will do.

Thank you !

