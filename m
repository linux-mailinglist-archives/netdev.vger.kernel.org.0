Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CF257F22D
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 02:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiGXAil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 20:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiGXAih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 20:38:37 -0400
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9BE1408A
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 17:38:35 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26O0c8EC019842;
        Sun, 24 Jul 2022 02:38:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=12052020;
 bh=j83F4qCiNDaplHCmmwDEVPID1jxIjxR0J0xDijvNBm4=;
 b=Eh+3oSdCTBRQKIefX12C+nXLpnGq5H8XEN+UR0Y56nDfBJggfyAU4QHtQw1s5veHJVBk
 hnYJhJKmKS9WA2vawZ1VO89WsQMGFhfkeb1Z4wTIw1mt/8swC5BkvTnnN6EHuGh/EJav
 P6X9VBQ1hMtFwFTBqAoXe1jmp+aToc5axFGHjjTDW4dGN5sZfDCW3/GDkYNSw1PDtE8x
 blC4/t0gMtO65BQYbXGgzPJ0SUVVKqM0cBrEgFL3XUigRykIOaJM7JK3rjIRsswnxxn6
 Jtgqjk1t/1HSBCFTNFPvxJRM6hJStrT/iZFZGr3di7at+ad6FpcPUaH7mHDJ9AQvA8p3 GQ== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hg5bbgrm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jul 2022 02:38:08 +0200
Received: from Orpheus.nch.westermo.com (172.29.100.2) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Sun, 24 Jul 2022 02:38:07 +0200
From:   Matthias May <matthias.may@westermo.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <nicolas.dichtel@6wind.com>,
        <eyal.birger@gmail.com>, <linux-kernel@vger.kernel.org>,
        Matthias May <matthias.may@westermo.com>
Subject: [PATCH 2/2 net-next] geneve: fix TOS inheriting for ipv6
Date:   Sun, 24 Jul 2022 02:37:41 +0200
Message-ID: <20220724003741.57816-3-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220724003741.57816-1-matthias.may@westermo.com>
References: <20220724003741.57816-1-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.100.2]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: q6bX-TEiNttAZoqHP0Ap_M1dyzqYwg5M
X-Proofpoint-ORIG-GUID: q6bX-TEiNttAZoqHP0Ap_M1dyzqYwg5M
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code uses the RT_TOS macro to cut off the 6 DSCP
bits, down to the original 3 TOS bits.

Do not use this macro to get the prio for inheriting purposes.

Signed-off-by: Matthias May <matthias.may@westermo.com>
---
 drivers/net/geneve.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 4c380c06f178..e1a4480e6f17 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -877,8 +877,7 @@ static struct dst_entry *geneve_get_v6_dst(struct sk_buff *skb,
 		use_cache = false;
 	}
 
-	fl6->flowlabel = ip6_make_flowinfo(RT_TOS(prio),
-					   info->key.label);
+	fl6->flowlabel = ip6_make_flowinfo(prio, info->key.label);
 	dst_cache = (struct dst_cache *)&info->dst_cache;
 	if (use_cache) {
 		dst = dst_cache_get_ip6(dst_cache, &fl6->saddr);
-- 
2.35.1

