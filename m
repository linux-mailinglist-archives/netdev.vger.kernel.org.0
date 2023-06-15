Return-Path: <netdev+bounces-11024-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA73731239
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:34:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 589AA2814AA
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65682EDF;
	Thu, 15 Jun 2023 08:34:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EF2659
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D28C433C8;
	Thu, 15 Jun 2023 08:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686818042;
	bh=MECXzX+FDXnYQ1yacpwQw22WL7LwOiF01zfw6D0DjCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vCyNP8YWYQV1FbnEBT7IYuWWhXUp9OVqWofK0H5Oo4nvmkgxE6bPSXHzWwTChV9sg
	 dYDzLRQA+F0Yettv1une5Kn/VppFuN1s6Du2HFZCQkiy7KgB0D0WHS9c+exeMDYvB/
	 b3GHPuri5zbiyyY7bi8rr9MeYwIG/XOM/cye2xFlAneE14yYO7eAJ7pmBsX9VsqAII
	 DB7v51MaSSYzDLNjeOSOZVUkCovB4vi57BslON5ynzfcAQjWC63qpwF0D27TADRndu
	 FhTmucIaiAdmdDcbCPlf3e1VcfRweR58pKS8Xc2MIXu2Waurh4Jp3K3lIJVYA8+Q6/
	 o0zZOWnw2HqxQ==
Date: Thu, 15 Jun 2023 10:33:56 +0200
From: Simon Horman <horms@kernel.org>
To: Terin Stock <terin@cloudflare.com>
Cc: horms@verge.net.au, ja@ssi.bg, netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org, kernel-team@cloudflare.com,
	pablo@netfilter.org, hengqing.hu@gmail.com, kuba@kernel.org,
	netfilter-devel@vger.kernel.org, fw@strlen.de,
	coreteam@netfilter.org, davem@davemloft.net, kadlec@netfilter.org,
	pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH v2] ipvs: align inner_mac_header for encapsulation
Message-ID: <ZIrM9KjofuimthQg@kernel.org>
References: <20230609205842.2333727-1-terin@cloudflare.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609205842.2333727-1-terin@cloudflare.com>

On Fri, Jun 09, 2023 at 10:58:42PM +0200, Terin Stock wrote:
> When using encapsulation the original packet's headers are copied to the
> inner headers. This preserves the space for an inner mac header, which
> is not used by the inner payloads for the encapsulation types supported
> by IPVS. If a packet is using GUE or GRE encapsulation and needs to be
> segmented, flow can be passed to __skb_udp_tunnel_segment() which
> calculates a negative tunnel header length. A negative tunnel header
> length causes pskb_may_pull() to fail, dropping the packet.
> 
> This can be observed by attaching probes to ip_vs_in_hook(),
> __dev_queue_xmit(), and __skb_udp_tunnel_segment():
> 
>     perf probe --add '__dev_queue_xmit skb->inner_mac_header \
>     skb->inner_network_header skb->mac_header skb->network_header'
>     perf probe --add '__skb_udp_tunnel_segment:7 tnl_hlen'
>     perf probe -m ip_vs --add 'ip_vs_in_hook skb->inner_mac_header \
>     skb->inner_network_header skb->mac_header skb->network_header'
> 
> These probes the headers and tunnel header length for packets which
> traverse the IPVS encapsulation path. A TCP packet can be forced into
> the segmentation path by being smaller than a calculated clamped MSS,
> but larger than the advertised MSS.
> 
>     probe:ip_vs_in_hook: inner_mac_header=0x0 inner_network_header=0x0 mac_header=0x44 network_header=0x52
>     probe:ip_vs_in_hook: inner_mac_header=0x44 inner_network_header=0x52 mac_header=0x44 network_header=0x32
>     probe:dev_queue_xmit: inner_mac_header=0x44 inner_network_header=0x52 mac_header=0x44 network_header=0x32
>     probe:__skb_udp_tunnel_segment_L7: tnl_hlen=-2
> 
> When using veth-based encapsulation, the interfaces are set to be
> mac-less, which does not preserve space for an inner mac header. This
> prevents this issue from occurring.
> 
> In our real-world testing of sending a 32KB file we observed operation
> time increasing from ~75ms for veth-based encapsulation to over 1.5s
> using IPVS encapsulation due to retries from dropped packets.
> 
> This changeset modifies the packet on the encapsulation path in
> ip_vs_tunnel_xmit() and ip_vs_tunnel_xmit_v6() to remove the inner mac
> header offset. This fixes UDP segmentation for both encapsulation types,
> and corrects the inner headers for any IPIP flows that may use it.
> 
> Fixes: 84c0d5e96f3a ("ipvs: allow tunneling with gue encapsulation")
> Signed-off-by: Terin Stock <terin@cloudflare.com>

Acked-by: Simon Horman <horms@kernel.org>


