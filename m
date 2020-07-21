Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7137E228976
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730990AbgGUTsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730902AbgGUTsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 15:48:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F1982073A;
        Tue, 21 Jul 2020 19:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595360893;
        bh=tQ/wsIMop2wLkSQU89i99v6hKtUDTr6BB6eXJoloDuo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cRCvfC2a+gl7ylgsFvmINyOIzGRYPPVocxOp9e5UQ9qRYKh52LdvF2e0j1MAZ0BWR
         6RjSgIGi64l0OV4YFeKWazTxBnw0NdtUF/013QREFzhnwk+mez5c2xrGgi1rxDy1Fa
         tQt2sWAvfqrfPhPWjokiUJCuFgh4jM3JI9Mr8acE=
Date:   Tue, 21 Jul 2020 12:48:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, <mhabets@solarflare.com>,
        <mslattery@solarflare.com>
Subject: Re: [PATCH net-next] efx: convert to new udp_tunnel infrastructure
Message-ID: <20200721124811.3fb63afe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ecc09a90-1946-fc6a-a5fd-5e0dfe11532d@solarflare.com>
References: <20200717235336.879264-1-kuba@kernel.org>
        <a97d3321-3fee-5217-59e4-e56bfbaff7a3@solarflare.com>
        <20200720102156.717e3e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ecc09a90-1946-fc6a-a5fd-5e0dfe11532d@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 13:05:39 +0100 Edward Cree wrote:
> On 20/07/2020 18:21, Jakub Kicinski wrote:
> > On Mon, 20 Jul 2020 12:45:54 +0100 Edward Cree wrote: =20
> >> I think I'd prefer to keep the switch() that explicitlychecks
> >> =C2=A0for UDP_TUNNEL_TYPE_GENEVE; even though the infrastructure
> >> =C2=A0makes sure it won't ever not be, I'd still feel more comfortable
> >> =C2=A0that way.=C2=A0 But it's up to you. =20
> >=20
> > To me the motivation of expressing capabilities is for the core=20
> > to be able to do the necessary checking (and make more intelligent
> > decisions). All the drivers I've converted make the assumption they
> > won't see tunnel types they don't support. =20
>=20
> Like I say, up to you.  It's not how I'd write it but if that's how
>  you're doing all the drivers then consistency is probably good.

I'll put a WARN() there, as a sign of "this can never happen".

> >> Could we not keep a 'valid'/'used' flag in the table, used in
> >> =C2=A0roughly the same way we were checking count !=3D 0? =20
> >=20
> > How about we do the !port check in efx_ef10_udp_tnl_has_port()?
> >=20
> > Per-entry valid / used flag seems a little wasteful.
> >=20
> > Another option is to have a reserved tunnel type for invalid / unused. =
=20
>=20
> Reserved tunnel type seems best to me.  (sfc generally uses all-ones
>  values for reserved, so this would be 0xffff.)

I'll do

#define TUNNEL_ENCAP_UDP_PORT_ENTRY_INVALID 0xffff

Can I add that in mcdi_pcol.h or better next to struct efx_udp_tunnel?

mcdi_pcol.h looks generated.
