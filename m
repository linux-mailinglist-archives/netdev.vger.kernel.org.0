Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26A46499AF
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 08:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiLLHpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 02:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLLHo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 02:44:56 -0500
Received: from mail.nfschina.com (unknown [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2560CB84F;
        Sun, 11 Dec 2022 23:44:55 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id CA40F1E80D9B;
        Mon, 12 Dec 2022 15:40:18 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EtGpDXQytxlk; Mon, 12 Dec 2022 15:40:16 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 48F101E80D9A;
        Mon, 12 Dec 2022 15:40:15 +0800 (CST)
From:   Li Qiong <liqiong@nfschina.com>
To:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        Yu Zhe <yuzhe@nfschina.com>, Li Qiong <liqiong@nfschina.com>
Subject: [PATCH v2] ipvs: add a 'default' case in do_ip_vs_set_ctl()
Date:   Mon, 12 Dec 2022 15:43:51 +0800
Message-Id: <20221212074351.26440-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <272315c8-5e3b-e8ca-3c7f-68eccd0f2430@nfschina.com>
References: <272315c8-5e3b-e8ca-3c7f-68eccd0f2430@nfschina.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is better to return the default switch case with
'-EINVAL', in case new commands are added. otherwise,
return a uninitialized value of ret.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
Reviewed-by: Simon Horman <horms@verge.net.au>
---
v2: Add 'default' case instead of initializing 'ret'.
---
 net/netfilter/ipvs/ip_vs_ctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 988222fff9f0..97f6a1c8933a 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2590,6 +2590,11 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, sockptr_t ptr, unsigned int len)
 		break;
 	case IP_VS_SO_SET_DELDEST:
 		ret = ip_vs_del_dest(svc, &udest);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		ret = -EINVAL;
+		break;
 	}
 
   out_unlock:
-- 
2.11.0

