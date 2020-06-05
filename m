Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F2E1F0122
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 22:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgFEUo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 16:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728091AbgFEUoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 16:44:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C628D206E6;
        Fri,  5 Jun 2020 20:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591389894;
        bh=Oe2SqUQG6Vs6CnaCrquxEUt+KbCPVfOurKKst0W+Dqo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a/w24oA4KqrULBrTUpZPPy6pAAO20NJcrlQFxPIETz4ZB9z6E2TKNkM3Gl0D8AW2p
         ipRHmyU1Mtd98HzARoAzxRoh4vohVKjLMsC7hmBCaA1u1GWUulXxT3M3rosXglVul0
         zBtZku4y/8I3tiO7aqNpVt0zHiuN0VwrAMsGxiAU=
Date:   Fri, 5 Jun 2020 13:44:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        len.brown@intel.com, chromeos-bluetooth-upstreaming@chromium.org,
        linux-pm@vger.kernel.org, rafael@kernel.org,
        todd.e.brandt@linux.intel.com, rui.zhang@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Bluetooth: Allow suspend even when preparation has
 failed
Message-ID: <20200605134452.4a91695a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200604212842.v2.1.I0ec31d716619532fc007eac081e827a204ba03de@changeid>
References: <20200604212842.v2.1.I0ec31d716619532fc007eac081e827a204ba03de@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Jun 2020 21:28:50 -0700 Abhishek Pandit-Subedi wrote:
> It is preferable to allow suspend even when Bluetooth has problems
> preparing for sleep. When Bluetooth fails to finish preparing for
> suspend, log the error and allow the suspend notifier to continue
> instead.
>=20
> To also make it clearer why suspend failed, change bt_dev_dbg to
> bt_dev_err when handling the suspend timeout.
>=20
> Fixes: dd522a7429b07e ("Bluetooth: Handle LE devices during suspend")
> Reported-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> To verify this is properly working, I added an additional change to
> hci_suspend_wait_event to always return -16. This validates that suspend
> continues even when an error has occurred during the suspend
> preparation.
>=20
> Example on Chromebook:
> [   55.834524] PM: Syncing filesystems ... done.
> [   55.841930] PM: Preparing system for sleep (s2idle)
> [   55.940492] Bluetooth: hci_core.c:hci_suspend_notifier() hci0: Suspend=
 notifier action (3) failed: -16
> [   55.940497] Freezing user space processes ... (elapsed 0.001 seconds) =
done.
> [   55.941692] OOM killer disabled.
> [   55.941693] Freezing remaining freezable tasks ... (elapsed 0.000 seco=
nds) done.
> [   55.942632] PM: Suspending system (s2idle)
>=20
> I ran this through a suspend_stress_test in the following scenarios:
> * Peer classic device connected: 50+ suspends
> * No devices connected: 100 suspends
> * With the above test case returning -EBUSY: 50 suspends
>=20
> I also ran this through our automated testing for suspend and wake on
> BT from suspend continues to work.
>=20
>=20
> Changes in v2:
> - Added fixes and reported-by tags

Building W=3D1 C=3D1 gcc-10:

In file included from ../net/bluetooth/hci_core.c:38:
../net/bluetooth/hci_core.c: In function =C3=A2=E2=82=AC=CB=9Chci_suspend_n=
otifier=C3=A2=E2=82=AC=E2=84=A2:
../include/net/bluetooth/bluetooth.h:182:9: warning: format =C3=A2=E2=82=AC=
=CB=9C%x=C3=A2=E2=82=AC=E2=84=A2 expects argument of type =C3=A2=E2=82=AC=
=CB=9Cunsigned int=C3=A2=E2=82=AC=E2=84=A2, but argument 3 has type =C3=A2=
=E2=82=AC=CB=9Clong unsigned int=C3=A2=E2=82=AC=E2=84=A2 [-Wformat=3D]
  182 |  BT_ERR("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
      |         ^~~~~~
../include/net/bluetooth/bluetooth.h:169:33: note: in definition of macro =
=C3=A2=E2=82=AC=CB=9CBT_ERR=C3=A2=E2=82=AC=E2=84=A2
  169 | #define BT_ERR(fmt, ...) bt_err(fmt "\n", ##__VA_ARGS__)
      |                                 ^~~
../net/bluetooth/hci_core.c:3368:3: note: in expansion of macro =C3=A2=E2=
=82=AC=CB=9Cbt_dev_err=C3=A2=E2=82=AC=E2=84=A2
 3368 |   bt_dev_err(hdev, "Suspend notifier action (%x) failed: %d",
      |   ^~~~~~~~~~
