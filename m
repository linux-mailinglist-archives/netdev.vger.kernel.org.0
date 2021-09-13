Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6AE40991D
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237818AbhIMQb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237773AbhIMQbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 12:31:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CDD0604E9;
        Mon, 13 Sep 2021 16:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631550591;
        bh=18h3VMHoLoIKtpSnPVm6tc7kTTJN90h78G0WhZbBzzo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sOvyDfcDuNRjcwfywRsbmBUvmU8ZBzklPjTX2NvhSH9LQ3+HH5myURcf2baIqUPwM
         TnTKT1JtIs/gl33Ie/o6cMSELWI8IcCQX2XJV0LpTYKj4J37oSl8+FLxo3hZZlzhBE
         p9KkoJ30XdqGqA0eNHFpbpRe0pm+35HVkeK9GUkLo6A77AvPVaYfk2bFMyHkYqxtkr
         lcanJ2Q/r5/EyVcdI2H1AOJqeAPnj5xMoayj9IlT4sKY8Pkt8c2dWN5j736ljb5G+K
         7fqAgX//TT/rqVrtx7ZT9o9MRcnRbx9TTZtPGvV8kX209AAvC6e7Tz60Os3ae1AYNW
         IF8sLyNn36M/Q==
Date:   Mon, 13 Sep 2021 09:29:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aya Levin <ayal@nvidia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net] udp_tunnel: Fix udp_tunnel_nic work-queue type
Message-ID: <20210913092950.13e92a7a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1631519629-12338-1-git-send-email-ayal@nvidia.com>
References: <1631519629-12338-1-git-send-email-ayal@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Sep 2021 10:53:49 +0300 Aya Levin wrote:
> Turn udp_tunnel_nic work-queue to an ordered work-queue. This queue
> holds the UDP-tunnel configuration commands of the different netdevs.
> When the netdevs are functions of the same NIC the order of
> execution may be crucial.
> 
> Problem example:
> NIC with 2 PFs, both PFs declare offload quota of up to 3 UDP-ports.
>  $ifconfig eth2 1.1.1.1/16 up
> 
>  $ip link add eth2_19503 type vxlan id 5049 remote 1.1.1.2 dev eth2 dstport 19053
>  $ip link set dev eth2_19503 up
> 
>  $ip link add eth2_19504 type vxlan id 5049 remote 1.1.1.3 dev eth2 dstport 19054
>  $ip link set dev eth2_19504 up
> 
>  $ip link add eth2_19505 type vxlan id 5049 remote 1.1.1.4 dev eth2 dstport 19055
>  $ip link set dev eth2_19505 up
> 
>  $ip link add eth2_19506 type vxlan id 5049 remote 1.1.1.5 dev eth2 dstport 19056
>  $ip link set dev eth2_19506 up
> 
> NIC RX port offload infrastructure offloads the first 3 UDP-ports (on
> all devices which sets NETIF_F_RX_UDP_TUNNEL_PORT feature) and not
> UDP-port 19056. So both PFs gets this offload configuration.
> 
>  $ip link set dev eth2_19504 down
> 
> This triggers udp-tunnel-core to remove the UDP-port 19504 from
> offload-ports-list and offload UDP-port 19056 instead.
> 
> In this scenario it is important that the UDP-port of 19504 will be
> removed from both PFs before trying to add UDP-port 19056. The NIC can
> stop offloading a UDP-port only when all references are removed.
> Otherwise the NIC may report exceeding of the offload quota.
> 
> Fixes: cc4e3835eff4 ("udp_tunnel: add central NIC RX port offload infrastructure")
> Signed-off-by: Aya Levin <ayal@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Obviously not. If you hardware uses a single port table regardless of
the number of PFs you should use the shared table version of the API,
like Intel does.
