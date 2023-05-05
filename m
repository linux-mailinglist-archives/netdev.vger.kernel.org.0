Return-Path: <netdev+bounces-619-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DAC06F8947
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 21:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6CF91C21998
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 19:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F58C8EA;
	Fri,  5 May 2023 19:04:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CD04C99;
	Fri,  5 May 2023 19:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FB4C433EF;
	Fri,  5 May 2023 19:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683313477;
	bh=C9FfdbxETWmChifU0PTW5qVrAClxjS6Z5WTZhtBAS7k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kU2UyVglGLmb1eLdyzv8fH4VFGago9J1msP/oYm2hDqjO4Q9Bc/j6uUddXlKuzJmf
	 9d4xmMh1r15UcyO3MGJbrR5lziiGBeQBdr7ptBWGPyWFLbuxeFjNQFQwcNFHVj6fNf
	 OSuu8me3vXAD+EZJTxLQRapKkmwVNU2fl1B/7DNHzlEpFBLBh67QnRAG/LQQuFSJ6X
	 JRtTcLGQJNA4u9urMYHhJfmu3IRe6fQzVjEEH43xhqYol1YUjxojUF+F5OBYcyDc43
	 EK1TBKGM9iQy8L2lKoXDGif3/gmZSUi8f6J+++R00guuNCuJ0FdXWjwfEofMSnlcku
	 PgAYaP53U7vZw==
Date: Fri, 5 May 2023 12:04:36 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>, Hayes Wang <hayeswang@realtek.com>, Linux
 regressions mailing list <regressions@lists.linux.dev>,
 netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, Stanislav
 Fomichev <sdf@fomichev.me>
Subject: Re: [regression] Kernel OOPS on boot with Kernel 6.3(.1) and
 RTL8153 Gigabit Ethernet Adapter
Message-ID: <20230505120436.6ff8cfca@kernel.org>
In-Reply-To: <87lei36q27.fsf@miraculix.mork.no>
References: <ec4be122-e213-ca5b-f5d6-e8f9c3fd3bee@leemhuis.info>
	<87lei36q27.fsf@miraculix.mork.no>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 05 May 2023 12:16:48 +0200 Bj=C3=B8rn Mork wrote:
> "Linux regression tracking (Thorsten Leemhuis)"
> <regressions@leemhuis.info> writes:
>=20
> >> Kernel OOPS on boot
> >>=20
> >> Hello,
> >>=20
> >> on my laptop with kernel 6.3.0 and 6.3.1 fails to correctly boot if th=
e usb-c device "RTL8153 Gigabit Ethernet Adapter" is connected.
> >>=20
> >> If I unplug it, boot and the plug it in, everything works fine.
> >>=20
> >> This used to work fine with 6.2.10.
> >>=20
> >> HW:
> >> - Dell Inc. Latitude 7410/0M5G57, BIOS 1.22.0 03/20/2023
> >> - Realtek Semiconductor Corp. RTL8153 Gigabit Ethernet Adapter
> >>=20
> >>=20
> >> Call Trace (manually typed from the image, typos maybe be included)
> >> - bpf_dev_bound_netdev_unregister
> >> - unregister_netdevice_many_notify
> >> - unregister_netdevice_gueue
> >> - unregister_netdev
> >> - usbnet_disconnect
> >> - usb_unbind_interface
> >> - device_release_driver_internal
> >> - bus_remove_device
> >> - device_del
> >> - ? kobject_put
> >> - usb_disable_device
> >> - usb_set_configuration
> >> - rt18152_cfgselector_probe
> >> - usb_probe_device
> >> - really_probe
> >> - ? driver_probe_device
> >> - ... =20
>=20
>=20
> Ouch. This is obviously related to the change I made to the RTL8153
> driver, which you can see is in effect by the call to
> rtl8152_cfgselector_probe above (compensating for the typo).
>=20
> But to me it doesn't look like the bug is in that driver. It seems we
> are triggering some latent bug in the unregister_netdev code?
>=20
> The trace looks precise enogh to me.  The image also shows
>=20
>  RIP: 0010: __rhastable_lookup.constprop.0+0x18/0x120
>=20
> which I believe comes from bpf_dev_bound_netdev_unregister() calling the
> bpf_offload_find_netdev(), which does:
>=20
>=20
> bpf_offload_find_netdev(struct net_device *netdev)
> {
>         lockdep_assert_held(&bpf_devs_lock);
>=20
>         return rhashtable_lookup_fast(&offdevs, &netdev, offdevs_params);
> }
>=20
>=20
> Maybe someone familiar with that code can explain why this fails if called
> at boot instead of later?
>=20
> AFAICS, we don't do anything out of the ordinary in that driver, with
> respect to netdev registration at least.  A similar device disconnet and
> netdev unregister would also happen if you decided to pull the USB
> device from the port during boot.  In fact, most USB network devices
> behave similar when disconnected and there is nothing preventing it
> from happening while the system is booting..

Yeah, I think it's because late_initcall is too conservative.=20
The device gets removed before late_initcall().=20

It's just a hashtable init, I think that we can do:

diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index d9c9f45e3529..8a26cd8814c1 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -859,4 +859,4 @@ static int __init bpf_offload_init(void)
 	return rhashtable_init(&offdevs, &offdevs_params);
 }
=20
-late_initcall(bpf_offload_init);
+core_initcall(bpf_offload_init);


Thorsten, how is the communication supposed to work in this case?
Can you ask the reporter to test this? I don't see them on CC...

