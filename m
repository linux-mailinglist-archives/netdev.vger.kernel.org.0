Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAD13AF6F
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 09:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387944AbfFJHV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 03:21:26 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:3680 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387541AbfFJHV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 03:21:26 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 31DE95C19D9;
        Mon, 10 Jun 2019 15:21:21 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH] netfilter: nft_paylaod: add base type NFT_PAYLOAD_LL_HEADER_NO_TAG
Date:   Mon, 10 Jun 2019 15:21:20 +0800
Message-Id: <1560151280-28908-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kIGBQJHllBWUlVSE9JS0tLS0tMTUlCSEJZV1koWUFJQjdXWS1ZQUlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nhg6Fww6Ajg9SR5DGBFNCDQ4
        NwEaCjdVSlVKTk1LSk5KSUNKSUxKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhKSk43Bg++
X-HM-Tid: 0a6b40434e412087kuqy31de95c19d9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

nft add rule bridge firewall rule-100-ingress ip protocol icmp drop

The rule like above "ip protocol icmp", the packet will not be
matched, It tracelate base=NFT_PAYLOAD_LL_HEADER off=12 &&
base=NFT_PAYLOAD_NETWORK_HEADER  off=11
if the packet contained with tag info. But the user don't care about
the vlan tag.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_payload.c              | 10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 505393c..345787f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -673,11 +673,13 @@ enum nft_dynset_attributes {
  * @NFT_PAYLOAD_LL_HEADER: link layer header
  * @NFT_PAYLOAD_NETWORK_HEADER: network header
  * @NFT_PAYLOAD_TRANSPORT_HEADER: transport header
+ * @NFT_PAYLOAD_LL_HEADER_NO_TAG: link layer header ignore vlan tag
  */
 enum nft_payload_bases {
 	NFT_PAYLOAD_LL_HEADER,
 	NFT_PAYLOAD_NETWORK_HEADER,
 	NFT_PAYLOAD_TRANSPORT_HEADER,
+	NFT_PAYLOAD_LL_HEADER_NO_TAG,
 };
 
 /**
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 1465b7d..3cc7398 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -93,6 +93,12 @@ void nft_payload_eval(const struct nft_expr *expr,
 		}
 		offset = skb_mac_header(skb) - skb->data;
 		break;
+	case NFT_PAYLOAD_LL_HEADER_NO_TAG:
+		if (!skb_mac_header_was_set(skb))
+			goto err;
+
+		offset = skb_mac_header(skb) - skb->data;
+		break;
 	case NFT_PAYLOAD_NETWORK_HEADER:
 		offset = skb_network_offset(skb);
 		break;
@@ -403,6 +409,7 @@ static int nft_payload_set_dump(struct sk_buff *skb, const struct nft_expr *expr
 	case NFT_PAYLOAD_LL_HEADER:
 	case NFT_PAYLOAD_NETWORK_HEADER:
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
+	case NFT_PAYLOAD_LL_HEADER_NO_TAG:
 		break;
 	default:
 		return ERR_PTR(-EOPNOTSUPP);
@@ -421,7 +428,8 @@ static int nft_payload_set_dump(struct sk_buff *skb, const struct nft_expr *expr
 	len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
 	if (len <= 4 && is_power_of_2(len) && IS_ALIGNED(offset, len) &&
-	    base != NFT_PAYLOAD_LL_HEADER)
+	    base != NFT_PAYLOAD_LL_HEADER &&
+	    base != NFT_PAYLOAD_LL_HEADER_NO_TAG)
 		return &nft_payload_fast_ops;
 	else
 		return &nft_payload_ops;
-- 
1.8.3.1

