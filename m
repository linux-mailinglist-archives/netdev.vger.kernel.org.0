Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281D4529E7D
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240076AbiEQJut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiEQJur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:50:47 -0400
X-Greylist: delayed 469 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 May 2022 02:50:42 PDT
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30803BBB;
        Tue, 17 May 2022 02:50:40 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-01 (Coremail) with SMTP id qwCowADX3oYKboNiPsfaBw--.53394S2;
        Tue, 17 May 2022 17:42:35 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] net: af_key: add check for pfkey_broadcast in function pfkey_process
Date:   Tue, 17 May 2022 17:42:31 +0800
Message-Id: <20220517094231.414168-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowADX3oYKboNiPsfaBw--.53394S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZryrKw4fuw15Cr4kGFyDJrb_yoWDCrX_Cr
        1xXF43Cws8tr9a9r17tw4Syr1DAr4UurZagFZaq34rX3yDKr12grWvkFn3JryYgrWjgr45
        Ar95Cws7ZF1xujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbwAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48J
        MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
        AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
        0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4
        v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
        14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If skb_clone() returns null pointer, pfkey_broadcast() will
return error.
Therefore, it should be better to check the return value of
pfkey_broadcast() and return error if fails.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 net/key/af_key.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index fd51db3be91c..92e9d75dba2f 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2826,8 +2826,10 @@ static int pfkey_process(struct sock *sk, struct sk_buff *skb, const struct sadb
 	void *ext_hdrs[SADB_EXT_MAX];
 	int err;
 
-	pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
-			BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
+	err = pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
+			      BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
+	if (err)
+		return err;
 
 	memset(ext_hdrs, 0, sizeof(ext_hdrs));
 	err = parse_exthdrs(skb, hdr, ext_hdrs);
-- 
2.25.1

