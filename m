Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4FD36FC57
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 16:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhD3O1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 10:27:34 -0400
Received: from mga17.intel.com ([192.55.52.151]:60848 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232744AbhD3O1d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 10:27:33 -0400
IronPort-SDR: nWJsUSrtVaaARLB4GEm82EqfMHw4wCQpoTOTZbE6gAa3tUIXidN0nPCyoWzfChQiP5DR0IsRoL
 Zz3r4Ihyrw7A==
X-IronPort-AV: E=McAfee;i="6200,9189,9970"; a="177445031"
X-IronPort-AV: E=Sophos;i="5.82,262,1613462400"; 
   d="scan'208";a="177445031"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2021 07:26:44 -0700
IronPort-SDR: FpLhH5+6gPxNJ4wUipHQWI3uUhKQf+RYGfkXYsiU3KmMeCV/wIMQ27smUjSKWiazWhA7kUCBFZ
 2bxM7AWFfdgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,262,1613462400"; 
   d="scan'208";a="466836089"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 30 Apr 2021 07:26:39 -0700
Received: from alobakin-mobl.ger.corp.intel.com (jficek-mobl.ger.corp.intel.com [10.213.24.214])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 13UEQbtf016736;
        Fri, 30 Apr 2021 15:26:37 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        "Desouza, Ederson" <ederson.desouza@intel.com>,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        David Ahern <dsahern@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jens Steen Krogh <jskro@vestas.com>,
        Joao Pedro Barros Silva <jopbs@vestas.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PTP RX & TX time-stamp and TX Time in XDP ZC socket
Date:   Fri, 30 Apr 2021 16:26:35 +0200
Message-Id: <20210430142635.3791-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423183731.7279808a@carbon>
References: <DM6PR11MB27800045D6EE4A69B1A65C45CA479@DM6PR11MB2780.namprd11.prod.outlook.com> <20210421103948.5a453e6d@carbon> <DM6PR11MB2780B29F0045B76119AFC388CA469@DM6PR11MB2780.namprd11.prod.outlook.com> <20210423183731.7279808a@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Fri, 23 Apr 2021 18:37:31 +0200

> Cc, netdev, as I think we get upstream feedback as early as possible.
> (Maybe Alexei will be critique my idea of storing btf_id in struct?)
> 
> 
> On Thu, 22 Apr 2021 07:34:23 +0000
> "Ong, Boon Leong" <boon.leong.ong@intel.com> wrote:
> 
> > >> Now that stmmac driver has been added with XDP ZC, we would like
> > >> to know if there is any on-going POC or discussion on XDP ZC
> > >> socket for adding below:
> > >>
> > >> 1) PTP RX & TX time-stamp
> > >> 2) Per-packet TX transmit time (similar to SO_TXTIME)  
> > >
> > > Well, this is actually perfect timing! (pun intended)
> > >
> > > I'm actually going to work on adding this to XDP.  I was reading igc
> > > driver and i225 sw datasheet last night, trying to figure out a design
> > > based on what hardware can do. My design ideas obviously involve BTF,
> > > but a lot of missing pieces like an XDP TX hook is also missing.  
> > 
> > Currently, we are using a non-standard/not elegant way to provide for 
> > internal real-time KPI measurement purpose as follow 
> >
> > 1) TX time stored in a newly introduced 64-bit timestamp in XDP descriptor.
> 
> Did you create a separate XDP descriptor?
> If so what memory is backing that?
> 
> My idea[1] is to use the meta-data area (xdp_buff->data_meta), that is
> located in-front of the packet headers.  Or the area in top of the
> "packet" memory, which is already used by struct xdp_frame, except that
> zero-copy AF_XDP don't have the xdp_frame.  Due to AF_XDP limits I'm
> leaning towards using xdp_buff->data_meta area.
> 
> [1] https://people.netfilter.org/hawk/presentations/KernelRecipes2019/xdp-netstack-concert.pdf
> 
> I should mention that I want a generic solution (based on BTF), that can
> support many types of hardware hints.  Like existing RX-hash, VLAN,
> checksum, mark and timestamps.  And newer HW hints that netstack
> doesn't support yet, e.g. I know mlx5 can assign unique (64-bit)
> flow-marks.
> 
> I should also mention that I also want the solution to work for (struct)
> xdp_frame packets that gets redirected from RX to TX.  And work when/if
> an xdp_frame gets converted to an SKB (happens for veth and cpumap)
> then the RX-hash, VLAN, checksum, mark, timestamp should be transferred
> to the SKB.

