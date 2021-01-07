Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7F72EE692
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbhAGUIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:08:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbhAGUIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:08:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05070233EE;
        Thu,  7 Jan 2021 20:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610050058;
        bh=B5aAeVfs7Q0i/naLZ942cT+Rq/DUuli/PMvj5K9qh+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EWlDJqe9JBxdzPJEQzCRPw9iRt1j2zn87T8ko31Ft888abz3ytBl3WaL8IpCgQ+Au
         LM1GTV3nnOs5ZJt27FgzkNKcU0KBifGFI+GFIwtqs6UeHJME/V/D18IyG4sNBrVzkY
         T55XFhC6WacocIJ9VvCJromIN/BNMoGhsyll62XyfjJMmfwcUKA7WsX2CMMjy8XNsw
         8UosaAM6UTmENO2LzBK+k8MSLldY943IYotLiFQUjceXuvM3ZFEMWzGcioP+92PvrG
         1CL7PAWXV/z0Fu3Avkr8BxXcH7lN08xE2q6ipFKzkpqnscvjxfS3AcC35tlfp2h9Bx
         Qa80CleWP/aHA==
Date:   Thu, 7 Jan 2021 12:07:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Kristian Evensen <kristian.evensen@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] qmi_wwan: Increase headroom for QMAP SKBs
Message-ID: <20210107120737.3b21a5a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87ft3e3zo1.fsf@miraculix.mork.no>
References: <20210106122403.1321180-1-kristian.evensen@gmail.com>
        <87ft3e3zo1.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 06 Jan 2021 15:31:10 +0100 Bj=C3=B8rn Mork wrote:
> Kristian Evensen <kristian.evensen@gmail.com> writes:
>=20
> > When measuring the throughput (iperf3 + TCP) while routing on a
> > not-so-powerful device (Mediatek MT7621, 880MHz CPU), I noticed that I
> > achieved significantly lower speeds with QMI-based modems than for
> > example a USB LAN dongle. The CPU was saturated in all of my tests.
> >
> > With the dongle I got ~300 Mbit/s, while I only measured ~200 Mbit/s
> > with the modems. All offloads, etc.  were switched off for the dongle,
> > and I configured the modems to use QMAP (16k aggregation). The tests
> > with the dongle were performed in my local (gigabit) network, while the
> > LTE network the modems were connected to delivers 700-800 Mbit/s.
> >
> > Profiling the kernel revealed the cause of the performance difference.
> > In qmimux_rx_fixup(), an SKB is allocated for each packet contained in
> > the URB. This SKB has too little headroom, causing the check in
> > skb_cow() (called from ip_forward()) to fail. pskb_expand_head() is then
> > called and the SKB is reallocated. In the output from perf, I see that a
> > significant amount of time is spent in pskb_expand_head() + support
> > functions.
> >
> > In order to ensure that the SKB has enough headroom, this commit
> > increases the amount of memory allocated in qmimux_rx_fixup() by
> > LL_MAX_HEADER. The reason for using LL_MAX_HEADER and not a more
> > accurate value, is that we do not know the type of the outgoing network
> > interface. After making this change, I achieve the same throughput with
> > the modems as with the dongle.
> >
> > Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com> =20
>=20
> Nice work!
>=20
> Just wondering: Will the same problem affect the usbnet allocated skbs
> as well in case of raw-ip? They will obviously be large enough, but the
> reserved headroom probably isn't when we put an IP packet there without
> any L2 header?
>=20
> In any case:
>=20
> Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>

Applied, thanks!
