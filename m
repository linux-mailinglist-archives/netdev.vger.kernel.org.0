Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21886EA53A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjDUHuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjDUHuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:50:11 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B8A3C22;
        Fri, 21 Apr 2023 00:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682063402; x=1713599402;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Uiroj0n/u+QOES0WHXYHHG/HRX95w83Ff6vjs3Kqv1M=;
  b=vrJtVz34WfC8Q/hPG76+ayVUkS1sagmctZ7iqujUGCwGJ/9zCfp9T3Eo
   qQL62HpDruJcS4odPET8JggZ9vZxPyKaRRWgm9dfRlG49/Ntt4Ua0ghQF
   7dL1Piyzg4hXolVTBho94td7Xz+oZgwxZGmQTGCVwk1RuoUJd2QElKhxp
   cwJ4FXjPBWkK8VlBL/6VIbM4//77VgyT+xnIeXtU4h+RRiJS8MbzaMqP4
   A8TeGKLVhJslS+x7wuI7Yx6VurK8KQoikgJvaC+6frKoulmjZJLXGSEaG
   mQFd6JuWAjQApIKT7ADg9sO/JWcUtA3OZ87M3ogQ5ZcG5jAWm9cUTNzr/
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,214,1677567600"; 
   d="scan'208";a="207640124"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Apr 2023 00:50:01 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 21 Apr 2023 00:50:00 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 21 Apr 2023 00:50:00 -0700
Date:   Fri, 21 Apr 2023 09:49:59 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <maciej.fijalkowski@intel.com>,
        <alexandr.lobakin@intel.com>
Subject: Re: [PATCH net-next] net: lan966x: Don't use xdp_frame when action
 is XDP_TX
Message-ID: <20230421074959.t2ttsy6qpfjgngcr@soft-dev3-1>
References: <20230420121152.2737625-1-horatiu.vultur@microchip.com>
 <f79e2dde-6d45-cc97-0cde-05454bdb5077@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <f79e2dde-6d45-cc97-0cde-05454bdb5077@intel.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/20/2023 16:49, Alexander Lobakin wrote:
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Thu, 20 Apr 2023 14:11:52 +0200

Hi Olek,

> 
> > When the action of an xdp program was XDP_TX, lan966x was creating
> > a xdp_frame and use this one to send the frame back. But it is also
> > possible to send back the frame without needing a xdp_frame, because
> > it possible to send it back using the page.
> > And then once the frame is transmitted is possible to use directly
> > page_pool_recycle_direct as lan966x is using page pools.
> > This would save some CPU usage on this path.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> [...]
> 
> > @@ -702,6 +704,7 @@ static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
> >  int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
> >                          struct xdp_frame *xdpf,
> >                          struct page *page,
> > +                        u32 len,
> >                          bool dma_map)
> 
> I think you can cut the number of arguments by almost a half:
> 
> int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
>                            void *ptr, u32 len)
> {
>         if (len) {
>                 /* XDP_TX, ptr is page */
>                 page = ptr;
> 
>                 dma_sync_here(page, len);
>         } else {
>                 /* XDP_REDIR, ptr is xdp_frame */
>                 xdpf = ptr;
> 
>                 dma_map_here(xdpf->data, xdpf->len);
>         }
> 
> @page and @xdpf are mutually exclusive. When @xdpf is non-null, @len is
> excessive (xdpf->len is here), so you can use @len as logical
> `len * !dma_map`, i.e. zero for REDIR and the actual frame length for TX.

Thanks for the review. You are right, I can reduce number of arguments,
the reason why I have done it like this, I thought it is a little bit more
clear this way. But I will update as you propose in the next version

> 
> I generally enjoy seeing how you constantly improve stuff in your driver :)
> 
> >  {
> >       struct lan966x *lan966x = port->lan966x;
> > @@ -722,6 +725,15 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
> >               goto out;
> >       }
> [...]
> 
> Thanks,
> Olek

-- 
/Horatiu
