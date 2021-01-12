Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA72F3CF1
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438085AbhALVhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436987AbhALUfw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 15:35:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44CF32311F;
        Tue, 12 Jan 2021 20:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610483711;
        bh=KVKlOQnOuAWB+tvUn97Yw4QhON1A8Tqg6O9PMHQwfVo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KjcZSRExp0uk3p2vPou+zoOqjqvFRVyiZkNI1XsaQc5hQlnhwDafhWsGIgxLTEFVM
         dKPGBduHTM6OTw5iQ9TYb8BhMU1gbT2R2kqzpqT3JQVKov5EU2LPH42iKprkIjlHYE
         v/7DoE6Rf/n8uL6VMfAovAvz6xfGSyBwYUxDrcVycQdie8qKSu+wO49SnJPXGhLyYZ
         zBvC7DcfCIg8RiJKyyZZQwgmWGdacXO+Kk5Zb1JYYnmRO4u2WSC/+LoQfyz3JC+wF1
         K6QDMC0hbO24DaB8MLiLBFUSwXtRcdJ/auKL05jGkinwGQuYBpJ8FWpVHaiHBc6grE
         t81yPW8KJ+ZbQ==
Message-ID: <06917964a6abf26ddad21a22b29d760fc89cfcf7.camel@kernel.org>
Subject: Re: mlx5 error when the skb linear space is empty
From:   Saeed Mahameed <saeed@kernel.org>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Network Development <netdev@vger.kernel.org>
Date:   Tue, 12 Jan 2021 12:35:09 -0800
In-Reply-To: <CAJ8uoz0xkGUd6V9-+x6pfMoqz0UjhkSBWz-dBChi=eNGM2cS4w@mail.gmail.com>
References: <1609757998.875103-1-xuanzhuo@linux.alibaba.com>
         <741209d2a42d46ebdb8249caaef7531f5ad8fa76.camel@kernel.org>
         <CAJ8uoz0xkGUd6V9-+x6pfMoqz0UjhkSBWz-dBChi=eNGM2cS4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-01-11 at 09:02 +0100, Magnus Karlsson wrote:
> On Tue, Jan 5, 2021 at 9:51 PM Saeed Mahameed <saeed@kernel.org>
> wrote:
> > On Mon, 2021-01-04 at 18:59 +0800, Xuan Zhuo wrote:
> > > hi
> > > 
> > > In the process of developing xdp socket, we tried to directly use
> > > page to
> > > construct skb directly, to avoid data copy. And the MAC
> > > information
> > > is also in
> > > the page, which caused the linear space of skb to be empty. In
> > > this
> > > case, I
> > > encountered a problem :
> > > 
> > > mlx5_core 0000:3b:00.1 eth1: Error cqe on cqn 0x817, ci 0x8, qn
> > > 0x1dbb, opcode 0xd, syndrome 0x1, vendor syndrome 0x68
> > > 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 00000030: 00 00 00 00 60 10 68 01 0a 00 1d bb 00 0f 9f d2
> > > WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0xf, len: 64
> > > 00000000: 00 00 0f 0a 00 1d bb 03 00 00 00 08 00 00 00 00
> > > 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 00000020: 00 00 00 2b 00 08 00 00 00 00 00 05 9e e3 08 00
> > > 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > mlx5_core 0000:3b:00.1 eth1: ERR CQE on SQ: 0x1dbb
> > > 
> > > 
> > > And when I try to copy only the mac address into the linear space
> > > of
> > > skb, the
> > > other parts are still placed in the page. When constructing skb
> > > in
> > > this way, I
> > > found that although the data can be sent successfully, the
> > > sending
> > > performance
> > > is relatively poor!!
> > > 
> > 
> > Hi,
> > 
> > This is an expected behavior of ConnectX4-LX, ConnectX4-LX requires
> > the
> > driver to copy at least the L2 headers into the linear part, in
> > some
> > DCB/DSCP configuration it will require L3 headers.
> 
> Do I understand this correctly if I say whatever is calling
> ndo_start_xmit has to make sure at least the L2 headers is in the
> linear part of the skb? If Xuan does not do this, the ConnectX4
> driver
> crashes, but if he does, it works. So from an ndo_start_xmit
> interface
> perspective, what is the requirement of an skb that is passed to it?
> Do all users of ndo_start_xmit make sure the L2 header is in the
> linear part, or are there users that do not make sure this is the
> case? Judging from the ConnectX5 code it seems that the latter is
> possible (since it has code to deal with this), but from the
> ConnectX4, it seems like the former is true (since it does not copy
> the L2 headers into the linear part as far as I can see). Sorry for
> my
> confusion, but I think it is important to get some clarity here as it
> will decide if Xuan's patch is a good idea or not in its current
> form.
> 

To clarify: 
Connectx4Lx, doesn't really require data to be in the linear part, I
was refereing to a HW limitation that requires the driver to copy the
L2/L3 headers (depending on current HW config) to a special area in the
tx descriptor, currently the driver copy the L2/L3 headers only from
the linear part of the SKB, but this can be changed via calling
pskb_may_pull in mlx5 ConnectX4LX tx path to make sure the linear part
has the needed data .. 

Something like:

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 61ed671fe741..5939fd8eed2c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -159,6 +159,7 @@ static inline int mlx5e_skb_l2_header_offset(struct
sk_buff *skb)
 {
 #define MLX5E_MIN_INLINE (ETH_HLEN + VLAN_HLEN)

+       /* need to check ret val */ 
+       pskb_may_pull(skb, MLX5E_MIN_INLINE);
        return max(skb_network_offset(skb), MLX5E_MIN_INLINE);
 }


