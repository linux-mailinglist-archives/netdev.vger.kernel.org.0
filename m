Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30C3653DCA
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 10:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiLVJ5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 04:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbiLVJ5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 04:57:46 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9FD1EC5D;
        Thu, 22 Dec 2022 01:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671703065; x=1703239065;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lzkiTJFuDg+jdbIUsy6bFLfCTacXXEJTXxziusXDoeA=;
  b=H/7yl+ISR5r2hZO5bBIP8if67qf5rubNcqORYYW0BEAn4LfeFWShH7OS
   3bBmZSB7BU31r8qnE6SEpj+sjBR43M4ibzwJVEDnRxo0Tb0Rq48PFdGsV
   pE+pk3rmK8S+ucIiVo5NFLeuxECU98ZhWYPTCLKl0o5bU5mlFGfA/DOCz
   oNIt6fmDyA1aGDSarhqmX1aHyjqqSuWuTg/UcBS3FBr2bsD6WifU1LZiN
   FlV58UcN5Il8MCN18EJIfbGwlW8bXT9Va7WVrYVGZcWVEIdnaUkUsMUqn
   w5r+qqFL6UXRmLZZeKeTE7ilDrFXqYMzpBvi+5J7hFQuJMhcGyKM/ZoZV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="318785717"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="318785717"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 01:57:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="776009637"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="776009637"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 01:57:41 -0800
Date:   Thu, 22 Dec 2022 10:57:32 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] qlcnic: prevent ->dcb use-after-free on
 qlcnic_dcb_enable() failure
Message-ID: <Y6QqDLoqCXHG8KVl@localhost.localdomain>
References: <20221222074223.1746072-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222074223.1746072-1-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 22, 2022 at 10:42:23AM +0300, Daniil Tatianin wrote:
> adapter->dcb would get silently freed inside qlcnic_dcb_enable() in
> case qlcnic_dcb_attach() would return an error, which always happens
> under OOM conditions. This would lead to use-after-free because both
> of the existing callers invoke qlcnic_dcb_get_info() on the obtained
> pointer, which is potentially freed at that point.
> 
> Propagate errors from qlcnic_dcb_enable(), and instead free the dcb
> pointer at callsite using qlcnic_dcb_free(). This also removes the now
> unused qlcnic_clear_dcb_ops() helper, which was a simple wrapper around
> kfree() also causing memory leaks for partially initialized dcb.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Fixes: 3c44bba1d270 ("qlcnic: Disable DCB operations from SR-IOV VFs")
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> ---
> Changes since v1:
> - Add a fixes tag + net as a target
> - Remove qlcnic_clear_dcb_ops entirely & use qlcnic_dcb_free instead
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |  9 ++++++++-
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h       | 10 ++--------
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c      |  9 ++++++++-
>  3 files changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
> index dbb800769cb6..774f2c6875ec 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
> @@ -2505,7 +2505,14 @@ int qlcnic_83xx_init(struct qlcnic_adapter *adapter)
>  		goto disable_mbx_intr;
>  
>  	qlcnic_83xx_clear_function_resources(adapter);
> -	qlcnic_dcb_enable(adapter->dcb);
> +
> +	err = qlcnic_dcb_enable(adapter->dcb);
> +	if (err) {
> +		qlcnic_dcb_free(adapter->dcb);
> +		adapter->dcb = NULL;
Small nit, I think qlcnic_dcb_free() already set adapter->dcb to NULL.

Otherwise, thanks for changing:
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Thanks,
Michal

[...]
> -- 
> 2.25.1
