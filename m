Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F022A5BDC
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbgKDB0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:26:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729246AbgKDB0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:26:09 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1F212242F;
        Wed,  4 Nov 2020 01:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604453169;
        bh=6a1hctPe2KygmZp7wOUYcvwOdBY2Yv0EfW16l+TmqWs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tIDWgXqRZkUctZ/KK3glz2w5aZkIN2MyW8k4y/2eKKg/QD010gzKkI5rpRO35r4G8
         VTELI5HnhTUj4jYpy+33iJW9gu6EzQzEqfBc11cKh9b4slB7F4aO0Z39xhnuCKEala
         P21FuOg+K3FLah/Xs+Xcw/5NA9hj3UB/kBl4lamA=
Message-ID: <1c831e09cd2c42d69f5702733e7b083581517e79.camel@kernel.org>
Subject: Re: [PATCH net-next v2 11/15] net/smc: Add SMC-D Linkgroup
 diagnostic support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Date:   Tue, 03 Nov 2020 17:26:07 -0800
In-Reply-To: <20201103102531.91710-12-kgraul@linux.ibm.com>
References: <20201103102531.91710-1-kgraul@linux.ibm.com>
         <20201103102531.91710-12-kgraul@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-03 at 11:25 +0100, Karsten Graul wrote:
> From: Guvenc Gulce <guvenc@linux.ibm.com>
> 
> Deliver SMCD Linkgroup information via netlink based
> diagnostic interface.
> 
> Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> ---
>  include/uapi/linux/smc_diag.h |   7 +++
>  net/smc/smc_diag.c            | 108
> ++++++++++++++++++++++++++++++++++
>  net/smc/smc_ism.c             |   2 +
>  3 files changed, 117 insertions(+)
> 
> diff --git a/include/uapi/linux/smc_diag.h
> b/include/uapi/linux/smc_diag.h
> index a57df0296aa4..5a80172df757 100644
> --- a/include/uapi/linux/smc_diag.h
> +++ b/include/uapi/linux/smc_diag.h
> @@ -81,6 +81,7 @@ enum {
>  enum {
>  	SMC_DIAG_LGR_INFO_SMCR = 1,
>  	SMC_DIAG_LGR_INFO_SMCR_LINK,
> +	SMC_DIAG_LGR_INFO_SMCD,
>  };
>  
> 
> +
> +static int smc_diag_fill_smcd_dev(struct smcd_dev_list *dev_list,
> +				  struct sk_buff *skb,
> +				  struct netlink_callback *cb,
> +				  struct smc_diag_req_v2 *req)
> +{
> +	struct smc_diag_dump_ctx *cb_ctx = smc_dump_context(cb);
> +	struct smcd_dev *smcd_dev;
> +	int snum = cb_ctx->pos[0];
> +	int rc = 0, num = 0;
> +
> +	mutex_lock(&dev_list->mutex);
> +	list_for_each_entry(smcd_dev, &dev_list->list, list) {
> +		if (!list_empty(&smcd_dev->lgr_list)) {

You could use early continue every where in this patch to avoid
indentation. 

> +			if (num < snum)
> +				goto next;
> +			rc = smc_diag_handle_smcd_lgr(smcd_dev, skb,
> +						      cb, req);
> +			if (rc < 0)
> +				goto errout;
> +next:
> +			num++;
> +		}
> +	}
> +errout:
> +	mutex_unlock(&dev_list->mutex);
> +	cb_ctx->pos[0] = num;
> +	return rc;
> +}
> +
>  static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  			   struct netlink_callback *cb,
>  			   const struct smc_diag_req *req)
> @@ -441,6 +546,9 @@ static int smc_diag_dump_ext(struct sk_buff *skb,
> struct netlink_callback *cb)
>  		if ((req->cmd_ext & (1 << (SMC_DIAG_LGR_INFO_SMCR -
> 1))))
>  			smc_diag_fill_lgr_list(&smc_lgr_list, skb, cb,
>  					       req);
> +		if ((req->cmd_ext & (1 << (SMC_DIAG_LGR_INFO_SMCD -
> 1))))
> +			smc_diag_fill_smcd_dev(&smcd_dev_list, skb, cb,
> +					       req);
>  	}
>  
>  	return skb->len;
> diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
> index 6abbdd09a580..5bb2c7fb4ea8 100644
> --- a/net/smc/smc_ism.c
> +++ b/net/smc/smc_ism.c
> @@ -20,6 +20,7 @@ struct smcd_dev_list smcd_dev_list = {
>  	.list = LIST_HEAD_INIT(smcd_dev_list.list),
>  	.mutex = __MUTEX_INITIALIZER(smcd_dev_list.mutex)
>  };
> +EXPORT_SYMBOL_GPL(smcd_dev_list);
>  
>  bool smc_ism_v2_capable;
>  
> @@ -50,6 +51,7 @@ u16 smc_ism_get_chid(struct smcd_dev *smcd)
>  {
>  	return smcd->ops->get_chid(smcd);
>  }
> +EXPORT_SYMBOL_GPL(smc_ism_get_chid);
>  

This is the 3rd EXPORT SYMBOL until now in this series,
IMHO it is unhealthy to contaminate the kernel symbol table just for
device specific diag purposes.


