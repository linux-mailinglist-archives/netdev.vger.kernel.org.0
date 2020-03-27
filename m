Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B431952B0
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgC0IQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:16:53 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39896 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725946AbgC0IQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 04:16:52 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7F23FCDF9720153B5766;
        Fri, 27 Mar 2020 16:16:47 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Fri, 27 Mar 2020
 16:16:44 +0800
Subject: Re: [PATCH net-next v3 01/11] devlink: prepare to support region
 operations
To:     Jacob Keller <jacob.e.keller@intel.com>, <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        "Jiri Pirko" <jiri@mellanox.com>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
 <20200326183718.2384349-2-jacob.e.keller@intel.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <e993d962-0853-c84b-89cc-84699aed6ee2@huawei.com>
Date:   Fri, 27 Mar 2020 16:16:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20200326183718.2384349-2-jacob.e.keller@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/3/27 2:37, Jacob Keller wrote:
> Modify the devlink region code in preparation for adding new operations
> on regions.
> 
> Create a devlink_region_ops structure, and move the name pointer from
> within the devlink_region structure into the ops structure (similar to
> the devlink_health_reporter_ops).
> 
> This prepares the regions to enable support of additional operations in
> the future such as requesting snapshots, or accessing the region
> directly without a snapshot.
> 
> In order to re-use the constant strings in the mlx4 driver their
> declaration must be changed to 'const char * const' to ensure the
> compiler realizes that both the data and the pointer cannot change.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
> Changes since RFC
> * Picked up Jiri's Reviewed-by
> 
>   drivers/net/ethernet/mellanox/mlx4/crdump.c | 16 +++++++++++----
>   drivers/net/netdevsim/dev.c                 |  6 +++++-
>   include/net/devlink.h                       | 16 +++++++++++----
>   net/core/devlink.c                          | 22 ++++++++++-----------
>   4 files changed, 40 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
> index 64ed725aec28..cc2bf596c74b 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
> @@ -38,8 +38,16 @@
>   #define CR_ENABLE_BIT_OFFSET		0xF3F04
>   #define MAX_NUM_OF_DUMPS_TO_STORE	(8)
>   
> -static const char *region_cr_space_str = "cr-space";
> -static const char *region_fw_health_str = "fw-health";
> +static const char * const region_cr_space_str = "cr-space";
> +static const char * const region_fw_health_str = "fw-health";
> +
> +static const struct devlink_region_ops region_cr_space_ops = {
> +	.name = region_cr_space_str,
> +};
> +
> +static const struct devlink_region_ops region_fw_health_ops = {
> +	.name = region_fw_health_str,
> +};
>  


Hi, Jacob.

After pull net-next, I get below compiler errors:
drivers/net/ethernet/mellanox//mlx4/crdump.c:45:10: error: initializer 
element is not constant
   .name = region_cr_space_str,
           ^
drivers/net/ethernet/mellanox//mlx4/crdump.c:45:10: note: (near 
initialization for ‘region_cr_space_ops.name’)
drivers/net/ethernet/mellanox//mlx4/crdump.c:50:10: error: initializer 
element is not constant
   .name = region_fw_health_str,

It seems the value of variables region_cr_space_str and 
region_cr_space_str is unknown during compiling phase.

Huazhong.

