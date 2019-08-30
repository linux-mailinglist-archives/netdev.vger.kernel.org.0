Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5B9A3388
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 11:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfH3JR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 05:17:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfH3JR3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 05:17:29 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1CB3D30860A5;
        Fri, 30 Aug 2019 09:17:29 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05C475C1D6;
        Fri, 30 Aug 2019 09:17:22 +0000 (UTC)
Date:   Fri, 30 Aug 2019 11:17:20 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
Message-ID: <20190830111720.04aa54e9.cohuck@redhat.com>
In-Reply-To: <20190829111904.16042-2-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190829111904.16042-1-parav@mellanox.com>
        <20190829111904.16042-2-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 30 Aug 2019 09:17:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 06:18:59 -0500
Parav Pandit <parav@mellanox.com> wrote:

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

(...)

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

This function allocates alias...

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

...and returns it here on success...

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

...to be saved into a local variable here...

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

...and reassigned to the mdev member here...

> +	/*
> +	 * At this point alias memory is owned by the mdev.
> +	 * Mark it NULL, so that only mdev can free it.
> +	 */
> +	alias = NULL;

...and detached from the local variable here. Who is freeing it? The
comment states that it is done by the mdev, but I don't see it?

This detour via the local variable looks weird to me. Can you either
create the alias directly in the mdev (would need to happen later in
the function, but I'm not sure why you generate the alias before
checking for duplicates anyway), or do an explicit copy?

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

(...)
