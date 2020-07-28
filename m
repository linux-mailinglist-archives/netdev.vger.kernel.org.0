Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDD9230384
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgG1HKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 03:10:03 -0400
Received: from mga05.intel.com ([192.55.52.43]:25782 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726854AbgG1HKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 03:10:03 -0400
IronPort-SDR: c3u+/N2oNop15z9bLMfS//Ar4uy6icVqt/boI1zjPilBq2nl4FSc7ofGSAnT6Ks8ZL/8zLn1R8
 HF7DqFl8va8w==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="236024616"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="236024616"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 00:10:03 -0700
IronPort-SDR: 33rBTYS3OXQWg8x3yBTwYwZbWTLvohGMkb7I3IDNaU03XwNiQeD14dXf1WDC970839ZyCzxqgj
 Sbrt4wmv33KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="322089923"
Received: from nheyde-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.57.223])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jul 2020 00:09:57 -0700
Subject: Re: [PATCH bpf-next v4 05/14] xsk: move queue_id, dev and need_wakeup
 to buffer pool
To:     Magnus Karlsson <magnus.karlsson@intel.com>, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
References: <1595307848-20719-1-git-send-email-magnus.karlsson@intel.com>
 <1595307848-20719-6-git-send-email-magnus.karlsson@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <00afe3da-0d5e-18fe-b6cb-490faa3dd132@intel.com>
Date:   Tue, 28 Jul 2020 09:09:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595307848-20719-6-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-07-21 07:03, Magnus Karlsson wrote:
> Move queue_id, dev, and need_wakeup from the umem to the
> buffer pool. This so that we in a later commit can share the umem
> between multiple HW queues. There is one buffer pool per dev and
> queue id, so these variables should belong to the buffer pool, not
> the umem. Need_wakeup is also something that is set on a per napi
> level, so there is usually one per device and queue id. So move
> this to the buffer pool too.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   include/net/xdp_sock.h      |  3 ---
>   include/net/xsk_buff_pool.h |  4 ++++
>   net/xdp/xdp_umem.c          | 19 +------------------
>   net/xdp/xdp_umem.h          |  4 ----
>   net/xdp/xsk.c               | 40 +++++++++++++++-------------------------
>   net/xdp/xsk_buff_pool.c     | 39 ++++++++++++++++++++++-----------------
>   net/xdp/xsk_diag.c          |  4 ++--
>   7 files changed, 44 insertions(+), 69 deletions(-)
> 
[...]
>   		}
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 36287d2..436648a 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -95,10 +95,9 @@ void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
>   }
>   EXPORT_SYMBOL(xp_set_rxq_info);
>   
> -int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
> +int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
>   		  u16 queue_id, u16 flags)
>   {
> -	struct xdp_umem *umem = pool->umem;
>   	bool force_zc, force_copy;
>   	struct netdev_bpf bpf;
>   	int err = 0;
> @@ -111,27 +110,30 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
>   	if (force_zc && force_copy)
>   		return -EINVAL;
>   
> -	if (xsk_get_pool_from_qid(dev, queue_id))
> +	if (xsk_get_pool_from_qid(netdev, queue_id))
>   		return -EBUSY;
>   
> -	err = xsk_reg_pool_at_qid(dev, pool, queue_id);
> +	err = xsk_reg_pool_at_qid(netdev, pool, queue_id);
>   	if (err)
>   		return err;
>   
>   	if (flags & XDP_USE_NEED_WAKEUP) {
> -		umem->flags |= XDP_UMEM_USES_NEED_WAKEUP;
> +		pool->uses_need_wakeup = true;
>   		/* Tx needs to be explicitly woken up the first time.
>   		 * Also for supporting drivers that do not implement this
>   		 * feature. They will always have to call sendto().
>   		 */
> -		umem->need_wakeup = XDP_WAKEUP_TX;
> +		pool->cached_need_wakeup = XDP_WAKEUP_TX;
>   	}
>   
> +	dev_hold(netdev);
> +

You have a reference leak here for the error case.


Björn
