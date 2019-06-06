Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 322E437D64
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 21:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfFFTl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 15:41:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbfFFTl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 15:41:26 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E3DA12F8BE2;
        Thu,  6 Jun 2019 19:41:15 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3968A6A253;
        Thu,  6 Jun 2019 19:41:06 +0000 (UTC)
Date:   Thu, 6 Jun 2019 21:41:05 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next 1/2] xdp: Add tracepoint for bulk XDP_TX
Message-ID: <20190606214105.6bf2f873@carbon>
In-Reply-To: <abd43c39-afb7-acd4-688a-553cec76f55c@gmail.com>
References: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
        <20190605053613.22888-2-toshiaki.makita1@gmail.com>
        <20190605095931.5d90b69c@carbon>
        <abd43c39-afb7-acd4-688a-553cec76f55c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 06 Jun 2019 19:41:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 20:04:20 +0900
Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:

> On 2019/06/05 16:59, Jesper Dangaard Brouer wrote:
> > On Wed,  5 Jun 2019 14:36:12 +0900
> > Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
> >   
> >> This is introduced for admins to check what is happening on XDP_TX when
> >> bulk XDP_TX is in use, which will be first introduced in veth in next
> >> commit.  
> > 
> > Is the plan that this tracepoint 'xdp:xdp_bulk_tx' should be used by
> > all drivers?  
> 
> I guess you mean all drivers that implement similar mechanism should use 
> this? Then yes.
> (I don't think all drivers needs bulk tx mechanism though)
> 
> > (more below)
> >   
> >> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
> >> ---
> >>   include/trace/events/xdp.h | 25 +++++++++++++++++++++++++
> >>   kernel/bpf/core.c          |  1 +
> >>   2 files changed, 26 insertions(+)
> >>
> >> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
> >> index e95cb86..e06ea65 100644
> >> --- a/include/trace/events/xdp.h
> >> +++ b/include/trace/events/xdp.h
> >> @@ -50,6 +50,31 @@
> >>   		  __entry->ifindex)
> >>   );
> >>   
> >> +TRACE_EVENT(xdp_bulk_tx,
> >> +
> >> +	TP_PROTO(const struct net_device *dev,
> >> +		 int sent, int drops, int err),
> >> +
> >> +	TP_ARGS(dev, sent, drops, err),
> >> +
> >> +	TP_STRUCT__entry(  
> > 
> > All other tracepoints in this file starts with:
> > 
> > 		__field(int, prog_id)
> > 		__field(u32, act)
> > or
> > 		__field(int, map_id)
> > 		__field(u32, act)
> > 
> > Could you please add those?  
> 
> So... prog_id is the problem. The program can be changed while we are 
> enqueueing packets to the bulk queue, so the prog_id at flush may be an 
> unexpected one.

Hmmm... that sounds problematic, if the XDP bpf_prog for veth can
change underneath, before the flush.  Our redirect system, depend on
things being stable until the xdp_do_flush_map() operation, as will
e.g. set per-CPU (bpf_redirect_info) map_to_flush pointer (which depend
on XDP prog), and expect it to be correct/valid.


> It can be fixed by disabling NAPI when changing XDP programs. This stops 
> packet processing while changing XDP programs, but I guess it is an 
> acceptable compromise. Having said that, I'm honestly not so eager to 
> make this change, since this will require refurbishment of one of the 
> most delicate part of veth XDP, NAPI disabling/enabling mechanism.
> 
> WDYT?

Sound like a bug, if XDP bpf_prog is not stable within the NAPI poll...

 
> >> +		__field(int, ifindex)
> >> +		__field(int, drops)
> >> +		__field(int, sent)
> >> +		__field(int, err)
> >> +	),  
> > 
> > The reason is that this make is easier to attach to multiple
> > tracepoints, and extract the same value.
> > 
> > Example with bpftrace oneliner:
> > 
> > $ sudo bpftrace -e 'tracepoint:xdp:xdp_* { @action[args->act] = count(); }'

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
