Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16924173737
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 13:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgB1MaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 07:30:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60393 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725730AbgB1M36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 07:29:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582892997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5/CKKzpFbreU0OMtvAw+wBkJ7+z4oVGyCnkh7UnzzUc=;
        b=Oz2u5g16OQPR9wsDeH6tJygTJQrvlYqpVdIlWwAAFSJllzmV9s5/kpht4X+NuFiVCS1eyN
        Iri4oNc2oOdzuwZKHNZpSip+BJDnzzs7TfE8cUpDhSgdhqc0d1mpRvxFEkzKq2DhuKlZBR
        eyYV2QonKRnSDZHji+ImxRqtp1EV7aw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-qfCMnb08OkGv40O0IKxkTQ-1; Fri, 28 Feb 2020 07:29:53 -0500
X-MC-Unique: qfCMnb08OkGv40O0IKxkTQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 982ED18A6ECC;
        Fri, 28 Feb 2020 12:29:51 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 680E460BE0;
        Fri, 28 Feb 2020 12:29:46 +0000 (UTC)
Date:   Fri, 28 Feb 2020 13:29:41 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Luigi Rizzo <lrizzo@google.com>
Cc:     netdev@vger.kernel.org, toke@redhat.com, davem@davemloft.net,
        hawk@kernel.org, sameehj@amazon.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] netdev attribute to control xdpgeneric skb
 linearization
Message-ID: <20200228132941.2c8b8d01@carbon>
In-Reply-To: <20200228105435.75298-1-lrizzo@google.com>
References: <20200228105435.75298-1-lrizzo@google.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
>  

Have you checked that calling bpf_xdp_adjust_tail() is not breaking anything?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

