Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F1D33B4C8
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhCONlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhCONlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 09:41:14 -0400
X-Greylist: delayed 598 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Mar 2021 06:41:14 PDT
Received: from mxwww.masterlogin.de (mxwww.masterlogin.de [IPv6:2a03:2900:1:1::a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C62C06174A;
        Mon, 15 Mar 2021 06:41:14 -0700 (PDT)
Received: from mxout2.routing.net (unknown [192.168.10.82])
        by backup.mxwww.masterlogin.de (Postfix) with ESMTPS id D2C212C50A;
        Mon, 15 Mar 2021 13:21:18 +0000 (UTC)
Received: from mxbox2.masterlogin.de (unknown [192.168.10.89])
        by mxout2.routing.net (Postfix) with ESMTP id E408E5FAA8;
        Mon, 15 Mar 2021 13:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1615814471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HcbP0eh7sT6aYdhihurrqxMVYQRkKRMHymQQjQvK67E=;
        b=K48Yk+PvuI2+pAWPe8NlZjcZLTWVP4BMQR59RtwlLyTuHmmv/DrMTtJ3MQ4cf4HbpEVqXm
        oKNnfKAD599uvZU/+8kW7Fb+sHnVWgpJpgApl/tl3/HtjVR9J0LNXyhImPIZYqAvD1lAGD
        chMG0YitLQi+oVxzv7PVm4CM07aZbLc=
Received: from localhost.localdomain (fttx-pool-217.61.149.205.bambit.de [217.61.149.205])
        by mxbox2.masterlogin.de (Postfix) with ESMTPSA id 3E95610038A;
        Mon, 15 Mar 2021 13:21:10 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>
Subject: [PATCH] net: wireguard: fix error with icmp{,v6}_ndo_send in 5.4
Date:   Mon, 15 Mar 2021 14:21:03 +0100
Message-Id: <20210315132103.129386-1-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: d4bbf83d-3042-487a-8ef8-1bd95eef3965
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

commit 2019554f9656 introduces implementation of icmp{,v6}_ndo_send in
include/linux/icmp{,v6}.h in case of NF_NAT is enabled. Now these
functions are defined twice in wireguard. Fix this by hiding code if
NF_NAT is set (reverse condition as in icmp*.h)

././net/wireguard/compat/compat.h:959:20: error: static declaration of 'icmp_ndo_send' follows non-static declaration
  959 | static inline void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
./include/net/icmp.h:47:6: note: previous declaration of 'icmp_ndo_send' was here
   47 | void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info);
././net/wireguard/compat/compat.h:988:20: error: static declaration of 'icmpv6_ndo_send' follows non-static declaration
  988 | static inline void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
./include/linux/icmpv6.h:56:6: note: previous declaration of 'icmpv6_ndo_send' was here
   56 | void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info);

Fixes: 2019554f9656 ("icmp: introduce helper for nat'd source address in network device context")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
 net/wireguard/compat/compat.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireguard/compat/compat.h b/net/wireguard/compat/compat.h
index 42f7beecaa5c..7cdb0b253c60 100644
--- a/net/wireguard/compat/compat.h
+++ b/net/wireguard/compat/compat.h
@@ -956,6 +956,7 @@ static inline int skb_ensure_writable(struct sk_buff *skb, int write_len)
 #if LINUX_VERSION_CODE < KERNEL_VERSION(5, 1, 0)
 #include <net/netfilter/nf_nat_core.h>
 #endif
+#if !IS_ENABLED(CONFIG_NF_NAT)
 static inline void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
 {
 	struct sk_buff *cloned_skb = NULL;
@@ -1014,6 +1015,7 @@ static inline void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u
 out:
 	consume_skb(cloned_skb);
 }
+#endif
 #else
 #define icmp_ndo_send icmp_send
 #define icmpv6_ndo_send icmpv6_send
-- 
2.25.1

