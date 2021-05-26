Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAFE392103
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 21:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhEZTky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 15:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231321AbhEZTkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 15:40:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61F4A613D3;
        Wed, 26 May 2021 19:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622057959;
        bh=C1PDxAiFXhmg6+qT5ljIvCqHchzsAkjnDyHZI2utLYI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JtKdivv3C0UX4qKxEHf7gYe/3LBD9kjmLyUwGOvf4VenEMjqGUGBQFyV+3InsabNV
         RGF0K6P77wG7VECG7kZeygrZOy/Ci1o4wQSTgweNZTGG1LEUWcctsj9R+QXZ0J+NMM
         kqyu9BklBHqbNmkWkbjy5Qo+251VK/IftrnOtnfNn/jDyOyei0K4J+KYXonYO8D97G
         k2IvilqmsBkt5k3ffgxMcg56ij5+yc1F/72DALcRA/1nflrF8oRjigPdq94eL1RNEZ
         I+pCoEiq3DkrUJA2JoTKKFoKE+yr9I1VXa0emdumO+7AOUvKUq1LlFjCoaLFd3Iy+1
         MOesh9aB8mvZA==
Date:   Wed, 26 May 2021 12:39:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v3 4/4] virtio_net: disable cb aggressively
Message-ID: <20210526123918.0aef851d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210526082423.47837-5-mst@redhat.com>
References: <20210526082423.47837-1-mst@redhat.com>
        <20210526082423.47837-5-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 04:24:43 -0400 Michael S. Tsirkin wrote:
> @@ -1605,12 +1608,17 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
>  	bool kick = !netdev_xmit_more();
>  	bool use_napi = sq->napi.weight;
> +	unsigned int bytes = skb->len;

FWIW GCC says bytes is unused.
