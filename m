Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84AF5265A4
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiEMPHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380804AbiEMPHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:07:06 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A50C24F21
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:07:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1CDFA20688;
        Fri, 13 May 2022 17:07:04 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Kijfz3vBxqn8; Fri, 13 May 2022 17:07:03 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9F3C42065D;
        Fri, 13 May 2022 17:07:03 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 96C1D80004A;
        Fri, 13 May 2022 17:07:03 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 17:07:03 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 13 May
 2022 17:07:03 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 01E293180A74; Fri, 13 May 2022 17:07:02 +0200 (CEST)
Date:   Fri, 13 May 2022 17:07:02 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH ipsec-next 6/6] xfrm: enforce separation between
 priorities of HW/SW policies
Message-ID: <20220513150702.GN680067@gauss3.secunet.de>
References: <cover.1652176932.git.leonro@nvidia.com>
 <3d81ef1171c464d3bad05c7d9a741e12c4c160a7.1652176932.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3d81ef1171c464d3bad05c7d9a741e12c4c160a7.1652176932.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 01:36:57PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Devices that implement IPsec full offload mode offload policies too.
> In RX path, it causes to the situation that HW can't effectively handle
> mixed SW and HW priorities unless users make sure that HW offloaded
> policies have higher priorities.
> 
> In order to make sure that users have coherent picture, let's require to
> make sure that HW offloaded policies have always (both RX and TX) higher
> priorities than SW ones.

I'm still not sure whether splitting priorities in software and hardware
is the right way to go. I fear we can get problems with corner cases we
don't think about now. But OTOH I don't have a better idea. So maybe
someone on the list has an opinion on that.
