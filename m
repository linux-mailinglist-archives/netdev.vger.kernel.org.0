Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53A951DE26
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 19:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443815AbiEFRLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 13:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444124AbiEFRLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 13:11:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4E46EC5E
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 10:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CD1CB80E84
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 17:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7B2C385A8;
        Fri,  6 May 2022 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651856877;
        bh=7awHDlMuoj29MbRMY1wKPQIOvc9SDY6wCvbAyS+Tvho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQyrcWNPJ6N/O4ZC/hOvhmA+1Tnph760bFDR9/7ccv+YwY37AnuZ5E+RooxDO7st2
         TPJNYz8sY5t7uy7yn3Ul0QVSCIxFmIABHeH3Kr4VdwaVfdwiLRXJ0ThlWNheHgRJZ3
         FqcTRLtX7BU0PQ6Y5VahocILJ+v6FVVUiZ+33TGDdBu0O8sOJvaLL/IG5M/be/ne0i
         l6Zl+UaQyz7KD+DLddn7gBHGsmBUgja5hFzxWyauqV5RVm/4IB+85Jht96gt+JhSDu
         BLh/xaoBMva/KYPCvrnkMSHO4JSGbkDHl2GZCYBaRVhn5tQ8gebbVZV+eZA9A3BQ5C
         NXQ3KdR2PupWA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, richard@nod.at,
        anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
        linux-um@lists.infradead.org
Subject: [PATCH net-next 1/6] um: vector: switch to netif_napi_add_weight()
Date:   Fri,  6 May 2022 10:07:46 -0700
Message-Id: <20220506170751.822862-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506170751.822862-1-kuba@kernel.org>
References: <20220506170751.822862-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UM's netdev driver uses a custom napi weight, switch to the new
API for setting custom weight.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: richard@nod.at
CC: anton.ivanov@cambridgegreys.com
CC: johannes@sipsolutions.net
CC: linux-um@lists.infradead.org
---
 arch/um/drivers/vector_kern.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 1d6f6a66766c..548265312743 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1255,7 +1255,8 @@ static int vector_net_open(struct net_device *dev)
 			goto out_close;
 	}
 
-	netif_napi_add(vp->dev, &vp->napi, vector_poll, get_depth(vp->parsed));
+	netif_napi_add_weight(vp->dev, &vp->napi, vector_poll,
+			      get_depth(vp->parsed));
 	napi_enable(&vp->napi);
 
 	/* READ IRQ */
-- 
2.34.1

