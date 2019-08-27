Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 399229DB5D
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 03:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbfH0Bvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 21:51:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbfH0Bvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 21:51:42 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D37E8A4D3E6;
        Tue, 27 Aug 2019 01:51:41 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 469D510016EA;
        Tue, 27 Aug 2019 01:51:41 +0000 (UTC)
Date:   Mon, 26 Aug 2019 19:51:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     jiri@mellanox.com, kwankhede@nvidia.com, cohuck@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
Message-ID: <20190826195140.0db1c9fd@x1.home>
In-Reply-To: <20190826194456.6edef7d1@x1.home>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-2-parav@mellanox.com>
        <20190826194456.6edef7d1@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Tue, 27 Aug 2019 01:51:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 19:44:56 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 26 Aug 2019 15:41:16 -0500
> Parav Pandit <parav@mellanox.com> wrote:
> 
> > Whenever a parent requests to generate mdev alias, generate a mdev
> > alias.
> > It is an optional attribute that parent can request to generate
> > for each of its child mdev.
> > mdev alias is generated using sha1 from the mdev name.
> > 
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c    | 98 +++++++++++++++++++++++++++++++-
> >  drivers/vfio/mdev/mdev_private.h |  5 +-
> >  drivers/vfio/mdev/mdev_sysfs.c   | 13 +++--
> >  include/linux/mdev.h             |  4 ++
> >  4 files changed, 111 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> > index b558d4cfd082..e825ff38b037 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
> > @@ -10,9 +10,11 @@
> >  #include <linux/module.h>
> >  #include <linux/device.h>
> >  #include <linux/slab.h>
> > +#include <linux/mm.h>
> >  #include <linux/uuid.h>
> >  #include <linux/sysfs.h>
> >  #include <linux/mdev.h>
> > +#include <crypto/hash.h>
> >  
> >  #include "mdev_private.h"
> >  
> > @@ -27,6 +29,8 @@ static struct class_compat *mdev_bus_compat_class;
> >  static LIST_HEAD(mdev_list);
> >  static DEFINE_MUTEX(mdev_list_lock);
> >  
> > +static struct crypto_shash *alias_hash;
> > +
> >  struct device *mdev_parent_dev(struct mdev_device *mdev)
> >  {
> >  	return mdev->parent->dev;
> > @@ -164,6 +168,18 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
> >  		goto add_dev_err;
> >  	}
> >  
> > +	if (ops->get_alias_length) {
> > +		unsigned int digest_size;
> > +		unsigned int aligned_len;
> > +
> > +		aligned_len = roundup(ops->get_alias_length(), 2);
> > +		digest_size = crypto_shash_digestsize(alias_hash);
> > +		if (aligned_len / 2 > digest_size) {
> > +			ret = -EINVAL;
> > +			goto add_dev_err;
> > +		}
> > +	}  
> 
> This looks like a sanity check, it could be done outside of the
> parent_list_lock, even before we get a parent device reference.
> 
> I think we're using a callback for get_alias_length() rather than a
> fixed field to support the mtty module option added in patch 4, right?
> Its utility is rather limited with no args.  I could imagine that if a
> parent wanted to generate an alias that could be incorporated into a
> string with the parent device name that it would be useful to call this
> with the parent device as an arg.  I guess we can save that until a
> user comes along though.
> 
> There doesn't seem to be anything serializing use of alias_hash.
> 
> > +
> >  	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
> >  	if (!parent) {
> >  		ret = -ENOMEM;
> > @@ -259,6 +275,7 @@ static void mdev_device_free(struct mdev_device *mdev)
> >  	mutex_unlock(&mdev_list_lock);
> >  
> >  	dev_dbg(&mdev->dev, "MDEV: destroying\n");
> > +	kvfree(mdev->alias);
> >  	kfree(mdev);
> >  }
> >  
> > @@ -269,18 +286,86 @@ static void mdev_device_release(struct device *dev)
> >  	mdev_device_free(mdev);
> >  }
> >  
> > -int mdev_device_create(struct kobject *kobj,
> > -		       struct device *dev, const guid_t *uuid)
> > +static const char *
> > +generate_alias(const char *uuid, unsigned int max_alias_len)
> > +{
> > +	struct shash_desc *hash_desc;
> > +	unsigned int digest_size;
> > +	unsigned char *digest;
> > +	unsigned int alias_len;
> > +	char *alias;
> > +	int ret = 0;
> > +
> > +	/* Align to multiple of 2 as bin2hex will generate
> > +	 * even number of bytes.
> > +	 */  
> 
> Comment style for non-networking code please.
> 
> > +	alias_len = roundup(max_alias_len, 2);
> > +	alias = kvzalloc(alias_len + 1, GFP_KERNEL);  

Oops, here's the null termination of alias for the even case (+ 1),
ignore the comment below about odd/even.  Thanks,

Alex

> 
> The size we're generating here should be small enough to just use
> kzalloc(), probably below too.
> 
> > +	if (!alias)
> > +		return NULL;
> > +
> > +	/* Allocate and init descriptor */
> > +	hash_desc = kvzalloc(sizeof(*hash_desc) +
> > +			     crypto_shash_descsize(alias_hash),
> > +			     GFP_KERNEL);
> > +	if (!hash_desc)
> > +		goto desc_err;
> > +
> > +	hash_desc->tfm = alias_hash;
> > +
> > +	digest_size = crypto_shash_digestsize(alias_hash);
> > +
> > +	digest = kvzalloc(digest_size, GFP_KERNEL);
> > +	if (!digest) {
> > +		ret = -ENOMEM;
> > +		goto digest_err;
> > +	}
> > +	crypto_shash_init(hash_desc);
> > +	crypto_shash_update(hash_desc, uuid, UUID_STRING_LEN);
> > +	crypto_shash_final(hash_desc, digest);
> > +	bin2hex(&alias[0], digest,  
> 
> &alias[0], ie. alias
> 
> > +		min_t(unsigned int, digest_size, alias_len / 2));
> > +	/* When alias length is odd, zero out and additional last byte
> > +	 * that bin2hex has copied.
> > +	 */
> > +	if (max_alias_len % 2)
> > +		alias[max_alias_len] = 0;  
> 
> Doesn't this give us a null terminated string for odd numbers but not
> even numbers?  Probably best to define that we always provide a null
> terminated string then we could do this unconditionally.
> 
> > +
> > +	kvfree(digest);
> > +	kvfree(hash_desc);
> > +	return alias;
> > +
> > +digest_err:
> > +	kvfree(hash_desc);
> > +desc_err:
> > +	kvfree(alias);
> > +	return NULL;
> > +}
> > +
> > +int mdev_device_create(struct kobject *kobj, struct device *dev,
> > +		       const char *uuid_str, const guid_t *uuid)
> >  {
> >  	int ret;
> >  	struct mdev_device *mdev, *tmp;
> >  	struct mdev_parent *parent;
> >  	struct mdev_type *type = to_mdev_type(kobj);
> > +	unsigned int alias_len = 0;
> > +	const char *alias = NULL;
> >  
> >  	parent = mdev_get_parent(type->parent);
> >  	if (!parent)
> >  		return -EINVAL;
> >  
> > +	if (parent->ops->get_alias_length)
> > +		alias_len = parent->ops->get_alias_length();
> > +	if (alias_len) {  
> 
> Why isn't this nested into the branch above?
> 
> > +		alias = generate_alias(uuid_str, alias_len);
> > +		if (!alias) {
> > +			ret = -ENOMEM;  
> 
> Could use an ERR_PTR and propagate an errno.
> 
> > +			goto alias_fail;
> > +		}
> > +	}
> > +
> >  	mutex_lock(&mdev_list_lock);
> >  
> >  	/* Check for duplicate */
> > @@ -300,6 +385,8 @@ int mdev_device_create(struct kobject *kobj,
> >  	}
> >  
> >  	guid_copy(&mdev->uuid, uuid);
> > +	mdev->alias = alias;
> > +	alias = NULL;  
> 
> A comment justifying this null'ing might help prevent it getting culled
> as some point.  It appears arbitrary at first look.  Thanks,
> 
> Alex
> 
> >  	list_add(&mdev->next, &mdev_list);
> >  	mutex_unlock(&mdev_list_lock);
> >  
> > @@ -346,6 +433,8 @@ int mdev_device_create(struct kobject *kobj,
> >  	up_read(&parent->unreg_sem);
> >  	put_device(&mdev->dev);
> >  mdev_fail:
> > +	kvfree(alias);
> > +alias_fail:
> >  	mdev_put_parent(parent);
> >  	return ret;
> >  }
> > @@ -406,6 +495,10 @@ EXPORT_SYMBOL(mdev_get_iommu_device);
> >  
> >  static int __init mdev_init(void)
> >  {
> > +	alias_hash = crypto_alloc_shash("sha1", 0, 0);
> > +	if (!alias_hash)
> > +		return -ENOMEM;
> > +
> >  	return mdev_bus_register();
> >  }
> >  
> > @@ -415,6 +508,7 @@ static void __exit mdev_exit(void)
> >  		class_compat_unregister(mdev_bus_compat_class);
> >  
> >  	mdev_bus_unregister();
> > +	crypto_free_shash(alias_hash);
> >  }
> >  
> >  module_init(mdev_init)
> > diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> > index 7d922950caaf..cf1c0d9842c6 100644
> > --- a/drivers/vfio/mdev/mdev_private.h
> > +++ b/drivers/vfio/mdev/mdev_private.h
> > @@ -33,6 +33,7 @@ struct mdev_device {
> >  	struct kobject *type_kobj;
> >  	struct device *iommu_device;
> >  	bool active;
> > +	const char *alias;
> >  };
> >  
> >  #define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
> > @@ -57,8 +58,8 @@ void parent_remove_sysfs_files(struct mdev_parent *parent);
> >  int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type);
> >  void mdev_remove_sysfs_files(struct device *dev, struct mdev_type *type);
> >  
> > -int  mdev_device_create(struct kobject *kobj,
> > -			struct device *dev, const guid_t *uuid);
> > +int mdev_device_create(struct kobject *kobj, struct device *dev,
> > +		       const char *uuid_str, const guid_t *uuid);
> >  int  mdev_device_remove(struct device *dev);
> >  
> >  #endif /* MDEV_PRIVATE_H */
> > diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> > index 7570c7602ab4..43afe0e80b76 100644
> > --- a/drivers/vfio/mdev/mdev_sysfs.c
> > +++ b/drivers/vfio/mdev/mdev_sysfs.c
> > @@ -63,15 +63,18 @@ static ssize_t create_store(struct kobject *kobj, struct device *dev,
> >  		return -ENOMEM;
> >  
> >  	ret = guid_parse(str, &uuid);
> > -	kfree(str);
> >  	if (ret)
> > -		return ret;
> > +		goto err;
> >  
> > -	ret = mdev_device_create(kobj, dev, &uuid);
> > +	ret = mdev_device_create(kobj, dev, str, &uuid);
> >  	if (ret)
> > -		return ret;
> > +		goto err;
> >  
> > -	return count;
> > +	ret = count;
> > +
> > +err:
> > +	kfree(str);
> > +	return ret;
> >  }
> >  
> >  MDEV_TYPE_ATTR_WO(create);
> > diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> > index 0ce30ca78db0..f036fe9854ee 100644
> > --- a/include/linux/mdev.h
> > +++ b/include/linux/mdev.h
> > @@ -72,6 +72,9 @@ struct device *mdev_get_iommu_device(struct device *dev);
> >   * @mmap:		mmap callback
> >   *			@mdev: mediated device structure
> >   *			@vma: vma structure
> > + * @get_alias_length:	Generate alias for the mdevs of this parent based on the
> > + *			mdev device name when it returns non zero alias length.
> > + *			It is optional.
> >   * Parent device that support mediated device should be registered with mdev
> >   * module with mdev_parent_ops structure.
> >   **/
> > @@ -92,6 +95,7 @@ struct mdev_parent_ops {
> >  	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
> >  			 unsigned long arg);
> >  	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
> > +	unsigned int (*get_alias_length)(void);
> >  };
> >  
> >  /* interface for exporting mdev supported type attributes */  
> 

