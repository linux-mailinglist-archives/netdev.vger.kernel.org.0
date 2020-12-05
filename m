Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A732F2CFEF0
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 21:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgLEUtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 15:49:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEUtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 15:49:41 -0500
Date:   Sat, 5 Dec 2020 12:48:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607201340;
        bh=Z/co9+Pvv4I2LEXBmRkaa+SbLCbOTc8rgFmjC1Xh5BE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=b5YMJNMCZCfyg5q1n2W38CE2FJV1cE/SGuJQswCsFwAHd2DZZuSwp96xp+6VFOO5H
         +0NENDzKlpibTPJOLOIputW6E1ygv8HL009zzQqLN7KRildM1ok2bWEcKCiNWWNmLi
         BeUdnTEBQQNXrZx1kgjBXiP6dD9/m0OXJyEC8BUDxmrUJIdZG64C1ccMPNAwTYdXmj
         rjWSftpNvlepD/9lW0YGcfl8jiKhmxeyL5WyvMds9a95Wp/4gkCYQsbPUft7i8agE9
         8ElUQIUu2NO0tzKtBdW7UqswCC7+tjGIWimSTGgyIEm/SAi4yYJlnY+COwrxod9c/x
         XRqQSevUDRDNQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/20] ethernet: ucc_geth: fix use-after-free in
 ucc_geth_remove()
Message-ID: <20201205124859.60d045e6@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205191744.7847-12-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
        <20201205191744.7847-12-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Dec 2020 20:17:34 +0100 Rasmus Villemoes wrote:
> -	unregister_netdev(dev);
> -	free_netdev(dev);
>  	ucc_geth_memclean(ugeth);
>  	if (of_phy_is_fixed_link(np))
>  		of_phy_deregister_fixed_link(np);
>  	of_node_put(ugeth->ug_info->tbi_node);
>  	of_node_put(ugeth->ug_info->phy_node);
> +	unregister_netdev(dev);
> +	free_netdev(dev);

Are you sure you want to move the unregister_netdev() as well as the
free?
