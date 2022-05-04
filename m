Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2C0519718
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 07:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344755AbiEDGCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiEDGCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:02:49 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86C9527CDE;
        Tue,  3 May 2022 22:59:12 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgB3ORAYFnJihcJQAg--.20435S2;
        Wed, 04 May 2022 13:58:53 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     krzysztof.kozlowski@linaro.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net] NFC: netlink: fix sleep in atomic bug when firmware download timeout
Date:   Wed,  4 May 2022 13:58:47 +0800
Message-Id: <20220504055847.38026-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgB3ORAYFnJihcJQAg--.20435S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ur48uF1rKF4fGw1DGFyxGrg_yoW8Cw47pF
        WUG3WxAF4UJw1FvFyvyF4vkw4aka1kJrWDGF429rWruF98JF18AF45KFy8ZF4fCr4kXa1a
        vF9Fvr4akF45Za7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUka1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y
        6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
        1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUp6wZUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAggAAVZdtZgToAARsP
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are sleep in atomic bug that could cause kernel panic during
firmware download process. The root cause is that nlmsg_new with
GFP_KERNEL parameter is called in fw_dnld_timeout which is a timer
handler. The call trace is shown below:

BUG: sleeping function called from invalid context at include/linux/sched/mm.h:265
Call Trace:
kmem_cache_alloc_node
__alloc_skb
nfc_genl_fw_download_done
call_timer_fn
__run_timers.part.0
run_timer_softirq
__do_softirq
...

The nlmsg_new with GFP_KERNEL parameter may sleep during memory
allocation process, and the timer handler is run as the result of
a "software interrupt" that should not call any other function
that could sleep.

This patch changes allocation mode of netlink message from GFP_KERNEL
to GFP_ATOMIC in order to prevent sleep in atomic bug. The GFP_ATOMIC
flag makes memory allocation operation could be used in atomic context.

Fixes: 9674da8759df ("NFC: Add firmware upload netlink command")
Fixes: 9ea7187c53f6 ("NFC: netlink: Rename CMD_FW_UPLOAD to CMD_FW_DOWNLOAD")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 net/nfc/netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index f184b0db79d..7c62417ccfd 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1244,7 +1244,7 @@ int nfc_genl_fw_download_done(struct nfc_dev *dev, const char *firmware_name,
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!msg)
 		return -ENOMEM;
 
@@ -1260,7 +1260,7 @@ int nfc_genl_fw_download_done(struct nfc_dev *dev, const char *firmware_name,
 
 	genlmsg_end(msg, hdr);
 
-	genlmsg_multicast(&nfc_genl_family, msg, 0, 0, GFP_KERNEL);
+	genlmsg_multicast(&nfc_genl_family, msg, 0, 0, GFP_ATOMIC);
 
 	return 0;
 
-- 
2.17.1

