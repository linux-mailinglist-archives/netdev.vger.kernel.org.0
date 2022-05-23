Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2440530889
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 06:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349650AbiEWE70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 00:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiEWE7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 00:59:23 -0400
Received: from corp-front08-corp.i.nease.net (corp-front08-corp.i.nease.net [59.111.134.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0797A10AB;
        Sun, 22 May 2022 21:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=PML+RtRHT09240DsDerNVlNwToxhZ9P/5T
        XgZocq7xA=; b=TjAfYTJ6kFt+5pjpxGgvWAl/8FQnDDURdteRclMsvefRQkdJH6
        kdZHxpeQhOUN1jXhgKIRWA6oMdVEhWtVJ5gU5uKsZo07olHKNoIVk2El6mbwD0sp
        aPA9Y2Eyi/sJCMa+hh5TColcT7AlSkMgOMvjYbiKzaaMS6b+Yl3xpETJE=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front08-corp.i.nease.net (Coremail) with SMTP id nhDICgCHGASaFItigE1hAA--.64988S2;
        Mon, 23 May 2022 12:59:06 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ubraun@linux.ibm.com,
        liuyacan <liuyacan@corp.netease.com>
Subject: [PATCH v2 net] net/smc: postpone sk_refcnt increment in connect()
Date:   Mon, 23 May 2022 12:57:07 +0800
Message-Id: <20220523045707.1704761-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220523032437.1059718-1-liuyacan@corp.netease.com>
References: <20220523032437.1059718-1-liuyacan@corp.netease.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: nhDICgCHGASaFItigE1hAA--.64988S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XrWxtFWUZw18uF4rWrWruFg_yoWkWFcEkr
        s3WFWDCr4jyF4rJw47A3yrAa97tw1rGr48Jws8ArWIq3W8WryDurs8Crsxur1Duw45Cr13
        Wr4FgFWrC34IyjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbtAYjxAI6xCIbckI1I0E57IF64kEYxAxM7AC8VAFwI0_Gr0_Xr1l
        1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0I
        I2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0
        Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84
        ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2kK67ZEXf0FJ3sC6x9vy-n0Xa0_Xr1Utr1k
        JwI_Jr4ln4vE4IxY62xKV4CY8xCE548m6r4UJryUGwAS0I0E0xvYzxvE52x082IY62kv04
        87Mc804VCqF7xvr2I5Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        JVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
        AKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwAKzVCY
        07xG64k0F24l7I0Y64k_MxkI7II2jI8vz4vEwIxGrwCF04k20xvY0x0EwIxGrwCF72vEw2
        IIxxk0rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7vE0wC20s026c02F40E14v26r1j6r18
        MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr4
        1lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1l
        IxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4
        A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRp6wAUUUUU=
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAPCVt760Y6zQABs4
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: liuyacan <liuyacan@corp.netease.com>

Same trigger condition as commit 86434744. When setsockopt runs
in parallel to a connect(), and switch the socket into fallback
mode. Then the sk_refcnt is incremented in smc_connect(), but
its state stay in SMC_INIT (NOT SMC_ACTIVE). This cause the
corresponding sk_refcnt decrement in __smc_release() will not be
performed.

Fixes: 86434744fedf ("net/smc: add fallback check to connect()")
Signed-off-by: liuyacan <liuyacan@corp.netease.com>
---
 net/smc/af_smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index fce16b9d6..45a24d242 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1564,9 +1564,9 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
 	if (rc && rc != -EINPROGRESS)
 		goto out;
 
-	sock_hold(&smc->sk); /* sock put in passive closing */
 	if (smc->use_fallback)
 		goto out;
+	sock_hold(&smc->sk); /* sock put in passive closing */
 	if (flags & O_NONBLOCK) {
 		if (queue_work(smc_hs_wq, &smc->connect_work))
 			smc->connect_nonblock = 1;
-- 
2.20.1

