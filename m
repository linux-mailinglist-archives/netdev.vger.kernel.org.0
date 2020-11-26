Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7482E2C526F
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 11:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388489AbgKZKve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 05:51:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbgKZKve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 05:51:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606387892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gjiOuLAHt7YqrFLz1eLEvNsryaX1UyRkFt2nva2s6Y=;
        b=h2SUC9oPq51p9JOCE1BEPVfCwJyGKpT80TFPzuibNpOLwkpfpbevtCK3VdjXB3Un2FkAgp
        xJ9AhpvkVwb5f2p7gFkG6iXu4cyJogI3pJd8wB9i9pA9J+W3Iqi57znT87GmkUGXgO0I6w
        1I1QY3l0famERTl00kudD3/6krzO6uc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-6unmhYAgPsSlmwKned8fRw-1; Thu, 26 Nov 2020 05:51:30 -0500
X-MC-Unique: 6unmhYAgPsSlmwKned8fRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 606661005D55;
        Thu, 26 Nov 2020 10:51:29 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EE246085A;
        Thu, 26 Nov 2020 10:51:20 +0000 (UTC)
Date:   Thu, 26 Nov 2020 11:51:19 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        brouer@redhat.com
Subject: Re: [PATCHv2 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
Message-ID: <20201126115119.20f82cba@carbon>
In-Reply-To: <20201126084325.477470-1-liuhangbin@gmail.com>
References: <20201110124639.1941654-1-liuhangbin@gmail.com>
        <20201126084325.477470-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 16:43:25 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> Current sample test xdp_redirect_map only count pkts on ingress. But we
> can't know whether the pkts are redirected or dropped. So add a counter
> on egress interface so we could know how many pkts are redirect in fact.

This is not true.

The 2nd devmap XDP-prog will run in the same RX-context, so it doesn't
tell us if the redirect was successful.  I looked up the code, and the
2nd XDP-prog is even allowed to run when the egress driver doesn't
support the NDO to xmit (dev->netdev_ops->ndo_xdp_xmit), which is very
misleading, if you place a output counter here.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
			       struct net_device *dev_rx)
{
	struct xdp_frame *xdpf;
	int err;

	if (!dev->netdev_ops->ndo_xdp_xmit)
		return -EOPNOTSUPP;

	err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
	if (unlikely(err))
		return err;

	xdpf = xdp_convert_buff_to_frame(xdp);
	if (unlikely(!xdpf))
		return -EOVERFLOW;

	bq_enqueue(dev, xdpf, dev_rx);
	return 0;
}

static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
					 struct xdp_buff *xdp,
					 struct bpf_prog *xdp_prog)
{
	struct xdp_txq_info txq = { .dev = dev };
	u32 act;

	xdp_set_data_meta_invalid(xdp);
	xdp->txq = &txq;

	act = bpf_prog_run_xdp(xdp_prog, xdp);
	switch (act) {
	case XDP_PASS:
		return xdp;
	case XDP_DROP:
		break;
	default:
		bpf_warn_invalid_xdp_action(act);
		fallthrough;
	case XDP_ABORTED:
		trace_xdp_exception(dev, xdp_prog, act);
		break;
	}

	xdp_return_buff(xdp);
	return NULL;
}

int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
		    struct net_device *dev_rx)
{
	return __xdp_enqueue(dev, xdp, dev_rx);
}

int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
		    struct net_device *dev_rx)
{
	struct net_device *dev = dst->dev;

	if (dst->xdp_prog) {
		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
		if (!xdp)
			return 0;
	}
	return __xdp_enqueue(dev, xdp, dev_rx);
}

