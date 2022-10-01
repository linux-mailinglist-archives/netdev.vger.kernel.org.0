Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365DA5F81B5
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 02:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiJHA52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 20:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiJHA5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 20:57:20 -0400
Received: from mailgw.kylinos.cn (unknown [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE52127908;
        Fri,  7 Oct 2022 17:57:11 -0700 (PDT)
X-UUID: 93c899f9e127409fa2dcfbc18898d6ad-20221001
X-Spam-Fingerprint: 0
X-GW-Reason: 13103
X-Policy-Incident: 5pS25Lu25Lq66LaF6L+HMTDkurrpnIDopoHlrqHmoLg=
X-Content-Feature: ica/max.line-size 85
        audit/email.address 1
        dict/adv 1
        meta/cnt.alert 1
X-CPASD-INFO: cd05f4b2fb544c6cbb7129773a2d9458@rLRqVZNmkGKSgneAg6aBnYKTZ2FiZVe
        GdZtSmGdkYViVhH5xTV5uYFV9fWtVYV9dYVR6eGxQYmBgZFJ4i3-XblBkXoZgUZB3sqZqVZtikg==
X-CLOUD-ID: cd05f4b2fb544c6cbb7129773a2d9458
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,OB:4.0,URL:-5,TVAL:180.
        0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:156.0,IP:-2.0,MAL:-5.0,PHF:-5.0,PHC:-5
        .0,SPF:4.0,EDMS:-5,IPLABEL:-2.0,FROMTO:1,AD:0,FFOB:4.0,CFOB:5.0,SPC:0,SIG:-5,
        AUF:19,DUF:6113,ACD:96,DCD:96,SL:0,EISP:0,AG:0,CFC:0.433,CFSR:0.081,UAT:0,RAF
        :0,IMG:-5.0,DFA:0,DTA:0,IBL:-2.0,ADI:-5,SBL:0,REDM:0,REIP:0,ESB:0,ATTNUM:0,EA
        F:0,CID:-5.0,VERSION:2.3.17
X-CPASD-ID: 93c899f9e127409fa2dcfbc18898d6ad-20221001
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1
X-UUID: 93c899f9e127409fa2dcfbc18898d6ad-20221001
X-User: jianghaoran@kylinos.cn
Received: from localhost.localdomain [(183.242.54.212)] by mailgw
        (envelope-from <jianghaoran@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES128-GCM-SHA256 128/128)
        with ESMTP id 779658113; Sat, 01 Oct 2022 09:21:50 +0800
From:   jianghaoran <jianghaoran@kylinos.cn>
To:     jianghaoran@kylinos.cn
Cc:     davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        vinicius.gomes@intel.com, xiyou.wangcong@gmail.com,
        vladimir.oltean@nxp.com
Subject: [PATCH] taprio: Set the value of picos_per_byte before fill sched_entry
Date:   Sat,  1 Oct 2022 09:17:17 +0800
Message-Id: <20221001011717.70409-1-jianghaoran@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220928065830.1544954-1-jianghaoran@kylinos.cn>
References: <20220928065830.1544954-1-jianghaoran@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,T_SPF_PERMERROR,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the value of picos_per_byte is set after fill sched_entry,
as a result, the min_duration calculated by length_to_duration is 0,
and the validity of the input interval cannot be judged,
too small intervals couldn't allow any packet to be transmitted.
It will appear like commit b5b73b26b3ca ("taprio:
Fix allowing too small intervals") described problem.
Here is a further modification of this problem.

example configuration which will not be able to transmit:

tc qdisc replace dev enp5s0f0 parent root handle 100 taprio \
              num_tc 3 \
              map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
              queues 1@0 1@1 2@2 \
              base-time  1528743495910289987 \
              sched-entry S 01 9 \
	      sched-entry S 02 9 \
	      sched-entry S 04 9 \
              clockid CLOCK_TAI

Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")
Signed-off-by: jianghaoran <jianghaoran@kylinos.cn>
---
 net/sched/sch_taprio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 86675a79da1e..d95ec2250f24 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1507,6 +1507,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 	}
 
+	taprio_set_picos_per_byte(dev, q);
+
 	err = parse_taprio_schedule(q, tb, new_admin, extack);
 	if (err < 0)
 		goto free_sched;
@@ -1521,8 +1523,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		goto free_sched;
 
-	taprio_set_picos_per_byte(dev, q);
-
 	if (mqprio) {
 		err = netdev_set_num_tc(dev, mqprio->num_tc);
 		if (err)
-- 
2.25.1

