Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB8B4ECD84
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 21:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiC3Ttx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 15:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiC3Ttw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 15:49:52 -0400
X-Greylist: delayed 316 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 30 Mar 2022 12:48:07 PDT
Received: from postfix02.core.dcmtl.stgraber.net (postfix02.core.dcmtl.stgraber.net [IPv6:2602:fc62:a:1002:216:3eff:fe9a:b0f9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2356549FAB;
        Wed, 30 Mar 2022 12:48:06 -0700 (PDT)
Received: from dakara.stgraber.net (unknown [IPv6:2602:fc62:b:1000:5436:5b25:64e4:d81a])
        by postfix02.core.dcmtl.stgraber.net (Postfix) with ESMTP id 4D45020107;
        Wed, 30 Mar 2022 19:42:48 +0000 (UTC)
From:   =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        Frode Nordahl <frode.nordahl@canonical.com>
Subject: [PATCH] openvswitch: Add recirc_id to recirc warning
Date:   Wed, 30 Mar 2022 15:42:45 -0400
Message-Id: <20220330194244.3476544-1-stgraber@ubuntu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When hitting the recirculation limit, the kernel would currently log
something like this:

[   58.586597] openvswitch: ovs-system: deferred action limit reached, drop recirc action

Which isn't all that useful to debug as we only have the interface name
to go on but can't track it down to a specific flow.

With this change, we now instead get:

[   58.586597] openvswitch: ovs-system: deferred action limit reached, drop recirc action (recirc_id=0x9e)

Which can now be correlated with the flow entries from OVS.

Suggested-by: Frode Nordahl <frode.nordahl@canonical.com>
Signed-off-by: Stéphane Graber <stgraber@ubuntu.com>
Tested-by: Stephane Graber <stgraber@ubuntu.com>
---
 net/openvswitch/actions.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 780d9e2246f3..7056cb1b8ba0 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1539,8 +1539,8 @@ static int clone_execute(struct datapath *dp, struct sk_buff *skb,
 				pr_warn("%s: deferred action limit reached, drop sample action\n",
 					ovs_dp_name(dp));
 			} else {  /* Recirc action */
-				pr_warn("%s: deferred action limit reached, drop recirc action\n",
-					ovs_dp_name(dp));
+				pr_warn("%s: deferred action limit reached, drop recirc action (recirc_id=%#x)\n",
+					ovs_dp_name(dp), recirc_id);
 			}
 		}
 	}
-- 
2.34.1

