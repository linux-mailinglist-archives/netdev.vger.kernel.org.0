Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463442F104D
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 11:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbhAKKnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 05:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbhAKKnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 05:43:39 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A77C061786;
        Mon, 11 Jan 2021 02:42:59 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id x126so10699921pfc.7;
        Mon, 11 Jan 2021 02:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yjwa/+wwRjtStCWa2EN4TWA8E306sEyH4OcuP/qlzRo=;
        b=GrOBJtpzR8VXd8yY0Sork+De+Pclz2Zs2svNIk7VYm7+HIeKUXVqRhF+VEwXd4C6Sc
         UueTUZhdc8yk4t407hgjNJe9fi+2snUAtxmJoBqKdjqWa/1oJVDYSQoUBQR6KVDGVwc4
         4mPicSprnhdQE8bp6XMcG1VhgN3XQrDUC1K/Q+P+IuKxYlsXSJM1tODSjy9zwRzFntOr
         IdE580lgPKzR+YiqWL9FRECds6/MYfJHW2eo4Niwtd61BqaIWQ5l1/Xl0ZN480hAaOo/
         Rt7M3uQCdHgbGd4+ok0wMjSoqHq6ieO9AJC3IFP17igES5AoI5J/w0ottPgwFbYq9vlP
         TA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yjwa/+wwRjtStCWa2EN4TWA8E306sEyH4OcuP/qlzRo=;
        b=pARku3uJor4YYVRB/gWO9ZdwtN5WUszBVmiV3yzV9kkYFtAAWCjg3KFGvg7yNFLFRb
         CikCDRM/ctn20xJ7SDGIYOLVBR2RC9umgKEtB+0T73oikgOmAqAZVBH3b7k+cHW8OAWG
         LOwRWIuXTqI10r8NVREfTGVj7pbkM4U4/DeJhI1StymPknlZJ9T2jaF5kj3rj+sfsYyM
         rLjQ63Tjga39rqWS4NmvzlcroVVDoekaJOFrRud/YN/6B5QHHo16lc81/34DJVlNCSrf
         M6u1gNWzUVj9AbI35CxYLrDvcBIZrmwhBORhA9LufcwkG2r9lfNrmAYvN+NhGG1iFnRq
         JUng==
X-Gm-Message-State: AOAM530eQJVlBKbScMPdSXFLK45kbwU8sQlko5Q5EsckelL3iLnwsqDE
        d5PYjvY8H0lz1wwyXaTOzao=
X-Google-Smtp-Source: ABdhPJwSGz1mZamAN5xujGCHRsNBpA2mqUuxLuAl//oToAYSvXlNGMTDZqnsjBb0iIt+Pg1kL3UpUA==
X-Received: by 2002:a65:50c8:: with SMTP id s8mr19309476pgp.68.1610361778919;
        Mon, 11 Jan 2021 02:42:58 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id d36sm19804128pgm.77.2021.01.11.02.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 02:42:58 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, andriin@fb.com,
        daniel@iogearbox.net, edumazet@google.com, ap420073@gmail.com,
        xiyou.wangcong@gmail.com, jiri@mellanox.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH net-next] net: core: use eth_type_vlan in __netif_receive_skb_core
Date:   Mon, 11 Jan 2021 02:42:21 -0800
Message-Id: <20210111104221.3451-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

Replace the check for ETH_P_8021Q and ETH_P_8021AD in
__netif_receive_skb_core with eth_type_vlan.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/core/dev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index e4d77c8abe76..267c4a8daa55 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5151,8 +5151,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 		skb_reset_mac_len(skb);
 	}
 
-	if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
-	    skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
+	if (eth_type_vlan(skb->protocol)) {
 		skb = skb_vlan_untag(skb);
 		if (unlikely(!skb))
 			goto out;
@@ -5236,8 +5235,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 			 * find vlan device.
 			 */
 			skb->pkt_type = PACKET_OTHERHOST;
-		} else if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
-			   skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
+		} else if (eth_type_vlan(skb->protocol)) {
 			/* Outer header is 802.1P with vlan 0, inner header is
 			 * 802.1Q or 802.1AD and vlan_do_receive() above could
 			 * not find vlan dev for vlan id 0.
-- 
2.17.1

