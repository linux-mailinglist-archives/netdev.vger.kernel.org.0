Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB746D3C18
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 05:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjDCDTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 23:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjDCDTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 23:19:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA2C1BE8
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 20:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680491895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0a2YoCPqdvT7sap4ltftxMthrEI89W8IvG18MozfGLE=;
        b=QNJXyIXmcZyEgZTJy+1pk4nythFVrlwyeEacQjZE7mOgK7J/plIzz3HUozUNAnXuqThyZG
        LzgEtVqqrQY/mi9oQ2TmN9hPpnlYLheBgTpaYHKdYyy6FmOrAAdd4clMCTmhr+0sQDjhzr
        /Q4o8yEa0GGzuPrPwfaYSzUcnrG2sTM=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-T0PHfsqdOZOzqxQ5ffMRfQ-1; Sun, 02 Apr 2023 23:18:14 -0400
X-MC-Unique: T0PHfsqdOZOzqxQ5ffMRfQ-1
Received: by mail-pj1-f71.google.com with SMTP id d13-20020a17090ad98d00b00240922fdb7cso9294914pjv.6
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 20:18:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680491892; x=1683083892;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0a2YoCPqdvT7sap4ltftxMthrEI89W8IvG18MozfGLE=;
        b=u/dSFRb+hLA+5vEKREViuYLZpWSmdVTce0yifOuW+W7hberTYYSVpfkjR1RKVE1J/P
         RaxnQ4aRB/IYU67bflZQc/K8k+vTokgtUOYpqKBAn3sfNwVbDXrXM/HUreksrFwfpxp5
         nItJjjOFM28NdvFnV5x0075UTdGeezhGSPiGxrfNtCIG57uTaZdeu6327Esqsh2B/hC3
         SaTzrdyDTyYJZN+pEAynQnjzQEIEmgOab/hcCc/yc4UsGbVZ1EPrr2nSzeaCAQsOdmnd
         j0CZ3YbC5U/LB2dEEbHBDox0XMi11Kd+0aPX4+fd46lUjBt4pwN5cRAx1caw33gvGo2Q
         HPPA==
X-Gm-Message-State: AAQBX9epnIx5n6vws9mo5GwJlSRApxYqYHa6BaYwzZqQczWM+S0rp95y
        VXkrDZaOsbqYpA5wxgTV0Mw1U1ANdNInFFHfdlOVFESbYimoaUTE7gx+ngBine23rGpx1S+wXxV
        W3Lizaof4sAC6Bede
X-Received: by 2002:a17:902:f906:b0:1a1:a7b6:e31e with SMTP id kw6-20020a170902f90600b001a1a7b6e31emr31254021plb.7.1680491892428;
        Sun, 02 Apr 2023 20:18:12 -0700 (PDT)
X-Google-Smtp-Source: AKy350YbGd0sV+9U72JXcUwXqsN0jZa3s1ooFR42QP8dDULUBD9CwCn5QOxWu4o+ScWQuzO1C6pkRQ==
X-Received: by 2002:a17:902:f906:b0:1a1:a7b6:e31e with SMTP id kw6-20020a170902f90600b001a1a7b6e31emr31254003plb.7.1680491892099;
        Sun, 02 Apr 2023 20:18:12 -0700 (PDT)
Received: from [10.72.13.175] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902a40a00b001a01bb92273sm5388287plq.279.2023.04.02.20.18.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 20:18:11 -0700 (PDT)
Message-ID: <5f48c497-1831-40cf-a4b5-5d283204d7a6@redhat.com>
Date:   Mon, 3 Apr 2023 11:18:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 6/8] virtio_net: auto release xdp shinfo
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com>
 <20230328120412.110114-7-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20230328120412.110114-7-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/3/28 20:04, Xuan Zhuo 写道:
> virtnet_build_xdp_buff_mrg() and virtnet_xdp_handler() auto


I think you meant virtnet_xdp_handler() actually?


> release xdp shinfo then the caller no need to careful the xdp shinfo.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 29 +++++++++++++++++------------
>   1 file changed, 17 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index a3f2bcb3db27..136131a7868a 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -833,14 +833,14 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
>   		stats->xdp_tx++;
>   		xdpf = xdp_convert_buff_to_frame(xdp);
>   		if (unlikely(!xdpf))
> -			return VIRTNET_XDP_RES_DROP;
> +			goto drop;
>   
>   		err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
>   		if (unlikely(!err)) {
>   			xdp_return_frame_rx_napi(xdpf);
>   		} else if (unlikely(err < 0)) {
>   			trace_xdp_exception(dev, xdp_prog, act);
> -			return VIRTNET_XDP_RES_DROP;
> +			goto drop;
>   		}
>   
>   		*xdp_xmit |= VIRTIO_XDP_TX;
> @@ -850,7 +850,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
>   		stats->xdp_redirects++;
>   		err = xdp_do_redirect(dev, xdp, xdp_prog);
>   		if (err)
> -			return VIRTNET_XDP_RES_DROP;
> +			goto drop;
>   
>   		*xdp_xmit |= VIRTIO_XDP_REDIR;
>   		return VIRTNET_XDP_RES_CONSUMED;
> @@ -862,8 +862,12 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
>   		trace_xdp_exception(dev, xdp_prog, act);
>   		fallthrough;
>   	case XDP_DROP:
> -		return VIRTNET_XDP_RES_DROP;
> +		goto drop;


This goto is kind of meaningless.

Thanks


>   	}
> +
> +drop:
> +	put_xdp_frags(xdp);
> +	return VIRTNET_XDP_RES_DROP;
>   }
>   
>   static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
> @@ -1199,7 +1203,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>   				 dev->name, *num_buf,
>   				 virtio16_to_cpu(vi->vdev, hdr->num_buffers));
>   			dev->stats.rx_length_errors++;
> -			return -EINVAL;
> +			goto err;
>   		}
>   
>   		stats->bytes += len;
> @@ -1218,7 +1222,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>   			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
>   				 dev->name, len, (unsigned long)(truesize - room));
>   			dev->stats.rx_length_errors++;
> -			return -EINVAL;
> +			goto err;
>   		}
>   
>   		frag = &shinfo->frags[shinfo->nr_frags++];
> @@ -1233,6 +1237,10 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>   
>   	*xdp_frags_truesize = xdp_frags_truesz;
>   	return 0;
> +
> +err:
> +	put_xdp_frags(xdp);
> +	return -EINVAL;
>   }
>   
>   static void *mergeable_xdp_prepare(struct virtnet_info *vi,
> @@ -1361,7 +1369,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   		err = virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, frame_sz,
>   						 &num_buf, &xdp_frags_truesz, stats);
>   		if (unlikely(err))
> -			goto err_xdp_frags;
> +			goto err_xdp;
>   
>   		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
>   
> @@ -1369,7 +1377,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   		case VIRTNET_XDP_RES_PASS:
>   			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
>   			if (unlikely(!head_skb))
> -				goto err_xdp_frags;
> +				goto err_xdp;
>   
>   			rcu_read_unlock();
>   			return head_skb;
> @@ -1379,11 +1387,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   			goto xdp_xmit;
>   
>   		case VIRTNET_XDP_RES_DROP:
> -			goto err_xdp_frags;
> +			goto err_xdp;
>   		}
> -err_xdp_frags:
> -		put_xdp_frags(&xdp);
> -		goto err_xdp;
>   	}
>   	rcu_read_unlock();
>   

