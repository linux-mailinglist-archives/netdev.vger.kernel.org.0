Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B351668AF7
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 05:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjAMElr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 23:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjAMElp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 23:41:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5834E6375
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 20:41:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 983FACE1FDC
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 04:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384BDC433EF;
        Fri, 13 Jan 2023 04:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673584899;
        bh=1HXG9oCt3sjsMrP6QeAMknr6n1etPS3vLodR1NrRy5Q=;
        h=From:To:Cc:Subject:Date:From;
        b=qQXTA6zRzVAKyTsYfwPBFfvAOO9tdqh6HbhhcRTk+e5J2bMeJBPpWX4Hp9grNt5iZ
         vm/pJvdRMTgHblFjnpeGTeT1mUNTOq1RfXK+ro4WRchqkp5s7BtzxGNyeF4/DbOHeY
         cmn0pNSIBPu9iBC5qgQv9t7J3o3aUZMdxwk+75XUxXNMP8uqIG+8xxfKcg/b/oKbi9
         1z7OxbVH4/pLchDpVt0aJ7orlI2CZTBj4H38laG16m2mmSjNEJuJSvW0iu8lkDEuG0
         2bcbU+Lp/gd/s7PENYBpD/2rhdPB0HoR4DaBIUL+B4hYmslYocFXjeMDjSVAcpiFwq
         BWHfmhJRG6P/g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        john.hurley@netronome.com
Subject: [PATCH net] net: sched: gred: prevent races when adding offloads to stats
Date:   Thu, 12 Jan 2023 20:41:37 -0800
Message-Id: <20230113044137.1383067-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Naresh reports seeing a warning that gred is calling
u64_stats_update_begin() with preemption enabled.
Arnd points out it's coming from _bstats_update().

We should be holding the qdisc lock when writing
to stats, they are also updated from the datapath.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Link: https://lore.kernel.org/all/CA+G9fYsTr9_r893+62u6UGD3dVaCE-kN9C-Apmb2m=hxjc1Cqg@mail.gmail.com/
Fixes: e49efd5288bd ("net: sched: gred: support reporting stats from offloads")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jhs@mojatatu.com
CC: xiyou.wangcong@gmail.com
CC: jiri@resnulli.us
CC: john.hurley@netronome.com
---
 net/sched/sch_gred.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index a661b062cca8..872d127c9db4 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -377,6 +377,7 @@ static int gred_offload_dump_stats(struct Qdisc *sch)
 	/* Even if driver returns failure adjust the stats - in case offload
 	 * ended but driver still wants to adjust the values.
 	 */
+	sch_tree_lock(sch);
 	for (i = 0; i < MAX_DPs; i++) {
 		if (!table->tab[i])
 			continue;
@@ -393,6 +394,7 @@ static int gred_offload_dump_stats(struct Qdisc *sch)
 		sch->qstats.overlimits += hw_stats->stats.qstats[i].overlimits;
 	}
 	_bstats_update(&sch->bstats, bytes, packets);
+	sch_tree_unlock(sch);
 
 	kfree(hw_stats);
 	return ret;
-- 
2.38.1

