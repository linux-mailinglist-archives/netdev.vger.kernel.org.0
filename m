Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 806F117747A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 11:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgCCKqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 05:46:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58401 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728572AbgCCKqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 05:46:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583232399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LXoGHL9cKs2G5/LsZKUdNKvZevYMpMCWwnuchpUSF1c=;
        b=ENtZMMupZXcK2poSmMlO7+JkApZTHzO9fsVo5IJKhIIFKJGsw5pZZiLM1SPnOyZz5Gs8BA
        fh83kHPMQWAkeuA5HSXi4Jl6IdRXBabOP9kty+QHL0sZx/vnIDol135Ok3sUEer4tTJYEi
        DpPqBjgeLCgglp8pI7JVgwREScOr+uY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-STFBAl4CPJSfLbyNMrdLJg-1; Tue, 03 Mar 2020 05:46:38 -0500
X-MC-Unique: STFBAl4CPJSfLbyNMrdLJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09C64801E76;
        Tue,  3 Mar 2020 10:46:36 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 574865D9C9;
        Tue,  3 Mar 2020 10:46:21 +0000 (UTC)
Date:   Tue, 3 Mar 2020 11:46:19 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        toke@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>,
        brouer@redhat.com
Subject: Re: [PATCH RFC v4 bpf-next 08/11] tun: Support xdp in the Tx path
 for skb
Message-ID: <20200303114619.1b5b52bc@carbon>
In-Reply-To: <20200227032013.12385-9-dsahern@kernel.org>
References: <20200227032013.12385-1-dsahern@kernel.org>
        <20200227032013.12385-9-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Feb 2020 20:20:10 -0700
David Ahern <dsahern@kernel.org> wrote:

> +static u32 tun_do_xdp_tx_generic(struct tun_struct *tun,
> +				 struct net_device *dev,
> +				 struct sk_buff *skb)
> +{
> +	struct bpf_prog *xdp_prog;
> +	u32 act = XDP_PASS;
> +
> +	xdp_prog = rcu_dereference(tun->xdp_egress_prog);
> +	if (xdp_prog) {
> +		struct xdp_txq_info txq = { .dev = dev };
> +		struct xdp_buff xdp;
> +
> +		skb = tun_prepare_xdp_skb(skb);
> +		if (!skb) {
> +			act = XDP_DROP;
> +			goto out;
> +		}
> +
> +		xdp.txq = &txq;
> +
> +		act = do_xdp_generic_core(skb, &xdp, xdp_prog);
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

Hmm, don't we need to extend the trace_xdp_exception() to give users a
hint that this happened on the TX/egress path?

> +			/* fall through */
> +		case XDP_DROP:
> +			break;
> +		}
> +	}
> +
> +out:
> +	return act;
> +}


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

