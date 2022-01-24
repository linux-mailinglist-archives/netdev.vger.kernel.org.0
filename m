Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41ECF4983D9
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbiAXPwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbiAXPwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 10:52:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D274C06173B;
        Mon, 24 Jan 2022 07:52:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BFAE1CE1177;
        Mon, 24 Jan 2022 15:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58F5C340E5;
        Mon, 24 Jan 2022 15:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643039530;
        bh=Za2nmmdrBsvvSiJM+At4GnGZhaz4oLqU5FLsbm9dpsM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W+U08PP/CUGugEvX4Z2D80VWBUftxJKYh8onjWuqzhLzddbRneREAg9MNvNu8vkZ/
         qDq7xhDibvQQoFgR8G5mYJHK+vMSkFcFOviqSp5dLj/vNUQ/1AQDRW6SPXScJHSdiz
         IlZrY8WKGJjkGijJBqqsFXFkqfOJ6qcguMvuHNIfagEWNtwUY5RV/TnFpz2t+dP3WM
         9MewCMHFpd5g1Zi2B+G/hdSv6tW1DidmrXMXeJFaPhPNkjPl6MvUKUkQmJPI1R/P5V
         H12uH4OS3Q6JYN/YXSdoCVSSrQmFDd78bFxHz0XPLL1uPj9ZnVBvRU76cZUsaNi9xv
         AfVhO1QZjBIkA==
Date:   Mon, 24 Jan 2022 07:52:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        "David S . Miller" <davem@davemloft.net>, tanghui20@huawei.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 12/19] net: apple: bmac: Fix build since
 dev_addr constification
Message-ID: <20220124075208.24c30dcc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220123001113.2460140-12-sashal@kernel.org>
References: <20220123001113.2460140-1-sashal@kernel.org>
        <20220123001113.2460140-12-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Jan 2022 19:11:05 -0500 Sasha Levin wrote:
> From: Michael Ellerman <mpe@ellerman.id.au>
>=20
> [ Upstream commit ea938248557a52e231a31f338eac4baee36a8626 ]
>=20
> Since commit adeef3e32146 ("net: constify netdev->dev_addr") the bmac
> driver no longer builds with the following errors (pmac32_defconfig):
>=20
>   linux/drivers/net/ethernet/apple/bmac.c: In function =E2=80=98bmac_prob=
e=E2=80=99:
>   linux/drivers/net/ethernet/apple/bmac.c:1287:20: error: assignment of r=
ead-only location =E2=80=98*(dev->dev_addr + (sizetype)j)=E2=80=99
>    1287 |   dev->dev_addr[j] =3D rev ? bitrev8(addr[j]): addr[j];
>         |                    ^
>=20
> Fix it by making the modifications to a local macaddr variable and then
> passing that to eth_hw_addr_set().
>=20
> We don't use the existing addr variable because the bitrev8() would
> mutate it, but it is already used unreversed later in the function.

Patches 11 and 12 are another case of prep for netdev->dev_addr
being const in 5.17, we don't need those backported.
