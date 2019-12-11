Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C92811ABDA
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbfLKNRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:17:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46096 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729442AbfLKNRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 08:17:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576070257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AX5fhWmUkcVTK2FGEAydksRsVVwg5DCyda4UF354+FM=;
        b=eUK89sLkwK4WEdYCOh7XW/Z+JcNRL6Az0F2MZG9jvMfovTfcJ/HF8+8XE+Xh7jHZ1eIuO2
        7M+iOwXoUuBZZWPkLmsD3BRvGCaw6DFkkBg0BHdhNccRi55g3E9zyydJVGcP1MmGby68Wc
        5/PncOVfERKJzoZeNfSvp4GlaEy19tc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-OSi8-b5bP9uGf_WTtpb2Qw-1; Wed, 11 Dec 2019 08:17:34 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B441DB25;
        Wed, 11 Dec 2019 13:17:32 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1BDD100EBA4;
        Wed, 11 Dec 2019 13:17:25 +0000 (UTC)
Date:   Wed, 11 Dec 2019 14:17:23 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     brouer@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 1/2] net: ethernet: ti: select PAGE_POOL for switchdev
 driver
Message-ID: <20191211141723.2cb3d5e9@carbon>
In-Reply-To: <20191211125643.1987157-1-arnd@arndb.de>
References: <20191211125643.1987157-1-arnd@arndb.de>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: OSi8-b5bP9uGf_WTtpb2Qw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 13:56:09 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> The new driver misses a dependency:
> 
> drivers/net/ethernet/ti/cpsw_new.o: In function `cpsw_rx_handler':
> cpsw_new.c:(.text+0x259c): undefined reference to `__page_pool_put_page'
> cpsw_new.c:(.text+0x25d0): undefined reference to `page_pool_alloc_pages'
> drivers/net/ethernet/ti/cpsw_priv.o: In function `cpsw_fill_rx_channels':
> cpsw_priv.c:(.text+0x22d8): undefined reference to `page_pool_alloc_pages'
> cpsw_priv.c:(.text+0x2420): undefined reference to `__page_pool_put_page'
> drivers/net/ethernet/ti/cpsw_priv.o: In function `cpsw_create_xdp_rxqs':
> cpsw_priv.c:(.text+0x2624): undefined reference to `page_pool_create'
> drivers/net/ethernet/ti/cpsw_priv.o: In function `cpsw_run_xdp':
> cpsw_priv.c:(.text+0x2dc8): undefined reference to `__page_pool_put_page'
> 
> Other drivers use 'select' for PAGE_POOL, so do the same here.
> 
> Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks for fixing this.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

