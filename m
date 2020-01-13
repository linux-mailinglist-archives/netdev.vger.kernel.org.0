Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA4413890B
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 01:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387503AbgAMAKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 19:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387460AbgAMAKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 19:10:19 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37AD6206DA;
        Mon, 13 Jan 2020 00:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578874218;
        bh=GUDs/y06Kpbbpg6tDXqmKoRcfaBF1YO6bipPFNelPq4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eNpzFcFD0axGSQrPp8xOwkS8p91ErFJDSttifjC4rURNKVnUl8gncA/qpnmnQeJgD
         7f+dSpifykfSYRJhQjNtDkbxqzW7iy7Ip85Qo6Xf0F7NIL2Ui7lYr340fen3O1Hcb+
         hz4npH+WESIH5mjVDVgOz6g+R7pDhGqEGJwyC8ks=
Date:   Sun, 12 Jan 2020 16:10:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Shalom Toledo <shalomt@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net 2/4] mlxsw: switchx2: Do not modify cloned SKBs
 during xmit
Message-ID: <20200112161017.43b728c8@cakuba>
In-Reply-To: <20200112160641.282108-3-idosch@idosch.org>
References: <20200112160641.282108-1-idosch@idosch.org>
        <20200112160641.282108-3-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jan 2020 18:06:39 +0200, Ido Schimmel wrote:
> From: Shalom Toledo <shalomt@mellanox.com>
> 
> The driver needs to prepend a Tx header to each packet it is transmitting.
> The header includes information such as the egress port and traffic class.
> 
> The addition of the header requires the driver to modify the SKB's data
> buffer and therefore the SKB must be unshared first. Otherwise, we risk
> hitting various race conditions with cloned SKBs.
> 
> For example, when a packet is flooded (cloned) by the bridge driver to two
> switch ports swp1 and swp2:
> 
> t0 - mlxsw_sp_port_xmit() is called for swp1. Tx header is prepended with
>      swp1's port number
> t1 - mlxsw_sp_port_xmit() is called for swp2. Tx header is prepended with
>      swp2's port number, overwriting swp1's port number
> t2 - The device processes data buffer from t0. Packet is transmitted via
>      swp2
> t3 - The device processes data buffer from t1. Packet is transmitted via
>      swp2
> 
> Usually, the device is fast enough and transmits the packet before its
> Tx header is overwritten, but this is not the case in emulated
> environments.
> 
> Fix this by unsharing the SKB.

Isn't this what skb_cow_head() is for?

> diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
> index de6cb22f68b1..47826e905e5c 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
> @@ -299,6 +299,10 @@ static netdev_tx_t mlxsw_sx_port_xmit(struct sk_buff *skb,
>  	u64 len;
>  	int err;
>  
> +	skb = skb_unshare(skb, GFP_ATOMIC);
> +	if (unlikely(!skb))
> +		return NETDEV_TX_BUSY;
> +
>  	memset(skb->cb, 0, sizeof(struct mlxsw_skb_cb));
>  
>  	if (mlxsw_core_skb_transmit_busy(mlxsw_sx->core, &tx_info))

the next line here is:

		return NETDEV_TX_BUSY;

Is it okay to return BUSY after copying an skb? The reference to the
original skb may already be gone at this point, while the copy is going
to be leaked, right?
