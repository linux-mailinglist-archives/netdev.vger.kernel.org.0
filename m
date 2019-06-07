Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A193871B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 11:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfFGJce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 05:32:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35128 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbfFGJcd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 05:32:33 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7105530C1206;
        Fri,  7 Jun 2019 09:32:31 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C02710A4B42;
        Fri,  7 Jun 2019 09:32:21 +0000 (UTC)
Date:   Fri, 7 Jun 2019 11:32:20 +0200
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
        Jason Wang <jasowang@redhat.com>, brouer@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 bpf-next 1/2] xdp: Add tracepoint for bulk XDP_TX
Message-ID: <20190607113220.1ea4093a@carbon>
In-Reply-To: <e0266202-5db6-123c-eba6-33e5c5c4ba6d@gmail.com>
References: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
        <20190605053613.22888-2-toshiaki.makita1@gmail.com>
        <20190605095931.5d90b69c@carbon>
        <abd43c39-afb7-acd4-688a-553cec76f55c@gmail.com>
        <20190606214105.6bf2f873@carbon>
        <e0266202-5db6-123c-eba6-33e5c5c4ba6d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 07 Jun 2019 09:32:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jun 2019 11:22:00 +0900
Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:

> On 2019/06/07 4:41, Jesper Dangaard Brouer wrote:
> > On Thu, 6 Jun 2019 20:04:20 +0900
> > Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
> >   
> >> On 2019/06/05 16:59, Jesper Dangaard Brouer wrote:  
> >>> On Wed,  5 Jun 2019 14:36:12 +0900
> >>> Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
> >>>      
[...]
> >>
> >> So... prog_id is the problem. The program can be changed while we are
> >> enqueueing packets to the bulk queue, so the prog_id at flush may be an
> >> unexpected one.  
> > 
> > Hmmm... that sounds problematic, if the XDP bpf_prog for veth can
> > change underneath, before the flush.  Our redirect system, depend on
> > things being stable until the xdp_do_flush_map() operation, as will
> > e.g. set per-CPU (bpf_redirect_info) map_to_flush pointer (which depend
> > on XDP prog), and expect it to be correct/valid.  
> 
> Sorry, I don't get how maps depend on programs.

BPF/XDP programs have a reference count on the map (e.g. used for
redirect) and when the XDP is removed, and last refcnt for the map is
reached, then the map is also removed (redirect maps does a call_rcu
when shutdown).

> At least xdp_do_redirect_map() handles map_to_flush change during NAPI. 
> Is there a problem when the map is not changed but the program is changed?
> Also I believe this is not veth-specific behavior. Looking at tun and 
> i40e, they seem to change xdp_prog without stopping data path.
 
I guess this could actually happen, but we are "saved" by the
'map_to_flush' (pointer) is still valid due to RCU protection.

But it does look fishy, as our rcu_read_lock's does not encapsulation
this. There is RCU-read-section in veth_xdp_rcv_skb(), which via can
call xdp_do_redirect() which set per-CPU ri->map_to_flush.  

Do we get this protection by running under softirq, and does this
prevent an RCU grace-period (call_rcu callbacks) from happening?
(between veth_xdp_rcv_skb() and xdp_do_flush_map() in veth_poll())


To Toshiaki, regarding your patch 2/2, you are not affected by this
per-CPU map storing, as you pass along the bulk-queue.  I do see you
point, with prog_id could change.  Could you change the tracepoint to
include the 'act' and place 'ifindex' above this in the struct, this way
the 'act' member is in the same location/offset as other XDP
tracepoints.  I see the 'ifindex' as the identifier for this tracepoint
(other have map_id or prog_id in this location).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
