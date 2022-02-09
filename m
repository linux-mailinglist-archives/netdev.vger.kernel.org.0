Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852F14AEE3C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbiBIJlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:41:35 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239370AbiBIJeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:34:01 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D99FE05BA50;
        Wed,  9 Feb 2022 01:33:57 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4-Z-Uv_1644399222;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V4-Z-Uv_1644399222)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 17:33:43 +0800
Date:   Wed, 9 Feb 2022 17:33:40 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v5 5/5] net/smc: Add global configure for auto
 fallback by netlink
Message-ID: <YgOKc5FW/JRmW1U6@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
 <f54ee9f30898b998edf8f07dabccc84efaa2ab8b.1644323503.git.alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f54ee9f30898b998edf8f07dabccc84efaa2ab8b.1644323503.git.alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 08:53:13PM +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> Although we can control SMC auto fallback through socket options, which
> means that applications who need it must modify their code. It's quite
> troublesome for many existing applications. This patch modifies the
> global default value of auto fallback through netlink, providing a way
> to auto fallback without modifying any code for applications.
> 
> Suggested-by: Tony Lu <tonylu@linux.alibaba.com>
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>  include/uapi/linux/smc.h |  3 +++
>  net/smc/af_smc.c         | 17 +++++++++++++++++
>  net/smc/smc.h            |  7 +++++++
>  net/smc/smc_core.c       |  2 ++
>  net/smc/smc_netlink.c    | 10 ++++++++++
>  5 files changed, 39 insertions(+)
> 
> diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
> index 9f2cbf8..33f7fb8 100644
> --- a/include/uapi/linux/smc.h
> +++ b/include/uapi/linux/smc.h
> @@ -59,6 +59,8 @@ enum {
>  	SMC_NETLINK_DUMP_SEID,
>  	SMC_NETLINK_ENABLE_SEID,
>  	SMC_NETLINK_DISABLE_SEID,
> +	SMC_NETLINK_ENABLE_AUTO_FALLBACK,
> +	SMC_NETLINK_DISABLE_AUTO_FALLBACK,
>  };
>  
>  /* SMC_GENL_FAMILY top level attributes */
> @@ -85,6 +87,7 @@ enum {
>  	SMC_NLA_SYS_LOCAL_HOST,		/* string */
>  	SMC_NLA_SYS_SEID,		/* string */
>  	SMC_NLA_SYS_IS_SMCR_V2,		/* u8 */
> +	SMC_NLA_SYS_AUTO_FALLBACK,	/* u8 */
>  	__SMC_NLA_SYS_MAX,
>  	SMC_NLA_SYS_MAX = __SMC_NLA_SYS_MAX - 1
>  };
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index c313561..4a25ce7 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -59,6 +59,8 @@
>  						 * creation on client
>  						 */
>  
> +bool smc_auto_fallback;	/* default behavior for auto fallback, disable by default */

SMC supports net namespace, it would be better to provide a per
net-namespace switch. Generally, one container has one application, runs
different workload that is different from others. So the behavior could
be different, such as high-performance (don't fallback for limit) or TCP
transparent replacement (limit if needed).

Thank you,
Tony Lu
