Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EB82FEE39
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 16:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732699AbhAUPPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 10:15:08 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:38859 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732626AbhAUPOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 10:14:34 -0500
Date:   Thu, 21 Jan 2021 15:13:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611242020; bh=O9TLtHmt2zh8yMakyKLVS/teU5JXK2tqPjP6ofPakhM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=eQ8lCveduUB8ZCLvch3E2Gn7spJr/z2r7aLu5lYla4sMTdqVW54xiHH7tb0qXWML7
         5lBAC6tbvoEraRw6HJyJtfehD0pMsgiqSoUyGmEo6gnWks+PydKzRyDYKXHAcXRI4N
         nyc5GO481bJeDGrR1fXz+2LJks+J/MfbG0hi6C7Wbvd0yIPVOLA1HZ8envfEEVrXWs
         VtQwmap3nF437RrO4mtEK/GnHipnNNQ/hlVkfEd6aa0loFrY3sMitnhdAe1EWXbnsn
         /ziYpr9/tR0UCdnqMnZwM7mZNMtAYjIc5df93+cYTeH67zT6Y1vSCsWJELRrC71i0p
         0+VhXOPQyCFRw==
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH bpf-next v3 1/3] net: add priv_flags for allow tx skb without linear
Message-ID: <20210121151320.3018-1-alobakin@pm.me>
In-Reply-To: <d44e0c054675e816b1ece745be795bd2a8b88350.1611236588.git.xuanzhuo@linux.alibaba.com>
References: <cover.1611236588.git.xuanzhuo@linux.alibaba.com> <d44e0c054675e816b1ece745be795bd2a8b88350.1611236588.git.xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date: Thu, 21 Jan 2021 21:47:07 +0800

> In some cases, we hope to construct skb directly based on the existing
> memory without copying data. In this case, the page will be placed
> directly in the skb, and the linear space of skb is empty. But
> unfortunately, many the network card does not support this operation.
> For example Mellanox Technologies MT27710 Family [ConnectX-4 Lx] will
> get the following error message:
>=20
>     mlx5_core 0000:3b:00.1 eth1: Error cqe on cqn 0x817, ci 0x8, qn 0x1db=
b, opcode 0xd, syndrome 0x1, vendor syndrome 0x68
>     00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>     00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>     00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>     00000030: 00 00 00 00 60 10 68 01 0a 00 1d bb 00 0f 9f d2
>     WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0xf, len: 64
>     00000000: 00 00 0f 0a 00 1d bb 03 00 00 00 08 00 00 00 00
>     00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>     00000020: 00 00 00 2b 00 08 00 00 00 00 00 05 9e e3 08 00
>     00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>     mlx5_core 0000:3b:00.1 eth1: ERR CQE on SQ: 0x1dbb
>=20
> So a priv_flag is added here to indicate whether the network card
> supports this feature.
>=20
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Suggested-by: Alexander Lobakin <alobakin@pm.me>

Acked-by: Alexander Lobakin <alobakin@pm.me>

> ---
>  include/linux/netdevice.h | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ef51725..135db8f 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1525,6 +1525,7 @@ struct net_device_ops {
>   * @IFF_FAILOVER_SLAVE: device is lower dev of a failover master device
>   * @IFF_L3MDEV_RX_HANDLER: only invoke the rx handler of L3 master devic=
e
>   * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
> + * @IFF_TX_SKB_NO_LINEAR: allow tx skb linear is empty
>   */
>  enum netdev_priv_flags {
>  =09IFF_802_1Q_VLAN=09=09=09=3D 1<<0,
> @@ -1558,6 +1559,7 @@ enum netdev_priv_flags {
>  =09IFF_FAILOVER_SLAVE=09=09=3D 1<<28,
>  =09IFF_L3MDEV_RX_HANDLER=09=09=3D 1<<29,
>  =09IFF_LIVE_RENAME_OK=09=09=3D 1<<30,
> +=09IFF_TX_SKB_NO_LINEAR=09=09=3D 1<<31,
>  };
> =20
>  #define IFF_802_1Q_VLAN=09=09=09IFF_802_1Q_VLAN
> @@ -1590,6 +1592,7 @@ enum netdev_priv_flags {
>  #define IFF_FAILOVER_SLAVE=09=09IFF_FAILOVER_SLAVE
>  #define IFF_L3MDEV_RX_HANDLER=09=09IFF_L3MDEV_RX_HANDLER
>  #define IFF_LIVE_RENAME_OK=09=09IFF_LIVE_RENAME_OK
> +#define IFF_TX_SKB_NO_LINEAR=09=09IFF_TX_SKB_NO_LINEAR
> =20
>  /**
>   *=09struct net_device - The DEVICE structure.
> --=20
> 1.8.3.1

Thanks,
Al

