Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA112B9DE7
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgKSW6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgKSW6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:58:46 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8B0C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:58:46 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kfst0-0005DD-0a; Thu, 19 Nov 2020 23:58:42 +0100
Date:   Thu, 19 Nov 2020 23:58:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH v3] aquantia: Remove the build_skb path
Message-ID: <20201119225842.GK15137@breakpoint.cc>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
 <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119221510.GI15137@breakpoint.cc>
 <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119222800.GJ15137@breakpoint.cc>
 <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ramsay, Lincoln <Lincoln.Ramsay@digi.com> wrote:
> When performing IPv6 forwarding, there is an expectation that SKBs
> will have some headroom. When forwarding a packet from the aquantia
> driver, this does not always happen, triggering a kernel warning.
> 
> The build_skb path fails to allow for an SKB header, but the hardware

For build_skb path to work the buffer scheme would need to be changed
to reserve headroom, so yes, I think that the proposed patch is the
most convenient solution.

> buffer it is built around won't allow for this anyway. Just always use the
> slower codepath that copies memory into an allocated SKB.

I thought this changes the driver to always copy the entire packet, but
thats not true, see below.

> It seems that skb_headroom is only 14, when it is expected to be >= 16.

Yes, kernel expects to have some headroom in skbs.

> aq_ring.c has this code (edited slightly for brevity):
> 
> if (buff->is_eop && buff->len <= AQ_CFG_RX_FRAME_MAX - AQ_SKB_ALIGN) {
>     skb = build_skb(aq_buf_vaddr(&buff->rxdata), AQ_CFG_RX_FRAME_MAX);
>     skb_put(skb, buff->len);
> } else {
>     skb = napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);
> 
> There is a significant difference between the SKB produced by these 2 code paths. When napi_alloc_skb creates an SKB, there is a certain amount of headroom reserved. The same pattern appears to be used in all of the other ethernet drivers I have looked at. However, this is not done in the build_skb codepath.

I think the above should be part of the commit message rather than this
meta-space (which gets removed by git-am).

> +		skb = napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);
> +		if (unlikely(!skb)) {

AQ_CFG_RX_HDR_SIZE is 256 byte, so for larger packets ...

> +		memcpy(__skb_put(skb, hdr_len), aq_buf_vaddr(&buff->rxdata),
> +			ALIGN(hdr_len, sizeof(long)));

This only copies the initial part and then...
> +		if (buff->len - hdr_len > 0) {
> +			skb_add_rx_frag(skb, 0, buff->rxdata.page,
> +					buff->rxdata.pg_off + hdr_len,
> +					buff->len - hdr_len,
>  					AQ_CFG_RX_FRAME_MAX);

The rest is added as a frag.

IOW, this patch looks good to me, but could you update the
commit message so it becomes clear that this doesn't result in a full
copy?

Perhaps something like:
'Just always use the napi_alloc_skb() code path that passes the buffer
 as a page fragment', or similar.

Thanks.
