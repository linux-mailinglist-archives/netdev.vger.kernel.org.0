Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CCC2DBD7C
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 10:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgLPJYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 04:24:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbgLPJYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 04:24:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608110605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MUx4wa69PeOW8vAItriAUKANW50g23Sn/MtCvu68J3o=;
        b=BaNRE3CK7TD2dUTVSRu5ygKr0sPABr9D/B1VphzafVHncwBrwTI0QttttujlTI1W/ICV0y
        9UDWbmf+tEieAA0cGP+3/Z2P6T6SRQZe4038zhpB4nm+n2+dNlxh/eRsnMhKJPcFs++CcE
        RlubDQUofBcL/gibeHyTnvxn7wk7m9g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-J3TEbTH4P1G-Q1rN-c8_fQ-1; Wed, 16 Dec 2020 04:23:21 -0500
X-MC-Unique: J3TEbTH4P1G-Q1rN-c8_fQ-1
Received: by mail-wm1-f72.google.com with SMTP id k67so1086887wmk.5
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 01:23:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MUx4wa69PeOW8vAItriAUKANW50g23Sn/MtCvu68J3o=;
        b=J55M+HkgBoQA6dSBXpcbvZhweo0o5TfOxq2vOGCWALeZU9Za8bGF+FwE3Ip0Y3OWts
         tl+5GaGIHO+BshUtNqxThzxDu2AxqWPFBrS7gGRKlpxHHVzMXwoJtzgEwicKdFsiBy9H
         /18om+s6GMM/fv+HmFJFieP6ebs58e/SmR/z8lEuPGdHaoUkU9e77xHvWiylPqkAgoNV
         0gfUY3vkBQNIx9++NxgfBEzdmaAOmuYVyiVha2DCCXsfWRBY+VSacKocw+ijYjLquGy2
         E3dKiQtjjDdFTMU7WiNhvpd047rORU6eNAbHjqDWbidWe3i7p6Zt7jybNVr6EE2B82jo
         xhpQ==
X-Gm-Message-State: AOAM5334paBb8Q95IBcmOMWkgvwPILbokYPjLDxQyxhuiCDe02BFWwJH
        CO/jCxutwDjVuRYgdSA5HgWIgyAKMeDxmgZt1PYpgrfCkAqtcDq7BY7kxq+3V/ZLjq3e17M9264
        iSG0zvH6dNTCcUNmr
X-Received: by 2002:a1c:6446:: with SMTP id y67mr2297981wmb.144.1608110600189;
        Wed, 16 Dec 2020 01:23:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygTHQ8GqT8mpW+0WKMBETjpkzHbjIExWECh+GMsL2oQNZX9gfDaNiLncaogJblgVV93AcnPQ==
X-Received: by 2002:a1c:6446:: with SMTP id y67mr2297955wmb.144.1608110599993;
        Wed, 16 Dec 2020 01:23:19 -0800 (PST)
Received: from redhat.com (bzq-109-67-15-113.red.bezeqint.net. [109.67.15.113])
        by smtp.gmail.com with ESMTPSA id q17sm2178361wrr.53.2020.12.16.01.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 01:23:19 -0800 (PST)
Date:   Wed, 16 Dec 2020 04:23:16 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com,
        willemdebruijn.kernel@gmail.com,
        virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
Subject: Re: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg
 fails
Message-ID: <20201216042027-mutt-send-email-mst@kernel.org>
References: <cover.1608065644.git.wangyunjian@huawei.com>
 <6b4c5fff8705dc4b5b6a25a45c50f36349350c73.1608065644.git.wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b4c5fff8705dc4b5b6a25a45c50f36349350c73.1608065644.git.wangyunjian@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 04:20:37PM +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Currently we break the loop and wake up the vhost_worker when
> sendmsg fails. When the worker wakes up again, we'll meet the
> same error. This will cause high CPU load. To fix this issue,
> we can skip this description by ignoring the error. When we
> exceeds sndbuf, the return value of sendmsg is -EAGAIN. In
> the case we don't skip the description and don't drop packet.

Question: with this patch, what happens if sendmsg is interrupted by a signal?


> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>  drivers/vhost/net.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index c8784dfafdd7..3d33f3183abe 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -827,16 +827,13 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  				msg.msg_flags &= ~MSG_MORE;
>  		}
>  
> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>  		err = sock->ops->sendmsg(sock, &msg, len);
> -		if (unlikely(err < 0)) {
> +		if (unlikely(err == -EAGAIN)) {
>  			vhost_discard_vq_desc(vq, 1);
>  			vhost_net_enable_vq(net, vq);
>  			break;
> -		}
> -		if (err != len)
> -			pr_debug("Truncated TX packet: len %d != %zd\n",
> -				 err, len);
> +		} else if (unlikely(err != len))
> +			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err, len);
>  done:
>  		vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
>  		vq->heads[nvq->done_idx].len = 0;
> @@ -922,7 +919,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  			msg.msg_flags &= ~MSG_MORE;
>  		}
>  
> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>  		err = sock->ops->sendmsg(sock, &msg, len);
>  		if (unlikely(err < 0)) {
>  			if (zcopy_used) {
> @@ -931,13 +927,14 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
>  					% UIO_MAXIOV;
>  			}
> -			vhost_discard_vq_desc(vq, 1);
> -			vhost_net_enable_vq(net, vq);
> -			break;
> +			if (err == -EAGAIN) {
> +				vhost_discard_vq_desc(vq, 1);
> +				vhost_net_enable_vq(net, vq);
> +				break;
> +			}
>  		}
>  		if (err != len)
> -			pr_debug("Truncated TX packet: "
> -				 " len %d != %zd\n", err, len);
> +			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err, len);

I'd rather make the pr_debug -> vq_err a separate change, with proper
commit log describing motivation.


>  		if (!zcopy_used)
>  			vhost_add_used_and_signal(&net->dev, vq, head, 0);
>  		else
> -- 
> 2.23.0

