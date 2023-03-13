Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE15F6B75CC
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 12:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjCMLTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 07:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjCMLTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 07:19:13 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7C727D5C;
        Mon, 13 Mar 2023 04:19:07 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vdm4vjq_1678706344;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Vdm4vjq_1678706344)
          by smtp.aliyun-inc.com;
          Mon, 13 Mar 2023 19:19:05 +0800
Date:   Mon, 13 Mar 2023 19:19:04 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Subject: Re: [PATCH net-next 1/2] net/smc: Introduce explicit check for v2
 support
Message-ID: <ZA8GqKJ1v2Ns4030@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20230313101032.13180-1-wenjia@linux.ibm.com>
 <20230313101032.13180-2-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313101032.13180-2-wenjia@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:10:31AM +0100, Wenjia Zhang wrote:
> From: Stefan Raspl <raspl@linux.ibm.com>
> 
> Previously, v2 support was derived from a very specific format of the SEID
> as part of the SMC-D codebase. Make this part of the SMC-D device API, so
> implementers do not need to adhere to a specific SEID format.
> 
> Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
> Reviewed-and-tested-by: Jan Karcher <jaka@linux.ibm.com>
> Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
> Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>

This solved my doubts about the magic number, and helps the extensions
of SMC-D. Thank you.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

> ---
>  drivers/s390/net/ism_drv.c | 7 +++++++
>  include/net/smc.h          | 1 +
>  net/smc/smc_ism.c          | 2 +-
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
> index eb7e13486087..1c73d32966f1 100644
> --- a/drivers/s390/net/ism_drv.c
> +++ b/drivers/s390/net/ism_drv.c
> @@ -842,6 +842,12 @@ static int smcd_move(struct smcd_dev *smcd, u64 dmb_tok, unsigned int idx,
>  	return ism_move(smcd->priv, dmb_tok, idx, sf, offset, data, size);
>  }
>  
> +static int smcd_supports_v2(void)
> +{
> +	return SYSTEM_EID.serial_number[0] != '0' ||
> +		SYSTEM_EID.type[0] != '0';
> +}
> +
>  static u64 smcd_get_local_gid(struct smcd_dev *smcd)
>  {
>  	return ism_get_local_gid(smcd->priv);
> @@ -869,6 +875,7 @@ static const struct smcd_ops ism_ops = {
>  	.reset_vlan_required = smcd_reset_vlan_required,
>  	.signal_event = smcd_signal_ieq,
>  	.move_data = smcd_move,
> +	.supports_v2 = smcd_supports_v2,
>  	.get_system_eid = ism_get_seid,
>  	.get_local_gid = smcd_get_local_gid,
>  	.get_chid = smcd_get_chid,
> diff --git a/include/net/smc.h b/include/net/smc.h
> index 597cb9381182..a002552be29c 100644
> --- a/include/net/smc.h
> +++ b/include/net/smc.h
> @@ -67,6 +67,7 @@ struct smcd_ops {
>  	int (*move_data)(struct smcd_dev *dev, u64 dmb_tok, unsigned int idx,
>  			 bool sf, unsigned int offset, void *data,
>  			 unsigned int size);
> +	int (*supports_v2)(void);
>  	u8* (*get_system_eid)(void);
>  	u64 (*get_local_gid)(struct smcd_dev *dev);
>  	u16 (*get_chid)(struct smcd_dev *dev);
> diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
> index 3b0b7710c6b0..fbee2493091f 100644
> --- a/net/smc/smc_ism.c
> +++ b/net/smc/smc_ism.c
> @@ -429,7 +429,7 @@ static void smcd_register_dev(struct ism_dev *ism)
>  		u8 *system_eid = NULL;
>  
>  		system_eid = smcd->ops->get_system_eid();
> -		if (system_eid[24] != '0' || system_eid[28] != '0') {
> +		if (smcd->ops->supports_v2()) {
>  			smc_ism_v2_capable = true;
>  			memcpy(smc_ism_v2_system_eid, system_eid,
>  			       SMC_MAX_EID_LEN);
> -- 
> 2.37.2
