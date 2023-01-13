Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5813669E70
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjAMQnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjAMQmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:42:36 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D5EBE8141B;
        Fri, 13 Jan 2023 08:41:12 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 3/3] netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits
Date:   Fri, 13 Jan 2023 17:41:06 +0100
Message-Id: <20230113164106.311491-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230113164106.311491-1-pablo@netfilter.org>
References: <20230113164106.311491-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the offset + length goes over the ethernet + vlan header, then the
length is adjusted to copy the bytes that are within the boundaries of
the vlan_ethhdr scratchpad area. The remaining bytes beyond ethernet +
vlan header are copied directly from the skbuff data area.

Fix incorrect arithmetic operator: subtract, not add, the size of the
vlan header in case of double-tagged packets to adjust the length
accordingly to address CVE-2023-0179.

Reported-by: Davide Ornaghi <d.ornaghi97@gmail.com>
Fixes: f6ae9f120dad ("netfilter: nft_payload: add C-VLAN support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 17b418a5a593..3a3c7746e88f 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -63,7 +63,7 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 			return false;
 
 		if (offset + len > VLAN_ETH_HLEN + vlan_hlen)
-			ethlen -= offset + len - VLAN_ETH_HLEN + vlan_hlen;
+			ethlen -= offset + len - VLAN_ETH_HLEN - vlan_hlen;
 
 		memcpy(dst_u8, vlanh + offset - vlan_hlen, ethlen);
 
-- 
2.30.2

