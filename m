Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8513126E669
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgIQUNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:13:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:53012 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbgIQUNN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 16:13:13 -0400
IronPort-SDR: T8eFxF8ZeGInuT8jZ7AaNkYqMlThTWu7LUKt1ly3e4AQT3wZZcP6OgKEp92dGnW1AmymPaM6nc
 9E6LrnB7OFxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="159839539"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="159839539"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 12:52:33 -0700
IronPort-SDR: 69VhgeBVLciuXz82BImTDbkaD0ObbCLtNQwUtsm3YrHzKJkmTyhDMu8GiaFsFbJZ1JtgNhg5+I
 Ro4yRS6M00NQ==
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="483887045"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.151.155]) ([10.212.151.155])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 12:52:32 -0700
Subject: Re: [PATCH v4 net-next 2/5] devlink: collect flash notify params into
 a struct
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net
References: <20200917030204.50098-1-snelson@pensando.io>
 <20200917030204.50098-3-snelson@pensando.io>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <b04ad9ea-b016-e4f0-3f53-8811d1f32aa3@intel.com>
Date:   Thu, 17 Sep 2020 12:52:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200917030204.50098-3-snelson@pensando.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/16/2020 8:02 PM, Shannon Nelson wrote:
> The dev flash status notify function parameter lists are getting
> rather long, so add a struct to be filled and passed rather than
> continuously changing the function signatures.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Guess I should have read farther in the series. I would have expected
this patch first before introducing the timeout.

