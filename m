Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8FB1FFEB2
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 01:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgFRXft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 19:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbgFRXfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 19:35:48 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E6FE206FA;
        Thu, 18 Jun 2020 23:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592523348;
        bh=60wkdJzvFg/6tlglOjQPgWYN/SHTvdLdTZp6Zt/GAP8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=haHhbMDYFdA455rCqd1raN1WRkUs+1zRBXt59PTWKEoQy7Fcg8emVGkCvodK7ObKa
         OWeXz7dVcHNGuUlAh8JBd9GwgfGJj60GFtGivnG/CjrPf7GADzS2OjXaBRcbZucZcW
         Ym2ERz/z7Ja+vjSorGZrUaa4O/CBiVoTwAYXTlFc=
Date:   Thu, 18 Jun 2020 16:35:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Barry Song <song.bao.hua@hisilicon.com>
Cc:     <davem@davemloft.net>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <linyunsheng@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH 2/5] net: hns3: pointer type of buffer should be void
Message-ID: <20200618163545.4544860d@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200618010211.75840-3-song.bao.hua@hisilicon.com>
References: <20200618010211.75840-1-song.bao.hua@hisilicon.com>
        <20200618010211.75840-3-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jun 2020 13:02:08 +1200 Barry Song wrote:
> Move the type of buffer address from unsigned char to void
> 
> Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index 1817d7f2e5f6..61b5a849b162 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -3070,7 +3070,7 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring)
>  		return -ENXIO;
>  
>  	if (!skb)
> -		ring->va = (unsigned char *)desc_cb->buf + desc_cb->page_offset;
> +		ring->va = desc_cb->buf + desc_cb->page_offset;
>  
>  	/* Prefetch first cache line of first page
>  	 * Idea is to cache few bytes of the header of the packet. Our L1 Cache
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> index 66cd4395f781..9f64077ee834 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> @@ -407,7 +407,7 @@ struct hns3_enet_ring {
>  
>  	u32 pull_len; /* head length for current packet */
>  	u32 frag_num;
> -	unsigned char *va; /* first buffer address for current packet */
> +	void *va; /* first buffer address for current packet */
>  
>  	u32 flag;          /* ring attribute */
>  

I think void pointer arithmetic is questionable in the eyes of the C
standard. But I'm not sure about kernel C.

Otherwise series looks good to me.

