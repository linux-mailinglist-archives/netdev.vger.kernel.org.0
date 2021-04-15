Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCB3360ED9
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbhDOPWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234259AbhDOPWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 11:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8D206115B;
        Thu, 15 Apr 2021 15:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618500106;
        bh=i9Nen5FIXDDX8NjLMoZ0nmj/bsF1Nsyy0XJWQ9jdqX4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dR5ubz6xlg2BkJhz+zVNmc8Pllg76FlgQB3eREo96UbNtzgulPJEujuHiLFH8t8S6
         oW4B9XQ7wPvwdJY2IrXK7H9qGzIF8Jw+cmZ2qFvURtO4Bx7owq/yaLPIDDUCH41vCv
         I5J2znK4sueRy6MdTubk3y8U7yWE1tfykRrdmHz5uBA5PMOwJ+EqxVW1At81PxrjYJ
         kefvx7r55hh9hIg6Dzz/i0dzcd5quBWm/SwvMColyifQvLFap49d6n/ohzKsoLqeLm
         ONJVyQMYUZKrUtNg+xs7BgDYEnG47PRVFKW34bNYdUEzYNpMTJWLJJO//WTYxSigqx
         fUtZbPsyGebNw==
Date:   Thu, 15 Apr 2021 08:21:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] ethtool: add FEC statistics
Message-ID: <20210415082144.260cf3ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <723b2858c61898df02e57bb2aaa4c4b4b3c30c50.camel@kernel.org>
References: <20210414034454.1970967-1-kuba@kernel.org>
        <20210414034454.1970967-4-kuba@kernel.org>
        <723b2858c61898df02e57bb2aaa4c4b4b3c30c50.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 23:25:43 -0700 Saeed Mahameed wrote:
> On Tue, 2021-04-13 at 20:44 -0700, Jakub Kicinski wrote:
> > ethtool_link_ksettings *);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0void=C2=A0=C2=A0=C2=A0=C2=A0=
(*get_fec_stats)(struct net_device *dev,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ethtool_fec_stats *fec_st=
ats); =20
>=20
> why void ? some drivers need to access the FW and it could be an old
> FW/device where the fec stats are not supported.

When stats are not supported just returning is fine. Stats are
initialized to -1, core will not dump them into the netlink message=20
if driver didn't assign anything.

> and sometimes e.g. in mlx5 case FW can fail for FW related businesses
> :)..

Can do. I was wondering if the entity reading the stats (from user
space) can do anything useful with the error, and didn't really come=20
up with anything other than printing an error. Which the kernel can=20
do as well. OTOH if there are multiple stats to read and one of them
fails its probably better to return partial results than fail=20
the entire op. Therefore I went for no error - if something fails -=20
the stats will be missing.

Does that make any sense? Or do you think errors are rare enough that
it's okay if they are fatal? (with the caveat that -EOPNOTSUPP should
be ignored).
