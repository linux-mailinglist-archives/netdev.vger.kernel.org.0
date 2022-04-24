Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD03E50D12D
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 12:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237494AbiDXKm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 06:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239108AbiDXKmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 06:42:53 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F71418A61E;
        Sun, 24 Apr 2022 03:39:50 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 3120D92009C; Sun, 24 Apr 2022 12:39:50 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 2DAA792009B;
        Sun, 24 Apr 2022 11:39:50 +0100 (BST)
Date:   Sun, 24 Apr 2022 11:39:50 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Wan Jiabing <wanjiabing@vivo.com>
cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Subject: Re: [PATCH] FDDI: defxx: simplify if-if to if-else
In-Reply-To: <20220424092842.101307-1-wanjiabing@vivo.com>
Message-ID: <alpine.DEB.2.21.2204241137440.9383@angie.orcam.me.uk>
References: <20220424092842.101307-1-wanjiabing@vivo.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Apr 2022, Wan Jiabing wrote:

> diff --git a/drivers/net/fddi/defxx.c b/drivers/net/fddi/defxx.c
> index b584ffe38ad6..3edb2e96f763 100644
> --- a/drivers/net/fddi/defxx.c
> +++ b/drivers/net/fddi/defxx.c
> @@ -585,10 +585,10 @@ static int dfx_register(struct device *bdev)
>  			bp->mmio = false;
>  			dfx_get_bars(bp, bar_start, bar_len);
>  		}
> -	}
> -	if (!dfx_use_mmio)
> +	} else {
>  		region = request_region(bar_start[0], bar_len[0],
>  					bdev->driver->name);
> +	}

 NAK.  The first conditional optionally sets `bp->mmio = false', which 
changes the value of `dfx_use_mmio' in some configurations:

#if defined(CONFIG_EISA) || defined(CONFIG_PCI)
#define dfx_use_mmio bp->mmio
#else
#define dfx_use_mmio true
#endif

  Maciej
