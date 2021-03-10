Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575CF333816
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhCJJDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:03:54 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:55825 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232356AbhCJJDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 04:03:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0URGKjCI_1615367021;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0URGKjCI_1615367021)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Mar 2021 17:03:41 +0800
Date:   Wed, 10 Mar 2021 17:03:40 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     davem@davemloft.net, mingo@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
Message-ID: <YEiLbLiXe6ju/vCO@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
 <20210309124011.709c6cd3@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309124011.709c6cd3@gandalf.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 12:40:11PM -0500, Steven Rostedt wrote:
> On Tue,  9 Mar 2021 12:43:50 +0800
> Tony Lu <tonylu@linux.alibaba.com> wrote:
> 
> > There are lots of net namespaces on the host runs containers like k8s.
> > It is very common to see the same interface names among different net
> > namespaces, such as eth0. It is not possible to distinguish them without
> > net namespace inode.
> > 
> > This adds net namespace inode for all net_dev events, help us
> > distinguish between different net devices.
> > 
> > Output:
> >   <idle>-0       [006] ..s.   133.306989: net_dev_xmit: net_inum=4026531992 dev=eth0 skbaddr=0000000011a87c68 len=54 rc=0
> > 
> > Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> > ---
> >  include/trace/events/net.h | 35 +++++++++++++++++++++++++----------
> >  1 file changed, 25 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/trace/events/net.h b/include/trace/events/net.h
> > index 2399073c3afc..a52f90d83411 100644
> > --- a/include/trace/events/net.h
> > +++ b/include/trace/events/net.h
> > @@ -35,6 +35,7 @@ TRACE_EVENT(net_dev_start_xmit,
> >  		__field(	u16,			gso_size	)
> >  		__field(	u16,			gso_segs	)
> >  		__field(	u16,			gso_type	)
> > +		__field(	unsigned int,		net_inum	)
> >  	),
> 
> This patch made me take a look at the net_dev_start_xmit trace event, and I
> see it's very "holy". That is, it has lots of holes in the structure.
> 
> 	TP_STRUCT__entry(
> 		__string(	name,			dev->name	)
> 		__field(	u16,			queue_mapping	)
> 		__field(	const void *,		skbaddr		)
> 		__field(	bool,			vlan_tagged	)
> 		__field(	u16,			vlan_proto	)
> 		__field(	u16,			vlan_tci	)
> 		__field(	u16,			protocol	)
> 		__field(	u8,			ip_summed	)
> 		__field(	unsigned int,		len		)
> 		__field(	unsigned int,		data_len	)
> 		__field(	int,			network_offset	)
> 		__field(	bool,			transport_offset_valid)
> 		__field(	int,			transport_offset)
> 		__field(	u8,			tx_flags	)
> 		__field(	u16,			gso_size	)
> 		__field(	u16,			gso_segs	)
> 		__field(	u16,			gso_type	)
> 		__field(	unsigned int,		net_inum	)
> 	),
> 
> If you look at /sys/kernel/tracing/events/net/net_dev_start_xmit/format
> 
> name: net_dev_start_xmit
> ID: 1581
> format:
> 	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
> 	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
> 	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
> 	field:int common_pid;	offset:4;	size:4;	signed:1;
> 
> 	field:__data_loc char[] name;	offset:8;	size:4;	signed:1;
> 	field:u16 queue_mapping;	offset:12;	size:2;	signed:0;
> 	field:const void * skbaddr;	offset:16;	size:8;	signed:0;
> 
> Notice, queue_mapping is 2 bytes at offset 12 (ends at offset 14), but
> skbaddr starts at offset 16. That means there's two bytes wasted.
> 
> 	field:bool vlan_tagged;	offset:24;	size:1;	signed:0;
> 	field:u16 vlan_proto;	offset:26;	size:2;	signed:0;
> 
> Another byte missing above (24 + 1 != 26)
> 
> 	field:u16 vlan_tci;	offset:28;	size:2;	signed:0;
> 	field:u16 protocol;	offset:30;	size:2;	signed:0;
> 	field:u8 ip_summed;	offset:32;	size:1;	signed:0;
> 	field:unsigned int len;	offset:36;	size:4;	signed:0;
> 
> Again another three bytes missing (32 + 1 != 36)
> 
> 	field:unsigned int data_len;	offset:40;	size:4;	signed:0;
> 	field:int network_offset;	offset:44;	size:4;	signed:1;
> 	field:bool transport_offset_valid;	offset:48;	size:1;	signed:0;
> 	field:int transport_offset;	offset:52;	size:4;	signed:1;
> 
> Again, another 3 bytes missing (48 + 1 != 52)
> 
> 	field:u8 tx_flags;	offset:56;	size:1;	signed:0;
> 	field:u16 gso_size;	offset:58;	size:2;	signed:0;
> 
> Another byte missing (56 + 1 != 58)
> 
> 	field:u16 gso_segs;	offset:60;	size:2;	signed:0;	
> 	field:u16 gso_type;	offset:62;	size:2;	signed:0;
> 	field:unsigned int net_inum;	offset:64;	size:4;	signed:0;
> 
> The above shows 10 bytes wasted for this event.
> 
> The order of the fields is important. Don't worry about breaking API by
> fixing it. The parsing code uses this output to find where the binary data
> is.
> 
> Hmm, I should write a script that reads all the format files and point out
> areas that have holes in it.

