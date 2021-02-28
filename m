Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E961A32743B
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 20:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbhB1ToK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 14:44:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231340AbhB1ToJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 14:44:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ECF8601FF;
        Sun, 28 Feb 2021 19:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614541409;
        bh=odkhyAkQV6vBM/QVUzrykAr4gFTrCEz09I318JWvhpQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nPL6BneoBysxjdgozVdCqylXlOOECoXaD0y7gcSGANuFuMY9TWvgvMdidnaPdw9Qu
         Ub+WN2VTrYYVs+ecA97WAyqr8cYT6l9/qnXL+lhwgha0h9CIC/r5hqnyXQFThRV5du
         2h2HA7PWd2v4Bg9DvlqzAXe97vobzuUq7nC1XnhXll6mXKPmxHgKI4YXHbfyHQNtoa
         h5SJxEmtiBbCkwuc/t/0HB4HW29pzrhVL4fKNLvXMIO/muKWL8KG5jIrmjWsdYzcmj
         jfrPeUkw2gRlCSxyjUn3hEo+s4RkL21bY2NwCiCZHeWFdx1CwxuQVyJ0ru9W7Xgi4t
         MGZ7bC3cKuhlg==
Date:   Sun, 28 Feb 2021 11:43:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH v3 net-next] virtio-net: support XDP_TX when not more
 queues
Message-ID: <20210228114328.4909c805@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1614500567-9059-1-git-send-email-xuanzhuo@linux.alibaba.com>
References: <1614500567-9059-1-git-send-email-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Feb 2021 16:22:47 +0800 Xuan Zhuo wrote:
> +static void virtnet_put_xdp_sq(struct virtnet_info *vi, struct send_queue *sq)
> +{
> +	struct netdev_queue *txq;
> +	unsigned int qp;
> +
> +	if (vi->curr_queue_pairs <= nr_cpu_ids) {
> +		qp = sq - vi->sq;
> +		txq = netdev_get_tx_queue(vi->dev, qp);
> +		__netif_tx_unlock(txq);
> +	}
> +}

Could we potentially avoid sparse warnings on this patch by adding the
right annotations?

I've seen this pattern used in a few places:

void maybe_take_some_lock() 
	__acquires(lock)
{
	if (condition) {
		lock(lock); /* really take the lock */
	} else {
		/* tell sparse we took the lock, but don't really take it */
		__acquire(lock);
	}
}

