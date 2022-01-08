Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D274880E8
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 03:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbiAHC1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 21:27:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44808 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiAHC1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 21:27:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A440B8272D;
        Sat,  8 Jan 2022 02:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6612C36AEB;
        Sat,  8 Jan 2022 02:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641608835;
        bh=TX3kCm6RVF/7MEzog9mzXfC2zzgkvFjbe2el+5vmbCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X3fM9io6M4QhzEtBKzHiKv1B1xv/TlAGOwneGNbM7yjEYF5ASNd17ERsI79KSuBjn
         xXcyo7+BF431U1S7t4hQHKiZPycwi+xesilX4qxgpvTGwMO7nUcM88i0x4kGCKFdzO
         H5wXQFbGOoord+ycVyU3r286MRqVnA2lHMDcudwgQn1kd0UplRMdHAuaGGkBgCR16h
         VYbV1aq5ijpoWd9CF7DTOe0mX+R2NT8+1bup9RH59b3xvbpzO3Pf6pIhrYvHh7S81Z
         x13kFNqdNVeHzaBRemME7SLF6uGBpFxLceMNi9j2LGtHewbxWL7aEU1VFOicfYYpJ2
         mxVYHhUrHfo2g==
Date:   Fri, 7 Jan 2022 18:27:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull request: bluetooth 2022-01-07
Message-ID: <20220107182712.7549a8eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220107210942.3750887-1-luiz.dentz@gmail.com>
References: <20220107210942.3750887-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  7 Jan 2022 13:09:42 -0800 Luiz Augusto von Dentz wrote:
> The following changes since commit 710ad98c363a66a0cd8526465426c5c5f8377e=
e0:
>=20
>   veth: Do not record rx queue hint in veth_xmit (2022-01-06 13:49:54 +00=
00)
>=20
> are available in the Git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.=
git tags/for-net-next-2022-01-07
>=20
> for you to fetch changes up to b9f9dbad0bd1c302d357fdd327c398f51f5fc2b1:
>=20
>   Bluetooth: hci_sock: fix endian bug in hci_sock_setsockopt() (2022-01-0=
7 08:41:38 +0100)
>=20
> ----------------------------------------------------------------
> bluetooth-next pull request for net-next:
>=20
>  - Add support for Foxconn QCA 0xe0d0
>  - Fix HCI init sequence on MacBook Air 8,1 and 8,2
>  - Fix Intel firmware loading on legacy ROM devices

A few warnings here that may be worth addressing - in particular this
one makes me feel that kbuild bot hasn't looked at the patches:

net/bluetooth/hci_sync.c:5143:5: warning: no previous prototype for =E2=80=
=98hci_le_ext_create_conn_sync=E2=80=99 [-Wmissing-prototypes]
 5143 | int hci_le_ext_create_conn_sync(struct hci_dev *hdev, struct hci_co=
nn *conn,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Also this Fixes tag could be mended:

Commit: 6845667146a2 ("Bluetooth: hci_qca: Fix NULL vs IS_ERR_OR_NULL check=
 in qca_serdev_probe")
	Fixes tag: Fixes: 77131dfe ("Bluetooth: hci_qca: Replace devm_gpiod_get() =
with devm_gpiod_get_optional()")
	Has these problem(s):
		- SHA1 should be at least 12 digits long
		  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
		  or later) just making sure it is not set (or set to "auto").


Would you be able to fix the new warnings and resend the PR or are you
confident that there isn't much serious breakage here and follow ups
will be enough?

FWIW to see the new warnings check out net-next, do a allmodconfig build
with W=3D1 C=3D1, pull in your code, reset back to net-next (this will
"touch" all the files that need rebuilding), do a single threaded build
and save (2>file) the warnings, pull in your code, do another build
(2>file2), diff the warnings from the build of just net-next and after
pull.
