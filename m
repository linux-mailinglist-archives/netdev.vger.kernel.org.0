Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1DC6BC850
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjCPIKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjCPIKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:10:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CE337710;
        Thu, 16 Mar 2023 01:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678954215; x=1710490215;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K9DMyKLnUq3+dJoYUSZeV9EfB5sCY/E9PdCn3oo45/c=;
  b=HEsLWxmd78FOdFJES6iWXDvyDSwlWSM7oLO0ivRyTUsgEVoaUveKKsau
   G3C2wknMS3swg1NqWiV/synE/STFVM5deix4dfiYu1Bx5Jeb6yMueGHAB
   qWsWdVYsIAb+yMQZaUsIQHjPv4J7hvqmk8wMVYQZgk6ARmPPgYkSCN8Bl
   aqQ0qChR+u0Ls4gA8/nAgmDBEKmT/JL4KYd5+en4Ac349JmB3sm6l2TFr
   bKxCdwF1Jdw7PXTH3KA6tlfjtYhD3OShp/VZoLsfKAWhRhDV8Nm+lT1ws
   I8VIRI66tHlrl8HNrnrA2D83EYsQinYhA923F66aMJSd74BpaKUd68TZA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="337938652"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="337938652"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 01:10:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="925668258"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="925668258"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 01:10:12 -0700
Date:   Thu, 16 Mar 2023 09:10:04 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] octeontx2-vf: Add missing free for alloc_percpu
Message-ID: <ZBLO3FSC4IhoBzl1@localhost.localdomain>
References: <20230316023911.3615-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316023911.3615-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 10:39:11AM +0800, Jiasheng Jiang wrote:
> Add the free_percpu for the allocated "vf->hw.lmt_info" in order to avoid
> memory leak, same as the "pf->hw.lmt_info" in
> `drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c`.
> 
> Fixes: 5c0512072f65 ("octeontx2-pf: cn10k: Use runtime allocated LMTLINE region")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> index 7f8ffbf79cf7..9db2e2d218bb 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> @@ -709,6 +709,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  err_ptp_destroy:
>  	otx2_ptp_destroy(vf);
>  err_detach_rsrc:
> +	if (vf->hw.lmt_info)
> +		free_percpu(vf->hw.lmt_info);
>  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
>  		qmem_free(vf->dev, vf->dync_lmt);
I wonder if it wouldn't be more error prune when You create a function
to unroll cn10k_lmtst_init() like cn10k_lmtst_deinit(). These two if can
be there, maybe also sth else is missing.

Otherwise it is fine
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

>  	otx2_detach_resources(&vf->mbox);
> @@ -762,6 +764,8 @@ static void otx2vf_remove(struct pci_dev *pdev)
>  	otx2_shutdown_tc(vf);
>  	otx2vf_disable_mbox_intr(vf);
>  	otx2_detach_resources(&vf->mbox);
> +	if (vf->hw.lmt_info)
> +		free_percpu(vf->hw.lmt_info);
>  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
>  		qmem_free(vf->dev, vf->dync_lmt);
>  	otx2vf_vfaf_mbox_destroy(vf);
> -- 
> 2.25.1
> 
