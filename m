Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55945A8EAD
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 08:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbiIAGuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 02:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbiIAGuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 02:50:12 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5672E9D2;
        Wed, 31 Aug 2022 23:50:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VNxyTX7_1662014999;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VNxyTX7_1662014999)
          by smtp.aliyun-inc.com;
          Thu, 01 Sep 2022 14:50:00 +0800
Date:   Thu, 1 Sep 2022 14:49:59 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     liuyacan@corp.netease.com
Cc:     davem@davemloft.net, edumazet@google.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, wenjia@linux.ibm.com, hwippel@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net v2] net/smc: Remove redundant refcount increase
Message-ID: <YxBWF7QCN+TnLk+4@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <YwzirUcxlQW3ydT7@TonyMac-Alibaba>
 <20220830152314.838736-1-liuyacan@corp.netease.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830152314.838736-1-liuyacan@corp.netease.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 11:23:14PM +0800, liuyacan@corp.netease.com wrote:
> From: Yacan Liu <liuyacan@corp.netease.com>
> 
> For passive connections, the refcount increment has been done in
> smc_clcsock_accept()-->smc_sock_alloc().
> 
> Fixes: 3b2dec2603d5 ("net/smc: restructure client and server code in af_smc")
> Signed-off-by: Yacan Liu <liuyacan@corp.netease.com>
> 
> ---
> Change in v2:
>   -- Tune commit message
> ---
>  net/smc/af_smc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 79c1318af..0939cc3b9 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -1855,7 +1855,6 @@ static void smc_listen_out_connected(struct smc_sock *new_smc)
>  {
>  	struct sock *newsmcsk = &new_smc->sk;
>  
> -	sk_refcnt_debug_inc(newsmcsk);
>  	if (newsmcsk->sk_state == SMC_INIT)
>  		newsmcsk->sk_state = SMC_ACTIVE;
>  

Thanks for this fixes. I dig into this sk_refcnt_debug_* facility. It
seems this is a very old debug methods and doesn't help a lot for sock
leak issue. Maybe there is another method to help track this issue?

For this patch, It looks good for me and tested in our environment.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

Cheers,
Tony Lu

