Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358AB6BCD2F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjCPKsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjCPKrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:47:43 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244F8BE5C2;
        Thu, 16 Mar 2023 03:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678963652; x=1710499652;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BYz5y8qjpu7VLTEbVu95st7NnX4R2KAVJgLfMmMipiA=;
  b=ktO/uFatEgrgBb/1LubSl0GM8wN8xDOHysOZ+KPDrcFkhWOwxGfJUHQ8
   m8y1jkM0HG5tr9fqCxCxr42coi8lsrWcRITpLzusZZIziibUV4D00BQfb
   vF/xMxSgsxLxtLC7BnMpH/yLY1ohtD1xngNoDtbowJuNTbs+uufEdnQlz
   0wDhMDS8kjDLhyn4ugYnfOVHvtwtCw1f+ATiLb6PH15esqQZQTyEs2jUJ
   NLUOMCKJmRUJbE1lfsZprY/X/JMEb9Li3z7TSb8HH/+nzJ95ba9KoGuaV
   bGuQqehsOcIRAu03aO7rWGM+gjtBmljDIh4VC+2lZ1yNT2UWOWvJXLCuL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="424225339"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="424225339"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 03:47:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="679852794"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="679852794"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 03:47:27 -0700
Date:   Thu, 16 Mar 2023 11:47:19 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yuval Mintz <Yuval.Mintz@qlogic.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] qed/qed_sriov: guard against NULL derefs from
 qed_iov_get_vf_info
Message-ID: <ZBLzt+tS/SKO9IGC@localhost.localdomain>
References: <20230316102921.609266-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316102921.609266-1-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 01:29:21PM +0300, Daniil Tatianin wrote:
> We have to make sure that the info returned by the helper is valid
> before using it.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Fixes: f990c82c385b ("qed*: Add support for ndo_set_vf_trust")
> Fixes: 733def6a04bf ("qed*: IOV link control")
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> ---
> Changes since v1:
> - Add a vf check to qed_iov_handle_trust_change as well
> ---
>  drivers/net/ethernet/qlogic/qed/qed_sriov.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
> index 2bf18748581d..fa167b1aa019 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
> @@ -4404,6 +4404,9 @@ qed_iov_configure_min_tx_rate(struct qed_dev *cdev, int vfid, u32 rate)
>  	}
>  
>  	vf = qed_iov_get_vf_info(QED_LEADING_HWFN(cdev), (u16)vfid, true);
> +	if (!vf)
> +		return -EINVAL;
> +
>  	vport_id = vf->vport_id;
>  
>  	return qed_configure_vport_wfq(cdev, vport_id, rate);
> @@ -5152,7 +5155,7 @@ static void qed_iov_handle_trust_change(struct qed_hwfn *hwfn)
>  
>  		/* Validate that the VF has a configured vport */
>  		vf = qed_iov_get_vf_info(hwfn, i, true);
> -		if (!vf->vport_instance)
> +		if (!vf || !vf->vport_instance)
>  			continue;
>  
>  		memset(&params, 0, sizeof(params));
> -- 
> 2.25.1
> 

Thanks,
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

