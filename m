Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBB81F5229
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 12:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgFJKWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 06:22:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43221 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728129AbgFJKWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 06:22:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591784531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k0njITY9f++hSq1Hw5Tb9xqKFGOJ4OO3ndmRGrG5uB8=;
        b=LtpeQQs67jcVBtBzW4lLChhjVSM/RT6kcOdCA3V4iflFuzjSFWcX4TTGQ+jJEbRb049fUS
        UIDFG10y5vk51t5Z7Lj9hR3Vvfs2NXSfV/qt4+4wsVn56lKO7sj3vbjnC+JOU10DIt3CT9
        5BG9Crp/H9mx5AqJnA0UoWEeMRrZN04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-lXNC9g-2M0SnkyjLW8zetg-1; Wed, 10 Jun 2020 06:22:07 -0400
X-MC-Unique: lXNC9g-2M0SnkyjLW8zetg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 234FB464;
        Wed, 10 Jun 2020 10:22:06 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C94F67B5F4;
        Wed, 10 Jun 2020 10:21:54 +0000 (UTC)
Date:   Wed, 10 Jun 2020 12:21:53 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCHv4 bpf-next 1/2] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200610122153.76d30e37@carbon>
In-Reply-To: <20200526140539.4103528-2-liuhangbin@gmail.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
        <20200526140539.4103528-1-liuhangbin@gmail.com>
        <20200526140539.4103528-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 22:05:38 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index a51d9fb7a359..ecc5c44a5bab 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
[...]

> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> +			  struct bpf_map *map, struct bpf_map *ex_map,
> +			  bool exclude_ingress)
> +{
> +	struct bpf_dtab_netdev *obj = NULL;
> +	struct xdp_frame *xdpf, *nxdpf;
> +	struct net_device *dev;
> +	bool first = true;
> +	u32 key, next_key;
> +	int err;
> +
> +	devmap_get_next_key(map, NULL, &key);
> +
> +	xdpf = convert_to_xdp_frame(xdp);
> +	if (unlikely(!xdpf))
> +		return -EOVERFLOW;
> +
> +	for (;;) {
> +		switch (map->map_type) {
> +		case BPF_MAP_TYPE_DEVMAP:
> +			obj = __dev_map_lookup_elem(map, key);
> +			break;
> +		case BPF_MAP_TYPE_DEVMAP_HASH:
> +			obj = __dev_map_hash_lookup_elem(map, key);
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		if (!obj || dev_in_exclude_map(obj, ex_map,
> +					       exclude_ingress ? dev_rx->ifindex : 0))
> +			goto find_next;
> +
> +		dev = obj->dev;
> +
> +		if (!dev->netdev_ops->ndo_xdp_xmit)
> +			goto find_next;
> +
> +		err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
> +		if (unlikely(err))
> +			goto find_next;
> +
> +		if (!first) {
> +			nxdpf = xdpf_clone(xdpf);
> +			if (unlikely(!nxdpf))
> +				return -ENOMEM;
> +
> +			bq_enqueue(dev, nxdpf, dev_rx);
> +		} else {
> +			bq_enqueue(dev, xdpf, dev_rx);

This looks racy.  You enqueue the original frame, and then later
xdpf_clone it.  The original frame might have been freed at that point.

> +			first = false;
> +		}
> +
> +find_next:
> +		err = devmap_get_next_key(map, &key, &next_key);
> +		if (err)
> +			break;
> +		key = next_key;
> +	}
> +
> +	/* didn't find anywhere to forward to, free buf */
> +	if (first)
> +		xdp_return_frame_rx_napi(xdpf);
> +
> +	return 0;
> +}
> +


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

