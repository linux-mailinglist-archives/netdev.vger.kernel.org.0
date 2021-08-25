Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943793F7757
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 16:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241644AbhHYO1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 10:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241072AbhHYO1b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 10:27:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C28BF61073;
        Wed, 25 Aug 2021 14:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629901605;
        bh=ddjC84DBGSw2Ae6DxMj7QeyDUAa1UMlEhTlgZipo1XE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CK5qCf827n5XHd8TFdxUJZ6XSbAVuejIYI0w2YN+4VKTdJJzZE/CPF2MkABR5gzaq
         rW355o6IxVOZ6KBMDTtzq9JsVC8CRk38EyxvlmEGaS7PvN9Pfc9jYH07mj1aH+iT2i
         YJwvM9OAkf2oPJmn6fuU5Oa3dZSSRbOKLz2fAp/fKa1UbEsejKni4bCX0alLjmMRXD
         oTC5m01IFeZzGYgglWH0FpwYb3jofeAphx5+/4obEl8iRapPL5tFYtAbv5rvkha4Wj
         RPHa1CnteYk3xhAO7EEVfG75F8JHqaZLH3nT3LmjJeVdvhy5CMbm8p6YVoWllZGUKp
         cLjr0TRb45hKw==
Date:   Wed, 25 Aug 2021 07:26:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v3 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <20210825072644.1b3aaf46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YSYmFEDWJIu6eDvR@shredder>
References: <20210824130344.1828076-1-idosch@idosch.org>
        <20210824130344.1828076-2-idosch@idosch.org>
        <20210824161231.5e281f1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YSYmFEDWJIu6eDvR@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Aug 2021 14:14:28 +0300 Ido Schimmel wrote:
> So I suggest:
>=20
> "The default policy is driver-dependent, but "auto" is the recommended
> default and it should be implemented by new drivers and drivers where
> conformance to a legacy behavior is not critical."

SGTM

> > > + * @mode_valid: Indicates the validity of the @mode field. Should be=
 set by
> > > + * device drivers on get operations when a module is plugged-in. =20
> >=20
> > Should we make a firm decision on whether we want to use these kind of
> > valid bits or choose invalid defaults? As you may guess my preference
> > is the latter since that's what I usually do, that way drivers don't
> > have to write two fields.
> >=20
> > Actually I think this may be the first "valid" in ethtool, I thought we
> > already had one but I don't see it now.. =20
>=20
> I was thinking about this as well, but I wasn't sure if it's valid to
> adjust uAPI values in order to make in-kernel APIs simpler. I did see it
> in some other places, but wasn't sure if it's a pattern that should be
> copied.
>=20
> Do you mean something like this?
>=20
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 7d453f0e993b..d61049091538 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -732,7 +732,7 @@ enum ethtool_module_power_mode_policy {
>   * @ETHTOOL_MODULE_POWER_MODE_HIGH: Module is in high power mode.
>   */
>  enum ethtool_module_power_mode {
> -       ETHTOOL_MODULE_POWER_MODE_LOW,
> +       ETHTOOL_MODULE_POWER_MODE_LOW =3D 1,
>         ETHTOOL_MODULE_POWER_MODE_HIGH,
>  };
>=20
> I prefer this over memsetting a struct to 0xff.

Yup, I mean we mostly care about the policy but can adjust the state
enum as well ;) For stats 0 was a no-go, obviously but in general it
should work perfectly.

> If the above is fine, I can make the following patch:
>=20
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation=
/networking/ethtool-netlink.rst
> index c258b3f30a2e..d304df39ee5c 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -41,6 +41,11 @@ In the message structure descriptions below, if an att=
ribute name is suffixed
>  with "+", parent nest can contain multiple attributes of the same type. =
This
>  implements an array of entries.
> =20
> +Attributes that need to be filled-in by device drivers and that are dump=
ed to
> +user space based on whether they are valid or not should not use zero as=
 a
> +valid value. For example, ``ETHTOOL_A_MODULE_POWER_MODE``. This avoids t=
he need
> +to explicitly signal the validity of the attribute in the device driver =
API.
> +

Modulo the enum in question, but =F0=9F=91=8D
