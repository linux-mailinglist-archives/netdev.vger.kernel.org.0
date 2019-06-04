Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC8513443F
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 12:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfFDKRR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jun 2019 06:17:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727246AbfFDKRQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 06:17:16 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A877E3082DCE;
        Tue,  4 Jun 2019 10:17:15 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F399E5C89D;
        Tue,  4 Jun 2019 10:17:04 +0000 (UTC)
Date:   Tue, 4 Jun 2019 12:17:03 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "bjorn.topel@gmail.com" <bjorn.topel@gmail.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>, brouer@redhat.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
Message-ID: <20190604121703.2baa0c0c@carbon>
In-Reply-To: <f7e9b1c8f358a4bb83f01ab76dcc95195083e2bf.camel@mellanox.com>
References: <20190531094215.3729-1-bjorn.topel@gmail.com>
        <20190531094215.3729-2-bjorn.topel@gmail.com>
        <b0a9c3b198bdefd145c34e52aa89d33aa502aaf5.camel@mellanox.com>
        <20190601124233.5a130838@cakuba.netronome.com>
        <CAJ+HfNjbALzf4SaopKe3pA4dV6n9m30doai_CLEDB9XG2RzjOg@mail.gmail.com>
        <f7e9b1c8f358a4bb83f01ab76dcc95195083e2bf.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 04 Jun 2019 10:17:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 21:20:30 +0000
Saeed Mahameed <saeedm@mellanox.com> wrote:

> On Mon, 2019-06-03 at 11:04 +0200, Björn Töpel wrote:
> > On Sat, 1 Jun 2019 at 21:42, Jakub Kicinski
> > <jakub.kicinski@netronome.com> wrote:  
> > > On Fri, 31 May 2019 19:18:17 +0000, Saeed Mahameed wrote:  
> > > > On Fri, 2019-05-31 at 11:42 +0200, Björn Töpel wrote:  
> > > > > From: Björn Töpel <bjorn.topel@intel.com>
> > > > > 
> > > > > All XDP capable drivers need to implement the
> > > > > XDP_QUERY_PROG{,_HW} command of ndo_bpf. The query code is
> > > > > fairly generic. This commit refactors the query code up from
> > > > > the drivers to the netdev level.
> > > > > 
> > > > > The struct net_device has gained two new members: xdp_prog_hw
> > > > > and xdp_flags. The former is the offloaded XDP program, if
> > > > > any, and the latter tracks the flags that the supplied when
> > > > > attaching the XDP  program. The flags only apply to SKB_MODE
> > > > > or DRV_MODE, not HW_MODE.
> > > > > 
> > > > > The xdp_prog member, previously only used for SKB_MODE, is
> > > > > shared with DRV_MODE. This is OK, due to the fact that
> > > > > SKB_MODE and DRV_MODE are mutually exclusive. To
> > > > > differentiate between the two modes, a new internal flag is
> > > > > introduced as well.  
> > > > 
> > > > Just thinking out loud, why can't we allow any combination of
> > > > HW/DRV/SKB modes? they are totally different attach points in a
> > > > totally different checkpoints in a frame life cycle.  

The DRV_MODE and SKB_MODE is tricky to run concurrently. The XDP-redirect
scheme (designed by John) use a BPF helper (bpf_xdp_redirect_map) that
set global per-CPU state (this_cpu_ptr(&bpf_redirect_info)).

The tricky part (which I warned about, and we already have some fixes
for) is that the XDP/BPF-prog can call bpf_redirect_map, which update
the per-CPU state, but it can still choose not to return XDP_REDIRECT,
which then miss an invocation of xdp_do_redirect().  
 Later, your SKB_MODE XDP/BPF-prog can return XDP_REDIRECT without
calling the helper, and then use/reach to the per-CPU info set by the
DRV_MODE program, which is NOT something I want us to "support".


> > > FWIW see Message-ID: <20190201080236.446d84d4@redhat.com>
> > 
> > I've always seen the SKB-mode as something that will eventually be
> > removed.
> 
> I don't think so, we are too deep into SKB-mode.

I wish we could remove it.  After we got native XDP support in veth,
then its original purpose is gone, which were making it easier for
developers to get something working on their laptop, without having to
deploy it to the server with physical hardware all the time.


> > Clickable link:
> >  https://lore.kernel.org/netdev/20190201080236.446d84d4@redhat.com/
> > 
> 
> So we are all hanging on Jesper's refactoring ideas that are not
> getting any priority for now :).

Well, that is not true.  This patchset _is_ the refactor idea that
Bjørn is taking over and working on.  Specifically [2] from above link.

[2] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp_per_rxq01.org#refactor-idea-xdpbpf_prog-into-netdev_rx_queuenet_device
 
> > > > Down the road i think we will utilize this fact and start
> > > > introducing SKB helpers for SKB mode and driver helpers for DRV
> > > > mode..  
> > > 
> > > Any reason why we would want the extra complexity?  There is
> > > cls_bpf if someone wants skb features after all..  
> 
> Donno, SKB mode is earlier in the stack maybe .. 

From a BPF perspective you cannot introduce SKB helpers for SKB mode.
An XDP-prog have bpf prog type XDP (BPF_PROG_TYPE_XDP), and the program
itself is identical regardless of attaching for DRV_MODE or SKB_MODE.
You cannot detect this at attach time, due to tail-calls (which have
painted us into a corner).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
