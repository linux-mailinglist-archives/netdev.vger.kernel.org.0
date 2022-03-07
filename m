Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35364D0674
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 19:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbiCGS1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 13:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiCGS1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 13:27:01 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F1C92D10
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 10:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MOGu2WV3uSxVN3a4/8zT1vgXZ+IwuqPYTEktZHmksNs=; b=eM67wryyWSUyr1j0tG12B/xdCv
        fYmBvP14APXSaNpn21ZP347e6uRLSXYbKrF0IF/Et9DH52Hrc7ygeD1YNt327qNbMANNA8hPQ+DaP
        1TwInLkw0kXGBrqiobt3tIL4IkgrvnL0moD3h3Rh8ZwBr+C2GMs2qhIQlZ1V3S4WrxBA=;
Received: from p200300daa7204f0005a7b0458a613fd2.dip0.t-ipconnect.de ([2003:da:a720:4f00:5a7:b045:8a61:3fd2] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nRI3X-0007w7-Jk
        for netdev@vger.kernel.org; Mon, 07 Mar 2022 19:26:03 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [PATCH 1/2] sch_cake: allow setting TCA_CAKE_NAT with value 0 if conntrack is disabled
Date:   Mon,  7 Mar 2022 19:26:01 +0100
Message-Id: <20220307182602.16978-1-nbd@nbd.name>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
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

Allows the 'nonat' option to be specified

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/sched/sch_cake.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index a43a58a73d09..57c0095a831b 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2583,9 +2583,11 @@ static int cake_change(struct Qdisc *sch, struct nlattr *opt,
 		q->flow_mode |= CAKE_FLOW_NAT_FLAG *
 			!!nla_get_u32(tb[TCA_CAKE_NAT]);
 #else
-		NL_SET_ERR_MSG_ATTR(extack, tb[TCA_CAKE_NAT],
-				    "No conntrack support in kernel");
-		return -EOPNOTSUPP;
+		if (nla_get_u32(tb[TCA_CAKE_NAT])) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[TCA_CAKE_NAT],
+					    "No conntrack support in kernel");
+			return -EOPNOTSUPP;
+		}
 #endif
 	}
 
-- 
2.32.0 (Apple Git-132)

