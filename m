Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC49F46537E
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351666AbhLARHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 12:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbhLARHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 12:07:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20899C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 09:03:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC35AB82049
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 17:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E55C53FAD;
        Wed,  1 Dec 2021 17:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638378216;
        bh=0Qfmh9rQCf8d1/5uWmMF5YNcwNSblT3dOPeADSBceZk=;
        h=In-Reply-To:References:From:Subject:Cc:To:Date:From;
        b=Gj81L5nG+lRfH89AC36Tx6tGiv3c/uc3Db6g0LvZYMw/b3cG81u0RxvtQhqpIyKNN
         Xs+sTyXSGRTCTYrslTuf52xk9E1ajE6x8EuhEa5ak/emxxz0U/XyYfM+4zdgKHhCio
         50r9y060XbmBmsXj3XzF8asBp9QE2EWD+ynyD5JZpOY1DpyiimnIsAkKdK0tkzZ+XU
         QB16PyfGZw/720jdGPfQbK7t7/Rl+VARYFyeUTvH/Xrg/oI8Z9HOEGw8NbmZCSfdly
         IC/MXilu+CcSRd0by6d8A/g/GApUkaA+9nf/N5r2x09v2TYFRr2p/lGJu8wWNrf50z
         71J3P1VIi/uXQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211201070513.6830f1d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211129154520.295823-1-atenart@kernel.org> <20211130180839.285e31be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <163835112179.4366.10853783909376430643@kwain> <20211201070513.6830f1d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net] net-sysfs: update the queue counts in the unregistration path
Cc:     davem@davemloft.net, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
To:     Jakub Kicinski <kuba@kernel.org>
Message-ID: <163837821333.4357.11290896995730684742@kwain>
Date:   Wed, 01 Dec 2021 18:03:33 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jakub Kicinski (2021-12-01 16:05:13)
> On Wed, 01 Dec 2021 10:32:01 +0100 Antoine Tenart wrote:
> > > Would you mind pointing where in the code that happens? I can't seem =

> > > to find anything looking at real_num_.x_queues outside dev.c and
> > > net-sysfs.c :S =20
> >=20
> > The above trace was triggered using veths and this patch would solve
> > this as veths do use real_num_x_queues to fill 'struct ethtool_channels'
> > in its get_channels ops[1] which is then used to avoid making channel
> > counts updates if it is 0[2].
>=20
> But when we are at line 175 in [2] we already updated the values from
> the user space request at lines 144-151. This check validates the new
> config so a transition from 0 -> n should not be prevented here AFAICT.

You're right. It worked in my testbed because I was not providing the
number of Rx channels with Ethtool, so channels.rx_counts wasn't updated
and still had the value veth provided. It "fixed" the issue for a
completely unrelated reason and obviously can't be a fix for the issue
described here. Thanks for having a second look at this, I completely
missed it...

> Any way of fixing this is fine. If you ask me personally I'd probably
> go with the ethtool fix to net and the zeroing and warn to net-next.
> Unless I'm misreading and this fix does work, in which case your plan
> is good, too.

I think you're right. Let's target net with the ethtool patch[1]. This
patch (still needed to keep track of the queue counts) and the warning
one can target net-next.

[1] And probably another one for the old ethtool ioctl interface too.

Thanks!
Antoine
