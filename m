Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5D5463C63
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244500AbhK3RDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhK3RDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:03:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F6FC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 08:59:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A9EFBCE1A80
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 16:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51715C53FC7;
        Tue, 30 Nov 2021 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638291577;
        bh=dRUUd9PrdQq9Y9CVA37l7KFOaYhvZ7gRA9x58SEESFA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dpBYKgHWjXlDO6uf4mFWncrVlL8wirXhRM/D/6LrdzGb8LtIERpzsN8dxOg6lyB8n
         uprJ7l6op7wJMwDHMTVevUNZn6Trsn/tgsdoriuPUCYoq0el8Pq3D5v5mM60vSpb1v
         yRVnL/M1qm3rJq055xiQmmBq087q2SKPWcO+Cso0Prehhaz5mAv2ADK07PgDgnCDUS
         ezQAuSxXrrx0z4pT/W7IesGAe2EZ9gkugdTUu9gF1F9D60l2pSYduyW3OfxcJtbyVn
         BjOPE+jyeixEqgXddkUfQBFzfVQU3pfTg4F8x0sBfbO99NBPamZJDgBVJ8CYQxBuYV
         InhKTO4sO5f0g==
Date:   Tue, 30 Nov 2021 08:59:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        davem@davemloft.net, andrew@lunn.ch, pali@kernel.org,
        jacob.e.keller@intel.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to flash and
 query transceiver modules' firmware
Message-ID: <20211130085936.669eb48c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YaXzCKEwuICECkyz@shredder>
References: <20211127174530.3600237-1-idosch@idosch.org>
        <20211129093724.3b76ebff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YaXicrPwrHJoTi9w@shredder>
        <20211130085426.txa5xrrd3nipxgtz@lion.mk-sys.cz>
        <YaXzCKEwuICECkyz@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 11:46:48 +0200 Ido Schimmel wrote:
> > As I already mentioned, we should distinguish between ethtool API and
> > ethtool utility. It is possible to implement the flashing in devlink API
> > and let both devlink and ethtool utilities use that API.
> >=20
> > I'm not saying ethtool API is a wrong choice, IMHO either option has its
> > pros and cons. =20
>=20
> What are the cons of implementing it in ethtool? It seems that the only
> thing devlink has going for it is the fact that it supports devlink
> device firmware update API, but it cannot be used as-is and needs to be
> heavily extended (e.g., asynchronicity is a must, per-port as opposed to
> per-device). It doesn't support any transceiver module API, as opposed
> to ethtool.

The primary advantage is that we could hopefully share some of the
infrastructure around versioning, A/B image selection, activation and
error reporting. All those are universal firmware update problems.

> > I'm just trying to point out that implementation in devlink API does
> > not necessarily mean one cannot use the ethtool to use the feature. =20
>=20
> I agree it can be done, but the fact that something can be done doesn't
> mean it should be done. If I'm extending devlink with new uAPI, then I
> will add support for it in devlink(8) and not ethtool(8) and vice versa.

I'm not dead set on SFP flashing being in devlink, I just think it's
the right choice, but at the end of the day - your call.

=46rom my experience working with and on FW management in production
(using devlink) I don't think that the "rest of the SFP API is in
ethtool" motivation matters in practice. At least not in my
environment. Upgrading firmware is a process that's more concerned with
different device components than the functionality those devices
actually provide. For a person writing FW update automation its better
if they have one type of API to talk to. IOW nobody cares if e.g. the FW
upgrade on a soundcard is via the sound API.

When automation gets more complex (again versioning, checking if there
is degradation and FW has to be re-applied, checking if upgrades can be
live, or device has to be reset, power cycled, etc) plugging into a
consistent API is what matters most.
