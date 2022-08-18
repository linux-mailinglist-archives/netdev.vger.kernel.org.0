Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0D2598153
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 12:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244009AbiHRKJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 06:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244008AbiHRKJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 06:09:37 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D3C97509
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 03:09:35 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 757F620613;
        Thu, 18 Aug 2022 12:09:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7DXM7JlLsaQ1; Thu, 18 Aug 2022 12:09:31 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A4277201A0;
        Thu, 18 Aug 2022 12:09:31 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 9169480004A;
        Thu, 18 Aug 2022 12:09:31 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 18 Aug 2022 12:09:31 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 18 Aug
 2022 12:09:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C67D53182AA7; Thu, 18 Aug 2022 12:09:30 +0200 (CEST)
Date:   Thu, 18 Aug 2022 12:09:30 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220818100930.GA622211@gauss3.secunet.de>
References: <cover.1660639789.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1660639789.git.leonro@nvidia.com>
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

Hi Leon,

On Tue, Aug 16, 2022 at 11:59:21AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v2:
>  * Rebased to latest 6.0-rc1
>  * Add an extra check in TX datapath patch to validate packets before
>    forwarding to HW.
>  * Added policy cleanup logic in case of netdev down event 
> v1: https://lore.kernel.org/all/cover.1652851393.git.leonro@nvidia.com 
>  * Moved comment to be before if (...) in third patch.
> v0: https://lore.kernel.org/all/cover.1652176932.git.leonro@nvidia.com
> -----------------------------------------------------------------------
> 
> The following series extends XFRM core code to handle new type of IPsec
> offload - full offload.
> 
> In this mode, the HW is going to be responsible for whole data path, so
> both policy and state should be offloaded.

some general comments about the pachset:

As implemented, the software does not hold any state.
I.e. there is no sync between hardware and software
regarding stats, liftetime, lifebyte, packet counts
and replay window. IKE rekeying and auditing is based
on these, how should this be done?

I have not seen anything that catches configurations
that stack multiple tunnels with the outer offloaded.

Where do we make sure that policy offloading device
is the same as the state offloading device?

