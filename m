Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E45E5809D1
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 05:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbiGZDMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 23:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiGZDMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 23:12:09 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50F82A25F;
        Mon, 25 Jul 2022 20:12:03 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VKTOx0y_1658805120;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VKTOx0y_1658805120)
          by smtp.aliyun-inc.com;
          Tue, 26 Jul 2022 11:12:00 +0800
Date:   Tue, 26 Jul 2022 11:11:59 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Subject: Re: [PATCH net-next 3/4] net/smc: Pass on DMBE bit mask in IRQ
 handler
Message-ID: <Yt9bf/u0M2bjRvLI@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220725141000.70347-1-wenjia@linux.ibm.com>
 <20220725141000.70347-4-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725141000.70347-4-wenjia@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 04:09:59PM +0200, Wenjia Zhang wrote:
> From: Stefan Raspl <raspl@linux.ibm.com>
> 
> Make the DMBE bits, which are passed on individually in ism_move() as
> parameter idx, available to the receiver.
> 
> Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
> Signed-off-by: Wenjia Zhang < wenjia@linux.ibm.com>

LGTM.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

> ---
>  drivers/s390/net/ism_drv.c | 4 +++-
>  include/net/smc.h          | 2 +-
>  net/smc/smc_ism.c          | 6 +++---
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
> index 4665e9a0e048..d34bb6ec1490 100644
> --- a/drivers/s390/net/ism_drv.c
> +++ b/drivers/s390/net/ism_drv.c
> @@ -443,6 +443,7 @@ static irqreturn_t ism_handle_irq(int irq, void *data)
>  	struct ism_dev *ism = data;
>  	unsigned long bit, end;
>  	unsigned long *bv;
> +	u16 dmbemask;
>  
>  	bv = (void *) &ism->sba->dmb_bits[ISM_DMB_WORD_OFFSET];
>  	end = sizeof(ism->sba->dmb_bits) * BITS_PER_BYTE - ISM_DMB_BIT_OFFSET;
> @@ -456,9 +457,10 @@ static irqreturn_t ism_handle_irq(int irq, void *data)
>  			break;
>  
>  		clear_bit_inv(bit, bv);
> +		dmbemask = ism->sba->dmbe_mask[bit + ISM_DMB_BIT_OFFSET];
>  		ism->sba->dmbe_mask[bit + ISM_DMB_BIT_OFFSET] = 0;
>  		barrier();
> -		smcd_handle_irq(ism->smcd, bit + ISM_DMB_BIT_OFFSET);
> +		smcd_handle_irq(ism->smcd, bit + ISM_DMB_BIT_OFFSET, dmbemask);
>  	}
>  
>  	if (ism->sba->e) {
> diff --git a/include/net/smc.h b/include/net/smc.h
> index 1868a5014dea..c926d3313e05 100644
> --- a/include/net/smc.h
> +++ b/include/net/smc.h
> @@ -101,5 +101,5 @@ int smcd_register_dev(struct smcd_dev *smcd);
>  void smcd_unregister_dev(struct smcd_dev *smcd);
>  void smcd_free_dev(struct smcd_dev *smcd);
>  void smcd_handle_event(struct smcd_dev *dev, struct smcd_event *event);
> -void smcd_handle_irq(struct smcd_dev *dev, unsigned int bit);
> +void smcd_handle_irq(struct smcd_dev *dev, unsigned int bit, u16 dmbemask);
>  #endif	/* _SMC_H */
> diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
> index e51c0cdff8e0..911fe08bc54b 100644
> --- a/net/smc/smc_ism.c
> +++ b/net/smc/smc_ism.c
> @@ -508,13 +508,13 @@ void smcd_handle_event(struct smcd_dev *smcd, struct smcd_event *event)
>  EXPORT_SYMBOL_GPL(smcd_handle_event);
>  
>  /* SMCD Device interrupt handler. Called from ISM device interrupt handler.
> - * Parameters are smcd device pointer and DMB number. Find the connection and
> - * schedule the tasklet for this connection.
> + * Parameters are smcd device pointer, DMB number, and the DMBE bitmask.
> + * Find the connection and schedule the tasklet for this connection.
>   *
>   * Context:
>   * - Function called in IRQ context from ISM device driver IRQ handler.
>   */
> -void smcd_handle_irq(struct smcd_dev *smcd, unsigned int dmbno)
> +void smcd_handle_irq(struct smcd_dev *smcd, unsigned int dmbno, u16 dmbemask)
>  {
>  	struct smc_connection *conn = NULL;
>  	unsigned long flags;
> -- 
> 2.35.2
