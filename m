Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CA542CC8A
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 23:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhJMVM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 17:12:26 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:60753 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229882AbhJMVMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 17:12:25 -0400
Received: from localhost.localdomain (ip5f5ae911.dynamic.kabel-deutschland.de [95.90.233.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2425261E64760;
        Wed, 13 Oct 2021 23:10:20 +0200 (CEST)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Paul Menzel <pmenzel@molgen.mpg.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: sched: fix infinite loop when trying to create tcf rule
Date:   Wed, 13 Oct 2021 23:09:59 +0200
Message-Id: <20211013211000.8962-1-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Serhiy Boiko <serhiy.boiko@plvision.eu>

After running a specific set of commands tc will become unresponsive:

    $ ip link add dev DEV type veth
    $ tc qdisc add dev DEV clsact
    $ tc chain add dev DEV chain 0 ingress
    $ tc filter del dev DEV ingress
    $ tc filter add dev DEV ingress flower action pass

When executing chain flush the chain->flushing field is set to true, which
prevents insertion of new classifier instances.  It is unset in one place
under two conditions: `refcnt - chain->action_refcnt == 0` and `!by_act`.
Ignoring the by_act and action_refcnt arguments the `flushing procedure`
will be over when refcnt is 0.

But if the chain is explicitly created (e.g. `tc chain add .. chain 0 ..`)
refcnt is set to 1 without any classifier instances. Thus the condition is
never met and the chain->flushing field is never cleared.  And because the
default chain is `flushing` new classifiers cannot be added. tc_new_tfilter
is stuck in a loop trying to find a chain where chain->flushing is false.

Moving `chain->flushing = false` from __tcf_chain_put to the end of
tcf_chain_flush will avoid the condition and the field will always be reset
after the flush procedure.

Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
[Upstreamed from https://github.com/dentproject/dentOS/commit/3480aceaa5244a11edfe1fda90afd92b0199ef23]
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 net/sched/cls_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2ef8f5a6205a..405f955bef1e 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -563,8 +563,6 @@ static void __tcf_chain_put(struct tcf_chain *chain, bool by_act,
 	if (refcnt - chain->action_refcnt == 0 && !by_act) {
 		tc_chain_notify_delete(tmplt_ops, tmplt_priv, chain->index,
 				       block, NULL, 0, 0, false);
-		/* Last reference to chain, no need to lock. */
-		chain->flushing = false;
 	}
 
 	if (refcnt == 0)
@@ -615,6 +613,9 @@ static void tcf_chain_flush(struct tcf_chain *chain, bool rtnl_held)
 		tcf_proto_put(tp, rtnl_held, NULL);
 		tp = tp_next;
 	}
+
+	/* Last reference to chain, no need to lock. */
+	chain->flushing = false;
 }
 
 static int tcf_block_setup(struct tcf_block *block,
-- 
2.33.0

