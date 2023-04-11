Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADA76DE3EA
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjDKSaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjDKSaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:30:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64028BD;
        Tue, 11 Apr 2023 11:30:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFEB562AC9;
        Tue, 11 Apr 2023 18:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CD1C433D2;
        Tue, 11 Apr 2023 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681237805;
        bh=nBxoXgHstFZ077Cj9vEalKsAYO7RkFrZC0/DS7EY5mk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cG1sVocuW4qBEwREmW8qKX+h2Th5I3sUcxcRxjljlk1X36bIv4sLTIM7sOCJoUKBh
         0r6QMM6Uf/sS7f/69WfKT3Qm0d57PVtd/KjxLrv5OZzfYVa9A+b4ZELKAz6iIiqYsL
         kKFhTDEjnS4ga59zlpxBmiSMMEzUX/2Ewj3mo2TTKYn6JPkkNrhAVezyGejTF1phJO
         TJ0azODae2hzGlvD30xQ7Tlox1kk7G6vaZlLKNkdU0k5aPwhFcw9w3L6VGo771M43A
         zd8vWtKjr+GCtMSKNumUKeYdgUg6CY0nvjWhGOlur2GK5W+B8tOhpbah0ZIXXmfk8+
         cb4OdTI9P2UvA==
Date:   Tue, 11 Apr 2023 19:30:00 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Rafal Ozieblo <rafalo@cadence.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com
Subject: Re: [PATCH net] net: macb: fix a memory corruption in extended
 buffer descriptor mode
Message-ID: <20230411-turbulent-caddie-de82cf1a0f8f@spud>
References: <20230407172402.103168-1-roman.gushchin@linux.dev>
 <ZDWk8vjvk7HO4I7o@P9FQF9L96D.corp.robot.car>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+NKUCmJEde70Cw2p"
Content-Disposition: inline
In-Reply-To: <ZDWk8vjvk7HO4I7o@P9FQF9L96D.corp.robot.car>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+NKUCmJEde70Cw2p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 11, 2023 at 11:20:34AM -0700, Roman Gushchin wrote:
> Friendly ping.

Nicolas and Claudiu look after the macb stuff, it's a good idea to CC
the people that get_maintainer.pl says are supporters of the code!

> Also cc'ing Dave.

+CC Nicolas & Claudiu ;)

