Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981B945BF4
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 13:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfFNL6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 07:58:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36736 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbfFNL6V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 07:58:21 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 720A8308FB9D;
        Fri, 14 Jun 2019 11:58:20 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 674C260BE0;
        Fri, 14 Jun 2019 11:58:08 +0000 (UTC)
Date:   Fri, 14 Jun 2019 13:58:06 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf 2/3] devmap: Add missing bulk queue free
Message-ID: <20190614135806.4bcb1a31@carbon>
In-Reply-To: <20190614082015.23336-3-toshiaki.makita1@gmail.com>
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
        <20190614082015.23336-3-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 14 Jun 2019 11:58:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jun 2019 17:20:14 +0900
Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:

> dev_map_free() forgot to free bulk queue when freeing its entries.
> 
> Fixes: 5d053f9da431 ("bpf: devmap prepare xdp frames for bulking")
> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
> ---
>  kernel/bpf/devmap.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index e001fb1..a126d95 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -186,6 +186,7 @@ static void dev_map_free(struct bpf_map *map)
>  		if (!dev)
>  			continue;
>  
> +		free_percpu(dev->bulkq);
>  		dev_put(dev->dev);
>  		kfree(dev);
>  	}

Do we need to call need to call dev_map_flush_old() before
free_percpu(dev->bulkq) ?

Looking the code, I guess this is not needed as, above we are ensuring
all pending flush operations have completed.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
