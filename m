Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E2E6762CB
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 03:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjAUCCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 21:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjAUCC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 21:02:29 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC60044B4;
        Fri, 20 Jan 2023 18:02:27 -0800 (PST)
Message-ID: <d0232e99-862b-3255-aeac-7c04486cb773@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674266546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AQqw4MaC7sDy3U78U5FoOgEOrGLlK0bh/i/vClev/8k=;
        b=pLWjGNAsHVCXTKCyIdGQJ7wmhWbpo++mHOOIhWUum9kXoZXVre8rTHFRo5tH3qANtpoWBi
        EN2B4rYWjt5IpA7EDqfuVGn3+uFTX85mvM7nPXnB5gJs16vytOz53WC9BHbE18TLq+lMO5
        iO+8OE6+DEJJWG1y4qtX9m/+YTaKyL0=
Date:   Fri, 20 Jan 2023 18:02:18 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 6/7] bpf: devmap: check XDP features in
 bpf_map_update_elem and __xdp_enqueue
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, niklas.soderlund@corigine.com,
        bpf@vger.kernel.org
References: <cover.1674234430.git.lorenzo@kernel.org>
 <acc9460e6e29dfe02cf474735277e196b500d2ef.1674234430.git.lorenzo@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <acc9460e6e29dfe02cf474735277e196b500d2ef.1674234430.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/23 9:16 AM, Lorenzo Bianconi wrote:
> ---
>   kernel/bpf/devmap.c | 25 +++++++++++++++++++++----
>   net/core/filter.c   | 13 +++++--------
>   2 files changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index d01e4c55b376..69ceecc792df 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -474,7 +474,11 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
>   {
>   	int err;
>   
> -	if (!dev->netdev_ops->ndo_xdp_xmit)
> +	if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT))

The current "dev->netdev_ops->ndo_xdp_xmit" check is self explaining.
Any plan to put some document for the NETDEV_XDP_ACT_* values?

