Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7706D5A3868
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 17:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbiH0Pmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 11:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiH0Pmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 11:42:49 -0400
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 7F3FF642CE;
        Sat, 27 Aug 2022 08:42:46 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [218.12.17.21])
        by mail-app4 (Coremail) with SMTP id cS_KCgDnet1nOgpjW00nBA--.27577S2;
        Sat, 27 Aug 2022 23:38:23 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net] ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler
Date:   Sat, 27 Aug 2022 23:38:15 +0800
Message-Id: <20220827153815.124475-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgDnet1nOgpjW00nBA--.27577S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KF47GF18tF43uFWrKryDKFg_yoW8XrWrpa
        yrWFyjqF1kKF90ga1DXanYvrWrZ3WUAF9rG3WI9w15Zws2qrWDAF9YkFyY9FW0yFy8ZF4Y
        9F18Aw13AFnFy3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUym14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
        xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
        cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
        AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
        14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgIPAVZdtbMKaAAFsk
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function neigh_timer_handler() is a timer handler that runs in an
atomic context. When used by rocker, neigh_timer_handler() calls
"kzalloc(.., GFP_KERNEL)" that may sleep. As a result, the sleep in
atomic context bug will happen. One of the processes is shown below:

ofdpa_fib4_add()
 ...
 neigh_add_timer()

(wait a timer)

neigh_timer_handler()
 neigh_release()
  neigh_destroy()
   rocker_port_neigh_destroy()
    rocker_world_port_neigh_destroy()
     ofdpa_port_neigh_destroy()
      ofdpa_port_ipv4_neigh()
       kzalloc(sizeof(.., GFP_KERNEL) //may sleep

This patch changes the gfp_t parameter of kzalloc() from GFP_KERNEL to
GFP_ATOMIC in order to mitigate the bug.

Fixes: 00fc0c51e35b ("rocker: Change world_ops API and implementation to be switchdev independant")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/net/ethernet/rocker/rocker_ofdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index bc70c6abd6a..58cf7cc54f4 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1273,7 +1273,7 @@ static int ofdpa_port_ipv4_neigh(struct ofdpa_port *ofdpa_port,
 	bool removing;
 	int err = 0;
 
-	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 	if (!entry)
 		return -ENOMEM;
 
-- 
2.17.1

