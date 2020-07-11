Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799F321C5B8
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 20:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgGKSXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 14:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728640AbgGKSW7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 14:22:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5666A20725;
        Sat, 11 Jul 2020 18:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594491778;
        bh=PpE2E3a2mafxkVQhO4QXClb0T8OMAPeq+4EM4iu0Qsw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VO3cTiuYsqIxLAalmtWkXobd5O/HWawFfRWNFacHNeZM7xaLFjx+oVM0WEsmj7k+T
         SuWTXwb5EHwf7ChF5B4AkdoLr2FRIURKWBUCfxXgxuQZQz+lV7fPDz9ViGQUGl97aJ
         epWUXeqTjGzGgwIEq/YeF1JC9lxNmhbyBbUUkS/4=
Date:   Sat, 11 Jul 2020 11:22:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 01/13] net: sched: Pass qdisc reference in
 struct flow_block_offload
Message-ID: <20200711112256.4153f2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a5a3ccf7bf3a097c6400d64f617ee7ee9fc6156c.1594416408.git.petrm@mellanox.com>
References: <cover.1594416408.git.petrm@mellanox.com>
        <a5a3ccf7bf3a097c6400d64f617ee7ee9fc6156c.1594416408.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Jul 2020 00:55:03 +0300 Petr Machata wrote:
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> index 0a9a4467d7c7..e82e5cf64d61 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> @@ -1888,7 +1888,7 @@ static void bnxt_tc_setup_indr_rel(void *cb_priv)
>  	kfree(priv);
>  }
>  
> -static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
> +static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct Qdisc *sch, struct bnxt *bp,
>  				    struct flow_block_offload *f, void *data,
>  				    void (*cleanup)(struct flow_block_cb *block_cb))
>  {
> @@ -1911,7 +1911,7 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
>  		block_cb = flow_indr_block_cb_alloc(bnxt_tc_setup_indr_block_cb,
>  						    cb_priv, cb_priv,
>  						    bnxt_tc_setup_indr_rel, f,
> -						    netdev, data, bp, cleanup);
> +						    netdev, sch, data, bp, cleanup);

nit: the number of arguments is getting out of hand here, perhaps it's
     time to pass a structure in.

>  		if (IS_ERR(block_cb)) {
>  			list_del(&cb_priv->list);
>  			kfree(cb_priv);
> @@ -1946,7 +1946,7 @@ static bool bnxt_is_netdev_indr_offload(struct net_device *netdev)
>  	return netif_is_vxlan(netdev);
>  }
>  
> -static int bnxt_tc_setup_indr_cb(struct net_device *netdev, void *cb_priv,
> +static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, void *cb_priv,
>  				 enum tc_setup_type type, void *type_data,
>  				 void *data,
>  				 void (*cleanup)(struct flow_block_cb *block_cb))
> @@ -1956,8 +1956,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, void *cb_priv,
>  
>  	switch (type) {
>  	case TC_SETUP_BLOCK:
> -		return bnxt_tc_setup_indr_block(netdev, cb_priv, type_data, data,
> -						cleanup);
> +		return bnxt_tc_setup_indr_block(netdev, sch, cb_priv, type_data, data, cleanup);
>  	default:
>  		break;
>  	}
