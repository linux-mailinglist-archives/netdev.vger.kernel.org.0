Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5851D248E5A
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 20:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgHRS7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 14:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgHRS67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 14:58:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4441206B5;
        Tue, 18 Aug 2020 18:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597777139;
        bh=cdDqlxbTJLRPaomvljkcqdnEyM+0X43LsblU5qVipzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=10yqYHudnQXTl/lRXJhIjD/BGLLpAMZDFa2i3JRLFC8LkAMU/Hkq2cHzaSttmK4yn
         RXl7puyBg1YHewkND/h2l/hiI+c5MlEPstucK6Cw3T/21tleWqODsTJ2+xAMRvvbHz
         uKGPav1hrG05rA4NMcpit5Fz1Wf2BXa0gvQ5d5fU=
Date:   Tue, 18 Aug 2020 11:58:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Ooi, Joyce" <joyce.ooi@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>
Subject: Re: [PATCH v6 09/10] net: eth: altera: add msgdma prefetcher
Message-ID: <20200818115857.78d6b2ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200818154613.148921-10-joyce.ooi@intel.com>
References: <20200818154613.148921-1-joyce.ooi@intel.com>
        <20200818154613.148921-10-joyce.ooi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 23:46:12 +0800 Ooi, Joyce wrote:
> From: Dalon Westergreen <dalon.westergreen@intel.com>
>=20
> Add support for the mSGDMA prefetcher.  The prefetcher adds support
> for a linked list of descriptors in system memory.  The prefetcher
> feeds these to the mSGDMA dispatcher.

This generates warnings on 32bit builds:

../drivers/net/ethernet/altera/altera_msgdma_prefetcher.c: In function =E2=
=80=98msgdma_pref_initialize=E2=80=99:
../drivers/net/ethernet/altera/altera_msgdma_prefetcher.c:97:51: warning: f=
ormat =E2=80=98%llx=E2=80=99 expects argument of type =E2=80=98long long un=
signed int=E2=80=99, but argument 4 has type =E2=80=98dma_addr_t=E2=80=99 {=
aka =E2=80=98unsigned int=E2=80=99} [-Wformat=3D]
   97 |   netdev_info(priv->dev, "%s: RX Desc mem at 0x%llx\n", __func__,
      |                                                ~~~^
      |                                                   |
      |                                                   long long unsigne=
d int
      |                                                %x
   98 |        priv->pref_rxdescphys);
      |        ~~~~~~~~~~~~~~~~~~~~~                      =20
      |            |
      |            dma_addr_t {aka unsigned int}
../drivers/net/ethernet/altera/altera_msgdma_prefetcher.c:101:51: warning: =
format =E2=80=98%llx=E2=80=99 expects argument of type =E2=80=98long long u=
nsigned int=E2=80=99, but argument 4 has type =E2=80=98dma_addr_t=E2=80=99 =
{aka =E2=80=98unsigned int=E2=80=99} [-Wformat=3D]
  101 |   netdev_info(priv->dev, "%s: TX Desc mem at 0x%llx\n", __func__,
      |                                                ~~~^
      |                                                   |
      |                                                   long long unsigne=
d int
      |                                                %x
  102 |        priv->pref_txdescphys);
      |        ~~~~~~~~~~~~~~~~~~~~~                      =20
      |            |
      |            dma_addr_t {aka unsigned int}
