Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A20141BBE8
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 02:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243046AbhI2Aul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 20:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243496AbhI2Aue (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 20:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F352613D0;
        Wed, 29 Sep 2021 00:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632876534;
        bh=yTz5TNa3t2fIBCUxzcLoT09IrftJw4w0gXRpSbpynDg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IJ3UQgabPIIutrZtizJtzC7hN8/7Tn2GHjpe9rP9AqAvoHup8seeIED1eBGK94rg8
         o3cB9HWrZo9Zvy9Z7ujl3HWx2KcZ2LouQNcAnnysSuWsSWi6iqJAGZbDkb9JDxI/JO
         h5m3XTsF7CTgRNyHl6SuA+3HTTp7bHuGgX5y/iZqB8/2xwUX3kX/2VvUG4hAdTKc4X
         HjYwn1aPF+SExV6DHZlM/3U1XpY3ewhP1YJanJXdl6OU4OSR0c2WHPm/X8hZrORKJC
         i8XHbHTimOZCanFx0qba76g0+lNwPkkXRlm1N7C6QadB1vbVcYNwFIapiIQbm9yixw
         eu2pzBftHxDIA==
Date:   Tue, 28 Sep 2021 17:48:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toms Atteka <cpp.code.lv@gmail.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6] net: openvswitch: IPv6: Add IPv6 extension
 header support
Message-ID: <20210928174853.06fe8e66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210928194727.1635106-1-cpp.code.lv@gmail.com>
References: <20210928194727.1635106-1-cpp.code.lv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Sep 2021 12:47:27 -0700 Toms Atteka wrote:
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index a87b44cd5590..dc6eb5f6399f 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -346,6 +346,13 @@ enum ovs_key_attr {
>  #ifdef __KERNEL__
>  	OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
>  #endif
> +
> +#ifndef __KERNEL__

#else

> +	PADDING,  /* Padding so kernel and non kernel field count would match */

The name PADDING seems rather risky, collisions will be likely.
OVS_KEY_ATTR_PADDING maybe?

But maybe we don't need to define this special value and bake it into
the uAPI, why can't we add something like this to the kernel header
(i.e. include/linux/openvswitch.h):

/* Insert a kernel only KEY_ATTR */
#define OVS_KEY_ATTR_TUNNEL_INFO	__OVS_KEY_ATTR_MAX
#undef OVS_KEY_ATTR_MAX
#define OVS_KEY_ATTR_MAX		__OVS_KEY_ATTR_MAX

> +#endif
