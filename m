Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED785A5D81
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiH3H5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiH3H5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:57:33 -0400
X-Greylist: delayed 587 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 Aug 2022 00:57:31 PDT
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3119BB00C;
        Tue, 30 Aug 2022 00:57:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4F17B20561;
        Tue, 30 Aug 2022 09:47:42 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tGDGO2qRkNVU; Tue, 30 Aug 2022 09:47:41 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 713BD20547;
        Tue, 30 Aug 2022 09:47:41 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 61FBA80004A;
        Tue, 30 Aug 2022 09:47:41 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 09:47:41 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 30 Aug
 2022 09:47:40 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 8BBE03183BE2; Tue, 30 Aug 2022 09:47:40 +0200 (CEST)
Date:   Tue, 30 Aug 2022 09:47:40 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <herbert@gondor.apana.org.au>,
        <dsahern@kernel.org>, <contact@proelbtn.com>,
        <pablo@netfilter.org>, <nicolas.dichtel@6wind.com>,
        <razor@blackwall.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH ipsec-next,v4 0/3] xfrm: support collect metadata mode
 for xfrm interfaces
Message-ID: <20220830074740.GO2950045@gauss3.secunet.de>
References: <20220826114700.2272645-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220826114700.2272645-1-eyal.birger@gmail.com>
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

On Fri, Aug 26, 2022 at 02:46:57PM +0300, Eyal Birger wrote:
> This series adds support for "collect_md" mode in XFRM interfaces.
> 
> This feature is useful for maintaining a large number of IPsec connections
> with the benefits of using a network interface while reducing the overhead
> of maintaining a large number of devices.
> 
> Currently this is possible by having multiple connections share a common
> interface by sharing the if_id identifier and using some other criteria
> to distinguish between them - such as different subnets or skb marks.
> This becomes complex in multi-tenant environments where subnets collide
> and the mark space is used for other purposes.
> 
> Since the xfrm interface uses the if_id as the differentiator when
> looking for policies, setting the if_id in the dst_metadata framework
> allows using a single interface for different connections while having
> the ability to selectively steer traffic to each one. In addition the
> xfrm interface "link" property can also be specified to affect underlying
> routing in the context of VRFs.
> 
> The series is composed of the following steps:
> 
> - Introduce a new METADATA_XFRM metadata type to be used for this purpose.
>   Reuse of the existing "METADATA_IP_TUNNEL" type was rejected in [0] as
>   XFRM does not necessarily represent an IP tunnel.
> 
> - Add support for collect metadata mode in xfrm interfaces
> 
> - Allow setting the XFRM metadata from the LWT infrastructure
> 
> Future additions could allow setting/getting the XFRM metadata from eBPF
> programs, TC, OVS, NF, etc.
> 
> [0] https://patchwork.kernel.org/project/netdevbpf/patch/20201121142823.3629805-1-eyal.birger@gmail.com/#23824575
> 
> Eyal Birger (3):
>   net: allow storing xfrm interface metadata in metadata_dst
>   xfrm: interface: support collect metadata mode
>   xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md
>     mode
> 
>  include/net/dst_metadata.h    |  31 +++++
>  include/net/xfrm.h            |  11 +-
>  include/uapi/linux/if_link.h  |   1 +
>  include/uapi/linux/lwtunnel.h |  10 ++
>  net/core/lwtunnel.c           |   1 +
>  net/xfrm/xfrm_input.c         |   7 +-
>  net/xfrm/xfrm_interface.c     | 206 ++++++++++++++++++++++++++++++----
>  net/xfrm/xfrm_policy.c        |  10 +-
>  8 files changed, 248 insertions(+), 29 deletions(-)

Applied, thanks a lot Eyal!
