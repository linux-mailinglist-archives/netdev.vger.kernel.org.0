Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFE95E5F79
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 12:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiIVKKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 06:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiIVKKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 06:10:33 -0400
X-Greylist: delayed 2881 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 22 Sep 2022 03:10:21 PDT
Received: from stargate.chelsio.com (stargate.chelsio.com [12.32.117.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252E8D5777;
        Thu, 22 Sep 2022 03:10:16 -0700 (PDT)
Received: from localhost (chethan-pc.asicdesigners.com [10.193.177.183] (may be forged))
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 28M9LqH9001337;
        Thu, 22 Sep 2022 02:21:54 -0700
Date:   Thu, 22 Sep 2022 14:51:52 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Rafael Mendonca <rafaelmendsr@gmail.com>
Cc:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/1] cxgb4: fix missing unlock on ETHOFLD
 desc collect fail path
Message-ID: <YywpMC2gpdTbfFbL@chelsio.com>
References: <20220922053237.750832-1-rafaelmendsr@gmail.com>
 <20220922053237.750832-2-rafaelmendsr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922053237.750832-2-rafaelmendsr@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, September 09/22/22, 2022 at 02:32:36 -0300, Rafael Mendonca wrote:
> The label passed to the QDESC_GET for the ETHOFLD TXQ, RXQ, and FLQ, is the
> 'out' one, which skips the 'out_unlock' label, and thus doesn't unlock the
> 'uld_mutex' before returning. Additionally, since commit 5148e5950c67
> ("cxgb4: add EOTID tracking and software context dump"), the access to
> these ETHOFLD hardware queues should be protected by the 'mqprio_mutex'
> instead.
> 
> Fixes: 2d0cb84dd973 ("cxgb4: add ETHOFLD hardware queue support")
> Fixes: 5148e5950c67 ("cxgb4: add EOTID tracking and software context dump")
> Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>

Yes, the ETHOFLD queues do need to be accessed after unlocking the
uld_mutex and then taking the mqprio_mutex. Thanks for the fix!

Reviewed-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>


> ---
>  .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 28 +++++++++++++------
>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
> index a7f291c89702..557c591a6ce3 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
> @@ -14,6 +14,7 @@
>  #include "cudbg_entity.h"
>  #include "cudbg_lib.h"
>  #include "cudbg_zlib.h"
> +#include "cxgb4_tc_mqprio.h"
>  
>  static const u32 t6_tp_pio_array[][IREG_NUM_ELEM] = {
>  	{0x7e40, 0x7e44, 0x020, 28}, /* t6_tp_pio_regs_20_to_3b */
> @@ -3458,7 +3459,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
>  			for (i = 0; i < utxq->ntxq; i++)
>  				QDESC_GET_TXQ(&utxq->uldtxq[i].q,
>  					      cudbg_uld_txq_to_qtype(j),
> -					      out_unlock);
> +					      out_unlock_uld);
>  		}
>  	}
>  
> @@ -3475,7 +3476,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
>  			for (i = 0; i < urxq->nrxq; i++)
>  				QDESC_GET_RXQ(&urxq->uldrxq[i].rspq,
>  					      cudbg_uld_rxq_to_qtype(j),
> -					      out_unlock);
> +					      out_unlock_uld);
>  		}
>  
>  		/* ULD FLQ */
> @@ -3487,7 +3488,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
>  			for (i = 0; i < urxq->nrxq; i++)
>  				QDESC_GET_FLQ(&urxq->uldrxq[i].fl,
>  					      cudbg_uld_flq_to_qtype(j),
> -					      out_unlock);
> +					      out_unlock_uld);
>  		}
>  
>  		/* ULD CIQ */
> @@ -3500,29 +3501,34 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
>  			for (i = 0; i < urxq->nciq; i++)
>  				QDESC_GET_RXQ(&urxq->uldrxq[base + i].rspq,
>  					      cudbg_uld_ciq_to_qtype(j),
> -					      out_unlock);
> +					      out_unlock_uld);
>  		}
>  	}
> +	mutex_unlock(&uld_mutex);
> +
> +	if (!padap->tc_mqprio)
> +		goto out;
>  
> +	mutex_lock(&padap->tc_mqprio->mqprio_mutex);
>  	/* ETHOFLD TXQ */
>  	if (s->eohw_txq)
>  		for (i = 0; i < s->eoqsets; i++)
>  			QDESC_GET_TXQ(&s->eohw_txq[i].q,
> -				      CUDBG_QTYPE_ETHOFLD_TXQ, out);
> +				      CUDBG_QTYPE_ETHOFLD_TXQ, out_unlock_mqprio);
>  
>  	/* ETHOFLD RXQ and FLQ */
>  	if (s->eohw_rxq) {
>  		for (i = 0; i < s->eoqsets; i++)
>  			QDESC_GET_RXQ(&s->eohw_rxq[i].rspq,
> -				      CUDBG_QTYPE_ETHOFLD_RXQ, out);
> +				      CUDBG_QTYPE_ETHOFLD_RXQ, out_unlock_mqprio);
>  
>  		for (i = 0; i < s->eoqsets; i++)
>  			QDESC_GET_FLQ(&s->eohw_rxq[i].fl,
> -				      CUDBG_QTYPE_ETHOFLD_FLQ, out);
> +				      CUDBG_QTYPE_ETHOFLD_FLQ, out_unlock_mqprio);
>  	}
>  
> -out_unlock:
> -	mutex_unlock(&uld_mutex);
> +out_unlock_mqprio:
> +	mutex_unlock(&padap->tc_mqprio->mqprio_mutex);
>  
>  out:
>  	qdesc_info->qdesc_entry_size = sizeof(*qdesc_entry);
> @@ -3559,6 +3565,10 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
>  #undef QDESC_GET
>  
>  	return rc;
> +
> +out_unlock_uld:
> +	mutex_unlock(&uld_mutex);
> +	goto out;
>  }
>  
>  int cudbg_collect_flash(struct cudbg_init *pdbg_init,
> -- 
> 2.34.1
> 
