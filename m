Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF4C5A297
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfF1Rl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:41:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbfF1Rl1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 13:41:27 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4B87A3001802;
        Fri, 28 Jun 2019 17:41:22 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C451C608D0;
        Fri, 28 Jun 2019 17:41:10 +0000 (UTC)
Date:   Fri, 28 Jun 2019 19:41:09 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        jaswinder.singh@linaro.org, ard.biesheuvel@linaro.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, maciejromanfijalkowski@gmail.com,
        brouer@redhat.com
Subject: Re: [PATCH 1/3, net-next] net: netsec: Use page_pool API
Message-ID: <20190628194109.7fecc5f5@carbon>
In-Reply-To: <20190628171934.GA31070@apalos>
References: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
        <1561718355-13919-2-git-send-email-ilias.apalodimas@linaro.org>
        <20190628150434.30da8852@carbon>
        <20190628.094343.1065314747200152509.davem@davemloft.net>
        <20190628171934.GA31070@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 28 Jun 2019 17:41:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 20:19:34 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> Hi David, 
> 
> > >> Use page_pool and it's DMA mapping capabilities for Rx buffers instead
> > >> of netdev/napi_alloc_frag()
> > >> 
> > >> Although this will result in a slight performance penalty on small sized
> > >> packets (~10%) the use of the API will allow to easily add XDP support.
> > >> The penalty won't be visible in network testing i.e ipef/netperf etc, it
> > >> only happens during raw packet drops.
> > >> Furthermore we intend to add recycling capabilities on the API
> > >> in the future. Once the recycling is added the performance penalty will
> > >> go away.
> > >> The only 'real' penalty is the slightly increased memory usage, since we
> > >> now allocate a page per packet instead of the amount of bytes we need +
> > >> skb metadata (difference is roughly 2kb per packet).
> > >> With a minimum of 4BG of RAM on the only SoC that has this NIC the
> > >> extra memory usage is negligible (a bit more on 64K pages)
> > >> 
> > >> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > >> ---
> > >>  drivers/net/ethernet/socionext/Kconfig  |   1 +
> > >>  drivers/net/ethernet/socionext/netsec.c | 121 +++++++++++++++---------
> > >>  2 files changed, 75 insertions(+), 47 deletions(-)  
> > > 
> > > Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>  
> > 
> > Jesper this is confusing, you just asked if the code needs to be moved
> > around to be correct and then right now immediately afterwards you ACK
> > the patch.
>
> I can answer on the driver, page_pool_free() needs re-arranging
> indeed. I'll fix it and post a V2. I guess Jesper meant
> 'acked-if-fixed' so i can it on V2

Sorry, it was a mistake.  I though I had spotted an issue in 3/3 and
then I wanted to ACK 1/3.   Ilias you can add my ACK in V2, as this was
the only issue I spotted in 1/3.

Sorry for the confusion.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