>   /* Set to true in case cr enable bit was set to true before crdump */
>   static bool crdump_enbale_bit_set;
> @@ -205,7 +213,7 @@ int mlx4_crdump_init(struct mlx4_dev *dev)
>   	/* Create cr-space region */
>   	crdump->region_crspace =
>   		devlink_region_create(devlink,
> -				      region_cr_space_str,
> +				      &region_cr_space_ops,
>   				      MAX_NUM_OF_DUMPS_TO_STORE,
>   				      pci_resource_len(pdev, 0));
>   	if (IS_ERR(crdump->region_crspace))
> @@ -216,7 +224,7 @@ int mlx4_crdump_init(struct mlx4_dev *dev)
>   	/* Create fw-health region */
>   	crdump->region_fw_health =
>   		devlink_region_create(devlink,
> -				      region_fw_health_str,
> +				      &region_fw_health_ops,
>   				      MAX_NUM_OF_DUMPS_TO_STORE,
>   				      HEALTH_BUFFER_SIZE);
>   	if (IS_ERR(crdump->region_fw_health))
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 7bfd0622cef1..47a8f8c570c4 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -340,11 +340,15 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
>   
>   #define NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX 16
>   
> +static const struct devlink_region_ops dummy_region_ops = {
> +	.name = "dummy",
> +};
> +
>   static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
>   				      struct devlink *devlink)
>   {
>   	nsim_dev->dummy_region =
> -		devlink_region_create(devlink, "dummy",
> +		devlink_region_create(devlink, &dummy_region_ops,
>   				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
>   				      NSIM_DEV_DUMMY_REGION_SIZE);
>   	return PTR_ERR_OR_ZERO(nsim_dev->dummy_region);
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 37230e23b5b0..85db5dd5184d 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -498,6 +498,14 @@ struct devlink_info_req;
>   
>   typedef void devlink_snapshot_data_dest_t(const void *data);
>   
> +/**
> + * struct devlink_region_ops - Region operations
> + * @name: region name
> + */
> +struct devlink_region_ops {
> +	const char *name;
> +};
> +
>   struct devlink_fmsg;
>   struct devlink_health_reporter;
>   
> @@ -963,10 +971,10 @@ void devlink_port_param_value_changed(struct devlink_port *devlink_port,
>   				      u32 param_id);
>   void devlink_param_value_str_fill(union devlink_param_value *dst_val,
>   				  const char *src);
> -struct devlink_region *devlink_region_create(struct devlink *devlink,
> -					     const char *region_name,
> -					     u32 region_max_snapshots,
> -					     u64 region_size);
> +struct devlink_region *
> +devlink_region_create(struct devlink *devlink,
> +		      const struct devlink_region_ops *ops,
> +		      u32 region_max_snapshots, u64 region_size);
>   void devlink_region_destroy(struct devlink_region *region);
>   u32 devlink_region_snapshot_id_get(struct devlink *devlink);
>   int devlink_region_snapshot_create(struct devlink_region *region,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 73bb8fbe3393..ca5362530567 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -344,7 +344,7 @@ devlink_sb_tc_index_get_from_info(struct devlink_sb *devlink_sb,
>   struct devlink_region {
>   	struct devlink *devlink;
>   	struct list_head list;
> -	const char *name;
> +	const struct devlink_region_ops *ops;
>   	struct list_head snapshot_list;
>   	u32 max_snapshots;
>   	u32 cur_snapshots;
> @@ -365,7 +365,7 @@ devlink_region_get_by_name(struct devlink *devlink, const char *region_name)
>   	struct devlink_region *region;
>   
>   	list_for_each_entry(region, &devlink->region_list, list)
> -		if (!strcmp(region->name, region_name))
> +		if (!strcmp(region->ops->name, region_name))
>   			return region;
>   
>   	return NULL;
> @@ -3695,7 +3695,7 @@ static int devlink_nl_region_fill(struct sk_buff *msg, struct devlink *devlink,
>   	if (err)
>   		goto nla_put_failure;
>   
> -	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME, region->name);
> +	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME, region->ops->name);
>   	if (err)
>   		goto nla_put_failure;
>   
> @@ -3741,7 +3741,7 @@ static void devlink_nl_region_notify(struct devlink_region *region,
>   		goto out_cancel_msg;
>   
>   	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME,
> -			     region->name);
> +			     region->ops->name);
>   	if (err)
>   		goto out_cancel_msg;
>   
> @@ -7647,21 +7647,21 @@ EXPORT_SYMBOL_GPL(devlink_param_value_str_fill);
>    *	devlink_region_create - create a new address region
>    *
>    *	@devlink: devlink
> - *	@region_name: region name
> + *	@ops: region operations and name
>    *	@region_max_snapshots: Maximum supported number of snapshots for region
>    *	@region_size: size of region
>    */
> -struct devlink_region *devlink_region_create(struct devlink *devlink,
> -					     const char *region_name,
> -					     u32 region_max_snapshots,
> -					     u64 region_size)
> +struct devlink_region *
> +devlink_region_create(struct devlink *devlink,
> +		      const struct devlink_region_ops *ops,
> +		      u32 region_max_snapshots, u64 region_size)
>   {
>   	struct devlink_region *region;
>   	int err = 0;
>   
>   	mutex_lock(&devlink->lock);
>   
> -	if (devlink_region_get_by_name(devlink, region_name)) {
> +	if (devlink_region_get_by_name(devlink, ops->name)) {
>   		err = -EEXIST;
>   		goto unlock;
>   	}
> @@ -7674,7 +7674,7 @@ struct devlink_region *devlink_region_create(struct devlink *devlink,
>   
>   	region->devlink = devlink;
>   	region->max_snapshots = region_max_snapshots;
> -	region->name = region_name;
> +	region->ops = ops;
>   	region->size = region_size;
>   	INIT_LIST_HEAD(&region->snapshot_list);
>   	list_add_tail(&region->list, &devlink->region_list);
> 

