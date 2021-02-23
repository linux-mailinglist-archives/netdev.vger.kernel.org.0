Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B62E322356
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 01:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhBWA5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 19:57:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230060AbhBWA5H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 19:57:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6203064E5C;
        Tue, 23 Feb 2021 00:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614041786;
        bh=3pY5WFu1Ga0y3dwlJnmXoQgzLy9gOhz0VuznV36Gg24=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cXK+vcvBZwqwIZytW45gLGGcfHwosMNnQY8yLN+O4lHN4LdEddmh/wGvYOlAKwcwa
         Z9IYeD78H/LYAVskG/VV9SEBvJGmtfDQ6WMuf/gY+rsK7c4TDGeuv+hQJEmN6/krSN
         FGK+V/YQt5EigKGfBBbvi59IHiLBoVbk4Qbg5yIcD2cdSyogc8b1xCVYk9/L1BbSRn
         EHCMMPzPavUFexmxBzEcMpPuQQg3LmjNXmnN+/GK7LjBpGli2FF+vKZxxnPvvGF3we
         rkc4hKp+Fyh8dPavWrzhHjl2o7+qAf5ZLuC9vQ4jTFCtH8m9+AX55QSPo3FOSSEbJF
         xlsaJaqjAo7xg==
Date:   Mon, 22 Feb 2021 16:56:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Romain Perier <romain.perier@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        kernel-hardening@lists.openwall.com, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/20] devlink: Manual replacement of the deprecated
 strlcpy() with return values
Message-ID: <20210222165623.12e31597@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210222151231.22572-4-romain.perier@gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com>
        <20210222151231.22572-4-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Feb 2021 16:12:14 +0100 Romain Perier wrote:
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 737b61c2976e..7eb445460c92 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -9461,10 +9461,10 @@ EXPORT_SYMBOL_GPL(devlink_port_param_value_changed);
>  void devlink_param_value_str_fill(union devlink_param_value *dst_val,
>  				  const char *src)
>  {
> -	size_t len;
> +	ssize_t len;
>  
> -	len = strlcpy(dst_val->vstr, src, __DEVLINK_PARAM_MAX_STRING_VALUE);
> -	WARN_ON(len >= __DEVLINK_PARAM_MAX_STRING_VALUE);
> +	len = strscpy(dst_val->vstr, src, __DEVLINK_PARAM_MAX_STRING_VALUE);
> +	WARN_ON(len == -E2BIG);

WARN_ON(len < 0) ?
