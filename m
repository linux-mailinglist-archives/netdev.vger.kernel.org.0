Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 158C345015
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfFMXeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:34:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:62086 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfFMXeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 19:34:05 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 16:34:04 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 13 Jun 2019 16:34:03 -0700
Message-ID: <59a549e74f98871d25efdc311896eae73fdd7399.camel@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH bpf-next 0/6] add need_wakeup flag to
 the AF_XDP rings
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        brouer@redhat.com
Cc:     axboe@kernel.dk, maximmi@mellanox.com, kevin.laatz@intel.com,
        jakub.kicinski@netronome.com, maciejromanfijalkowski@gmail.com,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        ilias.apalodimas@linaro.org, xiaolong.ye@intel.com,
        intel-wired-lan@lists.osuosl.org, qi.z.zhang@intel.com,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org
Date:   Thu, 13 Jun 2019 16:34:23 -0700
In-Reply-To: <1560411450-29121-1-git-send-email-magnus.karlsson@intel.com>
References: <1560411450-29121-1-git-send-email-magnus.karlsson@intel.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-9ltDPTNIgxlKiuge5yg2"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-9ltDPTNIgxlKiuge5yg2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-06-13 at 09:37 +0200, Magnus Karlsson wrote:
> This patch set adds support for a new flag called need_wakeup in the
> AF_XDP Tx and fill rings. When this flag is set by the driver, it
> means that the application has to explicitly wake up the kernel Rx
> (for the bit in the fill ring) or kernel Tx (for bit in the Tx ring)
> processing by issuing a syscall. Poll() can wake up both and sendto()
> will wake up Tx processing only.
>=20
> The main reason for introducing this new flag is to be able to
> efficiently support the case when application and driver is executing
> on the same core. Previously, the driver was just busy-spinning on
> the
> fill ring if it ran out of buffers in the HW and there were none to
> get from the fill ring. This approach works when the application and
> driver is running on different cores as the application can replenish
> the fill ring while the driver is busy-spinning. Though, this is a
> lousy approach if both of them are running on the same core as the
> probability of the fill ring getting more entries when the driver is
> busy-spinning is zero. With this new feature the driver now sets the
> need_wakeup flag and returns to the application. The application can
> then replenish the fill queue and then explicitly wake up the Rx
> processing in the kernel using the syscall poll(). For Tx, the flag
> is
> only set to one if the driver has no outstanding Tx completion
> interrupts. If it has some, the flag is zero as it will be woken up
> by
> a completion interrupt anyway. This flag can also be used in other
> situations where the driver needs to be woken up explicitly.
>=20
> As a nice side effect, this new flag also improves the Tx performance
> of the case where application and driver are running on two different
> cores as it reduces the number of syscalls to the kernel. The kernel
> tells user space if it needs to be woken up by a syscall, and this
> eliminates many of the syscalls. The Rx performance of the 2-core
> case
> is on the other hand slightly worse, since there is a need to use a
> syscall now to wake up the driver, instead of the driver
> busy-spinning. It does waste less CPU cycles though, which might lead
> to better overall system performance.
>=20
> This new flag needs some simple driver support. If the driver does
> not
> support it, the Rx flag is always zero and the Tx flag is always
> one. This makes any application relying on this feature default to
> the
> old behavior of not requiring any syscalls in the Rx path and always
> having to call sendto() in the Tx path.
>=20
> For backwards compatibility reasons, this feature has to be
> explicitly
> turned on using a new bind flag (XDP_USE_NEED_WAKEUP). I recommend
> that you always turn it on as it has a large positive performance
> impact for the one core case and does not degrade 2 core performance
> and actually improves it for Tx heavy workloads.
>=20
> Here are some performance numbers measured on my local,
> non-performance optimized development system. That is why you are
> seeing numbers lower than the ones from Bj=C3=B6rn and Jesper. 64 byte
> packets at 40Gbit/s line rate. All results in Mpps. Cores =3D=3D 1 means
> that both application and driver is executing on the same core. Cores
> =3D=3D 2 that they are on different cores.
>=20
>                               Applications
> need_wakeup  cores    txpush    rxdrop      l2fwd
> ---------------------------------------------------------------
>      n         1       0.07      0.06        0.03
>      y         1       21.6      8.2         6.5
>      n         2       32.3      11.7        8.7
>      y         2       33.1      11.7        8.7
>=20
> Overall, the need_wakeup flag provides the same or better performance
> in all the micro-benchmarks. The reduction of sendto() calls in
> txpush
> is large. Only a few per second is needed. For l2fwd, the drop is 50%
> for the 1 core case and more than 99.9% for the 2 core case. Do not
> know why I am not seeing the same drop for the 1 core case yet.
>=20
> The name and inspiration of the flag has been taken from io_uring by
> Jens Axboe. Details about this feature in io_uring can be found in
> http://kernel.dk/io_uring.pdf, section 8.3. It also addresses most of
> the denial of service and sendto() concerns raised by Maxim
> Mikityanskiy in https://www.spinics.net/lists/netdev/msg554657.html.
>=20
> The typical Tx part of an application will have to change from:
>=20
> ret =3D sendto(fd,....)
>=20
> to:
>=20
> if (xsk_ring_prod__needs_wakeup(&xsk->tx))
>        ret =3D sendto(fd,....)
>=20
> and th Rx part from:
>=20
> rcvd =3D xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> if (!rcvd)
>        return;
>=20
> to:
>=20
> rcvd =3D xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> if (!rcvd) {
>        if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
>               ret =3D poll(fd,.....);
>        return;
> }
>=20
> This patch has been applied against commit aee450cbe482 ("bpf:
> silence warning messages in core")
>=20
> Structure of the patch set:
>=20
> Patch 1: Replaces the ndo_xsk_async_xmit with ndo_xsk_wakeup to
>          support waking up both Rx and Tx processing
> Patch 2: Implements the need_wakeup functionality in common code
> Patch 3-4: Add need_wakeup support to the i40e and ixgbe drivers
> Patch 5: Add need_wakeup support to libbpf
> Patch 6: Add need_wakeup support to the xdpsock sample application
>=20
> Thanks: Magnus

Since the i40e and ixgbe changes will not apply against my dev-queue
branch (with the current queue of i40e and ixgbe changes), can you
please rebase against my next-queue tree (dev-queue branch) when you
submit v2?  It will make it easier for me to apply and have validation
verify the changes.

>=20
> Magnus Karlsson (6):
>   xsk: replace ndo_xsk_async_xmit with ndo_xsk_wakeup
>   xsk: add support for need_wakeup flag in AF_XDP rings
>   i40e: add support for AF_XDP need_wakup feature
>   ixgbe: add support for AF_XDP need_wakup feature
>   libbpf: add support for need_wakeup flag in AF_XDP part
>   samples/bpf: add use of need_sleep flag in xdpsock
>=20
>  drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +-
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  23 ++-
>  drivers/net/ethernet/intel/i40e/i40e_xsk.h         |   2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   5 +-
>  .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |   2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  20 ++-
>  include/linux/netdevice.h                          |  18 +-
>  include/net/xdp_sock.h                             |  33 +++-
>  include/uapi/linux/if_xdp.h                        |  13 ++
>  net/xdp/xdp_umem.c                                 |   6 +-
>  net/xdp/xsk.c                                      |  93 +++++++++-
>  net/xdp/xsk_queue.h                                |   1 +
>  samples/bpf/xdpsock_user.c                         | 191
> +++++++++++++--------
>  tools/include/uapi/linux/if_xdp.h                  |  13 ++
>  tools/lib/bpf/xsk.c                                |   4 +
>  tools/lib/bpf/xsk.h                                |   6 +
>  16 files changed, 343 insertions(+), 92 deletions(-)
>=20
> --
> 2.7.4
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan


--=-9ltDPTNIgxlKiuge5yg2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl0C3X8ACgkQ5W/vlVpL
7c74lA/+MQ7ACtL62xuN44d3gkEXZPkDHNqBnIQBXvDUX5URJ/CI0Ffg3SeFACSZ
J16V9WcSRlzu7ZwJG2V9N5Wx95dEpGPY14DS57QPnITfejkvMQQiTbPqvRmb0vSe
EuNVlhVUnIDLLl5YuPfIK21CoHCQDM3b/haa1m0BnPiTa/PAhIEWtgnAcZxOT8fG
IMuK3rewu4VqEpnj0f7SSAckDwgyknjsysi78FAEmLBHiJX6p64diQyJg4DS4RjT
LyWOmJJE5hyxu91bl+gkIHW9u31FUOZhjsfidmS7BSfQoASvc6igtVAOffwzltnP
R/o9haxjnmPsnyJ0ABg+p1va1TJqFINWh8qarF5dKX335v7vJRV/XvKtu/3DYO+6
3sGJ8pyM3QfU2qqOlu551a1gBeFRnyulrzNoq6GiRXsgjYghRxfZanaODHzJySi0
a7c/JyEnAgVqYiNnFCyIoOKULhUg9W9pB4CRRu5n+7HpwMdgLuqFjVijt66/V31y
sSDpRTgI8wtUe4aPSr8HcBtOtZ29ILF2DTQB/FssiwhPcchcy/T53DcLtZ8+XzHW
rJKnZiltsgVfRqCL2pT04eTGB6C52jirzRhr27zv6am0fi0tZ3aaTpFUb20Z/RTZ
v6xck2vh4itdBABqzfTwSV4y7zhM76C6zbtJXfIECqMEYf9k1C0=
=/hs/
-----END PGP SIGNATURE-----

--=-9ltDPTNIgxlKiuge5yg2--

