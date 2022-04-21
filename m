Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2805509CFB
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387992AbiDUKC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388077AbiDUKC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:02:57 -0400
X-Greylist: delayed 720 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Apr 2022 03:00:06 PDT
Received: from corp-front09-corp.i.nease.net (corp-front09-corp.i.nease.net [59.111.134.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B754A199;
        Thu, 21 Apr 2022 03:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:MIME-Version:Content-Transfer-Encoding; bh=YFvbv
        yq+VCvdHQqmn2kiqnIUVvbxcDPO7+3LCOe1kPc=; b=JTBf6cQKutfbKxV9WeMpX
        bzNcqNn+jBBL1UrIYAOwoQiLKnWYAAXZOrsIVDrZucCfJ7c938asvNlMxLE4FPXq
        SKeB7da7YIBg/LuNDVJS7CTKa5RazLM9yFtfM+42Qnx2ifjNum/VJSCpJvSxPIO6
        9J2o04xJkLz8KJds44ADLU=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front09-corp.i.nease.net (Coremail) with SMTP id nxDICgCHjGGMJmFiMCBSAA--.46336S2;
        Thu, 21 Apr 2022 17:40:29 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: [PATCH net] net/smc: sync err code when tcp connection was refused
Date:   Thu, 21 Apr 2022 17:40:27 +0800
Message-Id: <20220421094027.683992-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: nxDICgCHjGGMJmFiMCBSAA--.46336S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZr48CF15CFy5KF1rtFWkZwb_yoWkuFbEkF
        1Ig3WxGa1jvr1rC3y7ZrsxZwsYqa48CrWrWrnIyrWkt3409w45ZFs5urn8Gwn7Cr4a9Fnx
        Jw45Kas5C34IyjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbXAYjxAI6xCIbckI1I0E57IF64kEYxAxM7AC8VAFwI0_Gr0_Xr1l
        1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0I
        I2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0
        Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7
        xvwVC2z280aVCY1x0267AKxVW0oVCq3wAawVAFpfBj4fn0lVCYm3Zqqf926ryUJw1UKr1v
        6r18M2kK6xCIbVAIwIAEc20F6c8GOVW8Jr15Jr4le2I262IYc4CY6c8Ij28IcVAaY2xG8w
        AqjxCE34x0Y48IcwAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lw4CEc2x0rVAKj4xxMx02cVAKzwCY0x0Ix7I2
        Y4AK64vIr41l42xK82IYc2Ij64vIr41l4x8a64kIII0Yj41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1l4IxY624lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
        zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
        4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
        CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
        VFxhVjvjDU0xZFpf9x0pRp6wAUUUUU=
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQADCVt76hFlaAABsY
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: liuyacan <liuyacan@corp.netease.com>

In the current implementation, when TCP initiates a connection
to an unavailable [ip,port], ECONNREFUSED will be stored in the
TCP socket, but SMC will not. However, some apps (like curl) use
getsockopt(,,SO_ERROR,,) to get the error information, which makes
them miss the error message and behave strangely.

Fixes: 50717a37db03 ("net/smc: nonblocking connect rework")
Signed-off-by: liuyacan <liuyacan@corp.netease.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index fc7b6eb22..bbb1a4ce5 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1475,6 +1475,8 @@ static void smc_connect_work(struct work_struct *work)
 		smc->sk.sk_state = SMC_CLOSED;
 		if (rc == -EPIPE || rc == -EAGAIN)
 			smc->sk.sk_err = EPIPE;
+		else if (rc == -ECONNREFUSED)
+			smc->sk.sk_err = ECONNREFUSED;
 		else if (signal_pending(current))
 			smc->sk.sk_err = -sock_intr_errno(timeo);
 		sock_put(&smc->sk); /* passive closing */
-- 
2.20.1

