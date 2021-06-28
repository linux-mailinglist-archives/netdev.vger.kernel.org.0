Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EC53B6B27
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236462AbhF1XIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235806AbhF1XIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 19:08:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D86D61CDA;
        Mon, 28 Jun 2021 23:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624921545;
        bh=SnGZtjLUu9IWUdD+Lzjzj+vLXNmweI9Cvn1DnZaXYSU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=a/CKx5Dcc9IpFYWOwxeTXUBe1akzQe6f/ORNMSIte/rlHpjab8gSp7pXjh6P7fMLK
         xXPl6yJME76ZU7uPoZDLjl1IkCTGpaMWKicTmrMUXCRyqp76XyynIkQ69MEyHKp02+
         0pAZcHQUk4A6/GLQHfeU8puAtJvm3Ixef/V/VM4nTbt/qfIv15UA/RkDALzSfdhkLt
         L2RswpDEDMM+Y4FIAgQjVbeiBImmplCz2uvKV0/QFtBwZ1ObiUKdvaXwbHACTOc8V5
         mRPo5Xyp1DvcvRnp283qLUYQt3FxxGEPfgyIrt2t6AVby+oL2fNzT6tfF0qsEatal5
         vbrl2SjSDUlUw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 6B9415C0329; Mon, 28 Jun 2021 16:05:45 -0700 (PDT)
Date:   Mon, 28 Jun 2021 16:05:45 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH bpf-next] bpf/devmap: convert remaining READ_ONCE() to
 rcu_dereference()
Message-ID: <20210628230545.GN4397@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210628230051.556099-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210628230051.556099-1-toke@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 01:00:51AM +0200, Toke Høiland-Jørgensen wrote:
> There were a couple of READ_ONCE()-invocations left-over by the devmap RCU
> conversion. Convert these to rcu_dereference() as well to avoid complaints
> from sparse.
> 
> Fixes: 782347b6bcad ("xdp: Add proper __rcu annotations to redirect map entries")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  kernel/bpf/devmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 2f6bd75cd682..7a0c008f751b 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -558,7 +558,7 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
>  
>  	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
>  		for (i = 0; i < map->max_entries; i++) {
> -			dst = READ_ONCE(dtab->netdev_map[i]);
> +			dst = rcu_dereference(dtab->netdev_map[i]);
>  			if (!is_valid_dst(dst, xdp, exclude_ifindex))
>  				continue;
>  
> @@ -654,7 +654,7 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
>  
>  	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
>  		for (i = 0; i < map->max_entries; i++) {
> -			dst = READ_ONCE(dtab->netdev_map[i]);
> +			dst = rcu_dereference(dtab->netdev_map[i]);
>  			if (!dst || dst->dev->ifindex == exclude_ifindex)
>  				continue;
>  
> -- 
> 2.32.0
> 
