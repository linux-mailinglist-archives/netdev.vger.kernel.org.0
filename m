Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0462314C70
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhBIKEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:04:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231256AbhBIKCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 05:02:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E09D64E9D;
        Tue,  9 Feb 2021 10:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612864883;
        bh=B10Hyq/wtIB3HZQivfE9KnVX+vkDVCQI5HDccdHG6Pg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kiRBHi4E1nHfZpTbuOGxSWHPmeNWkp2FCWD1M5j7o/l1bum0nFzSATkNA8rtMenHN
         3S8FsrhEiQKhqgslzGobZWMICv3+HKlz+00VvFHk+NQxyBi/HaH3AjPm3iXUuJa4O+
         EHU9hfG9ezYjUbQqBdWBbHODeDmi8NWC1NQ2/Ik2eQtlAbUQLoK/UI0f5RRVftF37C
         tqRh173v5EL8zvnTBZzoCJMBsGOUf3EwFV4CKw2xVqD9kwXyAO9W7c3Xmz1Uho9d3o
         J9lI2hUdie/f2CYxLpaZh1OqNLshgC0twKsPScYFw9HtewOGgyA5+ZSXkvwHqNA4qJ
         a3pOphTvsHFGw==
Date:   Tue, 9 Feb 2021 12:01:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210209100119.GC139298@unreal>
References: <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210130144231.GA3329243@shredder.lan>
 <8924ef5a-a3ac-1664-ca11-5f2a1f35399a@nvidia.com>
 <20210201180837.GB3456040@shredder.lan>
 <20210208070350.GB4656@unreal>
 <20210208085746.GA179437@shredder.lan>
 <20210208090702.GB20265@unreal>
 <20210208170735.GA207830@shredder.lan>
 <20210209064702.GB139298@unreal>
 <CAJ3xEMh72mb9ZYd8umr-FTEO+MV6TNyqST2kLAz_wdLgPcFnww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ3xEMh72mb9ZYd8umr-FTEO+MV6TNyqST2kLAz_wdLgPcFnww@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 11:25:33AM +0200, Or Gerlitz wrote:
> On Tue, Feb 9, 2021 at 8:49 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> [..]
>
> > This is another problem with mlx5 - complete madness with config options
> > that are not possible to test.
> > ➜  kernel git:(rdma-next) grep -h "config MLX" drivers/net/ethernet/mellanox/mlx5/core/Kconfig | awk '{ print $2}' | sort |uniq |wc -l
> > 19
>
> wait, why do you call it madness? we were suggested by some users (do
> git blame for the patches) to refine things with multiple configs and it seem
> to work quite well  -- what you don't like? and what's wrong with simple grep..

Yes, I aware of these users and what and why they asked it.

They didn't ask us to have new config for every feature/file, but to have
light ethernet device.

Other users are distributions and they enable all options that supported in
the specific kernel they picked, because they don't know in advance where their
distro will be used.

You also don't have capacity to test various combinations, so you
test only small subset of common ones that are pretty standard. This is why
you have this feeling of "work quite well".

And I'm not talking about compilations but actual regression runs.

I suggest to reduce number of configs to small amount, something like 3-5 options:
 * Basic ethernet driver
 * + ETH
 * + RDMA
 * + VDPA
 * ....
 * Full mlx5 driver

And there is nothing wrong with simple grep, it was my copy/paste from
another internal thread where this config bloat caused us to some griefs
in regression.

Thanks

>
> $ grep "config MLX5_" drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> config MLX5_CORE
> config MLX5_ACCEL
> config MLX5_FPGA
> config MLX5_CORE_EN
> config MLX5_EN_ARFS
> config MLX5_EN_RXNFC
> config MLX5_MPFS
> config MLX5_ESWITCH
> config MLX5_CLS_ACT
> config MLX5_TC_CT
> config MLX5_CORE_EN_DCB
> config MLX5_CORE_IPOIB
> config MLX5_FPGA_IPSEC
> config MLX5_IPSEC
> config MLX5_EN_IPSEC
> config MLX5_FPGA_TLS
> config MLX5_TLS
> config MLX5_EN_TLS
> config MLX5_SW_STEERING
> config MLX5_SF
> config MLX5_SF_MANAGER
> config MLX5_EN_NVMEOTCP
