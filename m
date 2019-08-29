Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7964CA1A01
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 14:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfH2M1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 08:27:11 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5694 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfH2M1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 08:27:11 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3870C6A50F0C549F9C48;
        Thu, 29 Aug 2019 20:27:06 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Thu, 29 Aug 2019
 20:27:00 +0800
Subject: Re: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
To:     Parav Pandit <parav@mellanox.com>, <alex.williamson@redhat.com>,
        <jiri@mellanox.com>, <kwankhede@nvidia.com>, <cohuck@redhat.com>,
        <davem@davemloft.net>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190829111904.16042-1-parav@mellanox.com>
 <20190829111904.16042-2-parav@mellanox.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <63e58577-f652-e021-2ff7-7e7403e38f9f@huawei.com>
Date:   Thu, 29 Aug 2019 20:26:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20190829111904.16042-2-parav@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/8/29 19:18, Parav Pandit wrote:
> Some vendor drivers want an identifier for an mdev device that is
> shorter than the UUID, due to length restrictions in the consumers of
> that identifier.
> 
> Add a callback that allows a vendor driver to request an alias of a
> specified length to be generated for an mdev device. If generated,
> that alias is checked for collisions.
> 
> It is an optional attribute.
> mdev alias is generated using sha1 from the mdev name.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> 
> ---
> Changelog:
> v1->v2:
>  - Kept mdev_device naturally aligned
>  - Added error checking for crypt_*() calls
>  - Corrected a typo from 'and' to 'an'
>  - Changed return type of generate_alias() from int to char*
> v0->v1:
>  - Moved alias length check outside of the parent lock
>  - Moved alias and digest allocation from kvzalloc to kzalloc
>  - &alias[0] changed to alias
>  - alias_length check is nested under get_alias_length callback check
>  - Changed comments to start with an empty line
>  - Fixed cleaunup of hash if mdev_bus_register() fails
>  - Added comment where alias memory ownership is handed over to mdev device
>  - Updated commit log to indicate motivation for this feature
> ---
>  drivers/vfio/mdev/mdev_core.c    | 123 ++++++++++++++++++++++++++++++-
>  drivers/vfio/mdev/mdev_private.h |   5 +-
>  drivers/vfio/mdev/mdev_sysfs.c   |  13 ++--
>  include/linux/mdev.h             |   4 +
>  4 files changed, 135 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index b558d4cfd082..3bdff0469607 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -10,9 +10,11 @@
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/slab.h>
> +#include <linux/mm.h>
>  #include <linux/uuid.h>
>  #include <linux/sysfs.h>
>  #include <linux/mdev.h>
> +#include <crypto/hash.h>
>  
>  #include "mdev_private.h"
>  
> @@ -27,6 +29,8 @@ static struct class_compat *mdev_bus_compat_class;
>  static LIST_HEAD(mdev_list);
>  static DEFINE_MUTEX(mdev_list_lock);
>  
> +static struct crypto_shash *alias_hash;
> +
>  struct device *mdev_parent_dev(struct mdev_device *mdev)
>  {
>  	return mdev->parent->dev;
> @@ -150,6 +154,16 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>  	if (!ops || !ops->create || !ops->remove || !ops->supported_type_groups)
>  		return -EINVAL;
>  
> +	if (ops->get_alias_length) {
> +		unsigned int digest_size;
> +		unsigned int aligned_len;
> +
> +		aligned_len = roundup(ops->get_alias_length(), 2);
> +		digest_size = crypto_shash_digestsize(alias_hash);
> +		if (aligned_len / 2 > digest_size)
> +			return -EINVAL;
> +	}
> +
>  	dev = get_device(dev);
>  	if (!dev)
>  		return -EINVAL;
> @@ -259,6 +273,7 @@ static void mdev_device_free(struct mdev_device *mdev)
>  	mutex_unlock(&mdev_list_lock);
>  
>  	dev_dbg(&mdev->dev, "MDEV: destroying\n");
> +	kfree(mdev->alias);
>  	kfree(mdev);
>  }
>  
> @@ -269,18 +284,101 @@ static void mdev_device_release(struct device *dev)
>  	mdev_device_free(mdev);
>  }
>  
> -int mdev_device_create(struct kobject *kobj,
> -		       struct device *dev, const guid_t *uuid)
> +static const char *
> +generate_alias(const char *uuid, unsigned int max_alias_len)
> +{
> +	struct shash_desc *hash_desc;
> +	unsigned int digest_size;
> +	unsigned char *digest;
> +	unsigned int alias_len;
> +	char *alias;
> +	int ret;
> +
> +	/*
> +	 * Align to multiple of 2 as bin2hex will generate
> +	 * even number of bytes.
> +	 */
> +	alias_len = roundup(max_alias_len, 2);
> +	alias = kzalloc(alias_len + 1, GFP_KERNEL);

It seems the mtty_alias_length in mtty.c can be set from module
parameter, and user can set a very large number, maybe limit the
max of the alias_len before calling kzalloc?

> +	if (!alias)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Allocate and init descriptor */
> +	hash_desc = kvzalloc(sizeof(*hash_desc) +
> +			     crypto_shash_descsize(alias_hash),
> +			     GFP_KERNEL);
> +	if (!hash_desc) {
> +		ret = -ENOMEM;
> +		goto desc_err;
> +	}
> +
> +	hash_desc->tfm = alias_hash;
> +
> +	digest_size = crypto_shash_digestsize(alias_hash);
> +
> +	digest = kzalloc(digest_size, GFP_KERNEL);
> +	if (!digest) {
> +		ret = -ENOMEM;
> +		goto digest_err;
> +	}
> +	ret = crypto_shash_init(hash_desc);
> +	if (ret)
> +		goto hash_err;
> +
> +	ret = crypto_shash_update(hash_desc, uuid, UUID_STRING_LEN);
> +	if (ret)
> +		goto hash_err;
> +
> +	ret = crypto_shash_final(hash_desc, digest);
> +	if (ret)
> +		goto hash_err;
> +
> +	bin2hex(alias, digest, min_t(unsigned int, digest_size, alias_len / 2));
> +	/*
> +	 * When alias length is odd, zero out an additional last byte
> +	 * that bin2hex has copied.
> +	 */
> +	if (max_alias_len % 2)
> +		alias[max_alias_len] = 0;
> +
> +	kfree(digest);
> +	kvfree(hash_desc);
> +	return alias;
> +
> +hash_err:
> +	kfree(digest);
> +digest_err:
> +	kvfree(hash_desc);
> +desc_err:
> +	kfree(alias);
> +	return ERR_PTR(ret);
> +}
> +
> +int mdev_device_create(struct kobject *kobj, struct device *dev,
> +		       const char *uuid_str, const guid_t *uuid)
>  {
>  	int ret;
>  	struct mdev_device *mdev, *tmp;
>  	struct mdev_parent *parent;
>  	struct mdev_type *type = to_mdev_type(kobj);
> +	const char *alias = NULL;
>  
>  	parent = mdev_get_parent(type->parent);
>  	if (!parent)
>  		return -EINVAL;
>  
> +	if (parent->ops->get_alias_length) {
> +		unsigned int alias_len;
> +
> +		alias_len = parent->ops->get_alias_length();
> +		if (alias_len) {
> +			alias = generate_alias(uuid_str, alias_len);
> +			if (IS_ERR(alias)) {
> +				ret = PTR_ERR(alias);
> +				goto alias_fail;
> +			}
> +		}
> +	}
>  	mutex_lock(&mdev_list_lock);
>  
>  	/* Check for duplicate */
> @@ -300,6 +398,12 @@ int mdev_device_create(struct kobject *kobj,
>  	}
>  
>  	guid_copy(&mdev->uuid, uuid);
> +	mdev->alias = alias;
> +	/*
> +	 * At this point alias memory is owned by the mdev.
> +	 * Mark it NULL, so that only mdev can free it.
> +	 */
> +	alias = NULL;
>  	list_add(&mdev->next, &mdev_list);
>  	mutex_unlock(&mdev_list_lock);
>  
> @@ -346,6 +450,8 @@ int mdev_device_create(struct kobject *kobj,
>  	up_read(&parent->unreg_sem);
>  	put_device(&mdev->dev);
>  mdev_fail:
> +	kfree(alias);
> +alias_fail:
>  	mdev_put_parent(parent);
>  	return ret;
>  }
> @@ -406,7 +512,17 @@ EXPORT_SYMBOL(mdev_get_iommu_device);
>  
>  static int __init mdev_init(void)
>  {
> -	return mdev_bus_register();
> +	int ret;
> +
> +	alias_hash = crypto_alloc_shash("sha1", 0, 0);
> +	if (!alias_hash)
> +		return -ENOMEM;
> +
> +	ret = mdev_bus_register();
> +	if (ret)
> +		crypto_free_shash(alias_hash);
> +
> +	return ret;
>  }
>  
>  static void __exit mdev_exit(void)
> @@ -415,6 +531,7 @@ static void __exit mdev_exit(void)
>  		class_compat_unregister(mdev_bus_compat_class);
>  
>  	mdev_bus_unregister();
> +	crypto_free_shash(alias_hash);
>  }
>  
>  module_init(mdev_init)
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 7d922950caaf..078fdaf7836e 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -32,6 +32,7 @@ struct mdev_device {
>  	struct list_head next;
>  	struct kobject *type_kobj;
>  	struct device *iommu_device;
> +	const char *alias;
>  	bool active;
>  };
>  
> @@ -57,8 +58,8 @@ void parent_remove_sysfs_files(struct mdev_parent *parent);
>  int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type);
>  void mdev_remove_sysfs_files(struct device *dev, struct mdev_type *type);
>  
> -int  mdev_device_create(struct kobject *kobj,
> -			struct device *dev, const guid_t *uuid);
> +int mdev_device_create(struct kobject *kobj, struct device *dev,
> +		       const char *uuid_str, const guid_t *uuid);
>  int  mdev_device_remove(struct device *dev);
>  
>  #endif /* MDEV_PRIVATE_H */
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 7570c7602ab4..43afe0e80b76 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -63,15 +63,18 @@ static ssize_t create_store(struct kobject *kobj, struct device *dev,
>  		return -ENOMEM;
>  
>  	ret = guid_parse(str, &uuid);
> -	kfree(str);
>  	if (ret)
> -		return ret;
> +		goto err;
>  
> -	ret = mdev_device_create(kobj, dev, &uuid);
> +	ret = mdev_device_create(kobj, dev, str, &uuid);
>  	if (ret)
> -		return ret;
> +		goto err;
>  
> -	return count;
> +	ret = count;
> +
> +err:
> +	kfree(str);
> +	return ret;
>  }
>  
>  MDEV_TYPE_ATTR_WO(create);
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 0ce30ca78db0..f036fe9854ee 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -72,6 +72,9 @@ struct device *mdev_get_iommu_device(struct device *dev);
>   * @mmap:		mmap callback
>   *			@mdev: mediated device structure
>   *			@vma: vma structure
> + * @get_alias_length:	Generate alias for the mdevs of this parent based on the
> + *			mdev device name when it returns non zero alias length.
> + *			It is optional.
>   * Parent device that support mediated device should be registered with mdev
>   * module with mdev_parent_ops structure.
>   **/
> @@ -92,6 +95,7 @@ struct mdev_parent_ops {
>  	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
>  			 unsigned long arg);
>  	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
> +	unsigned int (*get_alias_length)(void);
>  };
>  
>  /* interface for exporting mdev supported type attributes */
> 

