Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 991AC36E2B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfFFIJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:09:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFIJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 04:09:03 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5CA3A308626C;
        Thu,  6 Jun 2019 08:09:02 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23D1917C40;
        Thu,  6 Jun 2019 08:08:51 +0000 (UTC)
Date:   Thu, 6 Jun 2019 10:08:50 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     ivan.khoronzhuk@linaro.org, grygorii.strashko@ti.com,
        hawk@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v3 net-next 0/7] net: ethernet: ti: cpsw: Add XDP
 support
Message-ID: <20190606100850.72a48a43@carbon>
In-Reply-To: <20190605.121450.2198491088032558315.davem@davemloft.net>
References: <20190605132009.10734-1-ivan.khoronzhuk@linaro.org>
        <20190605.121450.2198491088032558315.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 06 Jun 2019 08:09:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 05 Jun 2019 12:14:50 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> Date: Wed,  5 Jun 2019 16:20:02 +0300
> 
> > This patchset adds XDP support for TI cpsw driver and base it on
> > page_pool allocator. It was verified on af_xdp socket drop,
> > af_xdp l2f, ebpf XDP_DROP, XDP_REDIRECT, XDP_PASS, XDP_TX.  
> 
> Jesper et al., please give this a good once over.

The issue with merging this, is that I recently discovered two bug with
page_pool API, when using DMA-mappings, which result in missing
DMA-unmap's.  These bugs are not "exposed" yet, but will get exposed
now with this drivers.  

The two bugs are:

#1: in-flight packet-pages can still be on remote drivers TX queue,
while XDP RX driver manage to unregister the page_pool (waiting 1 RCU
period is not enough).

#2: this patchset also introduce page_pool_unmap_page(), which is
called before an XDP frame travel into networks stack (as no callback
exist, yet).  But the CPUMAP redirect *also* needs to call this, else we
"leak"/miss DMA-unmap.

I do have a working prototype, that fixes these two bugs.  I guess, I'm
under pressure to send this to the list soon...

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
