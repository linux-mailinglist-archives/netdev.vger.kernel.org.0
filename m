Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83BD2DA70A
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 05:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgLOELd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 23:11:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbgLOELc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 23:11:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608005405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eb9YqhAgwHZcpT5CFtnpmMMTLEY1Grfh6mkROQiid4M=;
        b=SlTUcQLu268ySx5Yevwlp/eccQLTHsrrc5rH1DPrB8hAMKe81GzlOiuk1oKgK35kvsWv1L
        YKMujyKA7+mnAeBhJyZF2QAVv5Nbrw1c3IvrxtWOBzQytQcgFeG5HIMX3eIh5wJfv/nbye
        erXT+iQZ1KsNu8JQSbrlDSL/7tD/n5A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-rOfXLz7GN12DgVuiZC00-Q-1; Mon, 14 Dec 2020 23:10:01 -0500
X-MC-Unique: rOfXLz7GN12DgVuiZC00-Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08E68107ACE3;
        Tue, 15 Dec 2020 04:10:00 +0000 (UTC)
Received: from [10.72.13.123] (ovpn-13-123.pek2.redhat.com [10.72.13.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BA351002388;
        Tue, 15 Dec 2020 04:09:50 +0000 (UTC)
Subject: Re: [PATCH net 2/2] vhost_net: fix high cpu load when sendmsg fails
To:     wangyunjian <wangyunjian@huawei.com>, netdev@vger.kernel.org,
        mst@redhat.com, willemdebruijn.kernel@gmail.com
Cc:     virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
References: <cover.1608024547.git.wangyunjian@huawei.com>
 <4be47d3a325983f1bfc39f11f0e015767dd2aa3c.1608024547.git.wangyunjian@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e853a47e-b581-18d9-f13c-b449b176a308@redhat.com>
Date:   Tue, 15 Dec 2020 12:09:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4be47d3a325983f1bfc39f11f0e015767dd2aa3c.1608024547.git.wangyunjian@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/15 上午9:48, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> Currently we break the loop and wake up the vhost_worker when
> sendmsg fails. When the worker wakes up again, we'll meet the
> same error. This will cause high CPU load. To fix this issue,
> we can skip this description by ignoring the error. When we
> exceeds sndbuf, the return value of sendmsg is -EAGAIN. In
> the case we don't skip the description and don't drop packet.
>
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>   drivers/vhost/net.c | 21 +++++++++------------
>   1 file changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index c8784dfafdd7..f966592d8900 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -827,16 +827,13 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>   				msg.msg_flags &= ~MSG_MORE;
>   		}
>   
> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>   		err = sock->ops->sendmsg(sock, &msg, len);
> -		if (unlikely(err < 0)) {
> +		if (unlikely(err == -EAGAIN)) {
>   			vhost_discard_vq_desc(vq, 1);
>   			vhost_net_enable_vq(net, vq);
>   			break;
> -		}


As I've pointed out in last version. If you don't discard descriptor, 
you probably need to add the head to used ring. Otherwise this 
descriptor will be always inflight that may confuse drivers.


> -		if (err != len)
> -			pr_debug("Truncated TX packet: len %d != %zd\n",
> -				 err, len);
> +		} else if (unlikely(err < 0 || err != len))


It looks to me err != len covers err < 0.

Thanks


> +			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err, len);
>   done:
>   		vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
>   		vq->heads[nvq->done_idx].len = 0;
> @@ -922,7 +919,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>   			msg.msg_flags &= ~MSG_MORE;
>   		}
>   
> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>   		err = sock->ops->sendmsg(sock, &msg, len);
>   		if (unlikely(err < 0)) {
>   			if (zcopy_used) {
> @@ -931,13 +927,14 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>   				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
>   					% UIO_MAXIOV;
>   			}
> -			vhost_discard_vq_desc(vq, 1);
> -			vhost_net_enable_vq(net, vq);
> -			break;
> +			if (err == -EAGAIN) {
> +				vhost_discard_vq_desc(vq, 1);
> +				vhost_net_enable_vq(net, vq);
> +				break;
> +			}
>   		}
>   		if (err != len)
> -			pr_debug("Truncated TX packet: "
> -				 " len %d != %zd\n", err, len);
> +			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err, len);
>   		if (!zcopy_used)
>   			vhost_add_used_and_signal(&net->dev, vq, head, 0);
>   		else

