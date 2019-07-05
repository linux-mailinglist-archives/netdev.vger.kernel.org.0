Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEBF06023C
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfGEIgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:36:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfGEIgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:36:51 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D78B85541;
        Fri,  5 Jul 2019 08:36:50 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1DD852C5;
        Fri,  5 Jul 2019 08:36:43 +0000 (UTC)
Date:   Fri, 5 Jul 2019 10:36:42 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v7 net-next 5/5] net: ethernet: ti: cpsw: add XDP
 support
Message-ID: <20190705103642.5489bc87@carbon>
In-Reply-To: <20190704231406.27083-6-ivan.khoronzhuk@linaro.org>
References: <20190704231406.27083-1-ivan.khoronzhuk@linaro.org>
        <20190704231406.27083-6-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 05 Jul 2019 08:36:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Jul 2019 02:14:06 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> Add XDP support based on rx page_pool allocator, one frame per page.
> Page pool allocator is used with assumption that only one rx_handler
> is running simultaneously. DMA map/unmap is reused from page pool
> despite there is no need to map whole page.
> 
> Due to specific of cpsw, the same TX/RX handler can be used by 2
> network devices, so special fields in buffer are added to identify
> an interface the frame is destined to. Thus XDP works for both
> interfaces, that allows to test xdp redirect between two interfaces
> easily. Aslo, each rx queue have own page pools, but common for both
          ^^^^
          Also

> netdevs.
> 
> XDP prog is common for all channels till appropriate changes are added
> in XDP infrastructure. Also, once page_pool recycling becomes part of
> skb netstack some simplifications can be added, like removing
> page_pool_release_page() before skb receive.
> 
> In order to keep rx_dev while redirect, that can be somehow used in
> future, do flush in rx_handler, that allows to keep rx dev the same
> while reidrect. It allows to conform with tracing rx_dev pointed
        ^^^^^^^^
        redirect

> by Jesper.
> 
> Also, there is probability, that XDP generic code can be extended to
> support multi ndev drivers like this one, using same rx queue for
> several ndevs, based on switchdev for instance or else. In this case,
> driver can be modified like exposed here:
> https://lkml.org/lkml/2019/7/3/243
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

I didn't spot any issues, but I don't have access to this hardware, so
I've not tested it.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
