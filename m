Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB1242DA29
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 15:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhJNNW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 09:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhJNNWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 09:22:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C4CA610CC;
        Thu, 14 Oct 2021 13:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634217650;
        bh=CpR3tXam+usj796pgclI18TzOaigZVGhMw+oBpo8eEo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N5+IcGQUogijDwRwbZASj5jE15+StQWry3r2wZOgj12hNTKPEZKlKioa/HcaL0A5T
         87jdPRi/90Z/GW43VS+UGGGfs+aptEwI5yWHPiL9bc+8wWIFCl8Et5Bdl4pG64dY+E
         /oQ37lK/lJYs6p/Ooo9Dwf7j4/jmS13nl7EMPv0E6quU5w/90gc3yZZlTMGMbY0NWp
         HjGrReOrP8cV7fdxwDhX9F70FuYo7VBHEkq0LyZvpVd05l1+9tZ/0OCz9FsYZgEKce
         VUKDmndEN8obmWrBydSCXZoCEx07EPToavQ8DUpy6Tya3Oin8a7WVInnOy0RklGWph
         RfPaGToINB1jg==
Date:   Thu, 14 Oct 2021 06:20:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Niklas Soderlund <niklas.soderlund@corigine.com>
Subject: Re: [PATCH net] nfp: bpf: relax prog rejection for mtu check
 through max_pkt_offset
Message-ID: <20211014062049.1cf8e1b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211014120948.31278-1-simon.horman@corigine.com>
References: <20211014120948.31278-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 14:09:48 +0200 Simon Horman wrote:
>  nfp_bpf_check_mtu(struct nfp_app *app, struct net_device *netdev, int new_mtu)
>  {
>  	struct nfp_net *nn = netdev_priv(netdev);
> -	unsigned int max_mtu;
>  
>  	if (~nn->dp.ctrl & NFP_NET_CFG_CTRL_BPF)
>  		return 0;

This check only implies BPF is loaded..

> -	max_mtu = nn_readb(nn, NFP_NET_CFG_BPF_INL_MTU) * 64 - 32;
> -	if (new_mtu > max_mtu) {
> -		nn_info(nn, "BPF offload active, MTU over %u not supported\n",
> -			max_mtu);
> +	if (nfp_bpf_offload_check_mtu(nn, nn->xdp_hw.prog, new_mtu)) {

yet here you assume the BPF loaded is XDP. NFP also supports offloading
TC/cls_bpf programs.
