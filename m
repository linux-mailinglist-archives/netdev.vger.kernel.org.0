Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C33520BF4
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbiEJD1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiEJD1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:27:32 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9343E54F95;
        Mon,  9 May 2022 20:23:34 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VCofv7V_1652153011;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VCofv7V_1652153011)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 10 May 2022 11:23:32 +0800
Date:   Tue, 10 May 2022 11:23:30 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net/smc: non blocking recvmsg() return -EAGAIN
 when no data and signal_pending
Message-ID: <YnnaskOKyCqN4o6i@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220509115837.94911-1-guangguan.wang@linux.alibaba.com>
 <20220509115837.94911-2-guangguan.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509115837.94911-2-guangguan.wang@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 07:58:36PM +0800, Guangguan Wang wrote:
> Non blocking sendmsg will return -EAGAIN when any signal pending
> and no send space left, while non blocking recvmsg return -EINTR
> when signal pending and no data received. This may makes confused.
> As TCP returns -EAGAIN in the conditions descriped above. Align the

A little typo descriped -> described.

> behavior of smc with TCP.

I also agree with the behavior of aligning TCP.
 
Fixes tag is preferred:

Fixes: 846e344eb722 ("net/smc: add receive timeout check")

> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

Thanks,
Tony Lu

> ---
>  net/smc/smc_rx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index 51e8eb2933ff..338b9ef806e8 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
> @@ -355,12 +355,12 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
>  				}
>  				break;
>  			}
> +			if (!timeo)
> +				return -EAGAIN;
>  			if (signal_pending(current)) {
>  				read_done = sock_intr_errno(timeo);
>  				break;
>  			}
> -			if (!timeo)
> -				return -EAGAIN;
>  		}
>  
>  		if (!smc_rx_data_available(conn)) {
> -- 
> 2.24.3 (Apple Git-128)
