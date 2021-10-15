Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A8E42FE30
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhJOWdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235622AbhJOWdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:33:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71BA1611C3;
        Fri, 15 Oct 2021 22:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634337055;
        bh=fUrFqPRnlAT5YXQndyHh2D+XafDA6mw8WfAjlL8tzn0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SEBzdisNkvtUQ4vmlit744P1D8/R2uHULn0gGWdxXejWQvjmTC+nbw9F0Q7VmPIjP
         0AHTArU4eUSboC2BF7Nsxs7uZ95XxDc2J1/aSe5pYfAxy0ox8SzANtLHEBPXe24g0v
         6NjGdOU4xfmIwKV0TG+13c5DLU48BTVsxdYufn453vGzQJe1xIs2W7fe3PqV3d6Eei
         WaGo+huYGgIFDsCCu8fXkkv9+6773Hab1d6V+FwQuLGJdwA2Pro5UXJsaF48q6rBX3
         RdoGOP9Oqy5Y3Hls+uJRsm3hDEHn/y68rL4G5iSYskpZRBczBJZDnl0t7GgKPIALmn
         hIVSAKiqSO9Kw==
Date:   Fri, 15 Oct 2021 15:30:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com, jiri@nvidia.com,
        idosch@nvidia.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        bjarni.jonasson@microchip.com,
        linux-arm-kernel@lists.infradead.org, qiangqing.zhang@nxp.com,
        vkochan@marvell.com, tchornyi@marvell.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com
Subject: Re: [RFC net-next 1/6] ethernet: add a helper for assigning port
 addresses
Message-ID: <20211015153053.781b6e57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <47ac074a-bf85-a514-00a5-3749e3582099@pensando.io>
References: <20211015193848.779420-1-kuba@kernel.org>
        <20211015193848.779420-2-kuba@kernel.org>
        <47ac074a-bf85-a514-00a5-3749e3582099@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Oct 2021 14:36:00 -0700 Shannon Nelson wrote:
> On 10/15/21 12:38 PM, Jakub Kicinski wrote:
> > We have 5 drivers which offset base MAC addr by port id.
> > Create a helper for them.
> >
> > This helper takes care of overflows, which some drivers
> > did not do, please complain if that's going to break
> > anything!

> > +/**
> > + * eth_hw_addr_set_port - Generate and assign Ethernet address to a po=
rt
> > + * @dev: pointer to port's net_device structure
> > + * @base_addr: base Ethernet address
> > + * @id: offset to add to the base address
> > + *
> > + * Assign a MAC address to the net_device using a base address and an =
offset.
> > + * Commonly used by switch drivers which need to compute addresses for=
 all
> > + * their ports. addr_assign_type is not changed.
> > + */
> > +static inline void eth_hw_addr_set_port(struct net_device *dev,
> > +					const u8 *base_addr, u8 id) =20
>=20
> To me, the words "_set_port" imply that you're going to force "id" into=20
> the byte, overwriting what is already there.=C2=A0 Since this instead is=
=20
> adding "id" to the byte, perhaps a better name would include the word=20
> "offset", maybe like eth_hw_addr_set_port_offset(), to better imply the=20
> actual operation.
>=20
> Personally, I think my name suggestion is too long, but it gets my=20
> thought across.

I started with eth_hw_addr_set_offset() my thought process was:

  .._set_offset() sounds like it's setting the offset

  dev_addr_mod() uses offset to modify just part of the address
  so we have two similar functions using 'offset' with different=20
  meaning

  how about we name it after the most common use? -> .._port()

Thinking again maybe eth_hw_addr_gen()? We "generate" a port address
based on base address and port ID.

I can change if others agree that .._set_offset() is better.