LGTM.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  include/net/devlink.h | 21 ++++++++++++
>  net/core/devlink.c    | 80 +++++++++++++++++++++++--------------------
>  2 files changed, 63 insertions(+), 38 deletions(-)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index f206accf80ad..9ab2014885cb 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -391,6 +391,27 @@ struct devlink_param_gset_ctx {
>  	enum devlink_param_cmode cmode;
>  };
>  
> +/**
> + * struct devlink_flash_notify - devlink dev flash notify data
> + * @cmd: devlink notify command code
> + * @status_msg: current status string
> + * @component: firmware component being updated
> + * @done: amount of work completed of total amount
> + * @total: amount of work expected to be done
> + * @timeout: expected max timeout in seconds
> + *
> + * These are values to be given to userland to be displayed in order
> + * to show current activity in a firmware update process.
> + */
> +struct devlink_flash_notify {
> +	enum devlink_command cmd;
> +	const char *status_msg;
> +	const char *component;
> +	unsigned long done;
> +	unsigned long total;
> +	unsigned long timeout;
> +};
> +
>  /**
>   * struct devlink_param - devlink configuration parameter data
>   * @name: name of the parameter
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 01f855e53e06..816f27a18b16 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -3021,41 +3021,36 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>  
>  static int devlink_nl_flash_update_fill(struct sk_buff *msg,
>  					struct devlink *devlink,
> -					enum devlink_command cmd,
> -					const char *status_msg,
> -					const char *component,
> -					unsigned long done,
> -					unsigned long total,
> -					unsigned long timeout)
> +					struct devlink_flash_notify *params)
>  {
>  	void *hdr;
>  
> -	hdr = genlmsg_put(msg, 0, 0, &devlink_nl_family, 0, cmd);
> +	hdr = genlmsg_put(msg, 0, 0, &devlink_nl_family, 0, params->cmd);
>  	if (!hdr)
>  		return -EMSGSIZE;
>  
>  	if (devlink_nl_put_handle(msg, devlink))
>  		goto nla_put_failure;
>  
> -	if (cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS)
> +	if (params->cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS)
>  		goto out;
>  
> -	if (status_msg &&
> +	if (params->status_msg &&
>  	    nla_put_string(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG,
> -			   status_msg))
> +			   params->status_msg))
>  		goto nla_put_failure;
> -	if (component &&
> +	if (params->component &&
>  	    nla_put_string(msg, DEVLINK_ATTR_FLASH_UPDATE_COMPONENT,
> -			   component))
> +			   params->component))
>  		goto nla_put_failure;
>  	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,
> -			      done, DEVLINK_ATTR_PAD))
> +			      params->done, DEVLINK_ATTR_PAD))
>  		goto nla_put_failure;
>  	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,
> -			      total, DEVLINK_ATTR_PAD))
> +			      params->total, DEVLINK_ATTR_PAD))
>  		goto nla_put_failure;
>  	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT,
> -			      timeout, DEVLINK_ATTR_PAD))
> +			      params->timeout, DEVLINK_ATTR_PAD))
>  		goto nla_put_failure;
>  
>  out:
> @@ -3068,26 +3063,20 @@ static int devlink_nl_flash_update_fill(struct sk_buff *msg,
>  }
>  
>  static void __devlink_flash_update_notify(struct devlink *devlink,
> -					  enum devlink_command cmd,
> -					  const char *status_msg,
> -					  const char *component,
> -					  unsigned long done,
> -					  unsigned long total,
> -					  unsigned long timeout)
> +					  struct devlink_flash_notify *params)
>  {
>  	struct sk_buff *msg;
>  	int err;
>  
> -	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
> -		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
> -		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
> +	WARN_ON(params->cmd != DEVLINK_CMD_FLASH_UPDATE &&
> +		params->cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
> +		params->cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
>  
>  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!msg)
>  		return;
>  
> -	err = devlink_nl_flash_update_fill(msg, devlink, cmd, status_msg,
> -					   component, done, total, timeout);
> +	err = devlink_nl_flash_update_fill(msg, devlink, params);
>  	if (err)
>  		goto out_free_msg;
>  
> @@ -3101,17 +3090,21 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
>  
>  void devlink_flash_update_begin_notify(struct devlink *devlink)
>  {
> -	__devlink_flash_update_notify(devlink,
> -				      DEVLINK_CMD_FLASH_UPDATE,
> -				      NULL, NULL, 0, 0, 0);
> +	struct devlink_flash_notify params = {
> +		.cmd = DEVLINK_CMD_FLASH_UPDATE,
> +	};
> +
> +	__devlink_flash_update_notify(devlink, &params);
>  }
>  EXPORT_SYMBOL_GPL(devlink_flash_update_begin_notify);
>  
>  void devlink_flash_update_end_notify(struct devlink *devlink)
>  {
> -	__devlink_flash_update_notify(devlink,
> -				      DEVLINK_CMD_FLASH_UPDATE_END,
> -				      NULL, NULL, 0, 0, 0);
> +	struct devlink_flash_notify params = {
> +		.cmd = DEVLINK_CMD_FLASH_UPDATE_END,
> +	};
> +
> +	__devlink_flash_update_notify(devlink, &params);
>  }
>  EXPORT_SYMBOL_GPL(devlink_flash_update_end_notify);
>  
> @@ -3121,9 +3114,15 @@ void devlink_flash_update_status_notify(struct devlink *devlink,
>  					unsigned long done,
>  					unsigned long total)
>  {
> -	__devlink_flash_update_notify(devlink,
> -				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
> -				      status_msg, component, done, total, 0);
> +	struct devlink_flash_notify params = {
> +		.cmd = DEVLINK_CMD_FLASH_UPDATE_STATUS,
> +		.status_msg = status_msg,
> +		.component = component,
> +		.done = done,
> +		.total = total,
> +	};
> +
> +	__devlink_flash_update_notify(devlink, &params);
>  }
>  EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
>  
> @@ -3132,9 +3131,14 @@ void devlink_flash_update_timeout_notify(struct devlink *devlink,
>  					 const char *component,
>  					 unsigned long timeout)
>  {
> -	__devlink_flash_update_notify(devlink,
> -				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
> -				      status_msg, component, 0, 0, timeout);
> +	struct devlink_flash_notify params = {
> +		.cmd = DEVLINK_CMD_FLASH_UPDATE_STATUS,
> +		.status_msg = status_msg,
> +		.component = component,
> +		.timeout = timeout,
> +	};
> +
> +	__devlink_flash_update_notify(devlink, &params);
>  }
>  EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
>  
> 
