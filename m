Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD9E4730B9
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238932AbhLMPnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236536AbhLMPnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:43:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EA4C061574;
        Mon, 13 Dec 2021 07:43:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4E6BB81171;
        Mon, 13 Dec 2021 15:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35497C34603;
        Mon, 13 Dec 2021 15:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639410228;
        bh=Jyem4IeeXOlhrKvT5N2teQC7ZSrwA6+8aYLVrZpsUXw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WE7sxn1dxV/XRVrb+OwCqKRbuak+ydOpFIFdysBd6qrGAWRjgd5niEOfX48dy+Q03
         PGZ9ALW1NRUlsrxiDdJzKjPrRQbimzSJZ//WkahiXbtKfcWAH6WHUrHNG83bulUBOc
         qiC61EqgOjOzoR4Tx69irFye7ED2cCG2Dxm8RmmRYJddktuHRkawx94jKvQ+W6wpre
         eD0s/UZXpTKQaQ0jA0N/8x+xvZ1tNLwF2ZGmlEZJcASEObRhs2G4SKG+LYzMJMYMVh
         J/W8gYPcdeV5XJGJ3KG2T8RnLg8NvgFeQWpF/pg/1VmjDlMDqPI0MBRc2yGPrKCYON
         9JV9S6tVj8eMQ==
Date:   Mon, 13 Dec 2021 07:43:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksander Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: lantiq_xrx200: increase buffer reservation
Message-ID: <20211213074347.2e5ae33b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c4d93a2e-b4de-9b19-ff44-a122dbbb22b8@wp.pl>
References: <20211206223909.749043-1-olek2@wp.pl>
        <20211207205448.3b297e7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c4d93a2e-b4de-9b19-ff44-a122dbbb22b8@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Dec 2021 00:05:16 +0100 Aleksander Bajkowski wrote:
> On 12/8/21 5:54 AM, Jakub Kicinski wrote:
> > On Mon,  6 Dec 2021 23:39:09 +0100 Aleksander Jan Bajkowski wrote: =20
> >> +static int xrx200_max_frame_len(int mtu)
> >> +{
> >> +	return VLAN_ETH_HLEN + mtu + ETH_FCS_LEN; =20
> >=20
> > You sure the problem is not that this doesn't include ETH_HLEN?=20
> > MTU is the length of the L2 _payload_.
>=20
> VLAN_ETH_HLEN (14 + 4) contains ETH_HLEN (14). This function returns
> the length of the frame that is written to the RX descriptor. Maybe
> I don't understand the question and you are asking something else?=20

Ah, right, misread that as VLAN_HLEN.

> >> +}
> >> +
> >> +static int xrx200_buffer_size(int mtu)
> >> +{
> >> +	return round_up(xrx200_max_frame_len(mtu) - 1, 4 * XRX200_DMA_BURST_=
LEN); =20
> >=20
> > Why the - 1 ? =F0=9F=A4=94
> >  =20
>=20
> This is how the hardware behaves. I don't really know where the -1
> comes from. Unfortunately, I do not have access to TRM.=20
>
> > For a frame size 101 =3D> max_frame_len 109 you'll presumably want=20
> > the buffer to be 116, not 108?
>=20
> For a frame size 101 =3D> max_frame_len is 123 (18 + 101 + 4).

You get my point, tho right?

> Infact, PMAC strips FCS and ETH_FCS_LEN may not be needed. This behavior
> is controlled by the PMAC_HD_CTL_RC bit. This bit is enabled from
> the beginning of this driver. Ethtool has the option to enable
> FCS reception, but the ethtool interface is not yet supported
> by this driver.=20
>=20
> >> +}
> >> + =20
>=20
> Experiments show that the hardware starts to split the frame at
> max_frame_len() - 1. Some examples:
>=20
> pkt len	MTU	max_frame_size()	buffer_size()	desc1	desc2	desc3	desc4
> -------------------------------------------------------------------------=
---------------------
> 1506		1483		1505		1504		1502	4	X	X
> 1505		1483		1505		1504		1502	3	X	X
> 1504		1483		1505		1504		1504	X	X	X
> 1503		1483		1505		1504		1503	X	X	X
> 1502		1483		1505		1504		1502	X	X	X
> 1501		1483		1505		1504		1501	X	X	X
> -------------------------------------------------------------------------=
---------------------
> 1249		380		402		416		414	416	416	3
> 1248		380		402		416		414	416	416	2
> 1247		380		402		416		414	416	416	1
> 1246		380		402		416		414	416	416	X
> 1245		380		402		416		414	416	415	X
> -------------------------------------------------------------------------=
---------------------

Hm, doesn't the former example prove that the calculation in this
patch is incorrect? Shouldn't we be able to receive a 1505B frame=20
into a single buffer for the MTU of 1483?

The HW doesn't split at max_frame_len - 1 in the latter example.
Maybe to save one bit of state the HW doesn't register the lowest=20
bit of the buffer length? I thinks the buffer is 1504.

I'd lean towards dropping the -1 and letting the DMA alignment
calculation round the whole length up.

Also should we not take NET_IP_ALIGN into account?

Judging by the length of the first buffer when split happens
NET_IP_ALIGN is 2, and HW rounds off (2 + pkt-len) to the DMA
burst size. This makes me think we overrun the end of the buffer
by NET_IP_ALIGN.

> In fact, this patch is a preparation for SG DMA support, which
> I wrote some time ago.