> Thanks!
>=20
> On Fri, Apr 07, 2023 at 10:24:02AM -0700, Roman Gushchin wrote:
> > For quite some time we were chasing a bug which looked like a sudden
> > permanent failure of networking and mmc on some of our devices.
> > The bug was very sensitive to any software changes and even more to
> > any kernel debug options.
> >=20
> > Finally we got a setup where the problem was reproducible with
> > CONFIG_DMA_API_DEBUG=3Dy and it revealed the issue with the rx dma:
> >=20
> > [   16.992082] ------------[ cut here ]------------
> > [   16.996779] DMA-API: macb ff0b0000.ethernet: device driver tries to =
free DMA memory it has not allocated [device address=3D0x0000000875e3e244] =
[size=3D1536 bytes]
> > [   17.011049] WARNING: CPU: 0 PID: 85 at kernel/dma/debug.c:1011 check=
_unmap+0x6a0/0x900
> > [   17.018977] Modules linked in: xxxxx
> > [   17.038823] CPU: 0 PID: 85 Comm: irq/55-8000f000 Not tainted 5.4.0 #=
28
> > [   17.045345] Hardware name: xxxxx
> > [   17.049528] pstate: 60000005 (nZCv daif -PAN -UAO)
> > [   17.054322] pc : check_unmap+0x6a0/0x900
> > [   17.058243] lr : check_unmap+0x6a0/0x900
> > [   17.062163] sp : ffffffc010003c40
> > [   17.065470] x29: ffffffc010003c40 x28: 000000004000c03c
> > [   17.070783] x27: ffffffc010da7048 x26: ffffff8878e38800
> > [   17.076095] x25: ffffff8879d22810 x24: ffffffc010003cc8
> > [   17.081407] x23: 0000000000000000 x22: ffffffc010a08750
> > [   17.086719] x21: ffffff8878e3c7c0 x20: ffffffc010acb000
> > [   17.092032] x19: 0000000875e3e244 x18: 0000000000000010
> > [   17.097343] x17: 0000000000000000 x16: 0000000000000000
> > [   17.102647] x15: ffffff8879e4a988 x14: 0720072007200720
> > [   17.107959] x13: 0720072007200720 x12: 0720072007200720
> > [   17.113261] x11: 0720072007200720 x10: 0720072007200720
> > [   17.118565] x9 : 0720072007200720 x8 : 000000000000022d
> > [   17.123869] x7 : 0000000000000015 x6 : 0000000000000098
> > [   17.129173] x5 : 0000000000000000 x4 : 0000000000000000
> > [   17.134475] x3 : 00000000ffffffff x2 : ffffffc010a1d370
> > [   17.139778] x1 : b420c9d75d27bb00 x0 : 0000000000000000
> > [   17.145082] Call trace:
> > [   17.147524]  check_unmap+0x6a0/0x900
> > [   17.151091]  debug_dma_unmap_page+0x88/0x90
> > [   17.155266]  gem_rx+0x114/0x2f0
> > [   17.158396]  macb_poll+0x58/0x100
> > [   17.161705]  net_rx_action+0x118/0x400
> > [   17.165445]  __do_softirq+0x138/0x36c
> > [   17.169100]  irq_exit+0x98/0xc0
> > [   17.172234]  __handle_domain_irq+0x64/0xc0
> > [   17.176320]  gic_handle_irq+0x5c/0xc0
> > [   17.179974]  el1_irq+0xb8/0x140
> > [   17.183109]  xiic_process+0x5c/0xe30
> > [   17.186677]  irq_thread_fn+0x28/0x90
> > [   17.190244]  irq_thread+0x208/0x2a0
> > [   17.193724]  kthread+0x130/0x140
> > [   17.196945]  ret_from_fork+0x10/0x20
> > [   17.200510] ---[ end trace 7240980785f81d6f ]---
> >=20
> > [  237.021490] ------------[ cut here ]------------
> > [  237.026129] DMA-API: exceeded 7 overlapping mappings of cacheline 0x=
0000000021d79e7b
> > [  237.033886] WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:499 add_dma=
_entry+0x214/0x240
> > [  237.041802] Modules linked in: xxxxx
> > [  237.061637] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W       =
  5.4.0 #28
