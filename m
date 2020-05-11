Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B691CE56D
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731592AbgEKU1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgEKU1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:27:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66160C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:27:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD4B11284BE83;
        Mon, 11 May 2020 13:27:43 -0700 (PDT)
Date:   Mon, 11 May 2020 13:27:42 -0700 (PDT)
Message-Id: <20200511.132742.1876685074237414958.davem@davemloft.net>
To:     kda@linux-powerpc.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, jgross@suse.com,
        wei.liu@kernel.org, paul@xen.org, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v9 1/2] xen networking: add basic XDP support
 for xen-netfront
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1589192541-11686-2-git-send-email-kda@linux-powerpc.org>
References: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org>
        <1589192541-11686-2-git-send-email-kda@linux-powerpc.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 13:27:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>
Date: Mon, 11 May 2020 13:22:20 +0300

> @@ -560,6 +572,64 @@ static u16 xennet_select_queue(struct net_device *dev, struct sk_buff *skb,
>  	return queue_idx;
>  }
>  
> +static int xennet_xdp_xmit_one(struct net_device *dev, struct xdp_frame *xdpf)
> +{
> +	struct netfront_info *np = netdev_priv(dev);
> +	struct netfront_stats *tx_stats = this_cpu_ptr(np->tx_stats);
> +	struct netfront_queue *queue = NULL;
> +	unsigned int num_queues = dev->real_num_tx_queues;
> +	unsigned long flags;
> +	int notify;
> +	struct xen_netif_tx_request *tx;

Reverse christmas tree ordering for these local variables please.

> @@ -792,6 +909,9 @@ static int xennet_get_responses(struct netfront_queue *queue,
>  	int slots = 1;
>  	int err = 0;
>  	unsigned long ret;
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
> +	u32 verdict;

Likewise.

> @@ -997,7 +1132,9 @@ static int xennet_poll(struct napi_struct *napi, int budget)
>  	struct sk_buff_head rxq;
>  	struct sk_buff_head errq;
>  	struct sk_buff_head tmpq;
> +	struct bpf_prog *xdp_prog;
>  	int err;
> +	bool need_xdp_flush = false;

Likewise.

> +static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> +			  struct netlink_ext_ack *extack)
> +{
> +	struct netfront_info *np = netdev_priv(dev);
> +	struct bpf_prog *old_prog;
> +	unsigned int i, err;
> +	unsigned long max_mtu = XEN_PAGE_SIZE - XDP_PACKET_HEADROOM;

Likewise.

> +static u32 xennet_xdp_query(struct net_device *dev)
> +{
> +	struct netfront_info *np = netdev_priv(dev);
> +	unsigned int num_queues = dev->real_num_tx_queues;
> +	unsigned int i;
> +	struct netfront_queue *queue;
> +	const struct bpf_prog *xdp_prog;

Likewise.
