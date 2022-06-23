Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DFA557906
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 13:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiFWLs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 07:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiFWLsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 07:48:53 -0400
X-Greylist: delayed 76942 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jun 2022 04:48:51 PDT
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176304CD7C
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 04:48:50 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 0E58460007;
        Thu, 23 Jun 2022 11:48:46 +0000 (UTC)
Message-ID: <403746c5-8c4a-02e6-cbb8-b43116ad9f18@ovn.org>
Date:   Thu, 23 Jun 2022 13:48:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Cc:     i.maximets@ovn.org, netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220623050436.1290307-1-edumazet@google.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net] tcp: add a missing nf_reset_ct() in 3WHS handling
In-Reply-To: <20220623050436.1290307-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/22 07:04, Eric Dumazet wrote:
> When the third packet of 3WHS connection establishment
> contains payload, it is added into socket receive queue
> without the XFRM check and the drop of connection tracking
> context.
> 
> This means that if the data is left unread in the socket
> receive queue, conntrack module can not be unloaded.
> 
> As most applications usually reads the incoming data
> immediately after accept(), bug has been hiding for
> quite a long time.
> 
> Commit 68822bdf76f1 ("net: generalize skb freeing
> deferral to per-cpu lists") exposed this bug because
> even if the application reads this data, the skb
> with nfct state could stay in a per-cpu cache for
> an arbitrary time, if said cpu no longer process RX softirqs.
> 
> Many thanks to Ilya Maximets for reporting this issue,
> and for testing various patches:
> https://lore.kernel.org/netdev/20220619003919.394622-1-i.maximets@ovn.org/
> 
> Note that I also added a missing xfrm4_policy_check() call,
> although this is probably not a big issue, as the SYN
> packet should have been dropped earlier.
> 
> Fixes: b59c270104f0 ("[NETFILTER]: Keep conntrack reference until IPsec policy checks are done")
> Reported-by: Ilya Maximets <i.maximets@ovn.org>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>  net/ipv4/tcp_ipv4.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Thanks!  I re-tested this change with the OVS testsuite
and it works fine.  It can successfully reload ntfilter
modules now.  So, for the nf_reset_ct part of the fix:

Tested-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>

XFRM part seems correct to me, but I didn't test it.
