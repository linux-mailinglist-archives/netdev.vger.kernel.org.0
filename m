Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F062B53B6
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 22:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgKPVUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 16:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgKPVUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 16:20:53 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2433722240;
        Mon, 16 Nov 2020 21:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605561652;
        bh=rF3Hz1kpU0y5lwFVLCP2bES+xAXqxFS1AJzEq/S/sM4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L73HFGlMibLeyBrdJtwu4Stx1UiKgRjSqBXoM1hGSsN8VsXx4LSzwPZz6xMdOH4zN
         LZ0uSQhvGkQOvFZz3i/OI4Nm38zEjuUZu59h8Cg8AOH1deFWtE04UfhgAQ0hzu8av7
         ttJTAqEjx3p6tJyLQtmuj8kJANRb04VB6MDGkAPk=
Date:   Mon, 16 Nov 2020 13:20:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mahesh Bandewar (=?UTF-8?B?4KSu4KS54KWH4KS2IOCkrOCkguCkoeClh+CktQ==?=
        =?UTF-8?B?4KS+4KSw?=)" <maheshb@google.com>
Cc:     Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be
 controlled
Message-ID: <20201116132051.4eef4247@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAF2d9jjs9WF9JXzBGxrHEgAiFhS1qyDya+5WRZBHoxosAu5F4A@mail.gmail.com>
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
        <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
        <20201116121711.1e7bb04c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAF2d9jjs9WF9JXzBGxrHEgAiFhS1qyDya+5WRZBHoxosAu5F4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 12:50:22 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=
=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=
=A4=B0) wrote:
> On Mon, Nov 16, 2020 at 12:17 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 16 Nov 2020 12:02:48 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=
=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=
=E0=A4=B0) wrote: =20
> > > On Sat, Nov 14, 2020 at 10:17 AM Jakub Kicinski <kuba@kernel.org> wro=
te: =20
> > > > On Wed, 11 Nov 2020 12:43:08 -0800 Jian Yang wrote: =20
> > > > > From: Mahesh Bandewar <maheshb@google.com>
> > > > >
> > > > > Traditionally loopback devices comes up with initial state as DOW=
N for
> > > > > any new network-namespace. This would mean that anyone needing th=
is
> > > > > device (which is mostly true except sandboxes where networking in=
 not
> > > > > needed at all), would have to bring this UP by issuing something =
like
> > > > > 'ip link set lo up' which can be avoided if the initial state can=
 be set
> > > > > as UP. Also ICMP error propagation needs loopback to be UP.
> > > > >
> > > > > The default value for this sysctl is set to ZERO which will prese=
rve the
> > > > > backward compatible behavior for the root-netns while changing the
> > > > > sysctl will only alter the behavior of the newer network namespac=
es. =20
> > > =20
> > > > Any reason why the new sysctl itself is not per netns?
> > > > =20
> > > Making it per netns would not be very useful since its effect is only
> > > during netns creation. =20
> >
> > I must be confused. Are all namespaces spawned off init_net, not the
> > current netns the process is in? =20
> The namespace hierarchy is maintained in user-ns while we have per-ns
> sysctls hanging off of a netns object and we don't have parent (netns)
> reference when initializing newly created netns values. One can copy
> the current value of the settings from root-ns but I don't think
> that's a good practice since there is no clear way to affect those
> values when the root-ns changes them. Also from the isolation
> perspective (I think) it's better to have this behavior (sysctl
> values) stand on it's own i.e. have default values and then alter
> values on it's own without linking to any other netns values.

To be clear, what I meant was just to make the sysctl per namespace.
That way you can deploy a workload with this sysctl set appropriately
without changing the system-global setting.

Is your expectation that particular application stacks would take
advantage of this, or that people would set this to 1 across the
fleet?
