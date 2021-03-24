Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121E83479E2
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbhCXNrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235459AbhCXNri (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 09:47:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70C9761A01;
        Wed, 24 Mar 2021 13:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616593658;
        bh=hPtkX3/xhO/wMcHvFW3k+WU/tC3UTlM33aGBYnU044k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PCJRLb5ZMtXr2zs8Fqq1xj/SB5G4ps4QtFfpEq9xp1/U3H7YsfQUS4P1fnpnCDYel
         /vtdVNWnGSV1gUJSZ8K/YYcKN4m6RhKaUOz2dUUIxFB2stb7DpaY3XB685c8CKhYT1
         macxf/6XCSP8DIF+WgcuoEg22CfhtpS7vON2MQiVUChq/lnAdo2d0tG94x27EbadNA
         vnsYp1+7Q51RuY1sh5jRnjrf2J38YqDxO+Ofin9d7hjIljSsdgADMgi0983v6cZTGz
         Vq/GrtvfgmzwVD6XCzrSECkGLoRk2KQG874PsQpaiUjWWEef10tGQU2Tc34ycjP/Y6
         bD3meZen0Xa4Q==
Date:   Wed, 24 Mar 2021 15:47:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH v2 08/23] RDMA/irdma: Register auxiliary driver and
 implement private channel OPs
Message-ID: <YFtC9hWHYiCR9vIC@unreal>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
 <20210324000007.1450-9-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324000007.1450-9-shiraz.saleem@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 06:59:52PM -0500, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
> 
> Register auxiliary drivers which can attach to auxiliary RDMA
> devices from Intel PCI netdev drivers i40e and ice. Implement the private
> channel ops, and register net notifiers.
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/infiniband/hw/irdma/i40iw_if.c | 229 +++++++++++++
>  drivers/infiniband/hw/irdma/main.c     | 382 ++++++++++++++++++++++
>  drivers/infiniband/hw/irdma/main.h     | 565 +++++++++++++++++++++++++++++++++
>  3 files changed, 1176 insertions(+)
>  create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
>  create mode 100644 drivers/infiniband/hw/irdma/main.c
>  create mode 100644 drivers/infiniband/hw/irdma/main.h

<...>

> +/* client interface functions */
> +static const struct i40e_client_ops i40e_ops = {
> +	.open = i40iw_open,
> +	.close = i40iw_close,
> +	.l2_param_change = i40iw_l2param_change
> +};
> +
> +static struct i40e_client i40iw_client = {
> +	.ops = &i40e_ops,
> +	.type = I40E_CLIENT_IWARP,
> +};
> +
> +static int i40iw_probe(struct auxiliary_device *aux_dev, const struct auxiliary_device_id *id)
> +{
> +	struct i40e_auxiliary_device *i40e_adev = container_of(aux_dev,
> +							       struct i40e_auxiliary_device,
> +							       aux_dev);
> +	struct i40e_info *cdev_info = i40e_adev->ldev;
> +
> +	strncpy(i40iw_client.name, "irdma", I40E_CLIENT_STR_LENGTH);
> +	cdev_info->client = &i40iw_client;
> +	cdev_info->aux_dev = aux_dev;
> +
> +	return cdev_info->ops->client_device_register(cdev_info);

Why do we need all this indirection? I see it as leftover from previous
version where you mixed auxdev with your peer registration logic.

Thanks
