Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7E66108B1
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 05:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbiJ1DZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 23:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiJ1DZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 23:25:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0521FF87
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 20:25:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F28E1CE1346
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38571C433C1;
        Fri, 28 Oct 2022 03:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666927503;
        bh=E2VJYcfcqa5/q/32SYADLnrTTLSTjrlQcj7jM5wu92k=;
        h=From:To:Cc:Subject:Date:From;
        b=lyiJdVRFTJd/8/ezr827SPfoed4WV1EusK+Zyvab7XWSERE+7fYYZ/Qm93wR9TKfq
         bxhgq5WRmpm0xu37GdOJOx4hAGSP4+59k4wht3ZH3do2urAzFqKN6oHncC7iMXwitM
         qxHFcck2ZJaelMeAYbyDbgCnMaQqtk5/c1rq1sO0XMjB/htXy62pJCVQ6srradqgJN
         jrByzoZODAzd3BEJAQGAa4g4HC92NYUKtGg4nLskvxPSSANGaxqQiZNl06fh+D96Gc
         nMoJqsNFLB19fhQMi88xptc+RlywuAjV+zFWzN7xzrg8AoUL2bL1WY2SGexQ7inJyK
         RyYadriNXAmFA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+40eb8c0447c0e47a7e9b@syzkaller.appspotmail.com,
        pshelar@ovn.org, paul@paul-moore.com, dev@openvswitch.org
Subject: [PATCH net] net: openvswitch: add missing .resv_start_op
Date:   Thu, 27 Oct 2022 20:25:01 -0700
Message-Id: <20221028032501.2724270-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I missed one of the families in OvS when annotating .resv_start_op.
This triggers the warning added in commit ce48ebdd5651 ("genetlink:
limit the use of validation workarounds to old ops").

Reported-by: syzbot+40eb8c0447c0e47a7e9b@syzkaller.appspotmail.com
Fixes: 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: pshelar@ovn.org
CC: paul@paul-moore.com
CC: dev@openvswitch.org
---
 net/openvswitch/datapath.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 155263e73512..8b84869eb2ac 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2544,6 +2544,7 @@ struct genl_family dp_vport_genl_family __ro_after_init = {
 	.parallel_ops = true,
 	.small_ops = dp_vport_genl_ops,
 	.n_small_ops = ARRAY_SIZE(dp_vport_genl_ops),
+	.resv_start_op = OVS_VPORT_CMD_SET + 1,
 	.mcgrps = &ovs_dp_vport_multicast_group,
 	.n_mcgrps = 1,
 	.module = THIS_MODULE,
-- 
2.37.3

