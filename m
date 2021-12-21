Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE9847BA99
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 08:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbhLUHUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 02:20:33 -0500
Received: from relay028.a.hostedemail.com ([64.99.140.28]:61294 "EHLO
        relay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229999AbhLUHUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 02:20:32 -0500
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay13.hostedemail.com (Postfix) with ESMTP id D943760AE7;
        Tue, 21 Dec 2021 07:20:24 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf02.hostedemail.com (Postfix) with ESMTPA id 78B8280011;
        Tue, 21 Dec 2021 07:20:21 +0000 (UTC)
Message-ID: <4c0ec417457a16fd437f39e9b6d5bd7057aef028.camel@perches.com>
Subject: Re: [RFC PATCH v12 17/17] dlb: add basic sysfs interfaces
From:   Joe Perches <joe@perches.com>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>,
        linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Date:   Mon, 20 Dec 2021 23:20:21 -0800
In-Reply-To: <20211221065047.290182-18-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
         <20211221065047.290182-18-mike.ximing.chen@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mie8gpafwog5noazbwsegzgm3k5uxfi3
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 78B8280011
X-Spam-Status: No, score=-4.90
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+Nij3xIO172aXMp3FsVP7mNElwKBx0mpk=
X-HE-Tag: 1640071221-463686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-21 at 00:50 -0600, Mike Ximing Chen wrote:
> The dlb sysfs interfaces include files for reading the total and
> available device resources, and reading the device ID and version. The
> interfaces are used for device level configurations and resource
> inquiries.
[]
> diff --git a/drivers/misc/dlb/dlb_args.h b/drivers/misc/dlb/dlb_args.h
[]
> @@ -58,6 +58,40 @@ struct dlb_create_sched_domain_args {
>  	__u32 num_dir_credits;
>  };
>  
> +/*
> + * dlb_get_num_resources_args: Used to get the number of available resources
> + *      (queues, ports, etc.) that this device owns.
> + *
> + * Output parameters:
> + * @response.status: Detailed error code. In certain cases, such as if the
> + *	request arg is invalid, the driver won't set status.
> + * @num_domains: Number of available scheduling domains.
> + * @num_ldb_queues: Number of available load-balanced queues.
> + * @num_ldb_ports: Total number of available load-balanced ports.
> + * @num_dir_ports: Number of available directed ports. There is one directed
> + *	queue for every directed port.
> + * @num_atomic_inflights: Amount of available temporary atomic QE storage.
> + * @num_hist_list_entries: Amount of history list storage.
> + * @max_contiguous_hist_list_entries: History list storage is allocated in
> + *	a contiguous chunk, and this return value is the longest available
> + *	contiguous range of history list entries.
> + * @num_ldb_credits: Amount of available load-balanced QE storage.
> + * @num_dir_credits: Amount of available directed QE storage.
> + */

Is this supposed to be kernel-doc format with /** as the comment initiator ?

> +struct dlb_get_num_resources_args {
> +	/* Output parameters */
> +	struct dlb_cmd_response response;
> +	__u32 num_sched_domains;
> +	__u32 num_ldb_queues;
> +	__u32 num_ldb_ports;
> +	__u32 num_dir_ports;
> +	__u32 num_atomic_inflights;
> +	__u32 num_hist_list_entries;
> +	__u32 max_contiguous_hist_list_entries;
> +	__u32 num_ldb_credits;
> +	__u32 num_dir_credits;

__u32 is used when visible to user-space.
Do these really need to use __u32 and not u32 ?

> diff --git a/drivers/misc/dlb/dlb_pf_ops.c b/drivers/misc/dlb/dlb_pf_ops.c
[]
> @@ -102,3 +102,198 @@ void dlb_pf_init_hardware(struct dlb *dlb)
[]
> +#define DLB_TOTAL_SYSFS_SHOW(name, macro)		\
> +static ssize_t total_##name##_show(			\
> +	struct device *dev,				\
> +	struct device_attribute *attr,			\
> +	char *buf)					\
> +{							\
> +	int val = DLB_MAX_NUM_##macro;			\
> +							\
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", val);	\

Use sysfs_emit rather than scnprintf

maybe:
	return sysfs_emit(buf, "%u\n", DLB_MAX_NUM_##macro);

> +#define DLB_AVAIL_SYSFS_SHOW(name)			     \
> +static ssize_t avail_##name##_show(			     \
> +	struct device *dev,				     \
> +	struct device_attribute *attr,			     \
> +	char *buf)					     \
> +{							     \
> +	struct dlb *dlb = dev_get_drvdata(dev);		     \
> +	struct dlb_get_num_resources_args arg;		     \
> +	struct dlb_hw *hw = &dlb->hw;			     \
> +	int val;					     \

u32 val?

> +							     \
> +	mutex_lock(&dlb->resource_mutex);		     \
> +							     \
> +	val = dlb_hw_get_num_resources(hw, &arg);	     \
> +							     \
> +	mutex_unlock(&dlb->resource_mutex);		     \
> +							     \
> +	if (val)					     \
> +		return -1;				     \
> +							     \
> +	val = arg.name;					     \
> +							     \
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", val);	     \

sysfs_emit, etc...


