Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675306AB886
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 09:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCFIkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 03:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCFIkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 03:40:22 -0500
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E72B7AB9;
        Mon,  6 Mar 2023 00:40:21 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VdCwLpQ_1678092018;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VdCwLpQ_1678092018)
          by smtp.aliyun-inc.com;
          Mon, 06 Mar 2023 16:40:18 +0800
Date:   Mon, 6 Mar 2023 16:40:17 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/smc: fix NULL sndbuf_desc in smc_cdc_tx_handler()
Message-ID: <ZAWm8YHr77t4N29F@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <1678073786-110013-1-git-send-email-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1678073786-110013-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 11:36:26AM +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> When performing a stress test on SMC-R by rmmod mlx5_ib driver
> during the wrk/nginx test, we found that there is a probability
> of triggering a panic while terminating all link groups.
> 
> This issue dues to the race between smc_smcr_terminate_all()
> and smc_buf_create().
> 
> 			smc_smcr_terminate_all
> 
> smc_buf_create
> /* init */
> conn->sndbuf_desc = NULL;
> ...
> 
> 			__smc_lgr_terminate
> 				smc_conn_kill
> 					smc_close_abort
> 						smc_cdc_get_slot_and_msg_send
> 
> 			__softirqentry_text_start
> 				smc_wr_tx_process_cqe
> 					smc_cdc_tx_handler
> 						READ(conn->sndbuf_desc->len);
> 						/* panic dues to NULL sndbuf_desc */
> 
> conn->sndbuf_desc = xxx;
> 
> This patch tries to fix the issue by always to check the sndbuf_desc
> before send any cdc msg, to make sure that no null pointer is
> seen during cqe processing.
> 
> Fixes: 0b29ec643613 ("net/smc: immediate termination for SMCR link groups")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>

LGTM.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

> ---
>  net/smc/smc_cdc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 53f63bf..2f0e2ee 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -114,6 +114,9 @@ int smc_cdc_msg_send(struct smc_connection *conn,
>  	union smc_host_cursor cfed;
>  	int rc;
>  
> +	if (unlikely(!READ_ONCE(conn->sndbuf_desc)))
> +		return -EINVAL;
> +
>  	smc_cdc_add_pending_send(conn, pend);
>  
>  	conn->tx_cdc_seq++;
> -- 
> 1.8.3.1
