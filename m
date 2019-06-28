Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10F3C59C7B
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfF1NEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:04:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbfF1NEn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 09:04:43 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D28FF87630;
        Fri, 28 Jun 2019 13:04:42 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48B335D704;
        Fri, 28 Jun 2019 13:04:35 +0000 (UTC)
Date:   Fri, 28 Jun 2019 15:04:34 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, davem@davemloft.net,
        maciejromanfijalkowski@gmail.com, brouer@redhat.com
Subject: Re: [PATCH 1/3, net-next] net: netsec: Use page_pool API
Message-ID: <20190628150434.30da8852@carbon>
In-Reply-To: <1561718355-13919-2-git-send-email-ilias.apalodimas@linaro.org>
References: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
        <1561718355-13919-2-git-send-email-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 28 Jun 2019 13:04:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 13:39:13 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> Use page_pool and it's DMA mapping capabilities for Rx buffers instead
> of netdev/napi_alloc_frag()
> 
> Although this will result in a slight performance penalty on small sized
> packets (~10%) the use of the API will allow to easily add XDP support.
> The penalty won't be visible in network testing i.e ipef/netperf etc, it
> only happens during raw packet drops.
> Furthermore we intend to add recycling capabilities on the API
> in the future. Once the recycling is added the performance penalty will
> go away.
> The only 'real' penalty is the slightly increased memory usage, since we
> now allocate a page per packet instead of the amount of bytes we need +
> skb metadata (difference is roughly 2kb per packet).
> With a minimum of 4BG of RAM on the only SoC that has this NIC the
> extra memory usage is negligible (a bit more on 64K pages)
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> ---
>  drivers/net/ethernet/socionext/Kconfig  |   1 +
>  drivers/net/ethernet/socionext/netsec.c | 121 +++++++++++++++---------
>  2 files changed, 75 insertions(+), 47 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
