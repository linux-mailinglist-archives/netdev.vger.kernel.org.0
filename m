Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7297213A232
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 08:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgANHjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 02:39:16 -0500
Received: from mga05.intel.com ([192.55.52.43]:51400 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbgANHjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 02:39:16 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 23:39:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,432,1571727600"; 
   d="scan'208";a="423071642"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jan 2020 23:39:12 -0800
Date:   Tue, 14 Jan 2020 01:31:58 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bjorn.topel@gmail.com, bpf@vger.kernel.org, toke@redhat.com,
        toshiaki.makita1@gmail.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [bpf-next PATCH v2 2/2] bpf: xdp, remove no longer required
 rcu_read_{un}lock()
Message-ID: <20200114003158.GA6804@ranger.igk.intel.com>
References: <157879606461.8200.2816751890292483534.stgit@john-Precision-5820-Tower>
 <157879666276.8200.5529955400195897154.stgit@john-Precision-5820-Tower>
 <20200112064948.GA24292@ranger.igk.intel.com>
 <5e1d34bfbf1f5_78752af1940225b41c@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e1d34bfbf1f5_78752af1940225b41c@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 07:25:51PM -0800, John Fastabend wrote:
> Maciej Fijalkowski wrote:
> > On Sat, Jan 11, 2020 at 06:37:42PM -0800, John Fastabend wrote:
> > > Now that we depend on rcu_call() and synchronize_rcu() to also wait

one last thing since you'll be sending a v3, s/rcu_call/call_rcu.

> > > for preempt_disabled region to complete the rcu read critical section
> > > in __dev_map_flush() is no longer required. Except in a few special
> > > cases in drivers that need it for other reasons.
> > > 
> > > These originally ensured the map reference was safe while a map was
> > > also being free'd. And additionally that bpf program updates via
> > > ndo_bpf did not happen while flush updates were in flight. But flush
> > > by new rules can only be called from preempt-disabled NAPI context.
> > > The synchronize_rcu from the map free path and the rcu_call from the
> > > delete path will ensure the reference there is safe. So lets remove
> > > the rcu_read_lock and rcu_read_unlock pair to avoid any confusion
> > > around how this is being protected.
> > > 
> > > If the rcu_read_lock was required it would mean errors in the above
> > > logic and the original patch would also be wrong.
> > > 
> > > Now that we have done above we put the rcu_read_lock in the driver
> > > code where it is needed in a driver dependent way. I think this
> > > helps readability of the code so we know where and why we are
> > > taking read locks. Most drivers will not need rcu_read_locks here
> > > and further XDP drivers already have rcu_read_locks in their code
> > > paths for reading xdp programs on RX side so this makes it symmetric
> > > where we don't have half of rcu critical sections define in driver
> > > and the other half in devmap.
> > > 
> > > Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
> > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > > ---
> 
> [...]
> 
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 4d7d5434..2c11f82 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -498,12 +498,16 @@ static int virtnet_xdp_xmit(struct net_device *dev,
> > >  	void *ptr;
> > >  	int i;
> > >  
> > > +	rcu_read_lock();
> > > +
> > >  	/* Only allow ndo_xdp_xmit if XDP is loaded on dev, as this
> > >  	 * indicate XDP resources have been successfully allocated.
> > >  	 */
> > >  	xdp_prog = rcu_dereference(rq->xdp_prog);
> > 
> > We could convert that rcu_dereference to rcu_access_pointer so that we
> > don't need the rcu critical section here at all. Actually this was
> > suggested some time ago by David Ahern during the initial discussion
> > around this code. Not sure why we didn't change it.
> 
> Makes sense I'll send a v3 with a middle patch to do this and then drop
> this segment.

Great :)

> 
> > 
> > Veth is also checking the xdp prog presence and it is doing that via
> > rcu_access_pointer so such conversion would make it more common, no?
> 
> veth derefernces rcv netdevice and this accesses it. The logic to
> drop the rcu here is less obvious to me. At least I would have to
> study it closely.

Veth does two rcu derefs in the veth_xmit, one for netdev and one for
xdp_prog and I was referring to a xdp_prog deref which is done via
rcu_access_pointer. So yeah we need to keep the rcu section in there but I
was just making an argument for having the rcu_access_pointer on the
virtio_net side.

> 
> > 
> > xdp_prog is only check against NULL, so quoting the part of comment from
> > rcu_access_pointer:
> > "This is useful when the value of this pointer is accessed, but the pointer
> > is not dereferenced, for example, when testing an RCU-protected pointer
> > against NULL."
> 
> +1 thanks it does make the cleanup nicer.
