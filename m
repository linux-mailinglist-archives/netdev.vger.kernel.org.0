Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD52149587
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 13:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgAYMpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 07:45:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47773 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726191AbgAYMpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 07:45:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579956332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=djmhnJMNAZ3nK4m/SfSYCHUp1ZeQ5v8ufolDTDJcRmA=;
        b=JT08nkcrhZlBaX4a8DG7sLfB6O53YwoBAdIbsx9TI0m8MdFrRvxIGUV3H1AO7qNJhrG6WV
        2K+/iHrmnObiPzobUu0CsUnVxpe7t0sCZ50QdRDg+6I8j1jBg+DD/ci91NEZKl4WMg8DfH
        EcY2M/EO7C4hslsHRlbfGOgB3KYNXQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-MeXabQvPOXiF9ZvyDwF1gw-1; Sat, 25 Jan 2020 07:45:30 -0500
X-MC-Unique: MeXabQvPOXiF9ZvyDwF1gw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F1D31800D78;
        Sat, 25 Jan 2020 12:45:29 +0000 (UTC)
Received: from carbon (ovpn-200-22.brq.redhat.com [10.40.200.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4032B28D0D;
        Sat, 25 Jan 2020 12:45:21 +0000 (UTC)
Date:   Sat, 25 Jan 2020 13:45:21 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: Re: [PATCH net 1/2] net: socionext: fix possible user-after-free in
 netsec_process_rx
Message-ID: <20200125134521.28ae1fd7@carbon>
In-Reply-To: <b66c3b2603da49706597d84aacb7ac8b4ffb1820.1579952387.git.lorenzo@kernel.org>
References: <cover.1579952387.git.lorenzo@kernel.org>
        <b66c3b2603da49706597d84aacb7ac8b4ffb1820.1579952387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jan 2020 12:48:50 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Fix possible use-after-free in in netsec_process_rx that can occurs if
> the first packet is sent to the normal networking stack and the
> following one is dropped by the bpf program attached to the xdp hook.
> Fix the issue defining the skb pointer in the 'budget' loop
> 
> Fixes: ba2b232108d3c ("net: netsec: add XDP support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

>  drivers/net/ethernet/socionext/netsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index 869a498e3b5e..0e12a9856aea 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -929,7 +929,6 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  	struct netsec_rx_pkt_info rx_info;
>  	enum dma_data_direction dma_dir;
>  	struct bpf_prog *xdp_prog;
> -	struct sk_buff *skb = NULL;
>  	u16 xdp_xmit = 0;
>  	u32 xdp_act = 0;
>  	int done = 0;
> @@ -943,6 +942,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  		struct netsec_de *de = dring->vaddr + (DESC_SZ * idx);
>  		struct netsec_desc *desc = &dring->desc[idx];
>  		struct page *page = virt_to_page(desc->addr);
> +		struct sk_buff *skb = NULL;
>  		u32 xdp_result = XDP_PASS;
>  		u16 pkt_len, desc_len;
>  		dma_addr_t dma_handle;

Yes, this is needed in case an xdp_prog jumps to label 'next:',
skipping the skb = build_skb() assignment.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

