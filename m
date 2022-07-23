Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2109157EB26
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 03:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiGWB6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 21:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGWB6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 21:58:40 -0400
Received: from azure-sdnproxy-1.icoremail.net (azure-sdnproxy.icoremail.net [52.187.6.220])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id ADA4D7B1FA;
        Fri, 22 Jul 2022 18:58:36 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [106.117.76.127])
        by mail-app4 (Coremail) with SMTP id cS_KCgC3L8+yVdtiwTkdAQ--.30584S2;
        Sat, 23 Jul 2022 09:58:18 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-sctp@vger.kernel.org
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net] sctp: fix sleep in atomic context bug in timer handlers
Date:   Sat, 23 Jul 2022 09:58:09 +0800
Message-Id: <20220723015809.11553-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgC3L8+yVdtiwTkdAQ--.30584S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AF1DXrWruFWDKF4rKrWUXFb_yoW8Xw1rpr
        yDuF4FqF17tF18ZFZ5ur4Fqw1akws7J34DKF40kwn5A398Jr4YgFy8KrWSyrWxurWUZFWY
        va15K347Gr1jkFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6w4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUOMKZDUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgcAAVZdtay58AADsc
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are sleep in atomic context bugs in timer handlers of sctp
such as sctp_generate_t3_rtx_event(), sctp_generate_probe_event(),
sctp_generate_t1_init_event(), sctp_generate_timeout_event(),
sctp_generate_t3_rtx_event() and so on.

The root cause is sctp_sched_prio_init_sid() with GFP_KERNEL parameter
that may sleep could be called by different timer handlers which is in
interrupt context.

One of the call paths that could trigger bug is shown below:

      (interrupt context)
sctp_generate_probe_event
  sctp_do_sm
    sctp_side_effects
      sctp_cmd_interpreter
        sctp_outq_teardown
          sctp_outq_init
            sctp_sched_set_sched
              n->init_sid(..,GFP_KERNEL)
                sctp_sched_prio_init_sid //may sleep

This patch changes gfp_t parameter of init_sid in sctp_sched_set_sched()
from GFP_KERNEL to GFP_ATOMIC in order to prevent sleep in atomic
context bugs.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 net/sctp/stream_sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index 518b1b9bf89..1ad565ed562 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -160,7 +160,7 @@ int sctp_sched_set_sched(struct sctp_association *asoc,
 		if (!SCTP_SO(&asoc->stream, i)->ext)
 			continue;
 
-		ret = n->init_sid(&asoc->stream, i, GFP_KERNEL);
+		ret = n->init_sid(&asoc->stream, i, GFP_ATOMIC);
 		if (ret)
 			goto err;
 	}
-- 
2.17.1

