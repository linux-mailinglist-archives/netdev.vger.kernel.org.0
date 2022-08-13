Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06251591A66
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 14:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbiHMMxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 08:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiHMMxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 08:53:05 -0400
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.237.72.81])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 6547714D38;
        Sat, 13 Aug 2022 05:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=WQtOnY+Z92
        L7/1I7BZ8DkX5raCZRktz8clLSxNYeH20=; b=Pxx6fcQAqmPVvMUE/EOxsezWk3
        O1QUiIkSXCTGnjYWh9sgbX7wYBmO2LIAFFmXOTtUn+jq+P1vcf+zGQQS7K3ZleT4
        zsEVpC0zhmrtEWRyrqyI0Xy1R0oOOYmDyoCOPxODtMQwAaC6UXzhAE08gfy9J67s
        LjbFnpJ6bLFSmpOm4=
Received: from localhost.localdomain (unknown [10.230.34.198])
        by app1 (Coremail) with SMTP id XAUFCgAXDdGQnvdiVsQEBg--.16992S4;
        Sat, 13 Aug 2022 20:52:39 +0800 (CST)
From:   Xin Xiong <xiongx18@fudan.edu.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        Zhenggen Xu <zxu@linkedin.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] net: fix potential refcount leak in ndisc_router_discovery()
Date:   Sat, 13 Aug 2022 20:49:08 +0800
Message-Id: <20220813124907.3396-1-xiongx18@fudan.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: XAUFCgAXDdGQnvdiVsQEBg--.16992S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw4DJFyrZF1rCF4UGw4fuFg_yoW8JFy8pF
        sak34ftFyDKrnrWanrCa1fXry8ua1DtFW3Gw4vkwnYkr4DZ3s29ryFgF4Yq3WUurZ7AryS
        vF4jg345XF1kua7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9G14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCFx2
        IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
        6r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
        AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
        s7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxV
        W8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbHa0DUUUUU==
X-CM-SenderInfo: arytiiqsuqiimz6i3vldqovvfxof0/1tbiARAREFKp5Dni7wAAs7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue happens on specific paths in the function. After both the
object `rt` and `neigh` are grabbed successfully, when `lifetime` is
nonzero but the metric needs change, the function just deletes the
route and set `rt` to NULL. Then, it may try grabbing `rt` and `neigh`
again if above conditions hold. The function simply overwrite `neigh`
if succeeds or returns if fails, without decreasing the reference
count of previous `neigh`. This may result in memory leaks.

Fix it by decrementing the reference count of `neigh` in place.

Fixes: 6b2e04bc240f ("net: allow user to set metric on default route learned via Router Advertisement")
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/ipv6/ndisc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 98453693e400..3a553494ff16 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1378,6 +1378,9 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 	if (!rt && lifetime) {
 		ND_PRINTK(3, info, "RA: adding default router\n");
 
+		if (neigh)
+			neigh_release(neigh);
+
 		rt = rt6_add_dflt_router(net, &ipv6_hdr(skb)->saddr,
 					 skb->dev, pref, defrtr_usr_metric);
 		if (!rt) {
-- 
2.25.1

