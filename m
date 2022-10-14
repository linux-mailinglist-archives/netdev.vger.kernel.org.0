Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825055FEEBD
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 15:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiJNNh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 09:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiJNNhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 09:37:54 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881CF1CEC0F
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 06:37:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3CA27204E0;
        Fri, 14 Oct 2022 15:37:51 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uoykIjbzfGgn; Fri, 14 Oct 2022 15:37:50 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7477F20322;
        Fri, 14 Oct 2022 15:37:50 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 6453980004A;
        Fri, 14 Oct 2022 15:37:50 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 15:37:50 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 14 Oct
 2022 15:37:50 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A5FE931809FD; Fri, 14 Oct 2022 15:37:49 +0200 (CEST)
Date:   Fri, 14 Oct 2022 15:37:49 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <monil191989@gmail.com>, <nicolas.dichtel@6wind.com>,
        <stephen@networkplumber.org>
Subject: Re: [PATCH ipsec,v2] xfrm: fix "disable_policy" on ipv4 early demux
Message-ID: <20221014133749.GM2602992@gauss3.secunet.de>
References: <20221009191643.297623-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221009191643.297623-1-eyal.birger@gmail.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 10:16:43PM +0300, Eyal Birger wrote:
> The commit in the "Fixes" tag tried to avoid a case where policy check
> is ignored due to dst caching in next hops.
> 
> However, when the traffic is locally consumed, the dst may be cached
> in a local TCP or UDP socket as part of early demux. In this case the
> "disable_policy" flag is not checked as ip_route_input_noref() was only
> called before caching, and thus, packets after the initial packet in a
> flow will be dropped if not matching policies.
> 
> Fix by checking the "disable_policy" flag also when a valid dst is
> already available.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216557
> Reported-by: Monil Patel <monil191989@gmail.com>
> Fixes: e6175a2ed1f1 ("xfrm: fix "disable_policy" flag use when arriving from different devices")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

Applied, thanks Eyal!
