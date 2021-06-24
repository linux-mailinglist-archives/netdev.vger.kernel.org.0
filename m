Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568913B2CBE
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 12:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhFXKsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 06:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231294AbhFXKsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 06:48:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AAFB613FD;
        Thu, 24 Jun 2021 10:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624531550;
        bh=7e/uhceb4SsVfqed3rolRWCdLu/v31HwG/8C+2zCGgw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BioL4KtNRS/rKGgQ0TR8pwdsN9Wjc1OeTIiZwyJVntIAL6HrX08P91OloUEh3UfAG
         +VxZynI4VMIMG2FEAEBq3Pm8i5pygFbCfdFC06awczRWGsLDP2fdhyzKOiGe7QvnwL
         E7kYltndY19AdGhRWa7MEI7Bs/xegl7uYRGnwojWbC4k+IP1qvn7wZFUxXqi7AQIzK
         u36+cds+kPEZGMfdOHc38JLdSlqqCFbMJScT/8rRzvMsgFbfnJ+bucgjcBFDhp9Szn
         GvCNtLTGZxT65+GIzvy+fn72BMlhjTrCSIEfKVARUTHZGh/b/JwDZ+Q0pW1AayDop9
         xA8L7Vij9W76g==
Date:   Thu, 24 Jun 2021 12:45:45 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Phil Sutter <phil@nwl.cc>
Subject: Re: Issues during assigning addresses on point to point interfaces
Message-ID: <20210624124545.2b170258@dellmb>
In-Reply-To: <20210606151008.7dwx5ukrlvxt4t3k@pali>
References: <20210606151008.7dwx5ukrlvxt4t3k@pali>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Jun 2021 17:10:08 +0200
Pali Roh=C3=A1r <pali@kernel.org> wrote:

> Hello!
>=20
> Seems that there is a bug during assigning IP addresses on point to
> point interfaces.
>=20
> Assigning just one local address works fine:
>=20
>     ip address add fe80::6 dev ppp1 --> inet6 fe80::6/128 scope link
>=20
> Assigning both local and remote peer address also works fine:
>=20
>     ip address add fe80::7 peer fe80::8 dev ppp1 ---> inet6 fe80::7
> peer fe80::8/128 scope link
>=20
> But trying to assign just remote peer address does not work. Moreover
> "ip address" call does not fail, it returns zero but instead of
> setting remote peer address, it sets local address:
>=20
>     ip address add peer fe80::5 dev ppp1 --> inet6 fe80::5/128 scope
> link
>=20

Adding some other people to Cc in order to get their opinions.

It seems this bug is there from the beginning, from commit
caeaba79009c2 ("ipv6: add support of peer address")
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Dcaeaba79009c2

Maybe some older user-space utilities use IFA_ADDRESS instead of
IFA_LOCAL, and this was done in order to be compatible with them?

Marek
