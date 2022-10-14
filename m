Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE365FEEC0
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 15:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiJNNig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 09:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiJNNia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 09:38:30 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757EC1CF547
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 06:38:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 071992053B;
        Fri, 14 Oct 2022 15:38:28 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ISZk2ssmo-MR; Fri, 14 Oct 2022 15:38:27 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 854CA20322;
        Fri, 14 Oct 2022 15:38:27 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 7312880004A;
        Fri, 14 Oct 2022 15:38:27 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 15:38:27 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 14 Oct
 2022 15:38:26 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A640F31809FD; Fri, 14 Oct 2022 15:38:26 +0200 (CEST)
Date:   Fri, 14 Oct 2022 15:38:26 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     <idosch@idosch.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <herbert@gondor.apana.org.au>, <dsahern@kernel.org>,
        <contact@proelbtn.com>, <pablo@netfilter.org>,
        <nicolas.dichtel@6wind.com>, <razor@blackwall.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec] xfrm: lwtunnel: squelch kernel warning in case
 XFRM encap type is not available
Message-ID: <20221014133826.GN2602992@gauss3.secunet.de>
References: <20221011080137.440419-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221011080137.440419-1-eyal.birger@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 11, 2022 at 11:01:37AM +0300, Eyal Birger wrote:
> Ido reported that a kernel warning [1] can be triggered from
> user space when the kernel is compiled with CONFIG_MODULES=y and
> CONFIG_XFRM=n when adding an xfrm encap type route, e.g:
> 
> $ ip route add 198.51.100.0/24 dev dummy1 encap xfrm if_id 1
> Error: lwt encapsulation type not supported.
> 
> The reason for the warning is that the LWT infrastructure has an
> autoloading feature which is meant only for encap types that don't
> use a net device,  which is not the case in xfrm encap.
> 
> Mute this warning for xfrm encap as there's no encap module to autoload
> in this case.
> 
> [1]
>  WARNING: CPU: 3 PID: 2746262 at net/core/lwtunnel.c:57 lwtunnel_valid_encap_type+0x4f/0x120
> [...]
>  Call Trace:
>   <TASK>
>   rtm_to_fib_config+0x211/0x350
>   inet_rtm_newroute+0x3a/0xa0
>   rtnetlink_rcv_msg+0x154/0x3c0
>   netlink_rcv_skb+0x49/0xf0
>   netlink_unicast+0x22f/0x350
>   netlink_sendmsg+0x208/0x440
>   ____sys_sendmsg+0x21f/0x250
>   ___sys_sendmsg+0x83/0xd0
>   __sys_sendmsg+0x54/0xa0
>   do_syscall_64+0x35/0x80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Fixes: 2c2493b9da91 ("xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

Applied, thanks a lot!
