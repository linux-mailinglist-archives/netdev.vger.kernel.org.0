Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34153332D6C
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 18:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhCIRkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 12:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230173AbhCIRkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 12:40:14 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5407A64FBD;
        Tue,  9 Mar 2021 17:40:13 +0000 (UTC)
Date:   Tue, 9 Mar 2021 12:40:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     davem@davemloft.net, mingo@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
Message-ID: <20210309124011.709c6cd3@gandalf.local.home>
In-Reply-To: <20210309044349.6605-1-tonylu@linux.alibaba.com>
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Mar 2021 12:43:50 +0800
Tony Lu <tonylu@linux.alibaba.com> wrote:

> There are lots of net namespaces on the host runs containers like k8s.
> It is very common to see the same interface names among different net
> namespaces, such as eth0. It is not possible to distinguish them without
> net namespace inode.
> 
> This adds net namespace inode for all net_dev events, help us
> distinguish between different net devices.
> 
> Output:
>   <idle>-0       [006] ..s.   133.306989: net_dev_xmit: net_inum=4026531992 dev=eth0 skbaddr=0000000011a87c68 len=54 rc=0
> 
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> ---
>  include/trace/events/net.h | 35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/include/trace/events/net.h b/include/trace/events/net.h
> index 2399073c3afc..a52f90d83411 100644
> --- a/include/trace/events/net.h
> +++ b/include/trace/events/net.h
> @@ -35,6 +35,7 @@ TRACE_EVENT(net_dev_start_xmit,
>  		__field(	u16,			gso_size	)
>  		__field(	u16,			gso_segs	)
>  		__field(	u16,			gso_type	)
> +		__field(	unsigned int,		net_inum	)
>  	),

This patch made me take a look at the net_dev_start_xmit trace event, and I
see it's very "holy". That is, it has lots of holes in the structure.

	TP_STRUCT__entry(
		__string(	name,			dev->name	)
		__field(	u16,			queue_mapping	)
		__field(	const void *,		skbaddr		)
		__field(	bool,			vlan_tagged	)
		__field(	u16,			vlan_proto	)
		__field(	u16,			vlan_tci	)
		__field(	u16,			protocol	)
		__field(	u8,			ip_summed	)
		__field(	unsigned int,		len		)
		__field(	unsigned int,		data_len	)
		__field(	int,			network_offset	)
		__field(	bool,			transport_offset_valid)
		__field(	int,			transport_offset)
		__field(	u8,			tx_flags	)
		__field(	u16,			gso_size	)
		__field(	u16,			gso_segs	)
		__field(	u16,			gso_type	)
		__field(	unsigned int,		net_inum	)
	),

If you look at /sys/kernel/tracing/events/net/net_dev_start_xmit/format

name: net_dev_start_xmit
ID: 1581
format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;

	field:__data_loc char[] name;	offset:8;	size:4;	signed:1;
	field:u16 queue_mapping;	offset:12;	size:2;	signed:0;
	field:const void * skbaddr;	offset:16;	size:8;	signed:0;

Notice, queue_mapping is 2 bytes at offset 12 (ends at offset 14), but
skbaddr starts at offset 16. That means there's two bytes wasted.

	field:bool vlan_tagged;	offset:24;	size:1;	signed:0;
	field:u16 vlan_proto;	offset:26;	size:2;	signed:0;

Another byte missing above (24 + 1 != 26)

	field:u16 vlan_tci;	offset:28;	size:2;	signed:0;
	field:u16 protocol;	offset:30;	size:2;	signed:0;
	field:u8 ip_summed;	offset:32;	size:1;	signed:0;
	field:unsigned int len;	offset:36;	size:4;	signed:0;

Again another three bytes missing (32 + 1 != 36)

	field:unsigned int data_len;	offset:40;	size:4;	signed:0;
	field:int network_offset;	offset:44;	size:4;	signed:1;
	field:bool transport_offset_valid;	offset:48;	size:1;	signed:0;
	field:int transport_offset;	offset:52;	size:4;	signed:1;

Again, another 3 bytes missing (48 + 1 != 52)

	field:u8 tx_flags;	offset:56;	size:1;	signed:0;
	field:u16 gso_size;	offset:58;	size:2;	signed:0;

Another byte missing (56 + 1 != 58)

	field:u16 gso_segs;	offset:60;	size:2;	signed:0;	
	field:u16 gso_type;	offset:62;	size:2;	signed:0;
	field:unsigned int net_inum;	offset:64;	size:4;	signed:0;

The above shows 10 bytes wasted for this event.

The order of the fields is important. Don't worry about breaking API by
fixing it. The parsing code uses this output to find where the binary data
is.

Hmm, I should write a script that reads all the format files and point out
areas that have holes in it.

I haven't looked at the other trace events, but they may all have the same
issues.

-- Steve



>  
>  	TP_fast_assign(
> @@ -56,10 +57,12 @@ TRACE_EVENT(net_dev_start_xmit,
>  		__entry->gso_size = skb_shinfo(skb)->gso_size;
>  		__entry->gso_segs = skb_shinfo(skb)->gso_segs;
>  		__entry->gso_type = skb_shinfo(skb)->gso_type;
> +		__entry->net_inum = dev_net(skb->dev)->ns.inum;
>  	),
>  
>
