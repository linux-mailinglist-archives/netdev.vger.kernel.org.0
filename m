Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458233EEED3
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 16:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238070AbhHQO5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 10:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237928AbhHQO5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 10:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C22DF6054E;
        Tue, 17 Aug 2021 14:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629212199;
        bh=6D0RZwD4Sd3k+zl4G7BCjMhFKaKE1y/qVRSTUgs0hx0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fMc9gtwLwAo0gNznPkm/h5tHrPefwzOp9tjh3Bcmps66rtbYgvIJ1G/U1DgH/BQbS
         yAuWF0OE6XXUR+PIAWyv5VDcOvLdyWgIA0RfoF7WVqpMKfOAUNl0YZ3VTaGVJexQXm
         WrI62lKq+aMvizCQaAWdS1bVW86wq+YkrSxsYCX28fLmPnllyRzjHtOMUqSSSm2GRB
         37QR4uUf1DPbOq4SIIrcelfUpZBUMfsrPlF3yvGxoq/7qBtSZjL2KNZy957QOG4Gb1
         urjTvONpww0joiFoVrIoVX61sPEsz+e7UI7RV2fRb8Us55SYU/nrSawHvzGe7+Us1b
         Gc4TgVg3KE8fQ==
Date:   Tue, 17 Aug 2021 07:56:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/2] net: Fix offloading indirect devices
 dependency on qdisc order creation
Message-ID: <20210817075639.3cdbfd2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210817143009.GA91458@mtl-vdi-166.wap.labs.mlnx>
References: <20210817132217.100710-1-elic@nvidia.com>
        <20210817132217.100710-3-elic@nvidia.com>
        <20210817070041.1a2dd2b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210817143009.GA91458@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 17:30:09 +0300 Eli Cohen wrote:
> On Tue, Aug 17, 2021 at 07:00:41AM -0700, Jakub Kicinski wrote:
> > On Tue, 17 Aug 2021 16:22:17 +0300 Eli Cohen wrote: =20
> > > Currently, when creating an ingress qdisc on an indirect device before
> > > the driver registered for callbacks, the driver will not have a chance
> > > to register its filter configuration callbacks.
> > >=20
> > > To fix that, modify the code such that it keeps track of all the ingr=
ess
> > > qdiscs that call flow_indr_dev_setup_offload(). When a driver calls
> > > flow_indr_dev_register(),  go through the list of tracked ingress qdi=
scs
> > > and call the driver callback entry point so as to give it a chance to
> > > register its callback.
> > >=20
> > > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > > Signed-off-by: Eli Cohen <elic@nvidia.com> =20
> >=20
> > net/core/flow_offload.c: In function =E2=80=98existing_qdiscs_register=
=E2=80=99:
> > net/core/flow_offload.c:365:20: warning: variable =E2=80=98block=E2=80=
=99 set but not used [-Wunused-but-set-variable]
> >   365 |  struct tcf_block *block;
> >       |                    ^~~~~ =20
>=20
> Thanks Jakub.
> Would you mind telling me how you invoked the compiler to catch this?

make W=3D1
