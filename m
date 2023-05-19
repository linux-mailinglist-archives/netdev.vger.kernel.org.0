Return-Path: <netdev+bounces-4015-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E534A70A223
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:52:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF02F281C05
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E10A817FF5;
	Fri, 19 May 2023 21:52:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78DD174FC
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 21:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F9EC433EF;
	Fri, 19 May 2023 21:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684533140;
	bh=DvmYUH8tqNMAZb1R1bVtrDgnSZXt8yxQB+NplK600O0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=V+PBalyhMH6kzH7YzbdKg5bmrrp2uWrT4cWs/gTl+PeG2FdUwVUd3MVbzlXkmyfPP
	 TvpT81mfXBRGCwBeZgzJiFRJHghCAabKbdqT6LIUl2W8gws4KPChyDKPiUjnjjGFHM
	 r0ISzBsTNS3sZXYU5N6fIVtvNRcuMIYjDCZSVfV+Y07cKxPIg2hjnTQHTUwsHluBPb
	 rmrYfrR6doWjBdzdqmXuhbv3ZCCjJFU/ZbTPLiSctHuQGnfpgixfo0woS1TbOP2Xlo
	 oF9x1I9Ie92vleZLxtejrBXVkaGbExgilPKUKY6lJdcUPtsXB4cVazzYBRRksG5WhK
	 8T5om3gjwH8eA==
Date: Fri, 19 May 2023 14:52:18 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ido Schimmel <idosch@nvidia.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
 bridge@lists.linux-foundation.org, davem@davemloft.net, pabeni@redhat.com,
 edumazet@google.com, roopa@nvidia.com, taras.chornyi@plvision.eu,
 saeedm@nvidia.com, leon@kernel.org, petrm@nvidia.com,
 vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
 alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
 jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 taspelund@nvidia.com
Subject: Re: [PATCH net-next 1/5] skbuff: bridge: Add layer 2 miss
 indication
Message-ID: <20230519145218.659b0104@kernel.org>
In-Reply-To: <ZGd+9CUBM+eWG5FR@shredder>
References: <20230518113328.1952135-1-idosch@nvidia.com>
	<20230518113328.1952135-2-idosch@nvidia.com>
	<1ed139d5-6cb9-90c7-323c-22cf916e96a0@blackwall.org>
	<ZGd+9CUBM+eWG5FR@shredder>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 May 2023 16:51:48 +0300 Ido Schimmel wrote:
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index fc17b9fd93e6..274e55455b15 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -46,6 +46,8 @@ static int br_pass_frame_up(struct sk_buff *skb)
>          */
>         br_switchdev_frame_unmark(skb);
>  
> +       skb->l2_miss = BR_INPUT_SKB_CB(skb)->miss;
> +
>         /* Bridge is just like any other port.  Make sure the
>          * packet is allowed except in promisc mode when someone
>          * may be running packet capture.
> 
> Ran these changes through the selftest and it seems to work.

Can we possibly put the new field at the end of the CB and then have TC
look at it in the CB? We already do a bit of such CB juggling in strp
(first member of struct sk_skb_cb).

