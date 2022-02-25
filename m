Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C3D4C4B1D
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240232AbiBYQpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiBYQpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:45:43 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1A91F9829;
        Fri, 25 Feb 2022 08:45:09 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V5Tsmgd_1645807506;
Received: from 30.15.226.221(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V5Tsmgd_1645807506)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 26 Feb 2022 00:45:07 +0800
Message-ID: <45837d14-7895-4aff-43a3-a5ad6ef80c2d@linux.alibaba.com>
Date:   Sat, 26 Feb 2022 00:45:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net] net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1645776708-66113-1-git-send-email-alibuda@linux.alibaba.com>
In-Reply-To: <1645776708-66113-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/2/25 下午4:11, D. Wythe 写道:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> Remove connections from link group is not synchronous with handling
> SMC_LLC_DELETE_RKEY, which means that even the number of connections is
> less that SMC_RMBS_PER_LGR_MAX, it does not mean that the connection can
> register rtoken successfully later, in other words, the rtoken entry may
> have not been released. This will cause an unexpected
> SMC_CLC_DECL_ERR_REGRMB to be reported, and then ths smc connection have
> to fallback to TCP.
> 
> Therefore, we need to judge according to the number of idle rtoken
> entry.
> 
> Fixes: cd6851f30386 ("smc: remote memory buffers (RMBs)")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>   net/smc/smc_core.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 29525d0..24ef0af 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1864,7 +1864,8 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
>   		    (ini->smcd_version == SMC_V2 ||
>   		     lgr->vlan_id == ini->vlan_id) &&
>   		    (role == SMC_CLNT || ini->is_smcd ||
> -		     lgr->conns_num < SMC_RMBS_PER_LGR_MAX)) {
> +		     lgr->conns_num < SMC_RMBS_PER_LGR_MAX -
> +		     bitmap_weight(lgr->rtokens_used_mask, SMC_RMBS_PER_LGR_MAX))) {
>   			/* link group found */
>   			ini->first_contact_local = 0;
>   			conn->lgr = lgr;


I did a horrible math here, i'll send another fix later.

Best wishes.
