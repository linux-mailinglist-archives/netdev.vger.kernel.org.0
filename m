Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E2021745E
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 18:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgGGQqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 12:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727886AbgGGQqq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 12:46:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A051B20708;
        Tue,  7 Jul 2020 16:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594140405;
        bh=1ZKfornCGJKVDDAQy5ouz/ciACkmZUgK0i3io+zbv90=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F1rom+hrHwyUW1WeOQARW0jWAUtR3JrBRzUwZTknIs5FAHSEJ709cmBvjfy8W7Qf/
         /jSzqmxAbdFkCkTAOnKXRDYkkHZF8rBtq9Zbg2TihSyF4PQFSqBXkPVtN9x2m/Ccb1
         d1eaYg7Gi/azbhwMnPHeMjyibuh34EXNYNfZBVKU=
Date:   Tue, 7 Jul 2020 09:46:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net] ionic: centralize queue reset code
Message-ID: <20200707094643.66f18862@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fcb67ff8-2ef8-e5de-1609-2abb4a59a2d2@pensando.io>
References: <20200702233917.35166-1-snelson@pensando.io>
        <20200706103305.182bd727@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fcb67ff8-2ef8-e5de-1609-2abb4a59a2d2@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jul 2020 09:10:38 -0700 Shannon Nelson wrote:
> On 7/6/20 10:33 AM, Jakub Kicinski wrote:
> > On Thu,  2 Jul 2020 16:39:17 -0700 Shannon Nelson wrote: =20
> >> The queue reset pattern is used in a couple different places,
> >> only slightly different from each other, and could cause
> >> issues if one gets changed and the other didn't.  This puts
> >> them together so that only one version is needed, yet each
> >> can have slighty different effects by passing in a pointer
> >> to a work function to do whatever configuration twiddling is
> >> needed in the middle of the reset.
> >>
> >> Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
> >> Signed-off-by: Shannon Nelson <snelson@pensando.io> =20
> > Is this fixing anything? =20
>=20
> Yes, this fixes issues seen similar to what was fixed with b59eabd23ee5=20
> ("ionic: tame the watchdog timer on reconfig") where under loops of=20
> changing parameters we could occasionally bump into the netdev watchdog.

User-visible bug should always be part of the commit message for a fix,
please amend.

> > I think the pattern of having a separate structure describing all the
> > parameters and passing that into reconfig is a better path forward,
> > because it's easier to take that forward in the correct direction of
> > allocating new resources before old ones are freed. IOW not doing a
> > full close/open.
> >
> > E.g. nfp_net_set_ring_size(). =20
>=20
> This has been suggested before and looks great when you know you've got=20
> the resources for dual allocations.=C2=A0 In our case this code is also u=
sed=20
> inside our device where memory is tight: we are much more likely to have=
=20
> allocation issues if we try to allocate everything without first=20
> releasing what we already have.

Are you saying that inside the device the memory allocated for the
rings is close to the amount of max free memory? I find that hard to
believe.

> I agree there is room for evolution, and we have patches coming that=20
> change some of how we allocate our memory, but we're not quite ready to=20
> rewrite what we have, or to split the two driver cases yet.
