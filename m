Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4272A39A949
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhFCRgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:36:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:32976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhFCRgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:36:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D983613D2;
        Thu,  3 Jun 2021 17:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622741672;
        bh=nSPjwdgpt9if/5lEOJp4BlmsJ9DjmB1lCXvcoDoVfyU=;
        h=From:To:Cc:Subject:Date:From;
        b=O0zvkdiE7NeWEVFbnpiYdMoMI2W8SfgrcvU6S8fBqgYmrree2to0ak7AlefGJwSeO
         iKklKl7SPlvP9X6oWBbtxM4lpdsS2ej4UwmY3PCFejZXEKmqEb74Id/8vgPlp7wF44
         k8KJ17XWB5uQlfRaGQywE0b8udUMqg3bNKwPzLFFsKmMAs94tBbsQe7Duv1ciXpacN
         dGeu4tARlMYYNf4dy4DRpJCS9P8yAriASsQZM3dx+W8igmTzKw7yJ27mv+0kQE4LLU
         miruxdTIvmeVqeGtDIwLhe40FpW/fqDSY6bUIcUXAKoKSqDz/6gfDBgDAXRGBFXWf5
         kX4QNOaVsAOjQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Sharath Chandra Vurukala <sharathv@codeaurora.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH net-next] net: ethernet: rmnet: Restructure if checks to avoid uninitialized warning
Date:   Thu,  3 Jun 2021 10:34:10 -0700
Message-Id: <20210603173410.310362-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.rc3
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns that proto in rmnet_map_v5_checksum_uplink_packet() might be
used uninitialized:

drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:283:14: warning:
variable 'proto' is used uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]
                } else if (skb->protocol == htons(ETH_P_IPV6)) {
                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:295:36: note:
uninitialized use occurs here
                check = rmnet_map_get_csum_field(proto, trans);
                                                 ^~~~~
drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:283:10: note:
remove the 'if' if its condition is always true
                } else if (skb->protocol == htons(ETH_P_IPV6)) {
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:270:11: note:
initialize the variable 'proto' to silence this warning
                u8 proto;
                        ^
                         = '\0'
1 warning generated.

This is technically a false positive because there is an if statement
above this one that checks skb->protocol for not being either
ETH_P_IP{,V6}. However, it is more obvious to sink that into the if
statement as an else branch, which makes the code clearer and fixes the
warning.

At the same time, move the "IS_ENABLED(CONFIG_IPV6)" into the else if
condition so that the else branch of the preprocessor conditional can
be shared, since there is no build failure with CONFIG_IPV6 disabled.

Fixes: b6e5d27e32ef ("net: ethernet: rmnet: Add support for MAPv5 egress packets")
Link: https://github.com/ClangBuiltLinux/linux/issues/1390
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c    | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 6492ec5bdec4..cecf72be5102 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -269,27 +269,20 @@ static void rmnet_map_v5_checksum_uplink_packet(struct sk_buff *skb,
 		void *trans;
 		u8 proto;
 
-		if (skb->protocol != htons(ETH_P_IP) &&
-		    skb->protocol != htons(ETH_P_IPV6)) {
-			priv->stats.csum_err_invalid_ip_version++;
-			goto sw_csum;
-		}
-
 		if (skb->protocol == htons(ETH_P_IP)) {
 			u16 ip_len = ((struct iphdr *)iph)->ihl * 4;
 
 			proto = ((struct iphdr *)iph)->protocol;
 			trans = iph + ip_len;
-		} else if (skb->protocol == htons(ETH_P_IPV6)) {
-#if IS_ENABLED(CONFIG_IPV6)
+		} else if (IS_ENABLED(CONFIG_IPV6) &&
+			   skb->protocol == htons(ETH_P_IPV6)) {
 			u16 ip_len = sizeof(struct ipv6hdr);
 
 			proto = ((struct ipv6hdr *)iph)->nexthdr;
 			trans = iph + ip_len;
-#else
+		} else {
 			priv->stats.csum_err_invalid_ip_version++;
 			goto sw_csum;
-#endif /* CONFIG_IPV6 */
 		}
 
 		check = rmnet_map_get_csum_field(proto, trans);

base-commit: 270d47dc1fc4756a0158778084a236bc83c156d2
-- 
2.32.0.rc3

