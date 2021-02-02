Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573D430C553
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbhBBQTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:19:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28988 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234212AbhBBOPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 09:15:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612275264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KunqakVn1xJ0m1dnFKxNWc2BsmU6toTjQEsO1J2kZn0=;
        b=H//9CgY5x3z8CnKPCqtN4QQww5X39zOD+kZQL42HsZYk12GZZblJimwnUj/7VoLQcgkmA+
        MVlbYlrC861VE66mS2O6cxrJcognYv5wUnKXN/49vaqoMT7/1snYFaTvLZuES9ywvQgi1K
        p1n8MWpDhveMhl9VxVoXDO8sMGZ8twU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-B9QHKUKmMfmP75dYQNcZFA-1; Tue, 02 Feb 2021 09:14:22 -0500
X-MC-Unique: B9QHKUKmMfmP75dYQNcZFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F8F281620;
        Tue,  2 Feb 2021 14:14:20 +0000 (UTC)
Received: from carbon.lan (unknown [10.36.110.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BD4F4D;
        Tue,  2 Feb 2021 14:14:03 +0000 (UTC)
Date:   Tue, 2 Feb 2021 15:14:00 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        toshiaki.makita1@gmail.com, lorenzo.bianconi@redhat.com,
        toke@redhat.com, brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next] net: veth: alloc skb in bulk for
 ndo_xdp_xmit
Message-ID: <20210202151400.00e36ff7@carbon.lan>
In-Reply-To: <a14a30d3c06fff24e13f836c733d80efc0bd6eb5.1611957532.git.lorenzo@kernel.org>
References: <a14a30d3c06fff24e13f836c733d80efc0bd6eb5.1611957532.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 23:04:08 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Split ndo_xdp_xmit and ndo_start_xmit use cases in veth_xdp_rcv routine
> in order to alloc skbs in bulk for XDP_PASS verdict.
> Introduce xdp_alloc_skb_bulk utility routine to alloc skb bulk list.
> The proposed approach has been tested in the following scenario:
> 
> eth (ixgbe) --> XDP_REDIRECT --> veth0 --> (remote-ns) veth1 --> XDP_PASS
> 
> XDP_REDIRECT: xdp_redirect_map bpf sample
> XDP_PASS: xdp_rxq_info bpf sample
> 
> traffic generator: pkt_gen sending udp traffic on a remote device
> 
> bpf-next master: ~3.64Mpps
> bpf-next + skb bulking allocation: ~3.79Mpps
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

I wanted Lorenzo to test 8 vs 16 bulking, but after much testing and
IRC dialog, we cannot find and measure any difference with enough
accuracy. Thus:

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> Changes since v2:
> - use __GFP_ZERO flag instead of memset
> - move some veth_xdp_rcv_batch() logic in veth_xdp_rcv_skb()
> 
> Changes since v1:
> - drop patch 2/3, squash patch 1/3 and 3/3
> - set VETH_XDP_BATCH to 16
> - rework veth_xdp_rcv to use __ptr_ring_consume
> ---
>  drivers/net/veth.c | 78 ++++++++++++++++++++++++++++++++++------------
>  include/net/xdp.h  |  1 +
>  net/core/xdp.c     | 11 +++++++
>  3 files changed, 70 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 6e03b619c93c..aa1a66ad2ce5 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -35,6 +35,7 @@
>  #define VETH_XDP_HEADROOM	(XDP_PACKET_HEADROOM + NET_IP_ALIGN)
>  
>  #define VETH_XDP_TX_BULK_SIZE	16
> +#define VETH_XDP_BATCH		16
>  


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

