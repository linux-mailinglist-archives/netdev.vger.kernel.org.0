Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB0C3450A8
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhCVUWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:22:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:45158 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231561AbhCVUVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:21:41 -0400
IronPort-SDR: cLB16DqE+dUk1BlKhV0XHgsNjnKI88v8hA1w35OH/nmOaGdc6Rl/xMHAtFRwfJlMJh+sxir5Gk
 iX4k9Jgz8dGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="170303850"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="170303850"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:21:40 -0700
IronPort-SDR: VQu0Y+l03mddMLZ8vDsV2Xyi2fWYu3xgHmIVxZhUOVTXT3r7Gy62a1C8CQz191O20VKsQGTxrN
 +MuD67W905ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="451857172"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga001.jf.intel.com with ESMTP; 22 Mar 2021 13:21:37 -0700
Date:   Mon, 22 Mar 2021 21:11:02 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        ciara.loftus@intel.com, john fastabend <john.fastabend@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH v2 bpf-next 14/17] selftests: xsk: implement bpf_link test
Message-ID: <20210322201102.GC56104@ranger.igk.intel.com>
References: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
 <20210311152910.56760-15-maciej.fijalkowski@intel.com>
 <CAEf4BzZDW8V0SPzqWksR8fg=8xShvRQdN3rJr_H3zm-VoXtdNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZDW8V0SPzqWksR8fg=8xShvRQdN3rJr_H3zm-VoXtdNw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 10:39:38PM -0700, Andrii Nakryiko wrote:
> On Thu, Mar 11, 2021 at 7:43 AM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > Introduce a test that is supposed to verify the persistence of BPF
> > resources based on underlying bpf_link usage.
> >
> > Test will:
> > 1) create and bind two sockets on queue ids 0 and 1
> > 2) run a traffic on queue ids 0
> > 3) remove xsk sockets from queue 0 on both veth interfaces
> > 4) run a traffic on queues ids 1
> >
> > Running traffic successfully on qids 1 means that BPF resources were
> > not removed on step 3).
> >
> > In order to make it work, change the command that creates veth pair to
> > have the 4 queue pairs by default.
> >
> > Introduce the arrays of xsks and umems to ifobject struct but keep a
> > pointers to single entities, so rest of the logic around Rx/Tx can be
> > kept as-is.
> >
> > For umem handling, double the size of mmapped space and split that
> > between the two sockets.
> >
> > Rename also bidi_pass to a variable 'second_step' of a boolean type as
> > it's now used also for the test that is introduced here and it doesn't
> > have anything in common with bi-directional testing.
> >
> > Drop opt_queue command line argument as it wasn't working before anyway.
> >
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  tools/testing/selftests/bpf/test_xsk.sh  |   2 +-
> >  tools/testing/selftests/bpf/xdpxceiver.c | 179 +++++++++++++++++------
> >  tools/testing/selftests/bpf/xdpxceiver.h |   7 +-
> >  3 files changed, 138 insertions(+), 50 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
> > index 56d4474e2c83..2a00b8222475 100755
> > --- a/tools/testing/selftests/bpf/test_xsk.sh
> > +++ b/tools/testing/selftests/bpf/test_xsk.sh
> > @@ -107,7 +107,7 @@ setup_vethPairs() {
> >                 echo "setting up ${VETH0}: namespace: ${NS0}"
> >         fi
> >         ip netns add ${NS1}
> > -       ip link add ${VETH0} type veth peer name ${VETH1}
> > +       ip link add ${VETH0} numtxqueues 4 numrxqueues 4 type veth peer name ${VETH1} numtxqueues 4 numrxqueues 4
> >         if [ -f /proc/net/if_inet6 ]; then
> >                 echo 1 > /proc/sys/net/ipv6/conf/${VETH0}/disable_ipv6
> >         fi
> > diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> > index aef5840e1c24..dc775ee139c5 100644
> > --- a/tools/testing/selftests/bpf/xdpxceiver.c
> > +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> > @@ -41,8 +41,12 @@
> >   *            Reduce the size of the RX ring to a fraction of the fill ring size.
> >   *       iv.  fill queue empty
> >   *            Do not populate the fill queue and then try to receive pkts.
> > + *    f. bpf_link resource persitence
> 
> typo: persistence

I'll fix it.

> 
> > + *       Configure sockets at indexes 0 and 1,run a traffic on queue ids 0,
> 
> while I'm here nitting :) space after comma?

I like nitpicking, yeah let's add that space.

> 
> > + *       then remove xsk sockets from queue 0 on both veth interfaces and
> > + *       finally run a traffic on queues ids 1
> >   *
> > - * Total tests: 10
> > + * Total tests: 12
> >   *
> >   * Flow:
> >   * -----
> 
> [...]
