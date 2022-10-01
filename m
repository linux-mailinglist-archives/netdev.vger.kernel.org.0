Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B391B5F1ABB
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 10:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiJAIEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 04:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJAIEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 04:04:22 -0400
Received: from mailgw.kylinos.cn (unknown [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34B718656B;
        Sat,  1 Oct 2022 01:04:13 -0700 (PDT)
X-UUID: b0887db8af0a4f59be3159389f006f2b-20221001
X-CPASD-INFO: e48280871cdf4edc8528b3a819668d8f@roRyUmViZmddg6ayg6ivnVhmYmiSX4G
        Hc3NWamaUZIaVhH5xTV5uYFV9fWtVYV9dYVR6eGxQYmBgZFJ4i3-XblBkXoZgUZB3tHZyUmxeaA==
X-CLOUD-ID: e48280871cdf4edc8528b3a819668d8f
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,OB:4.0,URL:-5,TVAL:169.
        0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:165.0,IP:-2.0,MAL:-5.0,PHF:-5.0,PHC:-5
        .0,SPF:4.0,EDMS:-5,IPLABEL:-2.0,FROMTO:0,AD:0,FFOB:4.0,CFOB:4.0,SPC:0,SIG:-5,
        AUF:26,DUF:6129,ACD:97,DCD:97,SL:0,EISP:0,AG:0,CFC:0.427,CFSR:0.076,UAT:0,RAF
        :0,IMG:-5.0,DFA:0,DTA:0,IBL:-2.0,ADI:-5,SBL:0,REDM:0,REIP:0,ESB:0,ATTNUM:0,EA
        F:0,CID:-5.0,VERSION:2.3.17
X-CPASD-ID: b0887db8af0a4f59be3159389f006f2b-20221001
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1
X-UUID: b0887db8af0a4f59be3159389f006f2b-20221001
X-User: jianghaoran@kylinos.cn
Received: from localhost.localdomain [(183.242.54.212)] by mailgw
        (envelope-from <jianghaoran@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES128-GCM-SHA256 128/128)
        with ESMTP id 1574533610; Sat, 01 Oct 2022 16:04:58 +0800
From:   jianghaoran <jianghaoran@kylinos.cn>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH V2] taprio: Set the value of picos_per_byte before fill sched_entry
Date:   Sat,  1 Oct 2022 16:00:25 +0800
Message-Id: <20221001080025.458519-1-jianghaoran@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220928065830.1544954-1-jianghaoran@kylinos.cn>
References: <20220928065830.1544954-1-jianghaoran@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        MAY_BE_FORGED,PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,
        T_SPF_PERMERROR,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
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
v2:
1,Add an explanation of what this is an example.
2,add a Fixes tag pointing to the first commit
where the issue was presen.
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

