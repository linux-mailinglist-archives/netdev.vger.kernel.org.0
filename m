Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785AE2B2654
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgKMVMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgKMVMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:12:54 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F4BE2224D;
        Fri, 13 Nov 2020 21:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605301973;
        bh=Exnf1wjI8nGnU3J7yBKR4rBeVhS0197z+CG/HIuGdwo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XZEzmKfhRV5V893316azDkfJcawBcHXL4OVNpamKe7gTUsCGMRN2IcGVnNcL65jWA
         ZgfSsjmbOtiVIzyfwjy1+KoR0DwoBjrxLluc03vmvnMg22sh9HoUYJ02tsiP8piue+
         0kpB6KsJewH0NPKDGHZHUPTFgXUYxkGhdo9wmXn8=
Date:   Fri, 13 Nov 2020 13:12:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>
Subject: Re: [net-next] devlink: move request_firmware out of driver
Message-ID: <20201113131252.743c1226@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113000142.3563690-1-jacob.e.keller@intel.com>
References: <20201113000142.3563690-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 16:01:42 -0800 Jacob Keller wrote:
> All drivers which implement the devlink flash update support, with the
> exception of netdevsim, use either request_firmware or
> request_firmware_direct to locate the firmware file. Rather than having
> each driver do this separately as part of its .flash_update
> implementation, perform the request_firmware within net/core/devlink.c
>=20
> Replace the file_name paramter in the struct devlink_flash_update_params
> with a pointer to the fw object.
>=20
> Use request_firmware rather than request_firmware_direct. Although most
> Linux distributions today do not have the fallback mechanism
> implemented, only about half the drivers used the _direct request, as
> compared to the generic request_firmware. In the event that
> a distribution does support the fallback mechanism, the devlink flash
> update ought to be able to use it to provide the firmware contents. For
> distributions which do not support the fallback userspace mechanism,
> there should be essentially no difference between request_firmware and
> request_firmware_direct.

Thanks for working on this!

> This is a follow to the discussion that took place at [1]. After reading
> through the docs for request_firmware vs request_firmware_direct, I belie=
ve
> that the net/core/devlink.c should be using request_firmware. While it is
> true that no distribution supports this today, it seems like we shouldn't
> rule it out entirely here. I'm willing to change this if we think it's not
> worth bothering to support it.
>=20
> Note that I have only compile-tested the drivers other than ice, as I do =
not
> have hw for them. The only tricky transformation was in the bnxt driver
> which shares code with the ethtool implementation. The rest were pretty
> straight forward transformations.
>=20
> One other thing came to my attention while working on this and while
> discussing the ice devlink support with colleagues: the userspace devlink
> program doesn't really indicate that the flash file must be located in the
> firmware search path (usually /lib/firmware/*).

It's in the man page, same as ethool.

> It is probably worth some effort to make the userspace tool error out
> more clearly when the file can't be found.

Can do, although the path is configurable AFAIR through some kconfig,
and an extack from the kernel would probably be as informative?

Or are you thinking of doing something like copying/linking the file to
/lib/firmware automatically if user provides path relative to CWD?


../drivers/net/ethernet/intel/ice/ice_devlink.c:250:17: warning: unused var=
iable =E2=80=98dev=E2=80=99 [-Wunused-variable]
  250 |  struct device *dev =3D &pf->pdev->dev;
      |                 ^~~
../drivers/net/ethernet/qlogic/qed/qed_mcp.c:510:9: warning: context imbala=
nce in '_qed_mcp_cmd_and_union' - unexpected unlock
../drivers/net/ethernet/mellanox/mlx5/core/devlink.c: In function =E2=80=98=
mlx5_devlink_flash_update=E2=80=99:
../drivers/net/ethernet/mellanox/mlx5/core/devlink.c:16:25: warning: unused=
 variable =E2=80=98fw=E2=80=99 [-Wunused-variable]
   16 |  const struct firmware *fw;
      |                         ^~
