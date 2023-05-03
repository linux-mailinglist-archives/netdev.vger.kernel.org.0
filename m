Return-Path: <netdev+bounces-104-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A7176F52B4
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:08:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A651281077
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 696F563C3;
	Wed,  3 May 2023 08:07:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69CC1C15
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D272C433EF;
	Wed,  3 May 2023 08:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683101277;
	bh=EBb5xgIZZfYqj/z+N72o+F70JjDbzDj6lUwAS2EJY+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PWwD3NbO1wlU1UVmtLRmLDPs1X+Gc/1/KAG3f0UCJ15uB4m0xgJgk1LWL50F/jl6R
	 ExPkmKVObRYZgML5ZEUijewzNBWOg/8MOWRMoaiD8y6cLqsbq9Fwb2An0JUsjvUlm2
	 1n6q4Qi4C6pQXJOvVFXk2KR8dPCKJ6WAku73dLLBrMZsv2RwmX125HL2IXivIpnhEJ
	 VyG1GUjT0eqfojow6Nqglm3K0ra+JrJ9Q7bjv7qFK75YkUIdwPDNaEmF9cYoAMorqE
	 HQQqZ2qOPhvDsnQV3zdEZmLc4GIJDXX5r304UrScmCcXR5AM/fc5HWq06I9hOQNY8U
	 h8YInPrI2cm3A==
Date: Wed, 3 May 2023 11:07:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	sasha.neftin@intel.com, maciej.fijalkowski@intel.com,
	magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
	hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
	stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net 1/1] igc: read before write to SRRCTL register
Message-ID: <20230503080753.GE525452@unreal>
References: <20230502154806.1864762-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502154806.1864762-1-anthony.l.nguyen@intel.com>

On Tue, May 02, 2023 at 08:48:06AM -0700, Tony Nguyen wrote:
> From: Song Yoong Siang <yoong.siang.song@intel.com>
> 
> igc_configure_rx_ring() function will be called as part of XDP program
> setup. If Rx hardware timestamp is enabled prio to XDP program setup,
> this timestamp enablement will be overwritten when buffer size is
> written into SRRCTL register.
> 
> Thus, this commit read the register value before write to SRRCTL
> register. This commit is tested by using xdp_hw_metadata bpf selftest
> tool. The tool enables Rx hardware timestamp and then attach XDP program
> to igc driver. It will display hardware timestamp of UDP packet with
> port number 9092. Below are detail of test steps and results.
> 
> Command on DUT:
>   sudo ./xdp_hw_metadata <interface name>
> 
> Command on Link Partner:
>   echo -n skb | nc -u -q1 <destination IPv4 addr> 9092
> 
> Result before this patch:
>   skb hwtstamp is not found!
> 
> Result after this patch:
>   found skb hwtstamp = 1677800973.642836757
> 
> Optionally, read PHC to confirm the values obtained are almost the same:
> Command:
>   sudo ./testptp -d /dev/ptp0 -g
> Result:
>   clock time: 1677800973.913598978 or Fri Mar  3 07:49:33 2023
> 
> Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
> Cc: <stable@vger.kernel.org> # 5.14+
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_base.h | 11 ++++++++---
>  drivers/net/ethernet/intel/igc/igc_main.c |  7 +++++--
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

