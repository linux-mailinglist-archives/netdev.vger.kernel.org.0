Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFDEB149590
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 13:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgAYMvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 07:51:21 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40908 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726191AbgAYMvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 07:51:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579956679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ocv1t7CeJt1Gyt2qx2+bhPK3AWfqw1uXpAWl3B2fMjw=;
        b=YimwaFoLB0Aefu5zpk6nMh4dj3vPyBX7gFR8W3qoJLuKwdJOyL1f/Eh1ePkrVYpAo5LP4s
        PuKCArua2Xt17Q51uSZeFT5rzG43U1T0kGplCxA4zmly/sXBG8glTBh6DcA8ZPe/aPne91
        t0WK1zmTRGPBBCdoCEr0uK3xwm1RNv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-MCgNIgQfN4iCiabFbVInDw-1; Sat, 25 Jan 2020 07:51:17 -0500
X-MC-Unique: MCgNIgQfN4iCiabFbVInDw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74A62800D4C;
        Sat, 25 Jan 2020 12:51:16 +0000 (UTC)
Received: from carbon (ovpn-200-22.brq.redhat.com [10.40.200.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A376D5C290;
        Sat, 25 Jan 2020 12:50:58 +0000 (UTC)
Date:   Sat, 25 Jan 2020 13:50:56 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: Re: [PATCH net 2/2] net: socionext: fix xdp_result initialization
 in netsec_process_rx
Message-ID: <20200125135056.3bdd4255@carbon>
In-Reply-To: <6c5c8394590826f4d69172cf31e95d44eae92245.1579952387.git.lorenzo@kernel.org>
References: <cover.1579952387.git.lorenzo@kernel.org>
        <6c5c8394590826f4d69172cf31e95d44eae92245.1579952387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jan 2020 12:48:51 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Fix xdp_result initialization in netsec_process_rx in order to not
> increase rx counters if there is no bpf program attached to the xdp hook
> and napi_gro_receive returns GRO_DROP
> 
> Fixes: ba2b232108d3c ("net: netsec: add XDP support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


>  drivers/net/ethernet/socionext/netsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index 0e12a9856aea..56c0e643f430 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -942,8 +942,8 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  		struct netsec_de *de = dring->vaddr + (DESC_SZ * idx);
>  		struct netsec_desc *desc = &dring->desc[idx];
>  		struct page *page = virt_to_page(desc->addr);
> +		u32 xdp_result = NETSEC_XDP_PASS;

As a help to reviewers value is:
#define NETSEC_XDP_PASS          0

>  		struct sk_buff *skb = NULL;
> -		u32 xdp_result = XDP_PASS;

XDP_PASS == 2
>  		u16 pkt_len, desc_len;
>  		dma_addr_t dma_handle;
>  		struct xdp_buff xdp;

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

