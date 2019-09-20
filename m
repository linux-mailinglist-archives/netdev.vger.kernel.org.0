Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFF2B8EB9
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 12:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406039AbfITK5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 06:57:54 -0400
Received: from elvis.franken.de ([193.175.24.41]:52334 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390701AbfITK5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 06:57:53 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1iBGbo-0006yE-00; Fri, 20 Sep 2019 12:57:52 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id C8D8AC279E; Fri, 20 Sep 2019 12:43:53 +0200 (CEST)
Date:   Fri, 20 Sep 2019 12:43:53 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Arlie Davis <arlied@google.com>
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: Bug report (with fix) for DEC Tulip driver (de2104x.c)
Message-ID: <20190920104353.GA10706@alpha.franken.de>
References: <CAK-9enMxA68mRYFG=2zD02guvCqe-aa3NO0YZuJcTdBWn5MPqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK-9enMxA68mRYFG=2zD02guvCqe-aa3NO0YZuJcTdBWn5MPqg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 02:50:53PM -0700, Arlie Davis wrote:
>     See section 4.2.2 for the specs on the transfer descriptor.
> 
> Here's my patch that fixes it:
> 
> diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c
> b/drivers/net/ethernet/dec/tulip/de2104x.c
> index f1a2da15dd0a..3a420ceb52e5 100644
> --- a/drivers/net/ethernet/dec/tulip/de2104x.c
> +++ b/drivers/net/ethernet/dec/tulip/de2104x.c
> @@ -545,6 +545,7 @@ static void de_tx (struct de_private *de)
>         while (tx_tail != tx_head) {
>                 struct sk_buff *skb;
>                 u32 status;
> +               u32 control;
> 
>                 rmb();
>                 status = le32_to_cpu(de->tx_ring[tx_tail].opts1);
> @@ -565,7 +566,8 @@ static void de_tx (struct de_private *de)
>                 pci_unmap_single(de->pdev, de->tx_skb[tx_tail].mapping,
>                                  skb->len, PCI_DMA_TODEVICE);
> 
> -               if (status & LastFrag) {
> +               control = le32_to_cpu(de->tx_ring[tx_tail].opts2);
> +               if (control & LastFrag) {

how about just remove the complete if ? We know that we always
use one descriptor per packet and chip doesn't touch control
field. So I see no reason to check it here. Tulip driver for
2114x cards doesn't check it neither.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
