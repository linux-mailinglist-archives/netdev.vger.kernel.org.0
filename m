Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 333DD5DED8
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfGCH0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:26:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14659 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbfGCH0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 03:26:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F2A123083391;
        Wed,  3 Jul 2019 07:26:12 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CCF680F70;
        Wed,  3 Jul 2019 07:26:05 +0000 (UTC)
Date:   Wed, 3 Jul 2019 09:26:03 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v5 net-next 6/6] net: ethernet: ti: cpsw: add XDP
 support
Message-ID: <20190703092603.66f36914@carbon>
In-Reply-To: <20190630172348.5692-7-ivan.khoronzhuk@linaro.org>
References: <20190630172348.5692-1-ivan.khoronzhuk@linaro.org>
        <20190630172348.5692-7-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 03 Jul 2019 07:26:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sun, 30 Jun 2019 20:23:48 +0300 Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

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
> netdevs.

Looking at the details what happen when a single RX-queue can receive
into multiple net_device'es.  I realize that this driver will
violate/kill some of the "hidden"/implicit RX-bulking that the
XDP_REDIRECT code depend on for performance.

Specifically, it violate this assumption:
 https://github.com/torvalds/linux/blob/v5.2-rc7/kernel/bpf/devmap.c#L324-L329

	/* Ingress dev_rx will be the same for all xdp_frame's in
	 * bulk_queue, because bq stored per-CPU and must be flushed
	 * from net_device drivers NAPI func end.
	 */
	if (!bq->dev_rx)
		bq->dev_rx = dev_rx;

This drivers "NAPI func end", can have received into multiple
net_devices, before it's NAPI cycle ends.  Thus, violating this code
assumption.

Knowing all xdp_frame's in the bulk queue is from the same net_device,
can be used to further optimize XDP.  E.g. the dev->netdev_ops->ndo_xdp_xmit()
call don't take fully advantage of this, yet.  If we merge this driver,
it will block optimizations in this area.

NACK

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
