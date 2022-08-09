Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BB358DCC8
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 19:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245412AbiHIRG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 13:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245403AbiHIRG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 13:06:28 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2181114D;
        Tue,  9 Aug 2022 10:06:26 -0700 (PDT)
Received: from localhost.localdomain (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id E3E623F100;
        Tue,  9 Aug 2022 17:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660064780;
        bh=tp7Feci5c5QYbeTqtXxJ+DvDx3fFWiOlRvkDkssfD78=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=IiZfjzPGcg9atZGp4sqOWARH0QP00nTbHJXhtlMBLb2XutQzPl2Iy1Dh7xdZxSO5n
         gTHnkGFSNTxob0zfQ9AvTJ0B75OVqYChbZ/1Kdkb/FLGVNmtsjbFJpx8qhuPQSt/me
         O/PLoCDzhlwfs1OClDmYTQ4NyO6O2EdDXDHjcIHtpX0e1icwQY58lbtIjgdcJqfZ1F
         XlTlLN30XbwtlnbgYONEe4t8baiGB4JsY8bhzXyH+Dl4fdLoKmFnAU9hNTwKuEaxBp
         i8MCakvkZC8dt2rsDq6Cz94TajE/5V/tqAVvOPt+U6QQS1icSloWfIHX5S2MYtxD2S
         xTEv+NI0XnZPw==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Zhenpeng Lin <zplin@u.northwestern.edu>,
        Kamal Mostafa <kamal@canonical.com>, stable@vger.kernel.org
Subject: [PATCH] net_sched: cls_route: remove from list when handle is 0
Date:   Tue,  9 Aug 2022 14:05:18 -0300
Message-Id: <20220809170518.164662-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a route filter is replaced and the old filter has a 0 handle, the old
one won't be removed from the hashtable, while it will still be freed.

The test was there since before commit 1109c00547fc ("net: sched: RCU
cls_route"), when a new filter was not allocated when there was an old one.
The old filter was reused and the reinserting would only be necessary if an
old filter was replaced. That was still wrong for the same case where the
old handle was 0.

Remove the old filter from the list independently from its handle value.

This fixes CVE-2022-2588, also reported as ZDI-CAN-17440.

Reported-by: Zhenpeng Lin <zplin@u.northwestern.edu>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Reviewed-by: Kamal Mostafa <kamal@canonical.com>
Cc: <stable@vger.kernel.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/cls_route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index a35ab8c27866..3f935cbbaff6 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -526,7 +526,7 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 	rcu_assign_pointer(f->next, f1);
 	rcu_assign_pointer(*fp, f);
 
-	if (fold && fold->handle && f->handle != fold->handle) {
+	if (fold) {
 		th = to_hash(fold->handle);
 		h = from_hash(fold->handle >> 16);
 		b = rtnl_dereference(head->table[th]);
-- 
2.34.1

