Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3218C60BFA9
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 02:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJYAeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 20:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiJYAdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 20:33:47 -0400
Received: from m15114.mail.126.com (m15114.mail.126.com [220.181.15.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D73F74B0ED
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 15:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Qzivr
        l/GqL3eoExTAErsv7fnMKA+KnI6JsiaRaz0AvU=; b=ch03mZnDVNRiIuS9WVeZx
        1p5qkxV3LlMvEIIiNaDkmIf/4amg6B2cnk1C704PUtfrKkcWFoYmn9F79Ari29cn
        q3qBmRI52eaLQIveU76159VEhknB7zwcWUg+vqPR0F9XYr+J4rbIKd1bLfEZmL6U
        h9hOQG+4Xw4p3vwEfXGne4=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp7 (Coremail) with SMTP id DsmowADHzXmZpVZjeNZuDQ--.63775S2;
        Mon, 24 Oct 2022 22:47:54 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, windhl@126.com
Subject: [PATCH] appletalk: Fix potential refcount leak
Date:   Mon, 24 Oct 2022 22:47:53 +0800
Message-Id: <20221024144753.479152-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsmowADHzXmZpVZjeNZuDQ--.63775S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr1fuFWxXr45WF1DAw4fKrg_yoW3Xrc_Aa
        yfCw1ruF4UXan8Kw45GF4fJrn7ta1jqa92kr13WFZ3X34YyF4kXr18WFyfZry3u3y8uF9x
        WF95ZrW3Cr15WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRWWl97UUUUU==
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi3AikF1pEEdX3WQABsS
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In atrtr_create(), we have added a dev_hold for the new reference.
However, based on the code, if the 'rt' is not NULL and its 'dev'
is not NULL, we should use dev_put() for the replaced reference.

Signed-off-by: Liang He <windhl@126.com>
---
 net/appletalk/ddp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index a06f4d4a6f47..7e317d6448d1 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -564,6 +564,7 @@ static int atrtr_create(struct rtentry *r, struct net_device *devhint)
 	/* Fill in the routing entry */
 	rt->target  = ta->sat_addr;
 	dev_hold(devhint);
+	dev_put(rt->dev);
 	rt->dev     = devhint;
 	rt->flags   = r->rt_flags;
 	rt->gateway = ga->sat_addr;
-- 
2.25.1

