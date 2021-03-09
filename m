Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551AB3321F0
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 10:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhCIJ2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 04:28:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229481AbhCIJ2K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 04:28:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 573666525B;
        Tue,  9 Mar 2021 09:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615282089;
        bh=Y1/8HR74ZpCRwhggBqju8iS1LefZGygzgl+OhHjLg9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BaclR86SXtTzz7hLepdG+4a9DEod1mUG4lenrLxfN9Njxzxb5RJ1dzfiq+XGQot5O
         MWyrsp5nb4koIKUry57r4cber/hww64TSEC4flYQjyL1sFj7G+VrUVobrrEmpxkKaV
         A/AbJiPwRSVRmr9uIIesFO5CiXIOZx3+ZjcK42i4=
Date:   Tue, 9 Mar 2021 10:28:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com,
        Gage Eads <gage.eads@intel.com>
Subject: Re: [PATCH v10 05/20] dlb: add scheduling domain configuration
Message-ID: <YEc/prj8X12/rqVI@kroah.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-6-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210175423.1873-6-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 11:54:08AM -0600, Mike Ximing Chen wrote:
> +/**
> + * dlb_bitmap_clear_range() - clear a range of bitmap entries
> + * @bitmap: pointer to dlb_bitmap structure.
> + * @bit: starting bit index.
> + * @len: length of the range.
> + *
> + * Return:
> + * Returns 0 upon success, < 0 otherwise.
> + *
> + * Errors:
> + * EINVAL - bitmap is NULL or is uninitialized, or the range exceeds the bitmap
> + *	    length.
> + */
> +static inline int dlb_bitmap_clear_range(struct dlb_bitmap *bitmap,
> +					 unsigned int bit,
> +					 unsigned int len)
> +{
> +	if (!bitmap || !bitmap->map)
> +		return -EINVAL;
> +
> +	if (bitmap->len <= bit)
> +		return -EINVAL;
> +
> +	bitmap_clear(bitmap->map, bit, len);
> +
> +	return 0;
> +}

Why isn't logic like this just added to the lib/bitmap.c file?

> +/**
> + * dlb_bitmap_find_set_bit_range() - find an range of set bits
> + * @bitmap: pointer to dlb_bitmap structure.
> + * @len: length of the range.
> + *
> + * This function looks for a range of set bits of length @len.
> + *
> + * Return:
> + * Returns the base bit index upon success, < 0 otherwise.
> + *
> + * Errors:
> + * ENOENT - unable to find a length *len* range of set bits.
> + * EINVAL - bitmap is NULL or is uninitialized, or len is invalid.
> + */
> +static inline int dlb_bitmap_find_set_bit_range(struct dlb_bitmap *bitmap,
> +						unsigned int len)
> +{
> +	struct dlb_bitmap *complement_mask = NULL;
> +	int ret;
> +
> +	if (!bitmap || !bitmap->map || len == 0)
> +		return -EINVAL;
> +
> +	if (bitmap->len < len)
> +		return -ENOENT;
> +
> +	ret = dlb_bitmap_alloc(&complement_mask, bitmap->len);
> +	if (ret)
> +		return ret;
> +
> +	bitmap_zero(complement_mask->map, complement_mask->len);
> +
> +	bitmap_complement(complement_mask->map, bitmap->map, bitmap->len);
> +
> +	ret = bitmap_find_next_zero_area(complement_mask->map,
> +					 complement_mask->len,
> +					 0,
> +					 len,
> +					 0);
> +
> +	dlb_bitmap_free(complement_mask);
> +
> +	/* No set bit range of length len? */
> +	return (ret >= (int)bitmap->len) ? -ENOENT : ret;
> +}

Same here, why not put this in the core kernel instead of a tiny random
driver like this?

thanks,

greg k-h
