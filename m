Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39705F9714
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 04:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiJJCqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 22:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiJJCqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 22:46:46 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1604B0FD
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 19:46:44 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id C64B22C0746;
        Mon, 10 Oct 2022 02:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1665370000;
        bh=1brJsjl0xI5L1GkQZfaE8oXErg7ibxkUzqbxER+swKM=;
        h=From:To:Cc:Subject:Date:From;
        b=KerF0Dgg4+/Z9GKSxw+YXSAHcmrKpGI1le6Ue8uyebW0XnAbdT4RNe03MpWgxQTS0
         feVAn13TzKaTZM9NlFH+QFgYnR6AmmN6wVajRyACmZljHRW2rG6IbhZzOUgZVFwdcL
         p2v8+UIw9yDFroAwWix2+T+vwxoB1Hy/imAGAbzu4wJY0JbXn42y5gBPDtso7aY8um
         DBcrNSZTuyHgpNpP1/mR1aAfhG03/mfeV035Bk6iS+2Mh5GmHJS8GzPcoJKOcPhv06
         BmIBOT0TZp8MD/o+ke+qma/oCqZfIkEKlMffwGV7Phn9T6h28jDKQYuONEUrNW4J5K
         oHDILX0Ncveaw==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B634387900000>; Mon, 10 Oct 2022 15:46:40 +1300
Received: from markto-dl.ws.atlnz.lc (markto-dl.ws.atlnz.lc [10.33.23.25])
        by pat.atlnz.lc (Postfix) with ESMTP id 99B2713EDD7;
        Mon, 10 Oct 2022 15:46:40 +1300 (NZDT)
Received: by markto-dl.ws.atlnz.lc (Postfix, from userid 1155)
        id 974C5340926; Mon, 10 Oct 2022 15:46:40 +1300 (NZDT)
From:   Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Subject: [PATCH] tipc: Fix recognition of trial period
Date:   Mon, 10 Oct 2022 15:46:13 +1300
Message-Id: <20221010024613.2951-1-mark.tomlinson@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=UKij4xXy c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=Qawa6l4ZSaYA:10 a=CfVpqal7VN6jvvNFqYUA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The trial period exists until jiffies is after addr_trial_end. But as
jiffies will eventually overflow, just using time_after will eventually
give incorrect results. As the node address is set once the trial period
ends, this can be used to know that we are not in the trial period.

Fixes: e415577f57f4 ("tipc: correct discovery message handling during add=
ress trial period")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
---
 net/tipc/discover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index da69e1abf68f..e8630707901e 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -148,8 +148,8 @@ static bool tipc_disc_addr_trial_msg(struct tipc_disc=
overer *d,
 {
 	struct net *net =3D d->net;
 	struct tipc_net *tn =3D tipc_net(net);
-	bool trial =3D time_before(jiffies, tn->addr_trial_end);
 	u32 self =3D tipc_own_addr(net);
+	bool trial =3D time_before(jiffies, tn->addr_trial_end) && !self;
=20
 	if (mtyp =3D=3D DSC_TRIAL_FAIL_MSG) {
 		if (!trial)
--=20
2.38.0

