Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD61141F94D
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 04:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhJBCJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 22:09:35 -0400
Received: from mga17.intel.com ([192.55.52.151]:56313 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232278AbhJBCJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 22:09:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="205789257"
X-IronPort-AV: E=Sophos;i="5.85,340,1624345200"; 
   d="scan'208";a="205789257"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 19:07:49 -0700
X-IronPort-AV: E=Sophos;i="5.85,340,1624345200"; 
   d="scan'208";a="619627588"
Received: from rli9-mobl1.ccr.corp.intel.com ([10.249.172.70])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 19:07:42 -0700
Date:   Sat, 2 Oct 2021 10:07:37 +0800
From:   Philip Li <philip.li@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     kernel test robot <lkp@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kbuild-all@lists.01.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Zhang, Qi Z" <qi.z.zhang@intel.com>
Subject: Re: [kbuild-all] Re: [PATCH bpf-next v3 06/10] xsk: propagate
 napi_id to XDP socket Rx path
Message-ID: <20211002020737.GE26462@rli9-MOBL1.ccr.corp.intel.com>
References: <20201119083024.119566-7-bjorn.topel@gmail.com>
 <202109300212.l6Ky1gNu-lkp@intel.com>
 <CAJ8uoz3g6wzkTYRb4qq4aj+KDVGUfyZ6O6NkMK_t-EBp07igOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ8uoz3g6wzkTYRb4qq4aj+KDVGUfyZ6O6NkMK_t-EBp07igOg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 08:04:06AM +0200, Magnus Karlsson wrote:
> On Wed, Sep 29, 2021 at 8:37 PM kernel test robot <lkp@intel.com> wrote:
> >
> > Hi "Björn,
> >
> > I love your patch! Yet something to improve:
> >
> > [auto build test ERROR on 4e99d115d865d45e17e83478d757b58d8fa66d3c]
> >
> > url:    https://github.com/0day-ci/linux/commits/Bj-rn-T-pel/Introduce-preferred-busy-polling/20210929-234934
> > base:   4e99d115d865d45e17e83478d757b58d8fa66d3c
> > config: um-kunit_defconfig (attached as .config)
> > compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> > reproduce (this is a W=1 build):
> >         # https://github.com/0day-ci/linux/commit/f481c00164924dd5d782a92cc67897cc7f804502
> >         git remote add linux-review https://github.com/0day-ci/linux
> >         git fetch --no-tags linux-review Bj-rn-T-pel/Introduce-preferred-busy-polling/20210929-234934
> >         git checkout f481c00164924dd5d782a92cc67897cc7f804502
> >         # save the attached .config to linux build tree
> >         mkdir build_dir
> >         make W=1 O=build_dir ARCH=um SHELL=/bin/bash
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All errors (new ones prefixed by >>):
> >
> >    cc1: warning: arch/um/include/uapi: No such file or directory [-Wmissing-include-dirs]
> >    In file included from fs/select.c:32:
> >    include/net/busy_poll.h: In function 'sk_mark_napi_id_once':
> > >> include/net/busy_poll.h:150:36: error: 'const struct sk_buff' has no member named 'napi_id'
> >      150 |  __sk_mark_napi_id_once_xdp(sk, skb->napi_id);
> >          |                                    ^~
> >
> >
> > vim +150 include/net/busy_poll.h
> >
> >    145
> >    146  /* variant used for unconnected sockets */
> >    147  static inline void sk_mark_napi_id_once(struct sock *sk,
> >    148                                          const struct sk_buff *skb)
> >    149  {
> >  > 150          __sk_mark_napi_id_once_xdp(sk, skb->napi_id);
> >    151  }
> >    152
> 
> It seems that the robot tested an old commit and that this was already
> fixed by Daniel 10 months ago. Slow mail delivery, a robot glitch, or
> am I missing something?
sorry for the noise, we got storage crash and it seems to have old data
back in test queue after recovery. We will do cleanup to avoid this kind
of old commit being tested.

> 
> commit ba0581749fec389e55c9d761f2716f8fcbefced5
> Author: Daniel Borkmann <daniel@iogearbox.net>
> Date:   Tue Dec 1 15:22:59 2020 +0100
> 
>     net, xdp, xsk: fix __sk_mark_napi_id_once napi_id error
> 
>     Stephen reported the following build error for !CONFIG_NET_RX_BUSY_POLL
>     built kernels:
> 
>       In file included from fs/select.c:32:
>       include/net/busy_poll.h: In function 'sk_mark_napi_id_once':
>       include/net/busy_poll.h:150:36: error: 'const struct sk_buff'
> has no member named 'napi_id'
>         150 |  __sk_mark_napi_id_once_xdp(sk, skb->napi_id);
>             |                                    ^~
> 
>     Fix it by wrapping a CONFIG_NET_RX_BUSY_POLL around the helpers.
> 
>     Fixes: b02e5a0ebb17 ("xsk: Propagate napi_id to XDP socket Rx path")
>     Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>     Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>     Cc: Björn Töpel <bjorn.topel@intel.com>
>     Link: https://lore.kernel.org/linux-next/20201201190746.7d3357fb@canb.auug.org.au
> 
> 
> > ---
> > 0-DAY CI Kernel Test Service, Intel Corporation
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org
