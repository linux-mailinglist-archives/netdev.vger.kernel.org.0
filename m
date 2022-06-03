Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7122353D20E
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 21:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347897AbiFCTB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 15:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348708AbiFCTAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 15:00:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E2329833;
        Fri,  3 Jun 2022 12:00:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C987CE24B8;
        Fri,  3 Jun 2022 18:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77CCC385B8;
        Fri,  3 Jun 2022 18:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654282797;
        bh=wNoOUeH436EM5Q4+ipBC6tMdcUFPQYmnJuswlasQq7s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SoILe+FIL2S6KalxEeHmls5fUj88pDOTWr2GlXkpmPjl5+15cM4zJMc0RwCu3qH/3
         QQIsotDeOWea8wAWWgNZGA2Vzz1rv8wKxyj8Bdude0azly82ePzu51lJpXZ85CTweI
         5elR6Htm+9ahYC0czwCImx/nIgkILwiaxVRL1ZsjkUpbVFCexeLFzuZh0MQspNLkZU
         lZqEetTJ1+ZuY7yIHo9e6rIAXwzXdJ9Fpo38wEB64ZorajI8T/uAg3brpJGvrtmK1S
         9+R5sPRSMtfyS0q7/Bd4Qu8OuFPKFEVvuoLnNskg6SQZH0Mhg8PZhX9aGOINHxAEoV
         iKbEjktYZcC/g==
Date:   Fri, 3 Jun 2022 11:59:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Chen Lin <chen45464546@163.com>, Felix Fietkau <nbd@nbd.name>,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix misuse of mem alloc
 interface netdev[napi]_alloc_frag
Message-ID: <20220603115956.6ad82a53@kernel.org>
In-Reply-To: <CANn89iKiyh36ULH4PCXF4c8sBdh9WLksMoMcmQwipZYWCzBkMA@mail.gmail.com>
References: <2997c5b0-3611-5e00-466c-b2966f09f067@nbd.name>
        <1654245968-8067-1-git-send-email-chen45464546@163.com>
        <CANn89iKiyh36ULH4PCXF4c8sBdh9WLksMoMcmQwipZYWCzBkMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Jun 2022 10:25:16 -0700 Eric Dumazet wrote:
> >                         goto release_desc;
> > @@ -1914,7 +1923,16 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
> >                 return -ENOMEM;
> >
> >         for (i = 0; i < rx_dma_size; i++) {
> > -               ring->data[i] = netdev_alloc_frag(ring->frag_size);  
> 
> Note aside, calling netdev_alloc_frag() in a loop like that is adding
> GFP_ATOMIC pressure.
> 
> mtk_rx_alloc() being in process context, using GFP_KERNEL allocations
> would be less aggressive and
> have more chances to succeed.
> 
> We probably should offer a generic helper. This could be used from
> driver/net/tun.c and others.

Do cases where netdev_alloc_frag() is not run from a process context
from to your mind? My feeling is that the prevailing pattern is what
this driver does, which is netdev_alloc_frag() at startup / open and
napi_alloc_frag() from the datapath. So maybe we can even spare the
detail in the API and have napi_alloc_frag() assume GFP_KERNEL by
default?
