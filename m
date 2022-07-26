Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682E25809D3
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 05:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbiGZDNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 23:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiGZDNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 23:13:40 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6D32A264;
        Mon, 25 Jul 2022 20:13:37 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VKTKrXn_1658805214;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VKTKrXn_1658805214)
          by smtp.aliyun-inc.com;
          Tue, 26 Jul 2022 11:13:35 +0800
Date:   Tue, 26 Jul 2022 11:13:34 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Subject: Re: [PATCH net-next 2/4] s390/ism: Cleanups
Message-ID: <Yt9b3htzA6/HPSKo@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220725141000.70347-1-wenjia@linux.ibm.com>
 <20220725141000.70347-3-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725141000.70347-3-wenjia@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 04:09:58PM +0200, Wenjia Zhang wrote:
> From: Stefan Raspl <raspl@linux.ibm.com>
> 
> Reworked signature of the function to retrieve the system EID: No plausible
> reason to use a double pointer. And neither to pass in the device as an
> argument, as this identifier is by definition per system, not per device.
> Plus some minor consistency edits.
> 
> Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
> Signed-off-by: Wenjia Zhang < wenjia@linux.ibm.com>

LGTM.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

> ---
>  drivers/s390/net/ism_drv.c | 11 +++++------
>  include/net/smc.h          |  2 +-
>  net/smc/smc_ism.c          |  2 +-
>  3 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
> index 5f7e28de8b15..4665e9a0e048 100644
> --- a/drivers/s390/net/ism_drv.c
> +++ b/drivers/s390/net/ism_drv.c
> @@ -409,20 +409,19 @@ static void ism_create_system_eid(void)
>  	memcpy(&SYSTEM_EID.type, tmp, 4);
>  }
>  
> -static void ism_get_system_eid(struct smcd_dev *smcd, u8 **eid)
> +static u8 *ism_get_system_eid(void)
>  {
> -	*eid = &SYSTEM_EID.seid_string[0];
> +	return SYSTEM_EID.seid_string;
>  }
>  
>  static u16 ism_get_chid(struct smcd_dev *smcd)
>  {
> -	struct ism_dev *ismdev;
> +	struct ism_dev *ism = (struct ism_dev *)smcd->priv;
>  
> -	ismdev = (struct ism_dev *)smcd->priv;
> -	if (!ismdev || !ismdev->pdev)
> +	if (!ism || !ism->pdev)
>  		return 0;
>  
> -	return to_zpci(ismdev->pdev)->pchid;
> +	return to_zpci(ism->pdev)->pchid;
>  }
>  
>  static void ism_handle_event(struct ism_dev *ism)
> diff --git a/include/net/smc.h b/include/net/smc.h
> index 37f829d9c6e5..1868a5014dea 100644
> --- a/include/net/smc.h
> +++ b/include/net/smc.h
> @@ -72,7 +72,7 @@ struct smcd_ops {
>  	int (*move_data)(struct smcd_dev *dev, u64 dmb_tok, unsigned int idx,
>  			 bool sf, unsigned int offset, void *data,
>  			 unsigned int size);
> -	void (*get_system_eid)(struct smcd_dev *dev, u8 **eid);
> +	u8* (*get_system_eid)(void);
>  	u16 (*get_chid)(struct smcd_dev *dev);
>  };
>  
> diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
> index c656ef25ee4b..e51c0cdff8e0 100644
> --- a/net/smc/smc_ism.c
> +++ b/net/smc/smc_ism.c
> @@ -429,7 +429,7 @@ int smcd_register_dev(struct smcd_dev *smcd)
>  	if (list_empty(&smcd_dev_list.list)) {
>  		u8 *system_eid = NULL;
>  
> -		smcd->ops->get_system_eid(smcd, &system_eid);
> +		system_eid = smcd->ops->get_system_eid();
>  		if (system_eid[24] != '0' || system_eid[28] != '0') {
>  			smc_ism_v2_capable = true;
>  			memcpy(smc_ism_v2_system_eid, system_eid,
> -- 
> 2.35.2
