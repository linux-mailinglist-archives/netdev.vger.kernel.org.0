Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06E34D9BB2
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 13:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348519AbiCOM77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 08:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbiCOM76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 08:59:58 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A26A24F00
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 05:58:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7AF8920582;
        Tue, 15 Mar 2022 13:58:44 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id csgEOGwAKb_5; Tue, 15 Mar 2022 13:58:43 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id EB7BD20184;
        Tue, 15 Mar 2022 13:58:43 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id DD35C80004A;
        Tue, 15 Mar 2022 13:58:43 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Tue, 15 Mar 2022 13:58:43 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 15 Mar
 2022 13:58:43 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3FF433182EC9; Tue, 15 Mar 2022 13:58:43 +0100 (CET)
Date:   Tue, 15 Mar 2022 13:58:43 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Jordy Zomer <jordy@pwning.systems>,
        Xiumei Mu <xmu@redhat.com>
Subject: Re: [PATCH ipsec] esp6: fix check on ipv6_skip_exthdr's return value
Message-ID: <20220315125843.GJ3581047@gauss3.secunet.de>
References: <4215f33e156b9bf7259d3efb5c7b888f45c7f9b8.1646748826.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4215f33e156b9bf7259d3efb5c7b888f45c7f9b8.1646748826.git.sd@queasysnail.net>
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

On Thu, Mar 10, 2022 at 11:49:00AM +0100, Sabrina Dubroca wrote:
> Commit 5f9c55c8066b ("ipv6: check return value of ipv6_skip_exthdr")
> introduced an incorrect check, which leads to all ESP packets over
> either TCPv6 or UDPv6 encapsulation being dropped. In this particular
> case, offset is negative, since skb->data points to the ESP header in
> the following chain of headers, while skb->network_header points to
> the IPv6 header:
> 
>     IPv6 | ext | ... | ext | UDP | ESP | ...
> 
> That doesn't seem to be a problem, especially considering that if we
> reach esp6_input_done2, we're guaranteed to have a full set of headers
> available (otherwise the packet would have been dropped earlier in the
> stack). However, it means that the return value will (intentionally)
> be negative. We can make the test more specific, as the expected
> return value of ipv6_skip_exthdr will be the (negated) size of either
> a UDP header, or a TCP header with possible options.
> 
> In the future, we should probably either make ipv6_skip_exthdr
> explicitly accept negative offsets (and adjust its return value for
> error cases), or make ipv6_skip_exthdr only take non-negative
> offsets (and audit all callers).
> 
> Fixes: 5f9c55c8066b ("ipv6: check return value of ipv6_skip_exthdr")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Applied, thanks a lot Sabrina!
