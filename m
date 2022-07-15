Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80420575AA9
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 06:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiGOE5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 00:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGOE5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 00:57:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD372237CC
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 21:57:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D1EFB829EE
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 04:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DE4C34115;
        Fri, 15 Jul 2022 04:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657861070;
        bh=7EbJQ9muZ6cq7xoa2XFO40ccIIDdWaNozNsE27en8sU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=joJ6vLZXpb0yEzOAJWKMB1PTWfiJoUAQLAnHJtCHLsCl5/gpEmC4W2DWevTxz+DuH
         Sts7leClHuHR7DRT5T2//S8IZ3IcraXYkEkEvphcXkJvx0J2U73VUfZREK+M/3L9XQ
         GYiHbX0jAxgajY2RR1h49TyBhpvG18FTlfucpKMai1r7p/mJB6wfR4ZdzVZWs+RV1Z
         KVbRYDU91e6VFOBWx+0n5tdnsCYWSH5rXHEwRYhCzS6uWKQAhqy2fE61HVhogpjO/5
         JN4S0CGJ16QgWe70Ey0RwFS+1dgErkt+6uRWTCbeT5Eh0UhI6UYN2BdGxbxaHBwUnE
         rvlFmE8i6aUww==
Date:   Thu, 14 Jul 2022 21:57:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, alexanderduyck@fb.com
Subject: Re: [PATCH v2] net: sort queues in xps maps
Message-ID: <20220714215748.7699b361@kernel.org>
In-Reply-To: <1657852318-33812-1-git-send-email-liyonglong@chinatelecom.cn>
References: <1657852318-33812-1-git-send-email-liyonglong@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jul 2022 10:31:58 +0800 Yonglong Li wrote:
> It is more reasonable that pacekts in the same stream be hashed to the same
> tx queue when all tx queue bind with the same CPUs.
> 
> ---
> v1 -> v2:
> Jakub suggestion: factor out the second loop in __netif_set_xps_queue() -
> starting from the "add tx-queue to CPU/rx-queue maps" comment into a helper
> ---

Please put the changelog under the --- after your s-o-b.
git am will cut off the commit message at the first ---
it finds which means right now it'll cut off before the 
changelog, and also discard your s-o-b.

> Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
> ---
>  net/core/dev.c | 49 ++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 32 insertions(+), 17 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 978ed06..b9ae5d5 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -150,6 +150,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/prandom.h>
>  #include <linux/once_lite.h>
> +#include <linux/sort.h>
>  
>  #include "dev.h"
>  #include "net-sysfs.h"
> @@ -199,6 +200,11 @@ static int call_netdevice_notifiers_extack(unsigned long val,
>  
>  static DECLARE_RWSEM(devnet_rename_sem);
>  
> +static int cmp_u16(const void *a, const void *b)
> +{
> +	return *(u16 *)a - *(u16 *)b;
> +}
> +
>  static inline void dev_base_seq_inc(struct net *net)
>  {
>  	while (++net->dev_base_seq == 0)
> @@ -2537,6 +2543,31 @@ static void xps_copy_dev_maps(struct xps_dev_maps *dev_maps,
>  	}
>  }
>  
> +static void update_xps_map(struct xps_map *map, int cpu, u16 index,
> +			   bool *skip_tc, int *numa_node_id,
> +			   enum xps_map_type type)
> +{
> +	int pos = 0;
> +
> +	*skip_tc = true;

Maybe let's keep the skip_tc in the main function, output arguments are
not universally liked in the kernel, and it's just a single line.

Otherwise looks good, thank you!
