Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338E45FC233
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 10:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJLIpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 04:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJLIpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 04:45:11 -0400
Received: from a.mx.secunet.com (unknown [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F981D655;
        Wed, 12 Oct 2022 01:44:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7C35E206D8;
        Wed, 12 Oct 2022 10:44:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6GQRK5oqxZKv; Wed, 12 Oct 2022 10:44:32 +0200 (CEST)
Received: from mailout2.secunet.com (unknown [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0D21E206D2;
        Wed, 12 Oct 2022 10:44:32 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id F2CFA80004A;
        Wed, 12 Oct 2022 10:44:16 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 12 Oct 2022 10:44:16 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 12 Oct
 2022 10:44:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id F1BD431825C1; Wed, 12 Oct 2022 10:44:15 +0200 (CEST)
Date:   Wed, 12 Oct 2022 10:44:15 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Christian Langrock <christian.langrock@secunet.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ipsec v6] xfrm: replay: Fix ESN wrap around for GSO
Message-ID: <20221012084415.GQ2950045@gauss3.secunet.de>
References: <6810817b-e6b7-feac-64f8-c83c517ae9a5@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6810817b-e6b7-feac-64f8-c83c517ae9a5@secunet.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 07, 2022 at 04:50:15PM +0200, Christian Langrock wrote:
> When using GSO it can happen that the wrong seq_hi is used for the last
> packets before the wrap around. This can lead to double usage of a
> sequence number. To avoid this, we should serialize this last GSO
> packet.
> 
> Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for offloading")
> Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
> ---
> Changes in v6:
>  - move overflow check to offloading path to avoid locking issues
> 
> Changes in v5:
>  - Fix build
> 
> Changes in v4:
>  - move changelog within comment
>  - add reviewer
> 
> Changes in v3:
> - fix build
> - remove wrapper function
> 
> Changes in v2:
> - switch to bool as return value
> - remove switch case in wrapper function
> ---
>  net/ipv4/esp4_offload.c |  3 +++
>  net/ipv6/esp6_offload.c |  3 +++
>  net/xfrm/xfrm_device.c  | 15 ++++++++++++++-
>  net/xfrm/xfrm_replay.c  |  2 +-
>  4 files changed, 21 insertions(+), 2 deletions(-)

Your patch does not apply to the ipsec tree. Looks
like it is malformed by your mailer.
