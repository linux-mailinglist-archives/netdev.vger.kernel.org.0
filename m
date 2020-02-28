Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D8C173738
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 13:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgB1MbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 07:31:07 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44514 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725805AbgB1MbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 07:31:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582893066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2RooJPrqf81zft4ke8YUUk8aT1Ot7fHdQHDbAT/pgK0=;
        b=NwOPK07i7IoY2NLS+1PZcsr+CC3IpVbfgJxPwhAE5S1uJfK1+YL0KVRe9NNh+LkpHhTVio
        ua2p4vVPxxyg3T05a42OyITV42c9cL2DkSM1ppCpmzCeZHNeZdmlEtLN7+rUeyryAlnL8C
        sN7OM0rGshH3+dBQbnyST+ZpPQgJRG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-xA0PywavMw-iwRf2hXkv3g-1; Fri, 28 Feb 2020 07:31:05 -0500
X-MC-Unique: xA0PywavMw-iwRf2hXkv3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A185C108C314;
        Fri, 28 Feb 2020 12:31:03 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D1056E3EE;
        Fri, 28 Feb 2020 12:30:55 +0000 (UTC)
Date:   Fri, 28 Feb 2020 13:30:54 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Luigi Rizzo <lrizzo@google.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org, toke@redhat.com,
        davem@davemloft.net, sameehj@amazon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] netdev attribute to control xdpgeneric skb
 linearization
Message-ID: <20200228133054.47cc4d71@carbon>
In-Reply-To: <20200228105435.75298-1-lrizzo@google.com>
References: <20200228105435.75298-1-lrizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Feb 2020 02:54:35 -0800
Luigi Rizzo <lrizzo@google.com> wrote:

> diff --git a/net/core/dev.c b/net/core/dev.c
> index dbbfff123196..c539489d3166 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4520,9 +4520,12 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>  	/* XDP packets must be linear and must have sufficient headroom
>  	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
>  	 * native XDP provides, thus we need to do it here as well.
> +	 * For non shared skbs, xdpgeneric_linearize controls linearization.
>  	 */
> -	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
> -	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
> +	if (skb_cloned(skb) ||
> +	    (skb->dev->xdpgeneric_linearize &&
> +	     (skb_is_nonlinear(skb) ||
> +	      skb_headroom(skb) < XDP_PACKET_HEADROOM))) {
>  		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
>  		int troom = skb->tail + skb->data_len - skb->end;

Have you checked that calling bpf_xdp_adjust_tail() is not breaking anything?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

