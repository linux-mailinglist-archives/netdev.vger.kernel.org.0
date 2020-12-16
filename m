Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9E12DB7E1
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgLPAoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:44:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgLPAoX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 19:44:23 -0500
Date:   Tue, 15 Dec 2020 16:43:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608079422;
        bh=+f96kJpwYEZGtb9XTCDgesUkyxycpdlRgL+ZWgMLbmA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=GbUkJScMQa+f7Zf31OXGmc7jpgBwQvDSUItzm+UoFA+2sq1QdNVs9j7pexjTyekT5
         eNlFTcwDNp05WoK7l5xCNqwYKd3J1MvorYknY4FhZ06aKcWsrDOlevyQgzUV7O4YG1
         Yx9LuhktlX2yWBFBruwO+p2n5g09d9sLrCEmtqy2VIL/24dQCk+kMXke8VvkZDOsve
         rlTc2yD5JbPHk2yKTQGNXHFo77ho9sDywFP4fyePynJ0x3wb3hKU/CrlItropaMc0B
         J05+dHHcihF/ZP5HK0j+pW44bDFonJ0gB/hM/3HVZDk7h9VNZqr4oANwEuTKo3q0Rj
         0ztEWS9VhU2zQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next v5 07/15] net/mlx5: SF, Add auxiliary device support
Message-ID: <20201215164341.51fa3a0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215090358.240365-8-saeed@kernel.org>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-8-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 01:03:50 -0800 Saeed Mahameed wrote:
> +static ssize_t sfnum_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct auxiliary_device *adev = container_of(dev, struct auxiliary_device, dev);
> +	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
> +
> +	return scnprintf(buf, PAGE_SIZE, "%u\n", sf_dev->sfnum);
> +}
> +static DEVICE_ATTR_RO(sfnum);
> +
> +static struct attribute *sf_device_attrs[] = {
> +	&dev_attr_sfnum.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group sf_attr_group = {
> +	.attrs = sf_device_attrs,
> +};
> +
> +static const struct attribute_group *sf_attr_groups[2] = {
> +	&sf_attr_group,
> +	NULL
> +};

Why the sysfs attribute? Devlink should be able to report device name
so there's no need for a tie in from the other end.
