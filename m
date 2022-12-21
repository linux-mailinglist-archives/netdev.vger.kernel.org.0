Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38AA652F19
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 11:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbiLUKCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 05:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbiLUKBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 05:01:24 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AF5B03;
        Wed, 21 Dec 2022 02:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671616809; x=1703152809;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aiSXeVIBu1312PhslkhPu0/gx5qNetKLWcvvYm3kwKw=;
  b=LHhIn8kv7Sa7NFSTjE+jhyHrjmJftL3Akfdevw67a+FqNbNI+1NqGf3d
   uA29Q/w5nLluIU6YCHPDEtLItukJT/69TlZA1lp5uk0zxAUCQDbfBaerY
   pi/n8AxaT0rqSUOw3r7P9eWU4PJXkEItGiFhqrt8iHI51cpk24p/wiQ5s
   ML3dpjr7lwEL6cM6Y830o6FzJXSUQ/0cJXz0SqYEbLNEJHJUgj5Ju9XsJ
   UxV93Z4rPyLfU/7klg/QLBnBOQ8Kp1s9hSskNTInmkeaoxshx9GoBAVcC
   +OPSmCtH2sRJOjCXoUxrgbW6qYJbTiw1TbA06Bw01mqzMN95VCoGs52pH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="321012467"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="321012467"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 02:00:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="793649553"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="793649553"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 02:00:06 -0800
Date:   Wed, 21 Dec 2022 10:59:57 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] fjes: Fix an error handling path in fjes_probe()
Message-ID: <Y6LZEVU7tKPzjHQ8@localhost.localdomain>
References: <fde673f106d2b264ad76759195901aae94691b5c.1671569785.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fde673f106d2b264ad76759195901aae94691b5c.1671569785.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 09:57:06PM +0100, Christophe JAILLET wrote:
> A netif_napi_add() call is hidden in fjes_sw_init(). It should be undone
> by a corresponding netif_napi_del() call in the error handling path of the
> probe, as already done inthe remove function.
> 
> Fixes: 265859309a76 ("fjes: NAPI polling function")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/fjes/fjes_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
> index 2513be6d4e11..01b4c9c6adbd 100644
> --- a/drivers/net/fjes/fjes_main.c
> +++ b/drivers/net/fjes/fjes_main.c
> @@ -1370,7 +1370,7 @@ static int fjes_probe(struct platform_device *plat_dev)
>  	adapter->txrx_wq = alloc_workqueue(DRV_NAME "/txrx", WQ_MEM_RECLAIM, 0);
>  	if (unlikely(!adapter->txrx_wq)) {
>  		err = -ENOMEM;
> -		goto err_free_netdev;
> +		goto err_del_napi;
>  	}
>  
>  	adapter->control_wq = alloc_workqueue(DRV_NAME "/control",
> @@ -1431,6 +1431,8 @@ static int fjes_probe(struct platform_device *plat_dev)
>  	destroy_workqueue(adapter->control_wq);
>  err_free_txrx_wq:
>  	destroy_workqueue(adapter->txrx_wq);
> +err_del_napi:
> +	netif_napi_del(&adapter->napi);
>  err_free_netdev:
>  	free_netdev(netdev);
>  err_out:

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

I wonder if it won't be better to have fjes_sw_deinit() instead or
change fjes_sw_init to only netif_napi_add(). You know, to avoid another
bug here when someone add sth to the fjes_sw_deinit(). This is only
suggestion, patch looks fine.

> -- 
> 2.34.1
> 
