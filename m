Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0488627AB2
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbiKNKlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235941AbiKNKlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:41:14 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 803A41D306;
        Mon, 14 Nov 2022 02:41:13 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 2/6] netfilter: nft_inner: fix return value check in nft_inner_parse_l2l3()
Date:   Mon, 14 Nov 2022 11:41:02 +0100
Message-Id: <20221114104106.8719-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221114104106.8719-1-pablo@netfilter.org>
References: <20221114104106.8719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Wu <wupeng58@huawei.com>

In nft_inner_parse_l2l3(), the return value of skb_header_pointer() is
'veth' instead of 'eth' when case 'htons(ETH_P_8021Q)' and fix it.

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Signed-off-by: Peng Wu <wupeng58@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

