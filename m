Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1552631DD
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731071AbgIIQ26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731098AbgIIQ2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:28:42 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24728C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:28:42 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id u21so4478035eja.2
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 09:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=so9uz90DQo4KjR3AxKaW0CMVUnvyI+mDfB4zh4RW7Rc=;
        b=cOH53+aepFsKMC2a2j23qImLN9bczn8Uvp4tT7kEv/KbXzGh+L0hPVzQwF0mAHnrJR
         dWNgrLxSDGJkQprJ3VkAF1mdSeAXp37v0DRo794iTsMlW7Cn4KbRk2SncWlXzEtRHSYO
         Lr0owS5/AWZSAhMrhG41H+Zl2BX/rJ+altJLv/thh4XkUxyMW3NsWxAfPeD9WFsnhoAy
         nCAKQR4gUi/JbB4gDxONwAIfosAEaKjfuhU1lMiREH/T1GAAcjrezg2l6nTvMdsqap6D
         kq0ko5cQDoL8KAwpMgg9Q/En86b3TmQc7rQ+icro+irseEhAWg0irceK/CDmkVFoJTHL
         8idg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=so9uz90DQo4KjR3AxKaW0CMVUnvyI+mDfB4zh4RW7Rc=;
        b=L71jFsIm2m0YBeDaZvjMuXbjj2avsqpjAoDKeejrUfM9vPSjc6+iuuTq2/vUKCB3Wu
         bUVoPq+YH9dQF9gjcHTqMa+Dz5wCFfUb4WwgogrP1mXvKxvVUFEwjCc04Dhl/9xgD7fd
         u7uPq0X8XkuKRLhI1a8SvPTAMquZUI9B+87dx9htFRSgJZQhjjACWm3gNFXakGYdhTV4
         zHK3LaAD22ZfzJOTJZmV8kFrORwjIf2l0JAfWsYbfZUvIDSGS/lcrOylmMiZRhnD7GPl
         uoWBOnPLnYISGqsC8aY599eg5NSY4YtNLb7/cJjN3sat7ABD5cZSXPLt8kYWb99fqqmX
         kPag==
X-Gm-Message-State: AOAM532ZZ5kREOOmbyIS5jhvlVqempc6rrCy6AcSBh79UFUS0FHYtoYn
        dT9sPytG6BcT/L4HS1sOxKgGBA==
X-Google-Smtp-Source: ABdhPJxIvuNLJajbInQoEnSl4WGQMVtsDb+7BvARTTmspPI+QcvkHrafs9M5tjRCNcun3eaoF3afYQ==
X-Received: by 2002:a17:906:a156:: with SMTP id bu22mr4633110ejb.177.1599668920833;
        Wed, 09 Sep 2020 09:28:40 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id w14sm2920758ejn.36.2020.09.09.09.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 09:28:40 -0700 (PDT)
Date:   Wed, 9 Sep 2020 18:28:39 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, jes@trained-monkey.org, kuba@kernel.org,
        dougmill@linux.ibm.com, cooldavid@cooldavid.org,
        mlindner@marvell.com, stephen@networkplumber.org,
        borisp@mellanox.com, netdev@vger.kernel.org,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 16/20] ethernet: netronome: convert tasklets to use
 new tasklet_setup() API
Message-ID: <20200909162838.GA28336@netronome.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
 <20200909084510.648706-17-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909084510.648706-17-allen.lkml@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 02:15:06PM +0530, Allen Pais wrote:
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

The correct prefix for NFP driver patches is "nfp: ", not
"ethernet: netronome: ". Possibly a similar comment applies to other
patches in this series.

Patches targeted at "net-next" should include "net-next" in the subject,
like this: [PATCH v2 net-next 16/20] ...

The patch itself seems fine to me.
So with the above fixed feel free to add:

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> index 21ea22694e47..b150da43adb2 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> @@ -2287,9 +2287,9 @@ static bool nfp_ctrl_rx(struct nfp_net_r_vector *r_vec)
>  	return budget;
>  }
>  
> -static void nfp_ctrl_poll(unsigned long arg)
> +static void nfp_ctrl_poll(struct tasklet_struct *t)
>  {
> -	struct nfp_net_r_vector *r_vec = (void *)arg;
> +	struct nfp_net_r_vector *r_vec = from_tasklet(r_vec, t, tasklet);
>  
>  	spin_lock(&r_vec->lock);
>  	nfp_net_tx_complete(r_vec->tx_ring, 0);
> @@ -2337,8 +2337,7 @@ static void nfp_net_vecs_init(struct nfp_net *nn)
>  
>  			__skb_queue_head_init(&r_vec->queue);
>  			spin_lock_init(&r_vec->lock);
> -			tasklet_init(&r_vec->tasklet, nfp_ctrl_poll,
> -				     (unsigned long)r_vec);
> +			tasklet_setup(&r_vec->tasklet, nfp_ctrl_poll);
>  			tasklet_disable(&r_vec->tasklet);
>  		}
>  
> -- 
> 2.25.1
> 
