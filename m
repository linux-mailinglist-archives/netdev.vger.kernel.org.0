Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3AD2F72BC
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 07:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbhAOGGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 01:06:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbhAOGGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 01:06:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610690715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wcgJAQsGzq3/dGD55HWg0SrSpgHhMOqMMxS66PkVM3Q=;
        b=XOP72/0Bb3lftr/mEwBCs20iEjdVVyKURLzzVpqBskqHF9dZ6U4T9+cr3df/c7vEVy3Cyd
        Zc1PFzzpFLIhu+L29ZjaVdKsx0fjbNEtpCnXuTTauhN+/8ZzSvQXUedd5460KZrvG6Voap
        MVvoOMThoLDf25Hqa1bdxQqWdWlkBaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-0KUpvnWfMHWPDDzy07udnA-1; Fri, 15 Jan 2021 01:05:11 -0500
X-MC-Unique: 0KUpvnWfMHWPDDzy07udnA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66CF2107ACF7;
        Fri, 15 Jan 2021 06:05:10 +0000 (UTC)
Received: from [10.72.13.19] (ovpn-13-19.pek2.redhat.com [10.72.13.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72A0F1F45F;
        Fri, 15 Jan 2021 06:05:03 +0000 (UTC)
Subject: Re: [PATCH net-next v7] vhost_net: avoid tx queue stuck when sendmsg
 fails
To:     wangyunjian <wangyunjian@huawei.com>, netdev@vger.kernel.org
Cc:     mst@redhat.com, willemdebruijn.kernel@gmail.com,
        virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
References: <1610685980-38608-1-git-send-email-wangyunjian@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ff01b9da-f2a7-3559-63cc-833f52280ef6@redhat.com>
Date:   Fri, 15 Jan 2021 14:05:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1610685980-38608-1-git-send-email-wangyunjian@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/15 下午12:46, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> Currently the driver doesn't drop a packet which can't be sent by tun
> (e.g bad packet). In this case, the driver will always process the
> same packet lead to the tx queue stuck.
>
> To fix this issue:
> 1. in the case of persistent failure (e.g bad packet), the driver
>     can skip this descriptor by ignoring the error.
> 2. in the case of transient failure (e.g -ENOBUFS, -EAGAIN and -ENOMEM),
>     the driver schedules the worker to try again.
>
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
> v7:
>     * code rebase
> v6:
>     * update code styles and commit log
> ---
>   drivers/vhost/net.c | 26 ++++++++++++++------------
>   1 file changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 3b744031ec8f..df82b124170e 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -828,14 +828,15 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>   				msg.msg_flags &= ~MSG_MORE;
>   		}
>   
> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>   		err = sock->ops->sendmsg(sock, &msg, len);
>   		if (unlikely(err < 0)) {
> -			vhost_discard_vq_desc(vq, 1);
> -			vhost_net_enable_vq(net, vq);
> -			break;
> -		}
> -		if (err != len)
> +			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
> +				vhost_discard_vq_desc(vq, 1);
> +				vhost_net_enable_vq(net, vq);
> +				break;
> +			}
> +			pr_debug("Fail to send packet: err %d", err);
> +		} else if (unlikely(err != len))
>   			pr_debug("Truncated TX packet: len %d != %zd\n",
>   				 err, len);
>   done:
> @@ -924,7 +925,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>   			msg.msg_flags &= ~MSG_MORE;
>   		}
>   
> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>   		err = sock->ops->sendmsg(sock, &msg, len);
>   		if (unlikely(err < 0)) {
>   			if (zcopy_used) {
> @@ -933,11 +933,13 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>   				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
>   					% UIO_MAXIOV;
>   			}
> -			vhost_discard_vq_desc(vq, 1);
> -			vhost_net_enable_vq(net, vq);
> -			break;
> -		}
> -		if (err != len)
> +			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
> +				vhost_discard_vq_desc(vq, 1);
> +				vhost_net_enable_vq(net, vq);
> +				break;
> +			}
> +			pr_debug("Fail to send packet: err %d", err);
> +		} else if (unlikely(err != len))
>   			pr_debug("Truncated TX packet: "
>   				 " len %d != %zd\n", err, len);
>   		if (!zcopy_used)

