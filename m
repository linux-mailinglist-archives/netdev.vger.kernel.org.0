Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878D2485F6F
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 04:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiAFD52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 22:57:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49214 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbiAFD51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 22:57:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C70DCB81F0D
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 03:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E186C36AE0;
        Thu,  6 Jan 2022 03:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641441445;
        bh=Zz7RM046CcXmlNQun6L+tdFOGcvzEcaAv09a6MK+YM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uqlOCp6+0UlumSa7aHUazAvytmd3IjbXj7xk55eGL3lOhmnkINAYhLq/PK1wCpxQg
         emGVPXaPLJGAFlBhYbmPCdB8Ig44T1JtShtmHf0CIvl6UQKJD20gDxTcChtoFds59T
         5/9ljEu6BrpBdKp0wUr38f0a6vEQ8y6WCn7nd7upMGximvA7Fi13fakfMIl6ofRwu4
         qT/ZKIrziLCGcb1WP/2xsEzSl04dI9KQQsRPYLmnbYq+RVRegaMLTHGwg/hqFjw/pO
         sYKITZSzdYXNtdsfL7ARANbysqdu2gocoJqXmjknKtMsUj8O3s7GK4eEi9E1KptjcS
         EiC/AuG084VDQ==
Date:   Wed, 5 Jan 2022 19:57:23 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>, roid@nvidia.com
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH net 4/4] mlx5: Don't accidentally set RTO_ONLINK before
 mlx5e_route_lookup_ipv4_get()
Message-ID: <20220106035723.o4emdnfvhipoiz5r@sx1>
References: <cover.1641407336.git.gnault@redhat.com>
 <a0ba792bbbf088882a55507c932f1abec915c3b6.1641407336.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a0ba792bbbf088882a55507c932f1abec915c3b6.1641407336.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 08:56:28PM +0100, Guillaume Nault wrote:
>Mask the ECN bits before calling mlx5e_route_lookup_ipv4_get(). The
>tunnel key might have the last ECN bit set. This interferes with the
>route lookup process as ip_route_output_key_hash() interpretes this bit
>specially (to restrict the route scope).
>
>Found by code inspection, compile tested only.
>
>Fixes: c7b9038d8af6 ("net/mlx5e: TC preparation refactoring for routing update event")
>Fixes: 9a941117fb76 ("net/mlx5e: Maximize ip tunnel key usage on the TC offloading path")
>Signed-off-by: Guillaume Nault <gnault@redhat.com>
>---
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
>index a5e450973225..bc5f1dcb75e1 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
>@@ -1,6 +1,7 @@
> /* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
> /* Copyright (c) 2018 Mellanox Technologies. */
>
>+#include <net/inet_ecn.h>
> #include <net/vxlan.h>
> #include <net/gre.h>
> #include <net/geneve.h>
>@@ -235,7 +236,7 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
> 	int err;
>
> 	/* add the IP fields */
>-	attr.fl.fl4.flowi4_tos = tun_key->tos;
>+	attr.fl.fl4.flowi4_tos = tun_key->tos & ~INET_ECN_MASK;

This is TC control path, why would ecn bits be ON in TC act->tunnel info ?
I don't believe these bits are on and if they were, TC tunnels layer should
clear them before calling the driver's offload callback.

