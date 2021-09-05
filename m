Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5769E400E8F
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 09:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbhIEHYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 03:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236152AbhIEHYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 03:24:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBB5F60F4A;
        Sun,  5 Sep 2021 07:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630826620;
        bh=Bl5XjlnUT7ec37WklJ+pflfpCbR6md7qSYkSRa9o8jA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BXlXQaXhmiIky1Oq2A9b/ufFM2/vf1hpEf5fSuIQrVz/qGyvryVOsUIlA/ckyZI0j
         2oeP3sspHJK24YJqm3hbylunwXta6kk4bdCd70Q045pulWAp6g1mYgaeYbJTl2fw9p
         ABgXECNtVmGb4NJjD3K1fWnf7Qs/hUjj0Jn6aWAENGxaz43zgo0bbx3MtVjEorrITa
         ob9ESVjWcVl41aEDWPMGzGi7Qn6WiLIcNAZFf/MUxCgs+W6FsuMoVGVE+ecsAxOuAk
         NvXnCAluF+D5JBCabbR+rv4kPSjMvTC1IaVV98l8E3B3fvEpU+RGrPDBqdPdncaU0G
         b87lPdbZEhvEA==
Date:   Sun, 5 Sep 2021 10:23:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yongxin Liu <yongxin.liu@windriver.com>
Cc:     david.m.ertman@intel.com, shiraz.saleem@intel.com,
        anthony.l.nguyen@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, intel-wired-lan@lists.osuosl.org,
        kuba@kernel.org
Subject: Re: [PATCH net] ice: check whether AUX devices/drivers are supported
 in ice_rebuild
Message-ID: <YTRweH4JMbzUtxLf@unreal>
References: <20210903012500.39407-1-yongxin.liu@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903012500.39407-1-yongxin.liu@windriver.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 09:25:00AM +0800, Yongxin Liu wrote:
> In ice_rebuild(), check whether AUX devices/drivers are supported or not
> before calling ice_plug_aux_dev().
> 
> Fix the following call trace, if RDMA functionality is not available.
> 
>   auxiliary ice.roce.0: adding auxiliary device failed!: -17
>   sysfs: cannot create duplicate filename '/bus/auxiliary/devices/ice.roce.0'
>   Workqueue: ice ice_service_task [ice]
>   Call Trace:
>    dump_stack_lvl+0x38/0x49
>    dump_stack+0x10/0x12
>    sysfs_warn_dup+0x5b/0x70
>    sysfs_do_create_link_sd.isra.2+0xc8/0xd0
>    sysfs_create_link+0x25/0x40
>    bus_add_device+0x6d/0x110
>    device_add+0x49d/0x940
>    ? _printk+0x52/0x6e
>    ? _printk+0x52/0x6e
>    __auxiliary_device_add+0x60/0xc0
>    ice_plug_aux_dev+0xd3/0xf0 [ice]
>    ice_rebuild+0x27d/0x510 [ice]
>    ice_do_reset+0x51/0xe0 [ice]
>    ice_service_task+0x108/0xe70 [ice]
>    ? __switch_to+0x13b/0x510
>    process_one_work+0x1de/0x420
>    ? apply_wqattrs_cleanup+0xc0/0xc0
>    worker_thread+0x34/0x400
>    ? apply_wqattrs_cleanup+0xc0/0xc0
>    kthread+0x14d/0x180
>    ? set_kthread_struct+0x40/0x40
>    ret_from_fork+0x1f/0x30
> 
> Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
> Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 0d6c143f6653..98cc708e9517 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -6466,7 +6466,9 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
>  	/* if we get here, reset flow is successful */
>  	clear_bit(ICE_RESET_FAILED, pf->state);
>  
> -	ice_plug_aux_dev(pf);
> +	if (ice_is_aux_ena(pf))
> +		ice_plug_aux_dev(pf);
> +

The change is ok, but it hints that auxiliary bus is used horribly wrong
in this driver. In proper implementation, which should rely on driver/core,
every subdriver like ice.eth, ice.roce e.t.c is supposed to be retriggered
by the code and shouldn't  ave "if (ice_is_aux_ena(pf))" checks.

Thanks

>  	return;
>  
>  err_vsi_rebuild:
> -- 
> 2.14.5
> 
