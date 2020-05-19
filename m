Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357B41D9D49
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgESQzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728778AbgESQzm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 12:55:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC4A4204EA;
        Tue, 19 May 2020 16:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589907341;
        bh=RjYocffFKOJBoRXrKQVtxRkFXXHlM2JSmrJvKUhqZQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wZ38Yv509LMdk2AMoily5o/NpnCT4zyGc6FsE/CiBZpjorSleQZQvKhYBx+cRyRZs
         R9LM6IHFZmP2lRgiMMfaZlfifXfyp5KKegrrT7jhTMzKaB+feCH5L/6/N/71XqBp+U
         CWD6JRx8pOv6zOYfUl5qo4Jy7748kDAcRfMyh04E=
Date:   Tue, 19 May 2020 09:55:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     kbuild test robot <lkp@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, jeffrey.t.kirsher@intel.com,
        kbuild-all@lists.01.org, maximmi@mellanox.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v3 07/15] i40e: separate kernel allocated rx_bi
 rings from AF_XDP rings
Message-ID: <20200519095539.570323c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c81b36a0-11dd-4b7f-fad8-85f31dced58c@intel.com>
References: <20200519085724.294949-8-bjorn.topel@gmail.com>
        <202005192351.j1H08VpV%lkp@intel.com>
        <c81b36a0-11dd-4b7f-fad8-85f31dced58c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 18:20:09 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
> On 2020-05-19 17:18, kbuild test robot wrote:
> > Hi "Bj=C3=B6rn,
> >=20
> > I love your patch! Perhaps something to improve:
> >=20
> > [auto build test WARNING on bpf-next/master]
> > [also build test WARNING on jkirsher-next-queue/dev-queue next-20200518]
> > [cannot apply to bpf/master linus/master v5.7-rc6]
> > [if your patch is applied to the wrong git tree, please drop us a note =
to help
> > improve the system. BTW, we also suggest to use '--base' option to spec=
ify the
> > base tree in git format-patch, please see https://stackoverflow.com/a/3=
7406982]
> >=20
> > url:    https://github.com/0day-ci/linux/commits/Bj-rn-T-pel/Introduce-=
AF_XDP-buffer-allocation-API/20200519-203122
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.gi=
t master
> > config: riscv-allyesconfig (attached as .config)
> > compiler: riscv64-linux-gcc (GCC) 9.3.0
> > reproduce:
> >          wget https://raw.githubusercontent.com/intel/lkp-tests/master/=
sbin/make.cross -O ~/bin/make.cross
> >          chmod +x ~/bin/make.cross
> >          # save the attached .config to linux build tree
> >          COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-9.3.0 make.c=
ross ARCH=3Driscv
> >=20
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kbuild test robot <lkp@intel.com>
> >=20
> > All warnings (new ones prefixed by >>, old ones prefixed by <<):
> >  =20
> >>> drivers/net/ethernet/intel/i40e/i40e_txrx.c:531:6: warning: no previo=
us prototype for 'i40e_fd_handle_status' [-Wmissing-prototypes] =20
> > 531 | void i40e_fd_handle_status(struct i40e_ring *rx_ring, u64 qword0_=
raw,
> > |      ^~~~~~~~~~~~~~~~~~~~~
> > =20
>=20
> Yes, this could indeed be made static. Hmm, I wonder why I didn't get
> that warning on my x86-64 build!? I'll spin a v4 (or do a follow-up?).
>=20
>=20
> Bj=C3=B6rn

While at it I also get this on patch 11 (gcc-10, W=3D1):

drivers/net/ethernet/mellanox/mlx5/core/en_main.c: In function mlx5e_alloc_=
rq:
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:376:6: warning: variable =
num_xsk_frames set but not used [-Wunused-but-set-variable]
   376 |  u32 num_xsk_frames =3D 0;
       |      ^~~~~~~~~~~~~~
