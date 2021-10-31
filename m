Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B65A440D54
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 07:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhJaGb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 02:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbhJaGbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 02:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C12C260ED5;
        Sun, 31 Oct 2021 06:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635661764;
        bh=7SynATRRy800TKQWHUPn0bng+Xr+aWu2eK/8Wta6LgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cTSN0YOWj/mo175x+IKgN6nGrANc2DdRApfkRiXurDeDNgPMtTJFQmb4+MkYb3D92
         nVLYgAx0cllIu7CWB1l43w5Kd6r5n3J/6510XnbMER8COtzrpPcaZaoHtlNuprEnI5
         mo5a39Zx85vUyLh0vigK1YVL4Qte9YCSe+0OMJ6RIgiFUuTG0O359fE5/bAjGd67+B
         p1Dm17pLygSNymqiMAml/wrdpxvnDgRP7mmRxzqlzb49gS6iVHETyPzhsWbdZo/0r+
         0xCdd5HWt74xGHuoTImltlaycATLIlWK6mJZJcPQlziiiTHN9klL8fCyqYec7EGmYz
         HKOaiKKhjOqVQ==
Date:   Sun, 31 Oct 2021 08:29:20 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v2 3/4] devlink: expose get/put functions
Message-ID: <YX43wGPh5+TcXR81@unreal>
References: <20211030171851.1822583-1-kuba@kernel.org>
 <20211030171851.1822583-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030171851.1822583-4-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 30, 2021 at 10:18:50AM -0700, Jakub Kicinski wrote:
> Allow those who hold implicit reference on a devlink instance
> to try to take a full ref on it. This will be used from netdev
> code which has an implicit ref because of driver call ordering.
> 
> Note that after recent changes devlink_unregister() may happen
> before netdev unregister, but devlink_free() should still happen
> after, so we are safe to try, but we can't just refcount_inc()
> and assume it's not zero.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/net/devlink.h | 12 ++++++++++++
>  net/core/devlink.c    |  8 +++++---
>  2 files changed, 17 insertions(+), 3 deletions(-)

I really like this series, but your latest netdevsim RFC made me worry.

It is important to make sure that these devlink_put() and devlink_get()
calls will be out-of-reach from the drivers. Only core code should use
them.

Can you please add it as a comment above these functions?
At least for now, till we discuss your RFC.

Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Thanks

> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 1b1317d378de..991ce48f77ca 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1726,6 +1726,9 @@ devlink_trap_policers_unregister(struct devlink *devlink,
>  
>  #if IS_ENABLED(CONFIG_NET_DEVLINK)
>  
> +struct devlink *__must_check devlink_try_get(struct devlink *devlink);
> +void devlink_put(struct devlink *devlink);
> +
>  void devlink_compat_running_version(struct net_device *dev,
>  				    char *buf, size_t len);
>  int devlink_compat_flash_update(struct net_device *dev, const char *file_name);
> @@ -1736,6 +1739,15 @@ int devlink_compat_switch_id_get(struct net_device *dev,
>  
>  #else
>  
> +static inline struct devlink *devlink_try_get(struct devlink *devlink)
> +{
> +	return NULL;
> +}
> +
> +static inline void devlink_put(struct devlink *devlink)
> +{
> +}
> +
>  static inline void
>  devlink_compat_running_version(struct net_device *dev, char *buf, size_t len)
>  {
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 2d8abe88c673..100d87fd3f65 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -182,15 +182,17 @@ struct net *devlink_net(const struct devlink *devlink)
>  }
>  EXPORT_SYMBOL_GPL(devlink_net);
>  
> -static void devlink_put(struct devlink *devlink)
> +void devlink_put(struct devlink *devlink)
>  {
>  	if (refcount_dec_and_test(&devlink->refcount))
>  		complete(&devlink->comp);
>  }
>  
> -static bool __must_check devlink_try_get(struct devlink *devlink)
> +struct devlink *__must_check devlink_try_get(struct devlink *devlink)
>  {
> -	return refcount_inc_not_zero(&devlink->refcount);
> +	if (refcount_inc_not_zero(&devlink->refcount))
> +		return devlink;
> +	return NULL;
>  }
>  
>  static struct devlink *devlink_get_from_attrs(struct net *net,
> -- 
> 2.31.1
> 
