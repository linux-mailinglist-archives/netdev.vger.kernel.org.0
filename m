Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F349439D28
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbhJYRMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:12:32 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:34510 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbhJYRLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 13:11:52 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id D959892009C; Mon, 25 Oct 2021 19:09:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id D55C992009B;
        Mon, 25 Oct 2021 19:09:28 +0200 (CEST)
Date:   Mon, 25 Oct 2021 19:09:28 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] fddi: defza: add missing pointer type cast
In-Reply-To: <20211025160000.2803818-1-kuba@kernel.org>
Message-ID: <alpine.DEB.2.21.2110251852540.58149@angie.orcam.me.uk>
References: <20211025160000.2803818-1-kuba@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021, Jakub Kicinski wrote:

> hw_addr is a uint AKA unsigned int. dev_addr_set() takes
> a u8 *.

 Hmm, that's for alignment purposes to keep accessors simple (and somewhat 
faster) as hardware ignores byte lane enables, though having had a look at 
`fza_reads' something seems fishy to me here and I think `hw_addr' should 
be `u64' rather than `uint[2]'.  I'll have to double-check alignments 
throughout `struct fza_cmd_init' too and possibly elsewhere.  Unaligned 
accesses will trap and will be emulated even in the kernel mode (we need 
that for some IP packet header processing too), but obviously performance 
will suck.

> diff --git a/drivers/net/fddi/defza.c b/drivers/net/fddi/defza.c
> index 3a6b08eb5e1b..f5c25acaa577 100644
> --- a/drivers/net/fddi/defza.c
> +++ b/drivers/net/fddi/defza.c
> @@ -1380,7 +1380,7 @@ static int fza_probe(struct device *bdev)
>  		goto err_out_irq;
>  
>  	fza_reads(&init->hw_addr, &hw_addr, sizeof(hw_addr));
> -	dev_addr_set(dev, &hw_addr);
> +	dev_addr_set(dev, (u8 *)&hw_addr);

 A union would be cleaner rather than having the type punned, but let's 
keep it like you proposed for now.

Acked-by: Maciej W. Rozycki <macro@orcam.me.uk>

  Maciej
