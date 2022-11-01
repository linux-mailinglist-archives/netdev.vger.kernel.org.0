Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA8E6142CB
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 02:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiKABkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 21:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKABkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 21:40:02 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD3F10050
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:40:01 -0700 (PDT)
Received: from kwepemi500023.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N1Xl16K6pz15M2s;
        Tue,  1 Nov 2022 09:39:57 +0800 (CST)
Received: from huawei.com (10.175.112.208) by kwepemi500023.china.huawei.com
 (7.221.188.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 1 Nov
 2022 09:39:58 +0800
From:   Peng Wu <wupeng58@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <coreteam@netfilter.org>, <netdev@vger.kernel.org>,
        <liwei391@huawei.com>, Peng Wu <wupeng58@huawei.com>
Subject: [PATCH -next] netfilter: nft_inner: fix return value check in nft_inner_parse_l2l3()
Date:   Tue, 1 Nov 2022 01:37:28 +0000
Message-ID: <20221101013728.93115-1-wupeng58@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500023.china.huawei.com (7.221.188.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nft_inner_parse_l2l3(), the return value of skb_header_pointer() is
'veth' instead of 'eth' when case 'htons(ETH_P_8021Q)' and fix it.

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Signed-off-by: Peng Wu <wupeng58@huawei.com>
---
 net/netfilter/nft_inner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index eae7caeff316..809f0d0787ec 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -72,7 +72,7 @@ static int nft_inner_parse_l2l3(const struct nft_inner *priv,
 			break;
 		case htons(ETH_P_8021Q):
 			veth = skb_header_pointer(pkt->skb, off, sizeof(_veth), &_veth);
-			if (!eth)
+			if (!veth)
 				return -1;
 
 			outer_llproto = veth->h_vlan_encapsulated_proto;
-- 
2.17.1

