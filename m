Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E270957EBCC
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 05:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiGWD5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 23:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGWD5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 23:57:15 -0400
Received: from zg8tmtyylji0my4xnjqunzqa.icoremail.net (zg8tmtyylji0my4xnjqunzqa.icoremail.net [162.243.164.74])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id B43AC74DDA;
        Fri, 22 Jul 2022 20:57:12 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [106.117.76.127])
        by mail-app3 (Coremail) with SMTP id cC_KCgCHbah+cdtiivhQAQ--.2627S2;
        Sat, 23 Jul 2022 11:56:57 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net] netrom: fix sleep in atomic context bugs in timer handlers
Date:   Sat, 23 Jul 2022 11:56:46 +0800
Message-Id: <20220723035646.29857-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgCHbah+cdtiivhQAQ--.2627S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW5AFW8AF4kuFWxKw17ZFb_yoW8GrWfpF
        WxKF9IyF4qqw1UA3ykGw48u34Yvw1rJF4UC34v9r4Fy3s0qryDJFWjkFWjqF4v9rWxWayY
        qFs0vw1UJF12yFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkq14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r48
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb2g4DUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkAAVZdtay7fgACsf
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are sleep in atomic context bugs in timer handlers of netrom
such as nr_t1timer_expiry(), nr_t2timer_expiry(), nr_heartbeat_expiry(),
nr_idletimer_expiry() and so on.

The root cause is kmemdup() with GFP_KERNEL parameter that may sleep
could be called by different timer handlers which is in interrupt context.

One of the call paths that could trigger bug is shown below:

      (interrupt context)
nr_heartbeat_expiry
  nr_write_internal
    nr_transmit_buffer
      nr_route_frame
        nr_add_node
          kmemdup(..,GFP_KERNEL) //may sleep

This patch changes gfp_t parameter of kmemdup in nr_add_node()
from GFP_KERNEL to GFP_ATOMIC in order to prevent sleep in atomic
context bugs.

Fixes: eafff86d3bd8 ("[NETROM]: Use kmemdup")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 net/netrom/nr_route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index baea3cbd76c..1ddcf13de6a 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -163,7 +163,7 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 		if (ax25_digi != NULL && ax25_digi->ndigi > 0) {
 			nr_neigh->digipeat = kmemdup(ax25_digi,
 						     sizeof(*ax25_digi),
-						     GFP_KERNEL);
+						     GFP_ATOMIC);
 			if (nr_neigh->digipeat == NULL) {
 				kfree(nr_neigh);
 				if (nr_node)
-- 
2.17.1

