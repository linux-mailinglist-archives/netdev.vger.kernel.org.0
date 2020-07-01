Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89878211681
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 01:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgGAXQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 19:16:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgGAXQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 19:16:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62B382082F;
        Wed,  1 Jul 2020 23:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593645398;
        bh=JHloRAytcsh0+vmDsmqjNAqUPRhU0c4TRnMNyOIlDHg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PGJFQXSSVG4lVs5qOtPUeP1qbO9O5W8DU8MEP36W4YJc500VGhXieKiuaC0K4zHTC
         sNm1BaTjo9X1Y51LomMyIHXT0c+/67gYScAfrNtbS+kIKlwF7innYd3aGsvKgqgwC5
         lBVkMRQNjQ2HgpD9OfO8CyVPXjbvTz1nb3WBspcc=
Date:   Wed, 1 Jul 2020 16:16:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 01/15] sfc: support setting MTU even if not
 privileged to configure MAC fully
Message-ID: <20200701161636.3399d902@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3b76efb6-4b02-a26d-5284-65ab37b79ef5@solarflare.com>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
        <db235d46-96b0-ee6d-f09b-774e6fd9a072@solarflare.com>
        <20200701120311.4821118c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3b76efb6-4b02-a26d-5284-65ab37b79ef5@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jul 2020 23:13:13 +0100 Edward Cree wrote:
> On 01/07/2020 20:03, Jakub Kicinski wrote:
> > On Wed, 1 Jul 2020 15:51:25 +0100 Edward Cree wrote: =20
> >> Unprivileged functions (such as VFs) may set their MTU by use of the
> >>  'control' field of MC_CMD_SET_MAC_EXT, as used in efx_mcdi_set_mtu().
> >> If calling efx_ef10_mac_reconfigure() from efx_change_mtu(), the NIC
> >>  supports the above (SET_MAC_ENHANCED capability), and regular
> >>  efx_mcdi_set_mac() fails EPERM, then fall back to efx_mcdi_set_mtu().=
 =20
> > Is there no way of checking the permission the function has before
> > issuing the firmware call? =20
> We could condition on the LINKCTRL flag from the MC_CMD_DRV_ATTACH
> =C2=A0response we get at start of day; but usually in this driver we've
> =C2=A0tried to follow the EAFP principle rather than embedding knowledge
> =C2=A0of the firmware's permissions model into the driver.

I see. I'm actually asking because of efx_ef10_set_udp_tnl_ports().
I'd like to rewrite the UDP tunnel code so that=20
NETIF_F_RX_UDP_TUNNEL_PORT only appears on the interface if it=20
_really_ can do the offload. ef10 is the only driver I've seen where=20
I can't be sure what FW will say.. (other than liquidio, but that's=20
more of a kernel<->FW proxy than a driver, sigh).

Is there anything I can condition on there?

> I suppose it might make sense to go straight to efx_mcdi_set_mtu()
> =C2=A0in the mtu_only && SET_MAC_ENHANCED case, use efx_mcdi_set_mac()
> =C2=A0otherwise, and thus never have a fallback from one to the other.
> WDYT?

For the change of MTU that indeed seems much cleaner.
