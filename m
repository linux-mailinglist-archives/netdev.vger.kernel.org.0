Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DA54FBFE
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 16:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfFWOJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 10:09:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33452 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfFWOJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 10:09:32 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 30FACC04959F;
        Sun, 23 Jun 2019 14:09:32 +0000 (UTC)
Received: from carbon (ovpn-112-18.phx2.redhat.com [10.3.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4B7C19C78;
        Sun, 23 Jun 2019 14:09:26 +0000 (UTC)
Date:   Sun, 23 Jun 2019 16:09:24 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     <sameehj@amazon.com>
Cc:     brouer@redhat.com, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <dwmw@amazon.com>, "Machulsky, Zorik" <zorik@amazon.com>,
        <matua@amazon.com>, <saeedb@amazon.com>, <msw@amazon.com>,
        <aliguori@amazon.com>, <nafea@amazon.com>, <gtzalik@amazon.com>,
        <netanel@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <akiyano@amazon.com>, Daniel Borkmann <borkmann@iogearbox.net>
Subject: Re: [RFC V1 net-next 1/1] net: ena: implement XDP drop support
Message-ID: <20190623160924.19456df5@carbon>
In-Reply-To: <20190623070649.18447-2-sameehj@amazon.com>
References: <20190623070649.18447-1-sameehj@amazon.com>
        <20190623070649.18447-2-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Sun, 23 Jun 2019 14:09:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I'm very happy to see progress with XDP for the ENA driver.

On Sun, 23 Jun 2019 10:06:49 +0300 <sameehj@amazon.com> wrote:

> @@ -888,6 +959,15 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
>  	va = page_address(rx_info->page) + rx_info->page_offset;
>  	prefetch(va + NET_IP_ALIGN);
>  
> +	if (ena_xdp_present_ring(rx_ring)) {
> +		rx_ring->xdp.data = va;
> +		rx_ring->xdp.data_meta = rx_ring->xdp.data;
> +		rx_ring->xdp.data_hard_start = rx_ring->xdp.data -
> +			rx_info->page_offset;
> +		rx_ring->xdp.data_end = rx_ring->xdp.data + len;
> +		if (ena_xdp_execute(rx_ring, &rx_ring->xdp) != XDP_PASS)
> +			return NULL;
> +	}

Looks like you forgot to init xdp.rxq pointer.

You can use the samples/bpf/xdp_rxq_info* to access this... and this
driver will likely crash if you use it...

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
