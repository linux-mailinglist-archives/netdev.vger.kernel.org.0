Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3F0462B8F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238140AbhK3ERY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:17:24 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37890 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhK3ERY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:17:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 77705CE1415;
        Tue, 30 Nov 2021 04:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C8EC53FC1;
        Tue, 30 Nov 2021 04:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638245642;
        bh=eRgr8ruLS/HXkYygaB9wTl2f3VahlDG+KskOZEp4GJ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BIZL3x9UXrd584JCXX49+ZFOKJrODOqaJ3JvCIKuc9EiVoCqPaNBqATP4B4C2vJ69
         CJsG/XYckW/0eq6yswqAu93U4MFw4bSwbANKfFB/HZ8g31UlSEOb8QFRezvkKia3ZG
         qRLiTIJZGko5HGUuhfyJ1i59LB8vouTgbA/GKx6S2Fm/InT2PwvNMzrwcisAnH8iwi
         GBX6IPRXboDZTfmQpTD+60H5dfneTDmZiJzst5sIwBATjiSPYNIk3kTPksvpJ3hf+D
         4DPzYlla0l5kKMpIHnPhUUlgH7L7BpZRsiKdHBSVu9zm8QqlAUxsPtLM5HvutL5KWy
         GdGoanpFxA4eQ==
Date:   Mon, 29 Nov 2021 20:14:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v1] devlink: Simplify devlink resources
 unregister call
Message-ID: <20211129201400.488c8ef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e8684abc2c8ced4e35026e8fa85fe29447ef60b6.1638103213.git.leonro@nvidia.com>
References: <e8684abc2c8ced4e35026e8fa85fe29447ef60b6.1638103213.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Nov 2021 14:42:44 +0200 Leon Romanovsky wrote:
> The devlink_resources_unregister() used second parameter as an
> entry point for the recursive removal of devlink resources. None
> of external to devlink users needed to use this field, so lat's

None of the callers outside of devlink core...
s/lat/let/

> remove it.

> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index e3c88fabd700..043fcec8b0aa 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -361,33 +361,6 @@ devlink_resource_size_params_init(struct devlink_resource_size_params *size_para
>  
>  typedef u64 devlink_resource_occ_get_t(void *priv);
>  
> -/**
> - * struct devlink_resource - devlink resource
> - * @name: name of the resource
> - * @id: id, per devlink instance
> - * @size: size of the resource
> - * @size_new: updated size of the resource, reload is needed
> - * @size_valid: valid in case the total size of the resource is valid
> - *              including its children
> - * @parent: parent resource
> - * @size_params: size parameters
> - * @list: parent list
> - * @resource_list: list of child resources
> - */
> -struct devlink_resource {
> -	const char *name;
> -	u64 id;
> -	u64 size;
> -	u64 size_new;
> -	bool size_valid;
> -	struct devlink_resource *parent;
> -	struct devlink_resource_size_params size_params;
> -	struct list_head list;
> -	struct list_head resource_list;
> -	devlink_resource_occ_get_t *occ_get;
> -	void *occ_get_priv;
> -};

> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index fd21022145a3..db3b52110cf2 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -69,6 +69,35 @@ struct devlink {
>  	char priv[] __aligned(NETDEV_ALIGN);
>  };
>  
> +/**
> + * struct devlink_resource - devlink resource
> + * @name: name of the resource
> + * @id: id, per devlink instance
> + * @size: size of the resource
> + * @size_new: updated size of the resource, reload is needed
> + * @size_valid: valid in case the total size of the resource is valid
> + *              including its children
> + * @parent: parent resource
> + * @size_params: size parameters
> + * @list: parent list
> + * @resource_list: list of child resources
> + * @occ_get: occupancy getter callback
> + * @occ_get_priv: occupancy getter callback priv
> + */
> +struct devlink_resource {
> +	const char *name;
> +	u64 id;
> +	u64 size;
> +	u64 size_new;
> +	bool size_valid;
> +	struct devlink_resource *parent;
> +	struct devlink_resource_size_params size_params;
> +	struct list_head list;
> +	struct list_head resource_list;
> +	devlink_resource_occ_get_t *occ_get;
> +	void *occ_get_priv;
> +};

Hiding struct devlink_resource is not mentioned in the commit message
and entirely unrelated to removal of the unused argument.
