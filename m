Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4375297AB
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391094AbfEXLyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:54:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391271AbfEXLyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 07:54:31 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88D033087950;
        Fri, 24 May 2019 11:54:29 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D13E91001E6C;
        Fri, 24 May 2019 11:54:20 +0000 (UTC)
Date:   Fri, 24 May 2019 13:54:18 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        brouer@redhat.com, Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190524135418.5408591e@carbon>
In-Reply-To: <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
        <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 24 May 2019 11:54:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 21:20:35 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> Add XDP support based on rx page_pool allocator, one frame per page.
> Page pool allocator is used with assumption that only one rx_handler
> is running simultaneously. DMA map/unmap is reused from page pool
> despite there is no need to map whole page.

When using page_pool for DMA-mapping, your XDP-memory model must use
1-page per packet, which you state you do.  This is because
__page_pool_put_page() fallback mode does a __page_pool_clean_page()
unmapping the DMA.  Ilias and I are looking at options for removing this
restriction as Mlx5 would need it (when we extend the SKB to return
pages to page_pool).

Unfortunately, I've found another blocker for drivers using the DMA
mapping feature of page_pool.  We don't properly handle the case, where
a remote TX-driver have xdp_frame's in-flight, and simultaneously the
sending driver is unloaded and take down the page_pool.  Nothing crash,
but we end-up calling put_page() on a page that is still DMA-mapped.

I'm working on different solutions for fixing this, see here:
 https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool03_shutdown_inflight.org
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
