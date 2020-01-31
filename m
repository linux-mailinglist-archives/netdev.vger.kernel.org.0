Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C341114F1DC
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgAaSHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:07:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgAaSHr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:07:47 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C25D20663;
        Fri, 31 Jan 2020 18:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580494065;
        bh=k6oUG2SWczsVydDicYxahqUD/9HDe3cCjOV25J/4xqU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iq2+UQc1plmheLmfEGx4sVPo9N7Ca8/xJl1LYCL5vQxMc+jve/8xDG0eaS4dp89td
         1YycK4kjS3GphOABep41bVIol/Gmyuw5SgShBjuoZ9IsI4A1FCWHjTYGSvxQwMkJ31
         StNUPUorFuwM9cHbXkY0Fulx/OfUaBpa2aiu+fOo=
Date:   Fri, 31 Jan 2020 10:07:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
Subject: Re: [PATCH 13/15] devlink: support directly reading from region
 memory
Message-ID: <20200131100744.61ec7632@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130225913.1671982-14-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
        <20200130225913.1671982-14-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 14:59:08 -0800, Jacob Keller wrote:
> Add a new region operation for directly reading from a region, without
> taking a full snapshot.
>=20
> Extend the DEVLINK_CMD_REGION_READ to allow directly reading from
> a region, if supported. Instead of reporting a missing snapshot id as
> invalid, check to see if direct reading is implemented for the region.
> If so, use the direct read operation to grab the current contents of the
> region.
>=20
> This new behavior of DEVLINK_CMD_REGION_READ should be backwards
> compatible. Previously, all kernels rejected such
> a DEVLINK_CMD_REGION_READ with -EINVAL, and will now either accept the
> call or report -EOPNOTSUPP for regions which do not implement direct
> access.
>=20
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

> +static int devlink_nl_region_read_direct_fill(struct sk_buff *skb,
> +					      struct devlink *devlink,
> +					      struct devlink_region *region,
> +					      struct nlattr **attrs,
> +					      u64 start_offset,
> +					      u64 end_offset,
> +					      bool dump,
> +					      u64 *new_offset)
> +{
> +	u64 curr_offset =3D start_offset;
> +	int err =3D 0;
> +	u8 *data;
> +
> +	/* Allocate and re-use a single buffer */
> +	data =3D kzalloc(DEVLINK_REGION_READ_CHUNK_SIZE, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	*new_offset =3D start_offset;
> +
> +	if (end_offset > region->size || dump)
> +		end_offset =3D region->size;
> +
> +	while (curr_offset < end_offset) {
> +		u32 data_size;
> +
> +		if (end_offset - curr_offset < DEVLINK_REGION_READ_CHUNK_SIZE)
> +			data_size =3D end_offset - curr_offset;
> +		else
> +			data_size =3D DEVLINK_REGION_READ_CHUNK_SIZE;

Also known as min() ?

> +		err =3D region->ops->read(devlink, curr_offset, data_size, data);
> +		if (err)
> +			break;
> +
> +		err =3D devlink_nl_cmd_region_read_chunk_fill(skb, devlink,
> +							    data, data_size,
> +							    curr_offset);
> +		if (err)
> +			break;
> +
> +		curr_offset +=3D data_size;
> +	}
> +	*new_offset =3D curr_offset;
> +
> +	kfree(data);
> +
> +	return err;
> +}
> +
>  static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>  					     struct netlink_callback *cb)
>  {

> +	/* Region may not support direct read access */
> +	if (direct && !region->ops->read) {

for missing trigger you added an extack, perhaps makes sense here, too?

> +		err =3D -EOPNOTSUPP;
> +		goto out_unlock;
> +	}
> +
>  	hdr =3D genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
>  			  &devlink_nl_family, NLM_F_ACK | NLM_F_MULTI,
>  			  DEVLINK_CMD_REGION_READ);

Generally all the devlink parts look quite reasonable to me =F0=9F=91=8D
