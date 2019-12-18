Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9285D1243F3
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfLRKHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:07:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51705 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725930AbfLRKHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:07:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576663670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L2H+WkKsc/l2bx/U7wmjbiwWkRg7u/WvDk1Xhf9L5O0=;
        b=Q9uodE0kJ4N7EnALqHLK3ufGvHrLEWVjMc52nGUY7MfatzYsVUXCO4SHglzKIw/HFS0D7T
        zf/aKJli4/L2A2OK+wOuyile5RJBOykUA+f9VLEU5Rs4YJFbUruOdMvIw+RPB7ARzkbd3d
        z5pKf1ymZJJT/UNh9xQs5gWlkGITaek=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-tTPURtjAPKGsJctcGRmscg-1; Wed, 18 Dec 2019 05:07:46 -0500
X-MC-Unique: tTPURtjAPKGsJctcGRmscg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1240880256D;
        Wed, 18 Dec 2019 10:07:44 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAF397D8FA;
        Wed, 18 Dec 2019 10:07:36 +0000 (UTC)
Date:   Wed, 18 Dec 2019 11:07:32 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Prashant Bhole <prashantbhole.linux@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
Message-ID: <20191218110732.33494957@carbon>
In-Reply-To: <20191218081050.10170-12-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
        <20191218081050.10170-12-prashantbhole.linux@gmail.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 17:10:47 +0900
Prashant Bhole <prashantbhole.linux@gmail.com> wrote:

> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
> +			 struct xdp_frame *frame)
> +{
> +	struct bpf_prog *xdp_prog;
> +	struct tun_page tpage;
> +	struct xdp_buff xdp;
> +	u32 act = XDP_PASS;
> +	int flush = 0;
> +
> +	xdp_prog = rcu_dereference(tun->xdp_tx_prog);
> +	if (xdp_prog) {
> +		xdp.data_hard_start = frame->data - frame->headroom;
> +		xdp.data = frame->data;
> +		xdp.data_end = xdp.data + frame->len;
> +		xdp.data_meta = xdp.data - frame->metasize;

You have not configured xdp.rxq, thus a BPF-prog accessing this will crash.

For an XDP TX hook, I want us to provide/give BPF-prog access to some
more information about e.g. the current tx-queue length, or TC-q number.

Question to Daniel or Alexei, can we do this and still keep BPF_PROG_TYPE_XDP?
Or is it better to introduce a new BPF prog type (enum bpf_prog_type)
for XDP TX-hook ?

To Prashant, look at net/core/filter.c in xdp_convert_ctx_access() on
how the BPF instruction rewrites are done, when accessing xdp_rxq_info.


> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> +		switch (act) {
> +		case XDP_PASS:
> +			break;
> +		case XDP_TX:
> +			/* fall through */
> +		case XDP_REDIRECT:
> +			/* fall through */
> +		default:
> +			bpf_warn_invalid_xdp_action(act);
> +			/* fall through */
> +		case XDP_ABORTED:
> +			trace_xdp_exception(tun->dev, xdp_prog, act);
> +			/* fall through */
> +		case XDP_DROP:
> +			xdp_return_frame_rx_napi(frame);

I'm not sure that it is safe to use "napi" variant here, as you have to
be under same RX-NAPI processing loop for this to be safe.

Notice the "rx" part of the name "xdp_return_frame_rx_napi". 


> +			break;
> +		}
> +	}
> +
> +	return act;
> +}


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

