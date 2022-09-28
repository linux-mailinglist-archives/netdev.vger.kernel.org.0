Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A3C5ED59A
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 09:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiI1HCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 03:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiI1HBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 03:01:55 -0400
Received: from mailgw.kylinos.cn (unknown [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CB266A59;
        Wed, 28 Sep 2022 00:01:50 -0700 (PDT)
X-UUID: 03eb4b6b57574835a8ac1c1245924482-20220928
X-CPASD-INFO: 20ac31237c1c4aa38fe6546ba328bcf1@e4Cbg2BjYGNjg3Ovg6SsbViXlWZlYFa
        xo21SaJCTklGVhH5xTV5uYFV9fWtVYV9dYVR6eGxQYmBgZFJ4i3-XblBgXoZgUZB3gXKbg2NfYg==
X-CLOUD-ID: 20ac31237c1c4aa38fe6546ba328bcf1
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,OB:0.0,URL:-5,TVAL:184.
        0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:147.0,IP:-2.0,MAL:-5.0,PHF:-5.0,PHC:-5
        .0,SPF:4.0,EDMS:-5,IPLABEL:4992.0,FROMTO:0,AD:0,FFOB:0.0,CFOB:0.0,SPC:0,SIG:-
        5,AUF:4,DUF:5858,ACD:94,DCD:94,SL:0,EISP:0,AG:0,CFC:0.451,CFSR:0.081,UAT:0,RA
        F:0,IMG:-5.0,DFA:0,DTA:0,IBL:-2.0,ADI:-5,SBL:0,REDM:0,REIP:0,ESB:0,ATTNUM:0,E
        AF:0,CID:-5.0,VERSION:2.3.17
X-CPASD-ID: 03eb4b6b57574835a8ac1c1245924482-20220928
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1
X-UUID: 03eb4b6b57574835a8ac1c1245924482-20220928
X-User: jianghaoran@kylinos.cn
Received: from localhost.localdomain [(210.12.40.82)] by mailgw
        (envelope-from <jianghaoran@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES128-GCM-SHA256 128/128)
        with ESMTP id 1053301831; Wed, 28 Sep 2022 15:02:34 +0800
From:   jianghaoran <jianghaoran@kylinos.cn>
To:     vinicius.gomes@intel.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] taprio: Set the value of picos_per_byte before fill sched_entry
Date:   Wed, 28 Sep 2022 14:58:30 +0800
Message-Id: <20220928065830.1544954-1-jianghaoran@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        RDNS_DYNAMIC,SPF_HELO_NONE,T_SPF_PERMERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
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

example:

tc qdisc replace dev enp5s0f0 parent root handle 100 taprio \
              num_tc 3 \
              map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
              queues 1@0 1@1 2@2 \
              base-time  1528743495910289987 \
              sched-entry S 01 9 \
	      sched-entry S 02 9 \
	      sched-entry S 04 9 \
              clockid CLOCK_TAI

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

