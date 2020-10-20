Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D7C293603
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405422AbgJTHpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:45:05 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1052 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731722AbgJTHpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 03:45:04 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8e95250000>; Tue, 20 Oct 2020 00:43:33 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 20 Oct
 2020 07:44:56 +0000
Date:   Tue, 20 Oct 2020 10:44:53 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <wenxu@ucloud.cn>, <netdev@vger.kernel.org>, <eli@mellanox.com>
Subject: Re: [PATCH net] vdpa/mlx5: Fix miss to set VIRTIO_NET_S_LINK_UP for
 virtio_net_config
Message-ID: <20201020074453.GA158482@mtl-vdi-166.wap.labs.mlnx>
References: <1603098438-20200-1-git-send-email-wenxu@ucloud.cn>
 <b2ceb319-8447-b804-2965-4e5844b6fa36@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <b2ceb319-8447-b804-2965-4e5844b6fa36@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603179813; bh=yNUjwFb62wE+LaEk+KEHL2pl9MzGFTwmUWepniech8w=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=J0HwAeM/IQwcSO00Hkykvssi7bLU1Lw0lrqI20ZJbJwaA9AkqIfi1yNK1P5CZcikz
         t6PlciCZtaFn4KWGNIjZjA+AfzFg3ki7Fc0+1HFA2HRbwIENWmy9zcWqt+Y/BZtWJM
         35RvwGU1ga5FzHFW1Y8HeyLou1oLZP0dAlSRx9r0r8ugVz43JIfhoQVEidAwlmVwxn
         oPyG0T9hHKnhMJUDk5koRPCRPARjpaQo+WN56bgPw1sDx1eZMynbLAOn+0c4Y5V9h+
         EU8esiBH/DUq10KZVt1Y6olwfzYGqhLJ/KqSDz9lqVkIdgmA+23LkxgJVQRkj5nxHX
         0cbSbXfHNH7tw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 10:03:00AM +0800, Jason Wang wrote:
>=20
> On 2020/10/19 =E4=B8=8B=E5=8D=885:07, wenxu@ucloud.cn wrote:
> > From: wenxu <wenxu@ucloud.cn>
> >=20
> > Qemu get virtio_net_config from the vdpa driver. So The vdpa driver
> > should set the VIRTIO_NET_S_LINK_UP flag to virtio_net_config like
> > vdpa_sim. Or the link of virtio net NIC in the virtual machine will
> > never up.
> >=20
> > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 dev=
ices")
> > Signed-off-by: wenxu <wenxu@ucloud.cn>
> > ---
> >   drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >=20
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/=
mlx5_vnet.c
> > index 74264e59..af6c74c 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1537,6 +1537,8 @@ static int mlx5_vdpa_set_features(struct vdpa_dev=
ice *vdev, u64 features)
> >   	ndev->mvdev.actual_features =3D features & ndev->mvdev.mlx_features;
> >   	ndev->config.mtu =3D __cpu_to_virtio16(mlx5_vdpa_is_little_endian(mv=
dev),
> >   					     ndev->mtu);
> > +	ndev->config.status =3D __cpu_to_virtio16(mlx5_vdpa_is_little_endian(=
mvdev),
> > +					       VIRTIO_NET_S_LINK_UP);
> >   	return err;
> >   }
>=20
>=20
> Other than the small issue pointed out by Jakub.
>=20
> Acked-by: Jason Wang <jasowang@redhat.com>
>=20
>=20

I already posted a fix for this a while ago and Michael should merge it.

https://lkml.org/lkml/2020/9/17/543
