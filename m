Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC353321FA
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 10:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhCIJ3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 04:29:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhCIJ3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 04:29:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB48A65147;
        Tue,  9 Mar 2021 09:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615282164;
        bh=HFGmi8rzCAxBuPLkXLGdLa4BaBiywbkeurZcYob/UkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=flktNeL7Xcd4MOIheBp0unULpR8hV4R7fKB4OBmDxHgJdmmGxjNmsTFgAZZmvz9qb
         NSOBUgqZEYCl226cfL0VggRT0srtHq+iguRVXzBeUUkZuTN0fapG0LWdzVBxoGHfLP
         nEPL3bQMKasdGxfXtk3a1vwxDF/GZBVH8ja2xY9E=
Date:   Tue, 9 Mar 2021 10:29:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: Re: [PATCH v10 14/20] dlb: add start domain ioctl
Message-ID: <YEc/8RxroJzrN3xm@kroah.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-15-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210210175423.1873-15-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 11:54:17AM -0600, Mike Ximing Chen wrote:
> Add ioctl to start a domain. Once a scheduling domain and its resources
> have been configured, this ioctl is called to allow the domain's ports to
> begin enqueueing to the device. Once started, the domain's resources cannot
> be configured again until after the domain is reset.
> 
> This ioctl instructs the DLB device to start load-balancing operations.
> It corresponds to rte_event_dev_start() function in DPDK' eventdev library.
> 
> Signed-off-by: Gage Eads <gage.eads@intel.com>
> Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
> Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/misc/dlb/dlb_ioctl.c    |   3 +
>  drivers/misc/dlb/dlb_main.h     |   4 ++
>  drivers/misc/dlb/dlb_pf_ops.c   |   9 +++
>  drivers/misc/dlb/dlb_resource.c | 116 ++++++++++++++++++++++++++++++++
>  drivers/misc/dlb/dlb_resource.h |   4 ++
>  include/uapi/linux/dlb.h        |  22 ++++++
>  6 files changed, 158 insertions(+)
> 
> diff --git a/drivers/misc/dlb/dlb_ioctl.c b/drivers/misc/dlb/dlb_ioctl.c
> index 6a311b969643..9b05344f03c8 100644
> --- a/drivers/misc/dlb/dlb_ioctl.c
> +++ b/drivers/misc/dlb/dlb_ioctl.c
> @@ -51,6 +51,7 @@ DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(create_ldb_queue)
>  DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(create_dir_queue)
>  DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(get_ldb_queue_depth)
>  DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(get_dir_queue_depth)
> +DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(start_domain)
>  
>  /*
>   * Port creation ioctls don't use the callback template macro.
> @@ -322,6 +323,8 @@ long dlb_domain_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
>  		return dlb_domain_ioctl_get_dir_port_pp_fd(dlb, dom, arg);
>  	case DLB_IOC_GET_DIR_PORT_CQ_FD:
>  		return dlb_domain_ioctl_get_dir_port_cq_fd(dlb, dom, arg);
> +	case DLB_IOC_START_DOMAIN:
> +		return dlb_domain_ioctl_start_domain(dlb, dom, arg);
>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/drivers/misc/dlb/dlb_main.h b/drivers/misc/dlb/dlb_main.h
> index 477974e1a178..2f3096a45b1e 100644
> --- a/drivers/misc/dlb/dlb_main.h
> +++ b/drivers/misc/dlb/dlb_main.h
> @@ -63,6 +63,10 @@ struct dlb_device_ops {
>  			       struct dlb_create_dir_port_args *args,
>  			       uintptr_t cq_dma_base,
>  			       struct dlb_cmd_response *resp);
> +	int (*start_domain)(struct dlb_hw *hw,
> +			    u32 domain_id,
> +			    struct dlb_start_domain_args *args,
> +			    struct dlb_cmd_response *resp);
>  	int (*get_num_resources)(struct dlb_hw *hw,
>  				 struct dlb_get_num_resources_args *args);
>  	int (*reset_domain)(struct dlb_hw *hw, u32 domain_id);
> diff --git a/drivers/misc/dlb/dlb_pf_ops.c b/drivers/misc/dlb/dlb_pf_ops.c
> index 02a188aa5a60..ce9d29b94a55 100644
> --- a/drivers/misc/dlb/dlb_pf_ops.c
> +++ b/drivers/misc/dlb/dlb_pf_ops.c
> @@ -160,6 +160,14 @@ dlb_pf_create_dir_port(struct dlb_hw *hw, u32 id,
>  				       resp, false, 0);
>  }
>  
> +static int
> +dlb_pf_start_domain(struct dlb_hw *hw, u32 id,
> +		    struct dlb_start_domain_args *args,
> +		    struct dlb_cmd_response *resp)
> +{
> +	return dlb_hw_start_domain(hw, id, args, resp, false, 0);
> +}
> +
>  static int dlb_pf_get_num_resources(struct dlb_hw *hw,
>  				    struct dlb_get_num_resources_args *args)
>  {
> @@ -232,6 +240,7 @@ struct dlb_device_ops dlb_pf_ops = {
>  	.create_dir_queue = dlb_pf_create_dir_queue,
>  	.create_ldb_port = dlb_pf_create_ldb_port,
>  	.create_dir_port = dlb_pf_create_dir_port,
> +	.start_domain = dlb_pf_start_domain,

Why do you have a "callback" when you only ever call one function?  Why
is that needed at all?

thanks,

greg k-h
