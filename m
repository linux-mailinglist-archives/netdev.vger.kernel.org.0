Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9764F9797
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 16:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236706AbiDHOF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 10:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiDHOF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 10:05:57 -0400
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E841B13E17F;
        Fri,  8 Apr 2022 07:03:53 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 7D7E0600DD;
        Fri,  8 Apr 2022 16:03:52 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1ncpDM-00051l-De; Fri, 08 Apr 2022 16:03:52 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     Eric Dumazet <edumazet@google.com>,
        kongweibin <kongweibin2@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, rose.chen@huawei.com,
        liaichun@huawei.com, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        stable@vger.kernel.org
Subject: [PATCH net] ipv6: fix panic when forwarding a pkt with no in6 dev
Date:   Fri,  8 Apr 2022 16:03:42 +0200
Message-Id: <20220408140342.19311-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <59150cd5-9950-2479-a992-94dcdaa5e63c@6wind.com>
References: <59150cd5-9950-2479-a992-94dcdaa5e63c@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kongweibin reported a kernel panic in ip6_forward() when input interface
has no in6 dev associated.

The following tc commands were used to reproduce this panic:
tc qdisc del dev vxlan100 root
tc qdisc add dev vxlan100 root netem corrupt 5%

CC: stable@vger.kernel.org
Fixes: ccd27f05ae7b ("ipv6: fix 'disable_policy' for fwd packets")
Reported-by: kongweibin <kongweibin2@huawei.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---

kongweibin, could you test this patch with your setup?

Thanks,
Nicolas

 net/ipv6/ip6_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e23f058166af..fa63ef2bd99c 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -485,7 +485,7 @@ int ip6_forward(struct sk_buff *skb)
 		goto drop;
 
 	if (!net->ipv6.devconf_all->disable_policy &&
-	    !idev->cnf.disable_policy &&
+	    (!idev || !idev->cnf.disable_policy) &&
 	    !xfrm6_policy_check(NULL, XFRM_POLICY_FWD, skb)) {
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
 		goto drop;
-- 
2.33.0

