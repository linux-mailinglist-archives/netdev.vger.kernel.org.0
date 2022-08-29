Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7265A4438
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 09:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiH2HyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 03:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiH2HyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:54:11 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE5C13CF5
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:54:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 796772053B;
        Mon, 29 Aug 2022 09:54:05 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gntDNCNzybnu; Mon, 29 Aug 2022 09:54:04 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9C57B204E0;
        Mon, 29 Aug 2022 09:54:04 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 8CC3880004A;
        Mon, 29 Aug 2022 09:54:04 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 09:54:04 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 29 Aug
 2022 09:54:03 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id AEAB63182ABC; Mon, 29 Aug 2022 09:54:03 +0200 (CEST)
Date:   Mon, 29 Aug 2022 09:54:03 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH xfrm-next v3 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220829075403.GL566407@gauss3.secunet.de>
References: <cover.1661260787.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1661260787.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
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

On Tue, Aug 23, 2022 at 04:31:57PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v3:
>  * I didn't hear any suggestion what term to use instead of
>    "full offload", so left it as is. It is used in commit messages
>    and documentation only and easy to rename.
>  * Added performance data and background info to cover letter
>  * Reused xfrm_output_resume() function to support multiple XFRM transformations
>  * Add PMTU check in addition to driver .xdo_dev_offload_ok validation
>  * Documentation is in progress, but not part of this series yet.
> v2: https://lore.kernel.org/all/cover.1660639789.git.leonro@nvidia.com
>  * Rebased to latest 6.0-rc1
>  * Add an extra check in TX datapath patch to validate packets before
>    forwarding to HW.
>  * Added policy cleanup logic in case of netdev down event
> v1: https://lore.kernel.org/all/cover.1652851393.git.leonro@nvidia.com
>  * Moved comment to be before if (...) in third patch.
> v0: https://lore.kernel.org/all/cover.1652176932.git.leonro@nvidia.com
> -----------------------------------------------------------------------
> 
> The following series extends XFRM core code to handle a new type of IPsec
> offload - full offload.
> 
> In this mode, the HW is going to be responsible for the whole data path,
> so both policy and state should be offloaded.
> 
> IPsec full offload is an improved version of IPsec crypto mode,
> In full mode, HW is responsible to trim/add headers in addition to
> decrypt/encrypt. In this mode, the packet arrives to the stack as already
> decrypted and vice versa for TX (exits to HW as not-encrypted).
> 
> Devices that implement IPsec full offload mode offload policies too.
> In the RX path, it causes the situation that HW can't effectively
> handle mixed SW and HW priorities unless users make sure that HW offloaded
> policies have higher priorities.
> 
> To make sure that users have a coherent picture, we require that
> HW offloaded policies have always (both RX and TX) higher priorities
> than SW ones.
> 
> To not over-engineer the code, HW policies are treated as SW ones and
> don't take into account netdev to allow reuse of the same priorities for
> different devices.
> 
> There are several deliberate limitations:
>  * No software fallback
>  * Fragments are dropped, both in RX and TX
>  * No sockets policies
>  * Only IPsec transport mode is implemented

... and you still have not answered the fundamental questions:

As implemented, the software does not hold any state.
I.e. there is no sync between hardware and software
regarding stats, liftetime, lifebyte, packet counts
and replay window. IKE rekeying and auditing is based
on these, how should this be done?

How can tunnel mode work with this offload?

I want to see the full picture before I consider to
apply this.
