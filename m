Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E460394042
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 11:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhE1Jqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 05:46:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:64277 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233627AbhE1Jqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 05:46:52 -0400
IronPort-SDR: HBTuBQHQ/0t2y5zunYjqNRqYSXRHMjW8OMNMOz5trSJD+HwtWPZtcO45HZutHdik0DUfvipjVR
 gQhhFs8IoWHA==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="202964727"
X-IronPort-AV: E=Sophos;i="5.83,229,1616482800"; 
   d="scan'208";a="202964727"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2021 02:45:18 -0700
IronPort-SDR: WE4PVVAbBZlVB5NlbLi6QHRXSH3Smvo5TU3dhnTl/PW347qWoMt8wZdrrO3tRKMmWUJtV+y6wq
 ttRWH4xJpHfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,229,1616482800"; 
   d="scan'208";a="548533848"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 28 May 2021 02:45:13 -0700
Date:   Fri, 28 May 2021 11:32:13 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xie He <xie.he.0141@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Wang Hai <wanghai38@huawei.com>,
        Tanner Love <tannerlove@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] xsk: support AF_PACKET
Message-ID: <20210528093213.GB46923@ranger.igk.intel.com>
References: <1622192521.5931044-1-xuanzhuo@linux.alibaba.com>
 <87cztbgqfv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87cztbgqfv.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 11:25:56AM +0200, Toke Høiland-Jørgensen wrote:
> Xuan Zhuo <xuanzhuo@linux.alibaba.com> writes:
> 
> > On Fri, 28 May 2021 10:55:58 +0200, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >> Xuan Zhuo <xuanzhuo@linux.alibaba.com> writes:
> >>
> >> > In xsk mode, users cannot use AF_PACKET(tcpdump) to observe the current
> >> > rx/tx data packets. This feature is very important in many cases. So
> >> > this patch allows AF_PACKET to obtain xsk packages.
> >>
> >> You can use xdpdump to dump the packets from the XDP program before it
> >> gets redirected into the XSK:
> >> https://github.com/xdp-project/xdp-tools/tree/master/xdp-dump
> >
> > Wow, this is a good idea.
> >
> >>
> >> Doens't currently work on egress, but if/when we get a proper TX hook
> >> that should be doable as well.
> >>
> >> Wiring up XSK to AF_PACKET sounds a bit nonsensical: XSK is already a
> >> transport to userspace, why would you need a second one?
> >
> > I have some different ideas. In my opinion, just like AF_PACKET can monitor
> > tcp/udp packets, AF_PACKET monitors xsk packets is the same.
> 
> But you're adding code in the fast path to do this, in a code path where
> others have been working quite hard to squeeze out every drop of
> performance (literally chasing single nanoseconds). So I'm sorry, but
> this approach is just not going to fly.

+1. Probably would be better for everyone if Xuan started a thread on list
what is his need.

> 
> What is your use case anyway? Yes, being able to run tcpdump and see the
> packets is nice and convenient, but what do you actually want to use
> this for? Just for debugging your application? System monitoring?
> Something else?
> 
> -Toke
> 
