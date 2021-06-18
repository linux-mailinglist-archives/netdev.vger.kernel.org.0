Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FA33AD4BA
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 00:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhFRWEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 18:04:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhFRWEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 18:04:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08A8760FE7;
        Fri, 18 Jun 2021 22:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624053719;
        bh=bnFo0J3Ksau17YpNJhq1Z5oE5SLagjXJlHH86JEm0qw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rZipH2miRGV3Hp7ncBEMkH/+0uPyjs6B4CMBWDapUrT6KC5ZV5t8vHf1QKrjdgto9
         a9WPt3vLDV5YRquR2Td5/xFw3lyYv8Hqr5x2BDe1Lv7qVJnEdxsiZRI8B8+MGyS1IM
         1FH+kfmHKMNTH/WZy+1Yly9xucvOJ1LgMUp+D7Xt0hrBfwAKk48kqqGFP6NKXCjngb
         CJrWWTwiN/BdL2zAb3D6lyLvhOXvY2+T23iRaH6skZfSiRHrlByW17WIuH9IH5ysVN
         QTuyqzGDAlHWYO2b/4/VqU7HG5fXorUeWYZh4Zrhjfg2XDFjsrvdM8gI9VVO1Zewl5
         mQlTdTNEY2A4Q==
Date:   Fri, 18 Jun 2021 15:01:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "shenjian (K)" <shenjian15@huawei.com>
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 8/9] net: hns3: add support for queue bonding
 mode of flow director
Message-ID: <20210618150156.0ffc88a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9107b490-d74c-7ff2-de40-eb77770f0a64@huawei.com>
References: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
        <1615811031-55209-9-git-send-email-tanhuazhong@huawei.com>
        <20210315130448.2582a0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b7b23988-ecba-1ce4-6226-291938c92c08@huawei.com>
        <20210317182828.70fcc61d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9107b490-d74c-7ff2-de40-eb77770f0a64@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Jun 2021 09:18:21 +0800 shenjian (K) wrote:
> Hi=C2=A0 Jakub=EF=BC=8C
>=20
>=20
> =E5=9C=A8 2021/3/18 9:28, Jakub Kicinski =E5=86=99=E9=81=93:
> > On Thu, 18 Mar 2021 09:02:54 +0800 Huazhong Tan wrote: =20
> >> On 2021/3/16 4:04, Jakub Kicinski wrote: =20
> >>> On Mon, 15 Mar 2021 20:23:50 +0800 Huazhong Tan wrote: =20
> >>>> From: Jian Shen <shenjian15@huawei.com>
> >>>>
> >>>> For device version V3, it supports queue bonding, which can
> >>>> identify the tuple information of TCP stream, and create flow
> >>>> director rules automatically, in order to keep the tx and rx
> >>>> packets are in the same queue pair. The driver set FD_ADD
> >>>> field of TX BD for TCP SYN packet, and set FD_DEL filed for
> >>>> TCP FIN or RST packet. The hardware create or remove a fd rule
> >>>> according to the TX BD, and it also support to age-out a rule
> >>>> if not hit for a long time.
> >>>>
> >>>> The queue bonding mode is default to be disabled, and can be
> >>>> enabled/disabled with ethtool priv-flags command. =20
> >>> This seems like fairly well defined behavior, IMHO we should have a f=
ull
> >>> device feature for it, rather than a private flag. =20
> >> Should we add a NETIF_F_NTUPLE_HW feature for it? =20
> > It'd be better to keep the configuration close to the existing RFS
> > config, no? Perhaps a new file under
> >
> >    /sys/class/net/$dev/queues/rx-$id/
> >
> > to enable the feature would be more appropriate?
> >
> > Otherwise I'd call it something like NETIF_F_RFS_AUTO ? =20
> I noticed that the enum NETIF_F_XXX_BIT has already used 64 bits since
>=20
> NETIF_F_HW_HSR_DUP_BIT being added, while the prototype of=20
> netdev_features_t
>=20
> is u64.=C2=A0=C2=A0 So there is no useable bit for new feature if I under=
stand=20
> correct.
>=20
> Is there any solution or plan for it ?

I think you'll need to start a new word.