I use pahole to read vmlinux.o directly with defconfig and
CONFIG_DEBUG_INFO enabled, the result shows 22 structs prefixed with
trace_event_raw_ that have at least one hole.

Command:
	# structs have at least one hole and can be packed
	pahole vmlinux.o -H 1 -R -P -y trace_event_raw_ > output.txt

	# details (result includes above)
	pahole vmlinux.o -H 1 -y trace_event_raw_ > output_detail.txt

Here is the lists (>= 1 hole and can be packed, #1 size, #2 ):

	trace_event_raw_mm_shrink_slab_start    80      72      8
	trace_event_raw_mm_shrink_slab_end      64      56      8
	trace_event_raw_percpu_alloc_percpu     56      48      8
	trace_event_raw_writeback_inode_template        48      40      8
	trace_event_raw_filelock_lock   88      80      8
	trace_event_raw_iomap_apply     72      64      8
	trace_event_raw_ext4__map_blocks_exit   56      48      8
	trace_event_raw_ext4_ext_rm_leaf        64      56      8
	trace_event_raw_ext4_ext_remove_space_done      64      56      8
	trace_event_raw_nfs_rename_event_done   56      48      8
	trace_event_raw_nfs4_rename     56      48      8
	trace_event_raw_net_dev_start_xmit      72      64      8
	trace_event_raw_net_dev_rx_verbose_template     88      72      16
	trace_event_raw_tcp_probe       120     112     8
	trace_event_raw_qdisc_dequeue   64      56      8
	trace_event_raw_rpc_xdr_alignment       88      80      8
	trace_event_raw_rdev_return_int_mesh_config     108     104     4
	trace_event_raw_rdev_update_mesh_config 128     120     8
	trace_event_raw_rdev_get_ftm_responder_stats    120     112     8
	trace_event_raw_drv_bss_info_changed    184     168     16
	trace_event_raw_drv_ampdu_action        88      80      8
	trace_event_raw_drv_tdls_recv_channel_switch    112     104     8


Here is the detail (net_dev_start_xmit as example):

	struct trace_event_raw_net_dev_start_xmit {
	        struct trace_entry         ent;                  /*     0     8 */
	        u32                        __data_loc_name;      /*     8     4 */
	        u16                        queue_mapping;        /*    12     2 */
	
	        /* XXX 2 bytes hole, try to pack */
	
	        const void  *              skbaddr;              /*    16     8 */
	        bool                       vlan_tagged;          /*    24     1 */
	
	        /* XXX 1 byte hole, try to pack */
	
	        u16                        vlan_proto;           /*    26     2 */
	        u16                        vlan_tci;             /*    28     2 */
	        u16                        protocol;             /*    30     2 */
	        u8                         ip_summed;            /*    32     1 */
	
	        /* XXX 3 bytes hole, try to pack */
	
	        unsigned int               len;                  /*    36     4 */
	        unsigned int               data_len;             /*    40     4 */
	        int                        network_offset;       /*    44     4 */
	        bool                       transport_offset_valid; /*    48     1 */
	
	        /* XXX 3 bytes hole, try to pack */
	
	        int                        transport_offset;     /*    52     4 */
	        u8                         tx_flags;             /*    56     1 */
	
	        /* XXX 1 byte hole, try to pack */
	
	        u16                        gso_size;             /*    58     2 */
	        u16                        gso_segs;             /*    60     2 */
	        u16                        gso_type;             /*    62     2 */
	        /* --- cacheline 1 boundary (64 bytes) --- */
	        unsigned int               net_inum;             /*    64     4 */
	        char                       __data[];             /*    68     0 */
	
	        /* size: 72, cachelines: 2, members: 20 */
	        /* sum members: 58, holes: 5, sum holes: 10 */
	        /* padding: 4 */
	        /* last cacheline: 8 bytes */
	};

pahole shows there are 5 holes with 10 bytes in net_dev_start_xmit event.


Cheers,
Tony Lu

> 
> I haven't looked at the other trace events, but they may all have the same
> issues.
> 
> -- Steve
> 
> 
> 
> >  
> >  	TP_fast_assign(
> > @@ -56,10 +57,12 @@ TRACE_EVENT(net_dev_start_xmit,
> >  		__entry->gso_size = skb_shinfo(skb)->gso_size;
> >  		__entry->gso_segs = skb_shinfo(skb)->gso_segs;
> >  		__entry->gso_type = skb_shinfo(skb)->gso_type;
> > +		__entry->net_inum = dev_net(skb->dev)->ns.inum;
> >  	),
> >  
> >
