Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643F84639F3
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244478AbhK3P1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244047AbhK3P0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:26:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC7DC06179E;
        Tue, 30 Nov 2021 07:23:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 972A9B81A23;
        Tue, 30 Nov 2021 15:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059FCC53FC7;
        Tue, 30 Nov 2021 15:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638285789;
        bh=gXUuBFRqNCXwz3I7MJ/4FtgJh53slHzb7MVDANjM4xI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=be7nmfj58JdCtMpcg1x0SzWTzmFB7cl2NaXzZI8+tnYTon0fmvLUgpPgiz6TsRzJs
         7N6x2YVKvqJ58iOJMYCAd2mr4N95RVTGkMCpFbUgmOoPrrPRW8iE6mLiQIBwUdRA9b
         5R8TDpkjbIkPKHbXYPdYGy4i0wzBktP7N3oeINbzO6D6HPt+nTQURVjRf6zCWf7spf
         rlirkK9tDqOw+Nx0qQ23hnEIpN45sm5BhxaPaAf1Sc3qmfn0bSTDDp/gEzW8Ek9CJk
         k67mHPNyUJ84yvGhRYLGYeyUwQlJqbsfs+uIZ37IhTFqbCcMJyGms9bqQdnCSO9UEY
         CXj1F4MnnQIgg==
Date:   Tue, 30 Nov 2021 07:23:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Eric Dumazet <edumazet@google.com>,
        Menglong Dong <imagedong@tencent.com>,
        Yuchung Cheng <ycheng@google.com>, kuniyu@amazon.co.jp,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] net: snmp: add statistics for tcp small
 queue check
Message-ID: <20211130072308.76cc711c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADxym3YJwgs1-hYZURUf+K56zTtQmWHbwAvEG27s_w8FwQrkQQ@mail.gmail.com>
References: <20211128060102.6504-1-imagedong@tencent.com>
        <20211129075707.47ab0ffe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADxym3YJwgs1-hYZURUf+K56zTtQmWHbwAvEG27s_w8FwQrkQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 22:36:59 +0800 Menglong Dong wrote:
> On Mon, Nov 29, 2021 at 11:57 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Sun, 28 Nov 2021 14:01:02 +0800 menglong8.dong@gmail.com wrote: =20
> > > Once tcp small queue check failed in tcp_small_queue_check(), the
> > > throughput of tcp will be limited, and it's hard to distinguish
> > > whether it is out of tcp congestion control.
> > >
> > > Add statistics of LINUX_MIB_TCPSMALLQUEUEFAILURE for this scene. =20
> >
> > Isn't this going to trigger all the time and alarm users because of the
> > "Failure" in the TCPSmallQueueFailure name?  Isn't it perfectly fine
> > for TCP to bake full TSQ amount of data and have it paced out onto the
> > wire? What's your link speed? =20
>=20
> Well, it's a little complex. In my case, there is a guest in kvm, and vir=
tio_net
> is used with napi_tx enabled.
>=20
> With napi_tx enabled, skb won't be orphaned after it is passed to virtio_=
net,
> until it is released. The point is that the sending interrupt of
> virtio_net will be
> turned off and the skb can't be released until the next net_rx interrupt =
comes.
> So, wmem_alloc can't decrease on time, and the bandwidth is limited. When
> this happens, the bandwidth can decrease from 500M to 10M.
>=20
> In fact, this issue of uapi_tx is fixed in this commit:
> https://lore.kernel.org/lkml/20210719144949.935298466@linuxfoundation.org/
>=20
> I added this statistics to monitor the sending failure (may be called
> sending delay)
> caused by qdisc and net_device. When something happen, maybe users can
> raise =E2=80=98/proc/sys/net/ipv4/tcp_pacing_ss_ratio=E2=80=99 to get bet=
ter bandwidth.

Sounds very second-order and particular to a buggy driver :/
Let's see what Eric says but I vote revert.