Hi, just to let you know,
We at Intel are currently working on flexible XDP hints that include
both generic (i.e. that every single driver/HW has) and custom
hints/metadata and are planning to publish a first RFC soon.
Feel free to join if you wish, we could cooperate and work together.

> > 2) RX T/S is stored in the meta-data of the RX frame.
> 
> Yes, I also want to store the RX-timestamp the meta-data area.  This
> means that RX-timestamp is stored memory-wise just before the packet
> header starts.
> 
> For AF_XDP how does the userspace program know that info is stored in
> this area(?).  As you know, it might only be some packets that contain
> the timestamp, e.g. for some NIC is it only the PTP packets.
> 
> I've discussed this with OVS VMware people before (they requested
> RX-hash), and in that discussion Bjørn came up with the idea, that the
> "-32 bit" could contain the BTF-id number.  Meaning the last u32 member
> of the metadata is btf_id (example below).
> 
>  struct my_metadata {
> 	u64 rx_timestamp;
> 	u32 rx_hash32;
> 	u32 btf_id;
>  };
> 
> When having the btf_id then the memory layout basically becomes self
> describing.  I guess, we still need a single bit in the AF_XDP
> RX-descriptor telling us that meta-data area is populated, or perhaps
> we should store the btf_id in the AF_XDP RX-descriptor?
> 
> Same goes for xdp_frame, should it store btf_id or have a single bit
> that says, btf_id is located in data_meta area.
> 
> > 3) TX T/S is simply trace_printk out as there is missing XDP TX hook
> >    like you pointed out.
> 
> Again I want to use BTF to describe that a driver supports of
> TX-timestamp features.  Like Saeed did for RX, the driver should export
> (a number) of BTF-id's that it support.
> 
> E.g when the LaunchTime features is configured;
> 
>  struct my_metadata_tx {
> 	u64 LaunchTime_ktime;
> 	u32 btf_id;
>  };
> 
> When AF_XDP (or xdp_frame) want to transmit a frame as a specific time,
> e.g. via LaunchTime feature in i210 (igb) and i225 (igc).
> 
> I've read up on i210 and i225 capabilities, and I think this will help
> us guide our design choices.  We need to support different BTF-desc per
> TX queue basis, because the LaunchTime is configured per TX queue, and
> further more, i210 only support this on queue 0 and 1.
> 
> Currently the LaunchTime config happens via TC config when attaching a
> ETF qdisc and doing TC-offloading.  For now, I'm not suggesting
> changing that.  Instead we can simply export/expose that the driver now
> support LaunchTime BTF-desc, when the config gets enabled.
> 
> 
> > So, if there is some ready work that we can evaluate, it will have us
> > greatly in extending it to stmmac driver. 
> 
> Saeed have done a number of different implementation attempts on RX
> side with BTF.  We might be able to leverage some of that work.  That
> said, the kernels BTF API have become more advanced since Saeed worked
> on this. Thus, I expect that we might be able to leverage some of this
> to simplify the approach.
> 
> 
> > >I have a practical project with a wind-turbine producer Vestas (they
> > >have even approved we can say this publicly on mailing lists). Thus, I
> > >can actually dedicate some time for this.
> > >
> > >You also have a practical project that needs this? (And I/we can keep it
> > >off the mailing lists if you prefer/need-to).  
> > 
> > Yes, we are about to start a a 3-way joint-development project that is
> > evaluating the suitability of using preempt-RT + XDP ZC + TSN for
> > integrating high level Industrial Ethernet stack on-top of Linux mainline
> > interface. So, there is couple of area that we will be looking into and
> > above two capabilities are foundational in adding "time-aware" to
> > XDP ZC interface.  But, our current focus on getting the Linux mainline
> > capability ready, so we can discuss in ML.
> 
> It sounds like our projects align very well! :-)))
> My customer also want the combination preempt-RT + XDP ZC + TSN.
> 
> > >My plans: I will try to understand the hardware and drivers better, and
> > >then I will work on a design proposal that I will share with you for
> > >review.
> > >
> > >What are your plans?  
> > 
> > Siang and myself are looking into this area starting next week and
> > hopefully our time is aligned and we are hopeful to get this
> > capability available in stmmac for next RC cycles. Is the time-line
> > aligned to yours?
> 
> Yes, this aligns with my time-line.  I want to start prototyping some
> things next week, so I can start to run experiments with TSN.  The
> TSN capable hardware for our PoC is being shipped to my house and
> should arrive next week.
> 
> Looking forward to collaborate with all of you.  You can let me know
> (offlist) if you prefer not getting Cc'ed on these mails. Some of you
> are bcc'ed and you have to opt-in if you are interested in collaborating.
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

Thanks,
Al
