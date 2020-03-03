Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9BF17746C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 11:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgCCKlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 05:41:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52427 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727830AbgCCKlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 05:41:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583232066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YP0w4pc4fymck+A3w0VwHq+/e+2vIN/qnU1TyMD3gyk=;
        b=Dv4dp3640j1SMhv2b3zyIErbvKqoIk74V4FK39n5JWyI6HLKbBU2MqmLMpO38W36/uUoN+
        Vq7un8lQNVQVX5E3onv2J5GW+JyH6OrrI7DfQ9OkCMnQHU54Iqvy8O5AuySUs1boGBiSHf
        uJVo9soldmjucdysEqSZsJzvIH5KDlY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-vHJzaQ8UMDew2cdm7lsFPQ-1; Tue, 03 Mar 2020 05:41:01 -0500
X-MC-Unique: vHJzaQ8UMDew2cdm7lsFPQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4544318B9FC3;
        Tue,  3 Mar 2020 10:40:59 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 366E85D9C9;
        Tue,  3 Mar 2020 10:40:45 +0000 (UTC)
Date:   Tue, 3 Mar 2020 11:40:44 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        toke@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>,
        brouer@redhat.com
Subject: Re: [PATCH RFC v4 bpf-next 09/11] tun: Support xdp in the Tx path
 for xdp_frames
Message-ID: <20200303114044.2c7482d5@carbon>
In-Reply-To: <20200227032013.12385-10-dsahern@kernel.org>
References: <20200227032013.12385-1-dsahern@kernel.org>
        <20200227032013.12385-10-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Feb 2020 20:20:11 -0700
David Ahern <dsahern@kernel.org> wrote:

> From: David Ahern <dahern@digitalocean.com>
> 
> Add support to run Tx path program on packets arriving at a tun
> device via XDP redirect.
> 
> XDP_TX return code means move the packet to the Tx path of the device.
> For a program run in the Tx / egress path, XDP_TX is essentially the
> same as "continue on" which is XDP_PASS.
> 
> Conceptually, XDP_REDIRECT for this path can work the same as it
> does for the Rx path, but that return code is left for a follow
> on series.
> 
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  drivers/net/tun.c | 49 +++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 47 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index dcae6521a39d..d3fc7e921c85 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1359,10 +1359,50 @@ static void __tun_xdp_flush_tfile(struct tun_file *tfile)
>  	tfile->socket.sk->sk_data_ready(tfile->socket.sk);
>  }
>  
> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
> +			 struct xdp_frame *frame, struct xdp_txq_info *txq)
> +{
> +	struct bpf_prog *xdp_prog;
> +	u32 act = XDP_PASS;
> +
> +	xdp_prog = rcu_dereference(tun->xdp_egress_prog);
> +	if (xdp_prog) {
> +		struct xdp_buff xdp;
> +
> +		xdp.data_hard_start = frame->data - frame->headroom;

This is correct, only because frame->headroom have been reduced with
sizeof(*xdp_frame), as we want to avoid that the BPF-prog have access
to xdp_frame memory.  Remember that memory storing xdp_frame in located
in the top of the payload/page.


> +		xdp.data = frame->data;
> +		xdp.data_end = xdp.data + frame->len;
> +		xdp_set_data_meta_invalid(&xdp);
> +		xdp.txq = txq;
> +
> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);

The BPF-prog can change/adjust headroom and tailroom (tail only shrink,
but I'm working on extending this).  Thus, you need to adjust the
xdp_frame accordingly afterwards.

(The main use-case is pushing on a header, right?)

> +		switch (act) {
> +		case XDP_TX:    /* for Tx path, XDP_TX == XDP_PASS */
> +			act = XDP_PASS;
> +			break;
> +		case XDP_PASS:
> +			break;
> +		case XDP_REDIRECT:
> +			/* fall through */
> +		default:
> +			bpf_warn_invalid_xdp_action(act);
> +			/* fall through */
> +		case XDP_ABORTED:
> +			trace_xdp_exception(tun->dev, xdp_prog, act);
> +			/* fall through */
> +		case XDP_DROP:
> +			break;
> +		}
> +	}
> +
> +	return act;
> +}
> +
>  static int tun_xdp_xmit(struct net_device *dev, int n,
>  			struct xdp_frame **frames, u32 flags)
>  {
>  	struct tun_struct *tun = netdev_priv(dev);
> +	struct xdp_txq_info txq = { .dev = dev };
>  	struct tun_file *tfile;
>  	u32 numqueues;
>  	int drops = 0;
> @@ -1389,12 +1429,17 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
>  	spin_lock(&tfile->tx_ring.producer_lock);
>  	for (i = 0; i < n; i++) {
>  		struct xdp_frame *xdp = frames[i];
> +		void *frame;
> +
> +		if (tun_do_xdp_tx(tun, tfile, xdp, &txq) != XDP_PASS)
> +			goto drop;
> +
>  		/* Encode the XDP flag into lowest bit for consumer to differ
>  		 * XDP buffer from sk_buff.
>  		 */
> -		void *frame = tun_xdp_to_ptr(xdp);
> -
> +		frame = tun_xdp_to_ptr(xdp);
>  		if (__ptr_ring_produce(&tfile->tx_ring, frame)) {
> +drop:
>  			this_cpu_inc(tun->pcpu_stats->tx_dropped);
>  			xdp_return_frame_rx_napi(xdp);
>  			drops++;



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

