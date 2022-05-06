Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4447251D8BC
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 15:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392341AbiEFNWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 09:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237955AbiEFNW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 09:22:29 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A623563516
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 06:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mNzJFB4tUBYAkNjPnx6M6IKxwh6LsLkZa53qdPyr/kc=; b=Y42kg18vOlHHDrpdJj3VG3tITa
        NYy5wl5doQ9OIFYuh6b24kBW7XasNYTBWDrCUdamnHQZo48exhyfjzfedGysKMMYGEx0PBKknFX4B
        D/ls6vUvc0IhEWmUFM6uNI23rdCZCS2x+SJxu6jOcDG/d9Er3E4cME3PV5Gn/1TELIZI=;
Received: from p200300daa70ef2004175abbac4c8f9c2.dip0.t-ipconnect.de ([2003:da:a70e:f200:4175:abba:c4c8:f9c2] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nmxr2-0005Kx-GS; Fri, 06 May 2022 15:18:44 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH 1/4] netfilter: flowtable: fix excessive hw offload attempts after failure
Date:   Fri,  6 May 2022 15:18:38 +0200
Message-Id: <20220506131841.3177-1-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a flow cannot be offloaded, the code currently repeatedly tries again as
quickly as possible, which can significantly increase system load.
Fix this by limiting flow timeout update and hardware offload retry to once
per second.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/netfilter/nf_flow_table_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 3db256da919b..20b4a14e5d4e 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -335,8 +335,10 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 	u32 timeout;
 
 	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
-	if (READ_ONCE(flow->timeout) != timeout)
+	if (timeout - READ_ONCE(flow->timeout) > HZ)
 		WRITE_ONCE(flow->timeout, timeout);
+	else
+		return;
 
 	if (likely(!nf_flowtable_hw_offload(flow_table)))
 		return;
-- 
2.35.1

