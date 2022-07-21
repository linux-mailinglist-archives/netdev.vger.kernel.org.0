Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA56B57D15B
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiGUQUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbiGUQTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:19:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A472152E4E
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 09:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658420379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pBqZ3fMilguQI5pyGT2dYI0euEc2fh1Jj8YtVTRq8rI=;
        b=JQ6zImDbmle0uRW7zir9KU3Pv9lR1Au756lQBYWGANznQk3VNvV5XILOHbHpURlD6c7wU2
        0a8n11iTPaniaZ/qyUp45u8UKKoKxeDbKuss/85mxAz4abwmobEbWNYsUCyPGK72oqQijL
        nxOggFDFEEtGtKSM0VQt9x+nA6HKQeY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-b4kbprhsPdelkqTPp64xdQ-1; Thu, 21 Jul 2022 12:19:36 -0400
X-MC-Unique: b4kbprhsPdelkqTPp64xdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1E5529ABA13;
        Thu, 21 Jul 2022 16:19:35 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.40.193.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62112C27D95;
        Thu, 21 Jul 2022 16:19:33 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next] net/sched: act_mirred: avoid printout in the traffic path
Date:   Thu, 21 Jul 2022 18:19:22 +0200
Message-Id: <c2ef23da1d9a4eb62f4e7b7c4540f9bafb553c15.1658420239.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when tc-mirred outputs to a device that's not up, dmesg is cluttered with
messages like:

 tc mirred to Houston: device br-int is down

we can't completely remove this printout: users might be relying on it to
detect setups where tc-mirred drops everything, as discussed earlier [1].
however, we can at least reduce the amount of these messages, and improve
their content as follows:
 - add a pr_notice(...) in the .init() function, to warn users of missing
   IFF_UP flag on the target of a newly added tc-mirred action
 - check for NETDEV_DOWN in the .notifier_call() function, and add proper
   pr_notice(...) to warn users of missing/down target devices

[1] https://lore.kernel.org/netdev/CAM_iQpUvn+ijyZtLmca3n+nZmHY9cMmPYwZMp5BTv10bLUhg3Q@mail.gmail.com/

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_mirred.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index a1d70cf86843..4af6073e472b 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -178,6 +178,13 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 			err = -ENODEV;
 			goto put_chain;
 		}
+		if (!(ndev->flags & IFF_UP))
+			pr_notice("tc mirred: action %i %s on %s while device is down",
+				  m->tcf_index,
+				  tcf_mirred_is_act_redirect(parm->eaction) ?
+					"redirects" : "mirrors",
+				  ndev->name);
+
 		mac_header_xmit = dev_is_mac_header_xmit(ndev);
 		odev = rcu_replace_pointer(m->tcfm_dev, ndev,
 					  lockdep_is_held(&m->tcf_lock));
@@ -251,16 +258,8 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	m_eaction = READ_ONCE(m->tcfm_eaction);
 	retval = READ_ONCE(m->tcf_action);
 	dev = rcu_dereference_bh(m->tcfm_dev);
-	if (unlikely(!dev)) {
-		pr_notice_once("tc mirred: target device is gone\n");
+	if (unlikely(!dev || !(dev->flags & IFF_UP)))
 		goto out;
-	}
-
-	if (unlikely(!(dev->flags & IFF_UP))) {
-		net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
-				       dev->name);
-		goto out;
-	}
 
 	/* we could easily avoid the clone only if called by ingress and clsact;
 	 * since we can't easily detect the clsact caller, skip clone only for
@@ -397,16 +396,21 @@ static int mirred_device_event(struct notifier_block *unused,
 	struct tcf_mirred *m;
 
 	ASSERT_RTNL();
-	if (event == NETDEV_UNREGISTER) {
+	if (event == NETDEV_UNREGISTER || event == NETDEV_DOWN) {
 		spin_lock(&mirred_list_lock);
 		list_for_each_entry(m, &mirred_list, tcfm_list) {
 			spin_lock_bh(&m->tcf_lock);
 			if (tcf_mirred_dev_dereference(m) == dev) {
-				netdev_put(dev, &m->tcfm_dev_tracker);
-				/* Note : no rcu grace period necessary, as
-				 * net_device are already rcu protected.
-				 */
-				RCU_INIT_POINTER(m->tcfm_dev, NULL);
+				pr_notice("tc mirred: target device %s is %s\n",
+					  dev->name,
+					  event == NETDEV_UNREGISTER ? "gone" : "down");
+				if (event == NETDEV_UNREGISTER) {
+					netdev_put(dev, &m->tcfm_dev_tracker);
+					/* Note : no rcu grace period necessary, as
+					 * net_device are already rcu protected.
+					 */
+					RCU_INIT_POINTER(m->tcfm_dev, NULL);
+				}
 			}
 			spin_unlock_bh(&m->tcf_lock);
 		}
-- 
2.35.3

