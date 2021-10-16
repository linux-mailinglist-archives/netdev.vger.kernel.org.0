Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C03F4304FA
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 23:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244637AbhJPVD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 17:03:27 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:43072 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbhJPVD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 17:03:27 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Oct 2021 17:03:26 EDT
Received: from [IPv6:2003:e9:d74b:bb6b:a631:44a4:c3ee:c1f5] (p200300e9d74bbb6ba63144a4c3eec1f5.dip0.t-ipconnect.de [IPv6:2003:e9:d74b:bb6b:a631:44a4:c3ee:c1f5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id F26E3C079E;
        Sat, 16 Oct 2021 22:54:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1634417697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qUQR/nPhWlF8WaqCMJXIqyfMUvBxNFbRYdI1MwZS1WY=;
        b=KdLBrZmqOdV50YlWqGRdtT78UkdBLzKONXo8WMq+VB8RAHkWyodv/rcZAYYgtDPcnqmIi+
        AoqCb/mFpn1zu8vVuEVjBON/858oqdS2nL5Wa9eTEDEYYCrU/cRIx8NapcJ0r/djFuh4j5
        MOTpdMnoncEd6ngRaCa+PLfHMZH1na25PNM1j7zPDK5y91zLISJHkNJv2IQ4uKSnDNPMfg
        qbhs75QF/NvJsqH/ci//Fim/xBAKzJydXse3euKtjW0Io7nWbVUS6acwRP5IM8Rbc9bhFy
        r3xQm1g2cKbWhYgSdy41XnkftEz2xqsKGhIondi3NTmfjMrpZ58ZA57NXWGvFw==
Subject: Re: [PATCH] ieee802154: Remove redundant 'flush_workqueue()' calls
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        h.morris@cascoda.com, alex.aring@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <fedb57c4f6d4373e0d6888d13ad2de3a1d315d81.1634235880.git.christophe.jaillet@wanadoo.fr>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <0a080522-a30b-8b78-86d2-66c1c1a5f604@datenfreihafen.org>
Date:   Sat, 16 Oct 2021 22:54:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <fedb57c4f6d4373e0d6888d13ad2de3a1d315d81.1634235880.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

I have nothing else in my ieee802154 tree for net right now so it would 
be great if you could take it directly. If that poses a problem, let me 
know and I will get it in through my tree.

On 14.10.21 20:26, Christophe JAILLET wrote:
> 'destroy_workqueue()' already drains the queue before destroying it, so
> there is no need to flush it explicitly.
> 
> Remove the redundant 'flush_workqueue()' calls.
> 
> This was generated with coccinelle:
> 
> @@
> expression E;
> @@
> - 	flush_workqueue(E);
> 	destroy_workqueue(E);
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/net/ieee802154/ca8210.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index 3a2824f24caa..ece6ff6049f6 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -2938,9 +2938,7 @@ static int ca8210_dev_com_init(struct ca8210_priv *priv)
>    */
>   static void ca8210_dev_com_clear(struct ca8210_priv *priv)
>   {
> -	flush_workqueue(priv->mlme_workqueue);
>   	destroy_workqueue(priv->mlme_workqueue);
> -	flush_workqueue(priv->irq_workqueue);
>   	destroy_workqueue(priv->irq_workqueue);
>   }
>   
> 

Thanks Christophe for spotting and fixing this.

Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
