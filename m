Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919F25B18DD
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiIHJhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIHJhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:37:46 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBB243613;
        Thu,  8 Sep 2022 02:37:43 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VP29UV3_1662629860;
Received: from 30.221.129.118(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VP29UV3_1662629860)
          by smtp.aliyun-inc.com;
          Thu, 08 Sep 2022 17:37:41 +0800
Message-ID: <9f67d8b3-e813-6bc6-ca1f-e387288e9df4@linux.alibaba.com>
Date:   Thu, 8 Sep 2022 17:37:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 10/10] net/smc: fix application data exception
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1661407821.git.alibuda@linux.alibaba.com>
 <e590ca91e24d002608df29d100d4139977d0bcb6.1661407821.git.alibuda@linux.alibaba.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <e590ca91e24d002608df29d100d4139977d0bcb6.1661407821.git.alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.8 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/8/26 17:51, D. Wythe wrote:

> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> After we optimize the parallel capability of SMC-R connection
> establishment, There is a certain probability that following
> exceptions will occur in the wrk benchmark test:
> 
> Running 10s test @ http://11.213.45.6:80
>    8 threads and 64 connections
>    Thread Stats   Avg      Stdev     Max   +/- Stdev
>      Latency     3.72ms   13.94ms 245.33ms   94.17%
>      Req/Sec     1.96k   713.67     5.41k    75.16%
>    155262 requests in 10.10s, 23.10MB read
> Non-2xx or 3xx responses: 3
> 
> We will find that the error is HTTP 400 error, which is a serious
> exception in our test, which means the application data was
> corrupted.
> 
> Consider the following scenarios:
> 
> CPU0                            CPU1
> 
> buf_desc->used = 0;
>                                  cmpxchg(buf_desc->used, 0, 1)
>                                  deal_with(buf_desc)
> 
> memset(buf_desc->cpu_addr,0);
> 
> This will cause the data received by a victim connection to be cleared,
> thus triggering an HTTP 400 error in the server.
> 
> This patch exchange the order between clear used and memset, add
> barrier to ensure memory consistency.
> 
> Fixes: 1c5526968e27 ("net/smc: Clear memory when release and reuse buffer")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>   net/smc/smc_core.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 84bf84c..fdad953 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1380,8 +1380,9 @@ static void smcr_buf_unuse(struct smc_buf_desc *buf_desc, bool is_rmb,
>   
>   		smc_buf_free(lgr, is_rmb, buf_desc);
>   	} else {
> -		buf_desc->used = 0;
> -		memset(buf_desc->cpu_addr, 0, buf_desc->len);
> +		/* memzero_explicit provides potential memory barrier semantics */
> +		memzero_explicit(buf_desc->cpu_addr, buf_desc->len);
> +		WRITE_ONCE(buf_desc->used, 0);
>   	}
>   }
>   

It seems that the same issue exists in smc_buf_unuse(), Maybe it also needs to be fixed?


static void smc_buf_unuse(struct smc_connection *conn,
			  struct smc_link_group *lgr)
{
	if (conn->sndbuf_desc) {
		if (!lgr->is_smcd && conn->sndbuf_desc->is_vm) {
			smcr_buf_unuse(conn->sndbuf_desc, false, lgr);
		} else {
			conn->sndbuf_desc->used = 0;
			memset(conn->sndbuf_desc->cpu_addr, 0,
			       conn->sndbuf_desc->len);
                         ^...................
		}
	}
	if (conn->rmb_desc) {
		if (!lgr->is_smcd) {
			smcr_buf_unuse(conn->rmb_desc, true, lgr);
		} else {
			conn->rmb_desc->used = 0;
			memset(conn->rmb_desc->cpu_addr, 0,
			       conn->rmb_desc->len +
			       sizeof(struct smcd_cdc_msg));
                         ^...................
		}
	}
}

Thanks,
Wen Gu
