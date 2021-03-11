Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EB53378B2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbhCKQDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:03:34 -0500
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:60947 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbhCKQDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:03:16 -0500
Received: from localhost (unknown [10.16.0.21])
        by proxy.6wind.com (Postfix) with ESMTP id 8CFF690E4EC;
        Thu, 11 Mar 2021 16:53:22 +0100 (CET)
From:   Julien Massonneau <julien.massonneau@6wind.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, dlebrun@google.com
Cc:     Julien Massonneau <julien.massonneau@6wind.com>
Subject: [PATCH net-next 2/2] seg6: ignore routing header with segments left equal to 0
Date:   Thu, 11 Mar 2021 16:53:19 +0100
Message-Id: <20210311155319.2280-3-julien.massonneau@6wind.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311155319.2280-1-julien.massonneau@6wind.com>
References: <20210311155319.2280-1-julien.massonneau@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When there are 2 segments routing header, after an End.B6 action
for example, the second SRH will never be handled by an action, packet will
be dropped when the first SRH has segments left equal to 0.
For actions that doesn't perform decapsulation (currently: End, End.X,
End.T, End.B6, End.B6.Encaps), this patch adds the IP6_FH_F_SKIP_RH flag
in arguments for ipv6_find_hdr().

Signed-off-by: Julien Massonneau <julien.massonneau@6wind.com>
---
 net/ipv6/seg6_local.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index c2a0c78e84d4..8936f48570fc 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -119,12 +119,12 @@ static struct seg6_local_lwt *seg6_local_lwtunnel(struct lwtunnel_state *lwt)
 	return (struct seg6_local_lwt *)lwt->data;
 }
 
-static struct ipv6_sr_hdr *get_srh(struct sk_buff *skb)
+static struct ipv6_sr_hdr *get_srh(struct sk_buff *skb, int flags)
 {
 	struct ipv6_sr_hdr *srh;
 	int len, srhoff = 0;
 
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
+	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, &flags) < 0)
 		return NULL;
 
 	if (!pskb_may_pull(skb, srhoff + sizeof(*srh)))
@@ -152,13 +152,10 @@ static struct ipv6_sr_hdr *get_and_validate_srh(struct sk_buff *skb)
 {
 	struct ipv6_sr_hdr *srh;
 
-	srh = get_srh(skb);
+	srh = get_srh(skb, IP6_FH_F_SKIP_RH);
 	if (!srh)
 		return NULL;
 
-	if (srh->segments_left == 0)
-		return NULL;
-
 #ifdef CONFIG_IPV6_SEG6_HMAC
 	if (!seg6_hmac_validate_skb(skb))
 		return NULL;
@@ -172,7 +169,7 @@ static bool decap_and_validate(struct sk_buff *skb, int proto)
 	struct ipv6_sr_hdr *srh;
 	unsigned int off = 0;
 
-	srh = get_srh(skb);
+	srh = get_srh(skb, 0);
 	if (srh && srh->segments_left > 0)
 		return false;
 
-- 
2.29.2

