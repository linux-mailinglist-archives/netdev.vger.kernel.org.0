Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E214466930
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 18:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376368AbhLBRfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 12:35:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47832 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348206AbhLBRez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 12:34:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DF5AB82432;
        Thu,  2 Dec 2021 17:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6D2C00446;
        Thu,  2 Dec 2021 17:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638466290;
        bh=7xB90TXGyh5EQA3nDM6kWzzzzotwyl5E0HyqroM9cd0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bi0tDYY750slcnijfUVFtuXxPULDd+nU0KUkFvhJjTkqQJTPDMCh6gG8nrbpWWUd1
         clshyI4l+21frZNea1l1R+FNCwGStDn3g/fsfJ0xS05B3zR7sGkv6N2kHD1oZmtOwH
         zIqrWfnQTqZHVIRKtBI/u6EKpGaeXUoCtV5KJIUXoGg0R+PHbJaIVmgZlZPev+V7Sm
         ADlbvM+KD3pEyxn5IQ9QFrY+NYSMw83UrAT6OaarDnZE7Z0DgXHyKH9xa8oxSsg3nx
         y1W2rKYHrUpH1lMNNqvh8woJ1RKTkCxqquCdtC/V2O+pZ6T6G+eDpi7CaZyuC7q4fa
         sFdwSLWHzTwuA==
Date:   Thu, 2 Dec 2021 09:31:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Drory <shayd@nvidia.com>
Cc:     "David S . Miller" <davem@davemloft.net>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] net/mlx5: Memory optimizations
Message-ID: <20211202093129.2713b64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <879d6d7c-f789-69bc-9f2d-bf77d558586a@nvidia.com>
References: <20211130150705.19863-1-shayd@nvidia.com>
 <20211130113910.25a9e3ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <879d6d7c-f789-69bc-9f2d-bf77d558586a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Dec 2021 10:22:17 +0200 Shay Drory wrote:
> On 11/30/2021 21:39, Jakub Kicinski wrote:
> > On Tue, 30 Nov 2021 17:07:02 +0200 Shay Drory wrote: =20
> >>   - Patch-1 Provides I/O EQ size resource which enables to save
> >>     up to 128KB.
> >>   - Patch-2 Provides event EQ size resource which enables to save up to
> >>     512KB. =20
> > Why is something allocated in host memory a device resource? =F0=9F=A4=
=94 =20
>=20
> EQ resides in the host memory. It is RO for host driver, RW by device.
> When interrupt is generated EQ entry is placed by device and read by driv=
er.
> It indicates about what event occurred such as CQE, async and more.

I understand that. My point was the resource which is being consumed
here is _host_ memory. Is there precedent for configuring host memory
consumption via devlink resource?

I'd even question whether this belongs in devlink in the first place.
It is not global device config in any way. If devlink represents the
entire device it's rather strange to have a case where main instance
limits a size of some resource by VFs and other endpoints can still
choose whatever they want.

> > Did you analyze if others may need this? =20
>=20
> So far no feedback by other vendors.
> The resources are implemented in generic way, if other vendors would
> like to implement them.

Well, I was hoping you'd look around, but maybe that's too much to ask
of a vendor.
