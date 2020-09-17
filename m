Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771AF26E638
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgIQUFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:05:54 -0400
Received: from mga06.intel.com ([134.134.136.31]:35244 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgIQUFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 16:05:33 -0400
IronPort-SDR: ZPax8S8ezMZxBdDaHFQzHz5vxOTUOZjFjijH1sZZG6iI/R/K3Lmk3eF4RaWd9hx1b7LjRTZ84Y
 MQ+ftYeXJaTg==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="221337843"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="221337843"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 12:50:30 -0700
IronPort-SDR: u2WhtPBNeq35BCa6MiwjAjNtcQzXnsA8BUud9Bdb9JnAJwyJ1u1gExyqThxSl7G4IrHf87goaY
 HrPBmLRzCf4g==
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="483886582"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.151.155]) ([10.212.151.155])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 12:50:29 -0700
Subject: Re: [PATCH v4 net-next 1/5] devlink: add timeout information to
 status_notify
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net
References: <20200917030204.50098-1-snelson@pensando.io>
 <20200917030204.50098-2-snelson@pensando.io>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <4036d5eb-2e12-b4e2-03b1-94d6a93af0b6@intel.com>
Date:   Thu, 17 Sep 2020 12:50:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200917030204.50098-2-snelson@pensando.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/16/2020 8:02 PM, Shannon Nelson wrote:
> Add a timeout element to the DEVLINK_CMD_FLASH_UPDATE_STATUS
> netlink message for use by a userland utility to show that
> a particular firmware flash activity may take a long but
> bounded time to finish.  Also add a handy helper for drivers
> to make use of the new timeout value.
> 
> UI usage hints:
>  - if non-zero, add timeout display to the end of the status line
>  	[component] status_msg  ( Xm Ys : Am Bs )
>      using the timeout value for Am Bs and updating the Xm Ys
>      every second
>  - if the timeout expires while awaiting the next update,
>    display something like
>  	[component] status_msg  ( timeout reached : Am Bs )
>  - if new status notify messages are received, remove
>    the timeout and start over
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---

This one looks good to me. I think the only other things that I saw from
previous discussion are:

a) we could convert the internal helper devlink_nl_flash_update_fill and
__devlink_flash_update_notify to use structs for their fields, and..

b) Jakub pointed out that most drivers don't currently use the component
field so we could remove that from the helpers.

However, I don't have strong feelings about those either way, so:

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  include/net/devlink.h        |  4 ++++
>  include/uapi/linux/devlink.h |  3 +++
>  net/core/devlink.c           | 29 +++++++++++++++++++++++------
>  3 files changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index eaec0a8cc5ef..f206accf80ad 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1400,6 +1400,10 @@ void devlink_flash_update_status_notify(struct devlink *devlink,
>  					const char *component,
>  					unsigned long done,
>  					unsigned long total);
> +void devlink_flash_update_timeout_notify(struct devlink *devlink,
> +					 const char *status_msg,
> +					 const char *component,
> +					 unsigned long timeout);
>  
>  int devlink_traps_register(struct devlink *devlink,
>  			   const struct devlink_trap *traps,
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 40d35145c879..4a6e213cfa04 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -460,6 +460,9 @@ enum devlink_attr {
>  
>  	DEVLINK_ATTR_PORT_EXTERNAL,		/* u8 */
>  	DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,	/* u32 */
> +
> +	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT,	/* u64 */
> +
>  	/* add new attributes above here, update the policy in devlink.c */
>  
>  	__DEVLINK_ATTR_MAX,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 19037f114307..01f855e53e06 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -3024,7 +3024,9 @@ static int devlink_nl_flash_update_fill(struct sk_buff *msg,
>  					enum devlink_command cmd,
>  					const char *status_msg,
>  					const char *component,
> -					unsigned long done, unsigned long total)
> +					unsigned long done,
> +					unsigned long total,
> +					unsigned long timeout)

Number of paramters here is getting rather large. Does it make sense to
convert this one to a struct now?

>  {
>  	void *hdr;
>  
> @@ -3052,6 +3054,9 @@ static int devlink_nl_flash_update_fill(struct sk_buff *msg,
>  	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,
>  			      total, DEVLINK_ATTR_PAD))
>  		goto nla_put_failure;
> +	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT,
> +			      timeout, DEVLINK_ATTR_PAD))
> +		goto nla_put_failure;
>  
>  out:
>  	genlmsg_end(msg, hdr);
> @@ -3067,7 +3072,8 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
>  					  const char *status_msg,
>  					  const char *component,
>  					  unsigned long done,
> -					  unsigned long total)
> +					  unsigned long total,
> +					  unsigned long timeout)
>  {
>  	struct sk_buff *msg;
>  	int err;
> @@ -3081,7 +3087,7 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
>  		return;
>  
>  	err = devlink_nl_flash_update_fill(msg, devlink, cmd, status_msg,
> -					   component, done, total);
> +					   component, done, total, timeout);
>  	if (err)
>  		goto out_free_msg;
>  
> @@ -3097,7 +3103,7 @@ void devlink_flash_update_begin_notify(struct devlink *devlink)
>  {
>  	__devlink_flash_update_notify(devlink,
>  				      DEVLINK_CMD_FLASH_UPDATE,
> -				      NULL, NULL, 0, 0);
> +				      NULL, NULL, 0, 0, 0);
>  }
>  EXPORT_SYMBOL_GPL(devlink_flash_update_begin_notify);
>  
> @@ -3105,7 +3111,7 @@ void devlink_flash_update_end_notify(struct devlink *devlink)
>  {
>  	__devlink_flash_update_notify(devlink,
>  				      DEVLINK_CMD_FLASH_UPDATE_END,
> -				      NULL, NULL, 0, 0);
> +				      NULL, NULL, 0, 0, 0);
>  }
>  EXPORT_SYMBOL_GPL(devlink_flash_update_end_notify);
>  
> @@ -3117,10 +3123,21 @@ void devlink_flash_update_status_notify(struct devlink *devlink,
>  {
>  	__devlink_flash_update_notify(devlink,
>  				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
> -				      status_msg, component, done, total);
> +				      status_msg, component, done, total, 0);
>  }
>  EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
>  
> +void devlink_flash_update_timeout_notify(struct devlink *devlink,
> +					 const char *status_msg,
> +					 const char *component,
> +					 unsigned long timeout)

So we dropped the done and total here since in most cases we expect not
to need both a timeout and a done/total. I think that make sense. Most
of the time I think a command will benefit from one or the other.

> +{
> +	__devlink_flash_update_notify(devlink,
> +				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
> +				      status_msg, component, 0, 0, timeout);
> +}
> +EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
> +
>  static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>  				       struct genl_info *info)
>  {
> 
