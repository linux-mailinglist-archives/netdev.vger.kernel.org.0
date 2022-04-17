Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C818F5047C6
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 14:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbiDQMv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 08:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbiDQMv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 08:51:57 -0400
X-Greylist: delayed 927 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 17 Apr 2022 05:49:19 PDT
Received: from m12-15.163.com (m12-15.163.com [220.181.12.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB3192BB0B;
        Sun, 17 Apr 2022 05:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=K+Zu7
        9SFGsB8FkMycJpkj4rA7OHY5+I73z/C4EXhavI=; b=qBtzQX6EF28QUZhW7qLB8
        vw4BibBZrH1w7R6Fzaez3CF5ttVNmis7yW7zeZ3S1nNa1bYFTojspvFqPkqtKZAH
        8hzwJByr/RtuXwv6LKH3q5hrAmpjiEzg2OajG+4Vv5dbM1wKmTSxdosi0QQfXTym
        H+cwbjaUQnLBUVuU6Fbbno=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by smtp11 (Coremail) with SMTP id D8CowADnvCUVCVxiLzSsBg--.47634S2;
        Sun, 17 Apr 2022 20:33:26 +0800 (CST)
From:   yacanliu@163.com
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>
Subject: [PATCH] net/smc: sync err info when TCP connection is refused
Date:   Sun, 17 Apr 2022 20:33:07 +0800
Message-Id: <20220417123307.1094747-1-yacanliu@163.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: D8CowADnvCUVCVxiLzSsBg--.47634S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZr48CF15CFy5KF1rKr1ftFb_yoWDWrXEkr
        17W3WkGa1jvr1fG3y29398ZwsaqayrCFWrGwnIyrWqy3s29w45Zrs8Zrn8Crn7ur4a9F9x
        Gw45Kasak34IyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8AhLUUUUUU==
X-Originating-IP: [115.238.122.38]
X-CM-SenderInfo: p1dft0xolxqiywtou0bp/1tbiXwvlS1154TpjTwAAsp
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
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

Signed-off-by: liuyacan <liuyacan@corp.netease.com>
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