> > [  237.068941] Hardware name: xxxxx
> > [  237.073116] pstate: 80000085 (Nzcv daIf -PAN -UAO)
> > [  237.077900] pc : add_dma_entry+0x214/0x240
> > [  237.081986] lr : add_dma_entry+0x214/0x240
> > [  237.086072] sp : ffffffc010003c30
> > [  237.089379] x29: ffffffc010003c30 x28: ffffff8878a0be00
> > [  237.094683] x27: 0000000000000180 x26: ffffff8878e387c0
> > [  237.099987] x25: 0000000000000002 x24: 0000000000000000
> > [  237.105290] x23: 000000000000003b x22: ffffffc010a0fa00
> > [  237.110594] x21: 0000000021d79e7b x20: ffffffc010abe600
> > [  237.115897] x19: 00000000ffffffef x18: 0000000000000010
> > [  237.121201] x17: 0000000000000000 x16: 0000000000000000
> > [  237.126504] x15: ffffffc010a0fdc8 x14: 0720072007200720
> > [  237.131807] x13: 0720072007200720 x12: 0720072007200720
> > [  237.137111] x11: 0720072007200720 x10: 0720072007200720
> > [  237.142415] x9 : 0720072007200720 x8 : 0000000000000259
> > [  237.147718] x7 : 0000000000000001 x6 : 0000000000000000
> > [  237.153022] x5 : ffffffc010003a20 x4 : 0000000000000001
> > [  237.158325] x3 : 0000000000000006 x2 : 0000000000000007
> > [  237.163628] x1 : 8ac721b3a7dc1c00 x0 : 0000000000000000
> > [  237.168932] Call trace:
> > [  237.171373]  add_dma_entry+0x214/0x240
> > [  237.175115]  debug_dma_map_page+0xf8/0x120
> > [  237.179203]  gem_rx_refill+0x190/0x280
> > [  237.182942]  gem_rx+0x224/0x2f0
> > [  237.186075]  macb_poll+0x58/0x100
> > [  237.189384]  net_rx_action+0x118/0x400
> > [  237.193125]  __do_softirq+0x138/0x36c
> > [  237.196780]  irq_exit+0x98/0xc0
> > [  237.199914]  __handle_domain_irq+0x64/0xc0
> > [  237.204000]  gic_handle_irq+0x5c/0xc0
> > [  237.207654]  el1_irq+0xb8/0x140
> > [  237.210789]  arch_cpu_idle+0x40/0x200
> > [  237.214444]  default_idle_call+0x18/0x30
> > [  237.218359]  do_idle+0x200/0x280
> > [  237.221578]  cpu_startup_entry+0x20/0x30
> > [  237.225493]  rest_init+0xe4/0xf0
> > [  237.228713]  arch_call_rest_init+0xc/0x14
> > [  237.232714]  start_kernel+0x47c/0x4a8
> > [  237.236367] ---[ end trace 7240980785f81d70 ]---
> >=20
> > Lars was fast to find an explanation: according to the datasheet
> > bit 2 of the rx buffer descriptor entry has a different meaning in the
> > extended mode:
> >   Address [2] of beginning of buffer, or
> >   in extended buffer descriptor mode (DMA configuration register [28] =
=3D 1),
> >   indicates a valid timestamp in the buffer descriptor entry.
> >=20
> > The macb driver didn't mask this bit while getting an address and it
> > eventually caused a memory corruption and a dma failure.
> >=20
> > The problem is resolved by extending the MACB_RX_WADDR_SIZE
> > in the extended mode.
> >=20
> > Fixes: 7b4296148066 ("net: macb: Add support for PTP timestamps in DMA =
descriptors")
> > Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> > Co-developed-by: Lars-Peter Clausen <lars@metafoo.de>
> > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > ---
> >  drivers/net/ethernet/cadence/macb.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> >=20
> > diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet=
/cadence/macb.h
> > index c1fc91c97cee..1b330f7cfc09 100644
> > --- a/drivers/net/ethernet/cadence/macb.h
> > +++ b/drivers/net/ethernet/cadence/macb.h
> > @@ -826,8 +826,13 @@ struct macb_dma_desc_ptp {
> >  #define MACB_RX_USED_SIZE			1
> >  #define MACB_RX_WRAP_OFFSET			1
> >  #define MACB_RX_WRAP_SIZE			1
> > +#ifdef MACB_EXT_DESC
> > +#define MACB_RX_WADDR_OFFSET			3
> > +#define MACB_RX_WADDR_SIZE			29
> > +#else
> >  #define MACB_RX_WADDR_OFFSET			2
> >  #define MACB_RX_WADDR_SIZE			30
> > +#endif
> > =20
> >  #define MACB_RX_FRMLEN_OFFSET			0
> >  #define MACB_RX_FRMLEN_SIZE			12
> > --=20
> > 2.40.0
> >=20

--+NKUCmJEde70Cw2p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZDWnEwAKCRB4tDGHoIJi
0v0OAP43X3Ul8rsBrFmkUc1TEGh4ENxF49MdOJJS2NQv2kWEywD/VxyOvpNZHw2Y
v8ojKhy8lIBMNRef0B8BrKQThiQdogU=
=25dK
-----END PGP SIGNATURE-----

--+NKUCmJEde70Cw2p--
