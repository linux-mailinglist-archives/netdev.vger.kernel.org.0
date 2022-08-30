Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3375A6747
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiH3PX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiH3PXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:23:54 -0400
Received: from corp-front07-corp.i.nease.net (corp-front07-corp.i.nease.net [59.111.134.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3760512F55C;
        Tue, 30 Aug 2022 08:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=czJTLBpE0tloFZmYSS2AFw3bPxWy7e6kJq
        YwgdeEzv4=; b=eyAKvZ7bP5lCinzXZ3TLZqvvDVy+ixk6mX2QqAUeFAD5UBb5MC
        DKNEwwscxIjvV268duvoKI7H//Eu7w8cuux3YOXktATf6pBxE33OEzx6hveFV5Tm
        CCP3+hWs4I8IyVDvfGW7Oy5pAnU5g8Mqzj4wOc8/sUbPMe2gRysk/YeDA=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front07-corp.i.nease.net (Coremail) with SMTP id nRDICgA3jOhoKw5j3AUVAA--.38750S2;
        Tue, 30 Aug 2022 23:23:20 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     tonylu@linux.alibaba.com
Cc:     davem@davemloft.net, edumazet@google.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, liuyacan@corp.netease.com,
        netdev@vger.kernel.org, pabeni@redhat.com, wenjia@linux.ibm.com,
        hwippel@linux.ibm.com, ubraun@linux.ibm.com
Subject: [PATCH net v2] net/smc: Remove redundant refcount increase
Date:   Tue, 30 Aug 2022 23:23:14 +0800
Message-Id: <20220830152314.838736-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <YwzirUcxlQW3ydT7@TonyMac-Alibaba>
References: <YwzirUcxlQW3ydT7@TonyMac-Alibaba>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: nRDICgA3jOhoKw5j3AUVAA--.38750S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jr1xuF1kAFWxWr4kXw4Utwb_yoW3Zrc_K3
        47GFnrWa1jyFZayw4fG393uwsaqw1kJr48Xrn5ArZ0y3Wjvr48Can8Crn8uw15u3yYyF13
        Jr45tFZYgw12yjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
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
        1lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l
        IxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4
        A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRp6wAUUUUU=
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAOCVt77xO05QAVsa
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yacan Liu <liuyacan@corp.netease.com>

For passive connections, the refcount increment has been done in
smc_clcsock_accept()-->smc_sock_alloc().

Fixes: 3b2dec2603d5 ("net/smc: restructure client and server code in af_smc")
Signed-off-by: Yacan Liu <liuyacan@corp.netease.com>

---
Change in v2:
  -- Tune commit message
---
 net/smc/af_smc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 79c1318af..0939cc3b9 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1855,7 +1855,6 @@ static void smc_listen_out_connected(struct smc_sock *new_smc)
 {
 	struct sock *newsmcsk = &new_smc->sk;
 
-	sk_refcnt_debug_inc(newsmcsk);
 	if (newsmcsk->sk_state == SMC_INIT)
 		newsmcsk->sk_state = SMC_ACTIVE;
 
-- 
2.20.1

