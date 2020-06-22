Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB19B2033ED
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgFVJs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:48:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45712 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726525AbgFVJs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:48:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592819335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cf6nDCtN7M7tXSP4Nc4eZ+rkXRJDalbgveDT6DSJ+XQ=;
        b=DRX/N8DEeEnmxrT3z9LN+0xxsQPO07YCCSsKYqPfPmnTx7/dbvEfN8JLPX/GPqXLiMS6id
        /PStSzcbunjR5IuvQko9mTZU5WyXopBY54k8KgJNFzru2ihdI8Z0SmcyOSathxv2cCtTJn
        VhAhY0ltuz552RNcasg66Lxk/yD/jp0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-aSyqZULhPo2_nCin_g1Xzw-1; Mon, 22 Jun 2020 05:48:52 -0400
X-MC-Unique: aSyqZULhPo2_nCin_g1Xzw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB535835B41;
        Mon, 22 Jun 2020 09:48:50 +0000 (UTC)
Received: from carbon (unknown [10.40.208.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DBBA1A265;
        Mon, 22 Jun 2020 09:48:38 +0000 (UTC)
Date:   Mon, 22 Jun 2020 11:48:37 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org, brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next 4/8] bpf: cpumap: add the possibility to
 attach an eBPF program to cpumap
Message-ID: <20200622114837.278adefa@carbon>
In-Reply-To: <734113565894cb8447d1526e6a93eaf6ae994c2d.1592606391.git.lorenzo@kernel.org>
References: <cover.1592606391.git.lorenzo@kernel.org>
        <734113565894cb8447d1526e6a93eaf6ae994c2d.1592606391.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Jun 2020 00:57:20 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> +static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
> +				    void **xdp_frames, int n,
> +				    struct xdp_cpumap_stats *stats)
> +{
> +	struct xdp_rxq_info rxq;

I do think we can merge this code as-is (and I actually re-factored this
code offlist), but I have some optimizations I would like to try out.

E.g. as I've tried to explain over IRC, it will be possible to avoid
having to reconstruct xdp_rxq_info here, as we can use the
expected_attach_type and remap the BPF instructions to use info from
xdp_frame.  I want to benchmark it first, to see if it is worth it (we
will only save 2 store operations in a likely cache-hot area).


> +	struct bpf_prog *prog;
> +	struct xdp_buff xdp;
> +	int i, nframes = 0;
> +
> +	if (!rcpu->prog)
> +		return n;
> +
> +	xdp_set_return_frame_no_direct();
> +	xdp.rxq = &rxq;
> +
> +	rcu_read_lock();
> +
> +	prog = READ_ONCE(rcpu->prog);
> +	for (i = 0; i < n; i++) {
> +		struct xdp_frame *xdpf = xdp_frames[i];
> +		u32 act;
> +		int err;
> +
> +		rxq.dev = xdpf->dev_rx;
> +		rxq.mem = xdpf->mem;
> +		/* TODO: report queue_index to xdp_rxq_info */
> +
> +		xdp_convert_frame_to_buff(xdpf, &xdp);
> +
> +		act = bpf_prog_run_xdp(prog, &xdp);
> +		switch (act) {
> +		case XDP_PASS:
> +			err = xdp_update_frame_from_buff(&xdp, xdpf);
> +			if (err < 0) {
> +				xdp_return_frame(xdpf);
> +				stats->drop++;
> +			} else {
> +				xdp_frames[nframes++] = xdpf;
> +				stats->pass++;
> +			}
> +			break;
> +		default:
> +			bpf_warn_invalid_xdp_action(act);
> +			/* fallthrough */
> +		case XDP_DROP:
> +			xdp_return_frame(xdpf);
> +			stats->drop++;
> +			break;
> +		}
> +	}
> +
> +	rcu_read_unlock();
> +	xdp_clear_return_frame_no_direct();
> +
> +	return nframes;
> +}



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

