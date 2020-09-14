Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0743B268428
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 07:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgINFkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 01:40:33 -0400
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:57700
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726003AbgINFkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 01:40:32 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Sep 2020 01:40:31 EDT
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id A74C4207C1;
        Mon, 14 Sep 2020 05:32:54 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 14 Sep 2020 07:32:54 +0200
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/net/wan/x25_asy: Remove an unnecessary
 x25_type_trans call
Organization: TDT AG
In-Reply-To: <20200912021807.365158-1-xie.he.0141@gmail.com>
References: <20200912021807.365158-1-xie.he.0141@gmail.com>
Message-ID: <4d6345b6b072f60366aec9626809da95@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.1.5
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-12 04:18, Xie He wrote:
> x25_type_trans only needs to be called before we call netif_rx to pass
> the skb to upper layers.
> 
> It does not need to be called before lapb_data_received. The LAPB 
> module
> does not need the fields that are set by calling it.
> 
> In the other two X.25 drivers - lapbether and hdlc_x25. x25_type_trans
> is only called before netif_rx and not before lapb_data_received.
> 
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  drivers/net/wan/x25_asy.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
> index 5a7cf8bf9d0d..ab56a5e6447a 100644
> --- a/drivers/net/wan/x25_asy.c
> +++ b/drivers/net/wan/x25_asy.c
> @@ -202,8 +202,7 @@ static void x25_asy_bump(struct x25_asy *sl)
>  		return;
>  	}
>  	skb_put_data(skb, sl->rbuff, count);
> -	skb->protocol = x25_type_trans(skb, sl->dev);
> -	err = lapb_data_received(skb->dev, skb);
> +	err = lapb_data_received(sl->dev, skb);
>  	if (err != LAPB_OK) {
>  		kfree_skb(skb);
>  		printk(KERN_DEBUG "x25_asy: data received err - %d\n", err);

Acked-by: Martin Schiller <ms@dev.tdt.de>

