Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93774A4984
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 15:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239163AbiAaOmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 09:42:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39202 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236916AbiAaOmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 09:42:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D69AB82B57
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 14:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1306C340E8;
        Mon, 31 Jan 2022 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643640128;
        bh=NhGktzfN0r0xurR7x2ZVthm1YtYnY6JKbczj1R0xz0I=;
        h=In-Reply-To:References:From:To:Cc:Subject:Date:From;
        b=jsfqopQIi9AZ0CyP6ABd87ShbHnIi8mWytQPVKFzOsv+kJ6dEEUavXrQdKLDbF7cv
         YDUgy0CWW2OkHxurg8WaiuKkVr6OHzaS/2QXVsGXIjipQnXsE9QtsbHlPKCPNshh7/
         /sBZsbPKmDo7yoyLXJn5H+6Jgeour+rnxLMmYNzixBhl/D1huMgP9lPD1SUFm+oGKc
         /9hdjJUpL287cB848l8iT1ADa74sCq3vPUcGocXfZ1hSGBUuMpf0v1lUc9MMXAUmxO
         cOZNRZ1oNZrQFKRd50nbgTMEDajq6TKzFOWwzYVqxUuN/EWGQZy9UY8gr/zy5TRi2F
         K2VKU0iW7w1nw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220131150418.0fabd263@elisabeth>
References: <20210325153533.770125-1-atenart@kernel.org> <20210325153533.770125-2-atenart@kernel.org> <ygnhh79yluw2.fsf@nvidia.com> <164267447125.4497.8151505359440130213@kwain> <ygnhee52lg2d.fsf@nvidia.com> <164338929382.4461.13062562289533632448@kwain> <ygnhsft4p2mg.fsf@nvidia.com> <164363560725.4133.7633393991691247425@kwain> <20220131150418.0fabd263@elisabeth>
From:   Antoine Tenart <atenart@kernel.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, echaudro@redhat.com, netdev@vger.kernel.org,
        pshelar@ovn.org
Subject: Re: [PATCH net 1/2] vxlan: do not modify the shared tunnel info when PMTU triggers an ICMP reply
Message-ID: <164364012498.4133.407913680953084949@kwain>
Date:   Mon, 31 Jan 2022 15:42:04 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefano,

Quoting Stefano Brivio (2022-01-31 15:04:18)
> On Mon, 31 Jan 2022 14:26:47 +0100
> Antoine Tenart <atenart@kernel.org> wrote:
> > Quoting Vlad Buslov (2022-01-31 12:26:47)
> > > On Fri 28 Jan 2022 at 19:01, Antoine Tenart <atenart@kernel.org> wrot=
e: =20
> > > >
> > > > I finally had some time to look at this. Does the diff below fix yo=
ur
> > > > issue? =20
> > >=20
> > > Yes, with the patch applied I'm no longer able to reproduce memory le=
ak.
> > > Thanks for fixing this! =20
> >=20
> > Thanks for testing. I'll send a formal patch, can I add your Tested-by?
> >=20
> > Also, do you know how to trigger the following code path in OVS
> > https://elixir.bootlin.com/linux/latest/source/net/openvswitch/actions.=
c#L944
>=20
> I guess the selftests pmtu_ipv{4,6}_ovs_vxlan{4,6}_exception and
> pmtu_ipv{4,6}_ovs_geneve{4,6}_exception from net/pmtu.sh:
>=20
>         https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/tree/tools/testing/selftests/net/pmtu.sh?id=3Dece1278a9b81bdfc088f087f837=
2a072b7010956#n81
>=20
> should trigger that path once or twice per test, but I haven't tried
> recently.

Thanks for the suggestion! I did run all 8 ptmu_*_ovs_* tests, they all
passed but didn't trigger a call to dev_fill_metadata_dst in
net/openvswitch/actions.c.

To be sure there wasn't a misunderstanding: I did test the PTMU code
path in Geneve/VXLAN (while one of the endpoint is an OVS port); but the
net/openvswitch/actions.c code path is something different, used to
retrieve tunnel egress info. I don't know when/how this is used by OVS.

Thanks,
Antoine
