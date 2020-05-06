Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F261C6772
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 07:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgEFF2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 01:28:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39496 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726464AbgEFF2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 01:28:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588742899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MAw5AwbP2+lICtPzp1Soos0ajccelDLiyAxAMLKNgBk=;
        b=NyUJqHWwTL/h+xsgqh4FYBrJ5Y+eOEDDUOz/JRI7gYE71Kv8wQmi+QITLTYvekDyFFCdi8
        kVS37SCChdzA8uSIuJI995U7jemtum/BJ8ZKF2zLU0RPefEqchI+HdmJ9WDjiK4+RsrteE
        +dsKUx0UEvlVLoeqHh2pYG+PI7J6o8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-ZDFrgaNuMwK1UKtrgmdaAA-1; Wed, 06 May 2020 01:28:16 -0400
X-MC-Unique: ZDFrgaNuMwK1UKtrgmdaAA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BB06461;
        Wed,  6 May 2020 05:28:14 +0000 (UTC)
Received: from [10.72.13.165] (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F50160C18;
        Wed,  6 May 2020 05:28:09 +0000 (UTC)
Subject: Re: [PATCH] virtio_net: fix lockdep warning on 32 bit
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200506000006.196646-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cd6132a6-8dbe-9e7b-2e63-46a9864040e4@redhat.com>
Date:   Wed, 6 May 2020 13:28:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506000006.196646-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/6 =E4=B8=8A=E5=8D=888:01, Michael S. Tsirkin wrote:
> When we fill up a receive VQ, try_fill_recv currently tries to count
> kicks using a 64 bit stats counter. Turns out, on a 32 bit kernel that
> uses a seqcount. sequence counts are "lock" constructs where you need t=
o
> make sure that writers are serialized.
>
> In turn, this means that we mustn't run two try_fill_recv concurrently.
> Which of course we don't. We do run try_fill_recv sometimes from a full=
y
> preemptible context and sometimes from a softirq (napi) context.
>
> However, when it comes to the seqcount, lockdep is trying to enforce
> the rule that the same lock isn't accessed from preemptible
> and softirq context. This causes a false-positive warning:
>
> WARNING: inconsistent lock state
> ...
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
>
> As a work around, shut down the warning by switching
> to u64_stats_update_begin_irqsave - that works by disabling
> interrupts on 32 bit only, is a NOP on 64 bit.
>
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> I'm not thrilled about this but this seems the best we can do for now.
>
> Completely untested.
>
>
> Thomas, can you pls let me know the config I need to trigger the warnin=
g
> in question?
>
>
>   drivers/net/virtio_net.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 6594aab4910e..95393b61187f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1243,9 +1243,11 @@ static bool try_fill_recv(struct virtnet_info *v=
i, struct receive_queue *rq,
>   			break;
>   	} while (rq->vq->num_free);
>   	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
> -		u64_stats_update_begin(&rq->stats.syncp);
> +		unsigned long flags;
> +
> +		flags =3D u64_stats_update_begin_irqsave(&rq->stats.syncp);
>   		rq->stats.kicks++;
> -		u64_stats_update_end(&rq->stats.syncp);
> +		u64_stats_update_end_irqrestore(&rq->stats.syncp);
>   	}
>  =20
>   	return !oom;


Acked-by: Jason Wang <jasowang@redhat.com>



